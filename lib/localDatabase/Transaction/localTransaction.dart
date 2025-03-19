import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/localDatabase/Invoices/LocalDatabaseInvoices.dart';
import 'package:opalsystem/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalsystem/localDatabase/createTables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:opalsystem/invoices/transaction.dart' as TransactionModel;

class LocalTransaction {
  static const databaseName = 'transactions';

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

  Future<InvoiceModel> addToLocal(
      {required BuildContext context,
      required TransactionModel.Transaction transaction}) async {
    final path = await getPath;
    final open = await openDatabase(path);

    await open.transaction((txn) async {
      int id1 = await txn.insert(databaseName, transaction.toJson());
      log('inserted1: $id1');
    });

    final invoice = await LocalDatabaseInvoices(context)
        .makeInvoice(context: context, transaction: transaction);

    return invoice;
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

  Future<void> syncTransactions({
    required BuildContext context,
  }) async {
    final transactions = await LocalTransaction().getLocalTransactions();

    LocalTransactionBlocBloc bloc =
        BlocProvider.of<LocalTransactionBlocBloc>(context);
    bloc.add(
        UploadTransactionEvent(context: context, transaction: transactions));
  }
}
