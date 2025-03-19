import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:opalsystem/localDatabase/createTables.dart';
import 'package:opalsystem/services/placeorder.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:sqflite/sqflite.dart';
import 'package:opalsystem/invoices/transaction.dart' as TransactionModel;
import 'package:path/path.dart';

class LocalDraft {
  static const databaseName = 'draft';

  static get getPath async => await toPath();

  static Future<String> toPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');
    return path;
  }

  Future<void> initialize() async {
    final path = await getPath;

    final transaction = TransactionModel.Transaction().toJson();

    final table = CreateTables.createTable('`$databaseName`', transaction);

    await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(table);
    });
  }

  Future<void> addToLocal(
      {required BuildContext context,
      required TransactionModel.Transaction transaction}) async {
    final path = await getPath;
    final open = await openDatabase(path);

    await open.transaction((txn) async {
      int id1 = await txn.insert(databaseName, transaction.toJson());
      log('inserted1: $id1');
    });
  }

  Future<void> removeFromLocal({required String id}) async {
    final path = await getPath;
    final open = await openDatabase(path);

    await open.transaction((txn) async {
      int id1 = await txn.delete(databaseName,
          where: 'offline_invoice_no = "${id.toString()}"');
      log('inserted1: $id1');
    });
  }

  Future<List<TransactionModel.Transaction>> getLocalTransactions() async {
    final path = await getPath;
    final open = await openDatabase(path);

    List<Map<String, Object?>> records = await open.query(databaseName);

    List<TransactionModel.Transaction> list = records.map((e) {
      final model = TransactionModel.Transaction.fromJson(e);
      // log('from local transaction model ${model.toJson()}');
      return model;
    }).toList();

    return list;
  }

  Future<void> close() async {
    final path = await getPath;
    final open = await openDatabase(path);

    open.close();
    final file = File(path);
    await file.delete();
  }

  Future<void> deleteDatabase() async {
    final path = await getPath;
    final open = await openDatabase(path);

    open.delete(databaseName);
    await open.close();
  }

  Future<void> syncTransactions(
      {required BuildContext context,
      required List<TransactionModel.Transaction> transactions}) async {
    for (var transaction in transactions) {
      if (transactions.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 10));

        await PlaceOrder().placeOrder(context, transaction).then((value) {
          value.fold((invoice) async {
            log('transaction successful ${invoice.toJson()}');

            await removeFromLocal(id: invoice.offlineInvoiceNo.toString());
          }, (error) {
            ConstDialog(context).showErrorDialog(error: error);
          });
        });
      } else {
        ConstDialog(context).showErrorDialog(error: 'Transactions are empty');
      }
    }
  }
}
