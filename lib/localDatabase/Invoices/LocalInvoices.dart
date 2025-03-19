import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/localDatabase/createTables.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class LocalInvoices {
  static const databaseName = 'invoices';

  static get getPath async => await toPath();

  static Future<String> toPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');
    return path;
  }

  static Future<void> initialize() async {
    final path = await getPath;

    final invoice = InvoiceModel().toJson();

    final table = CreateTables.createTable('`$databaseName`', invoice);

    await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(table);
    });
  }

  Future<void> addToLocal(
      {required BuildContext context, required InvoiceModel invoice}) async {
    final path = await getPath;
    final open = await openDatabase(path);

    await open.transaction((txn) async {
      int id1 = await txn.insert(databaseName, invoice.toJson());
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

  Future<List<InvoiceModel>> getLocalInvoices() async {
    final path = await getPath;
    final open = await openDatabase(path);

    List<Map<String, Object?>> records = await open.query(databaseName);

    List<InvoiceModel> list = records.map((e) {
      final model = InvoiceModel.fromJson(e);
      log('from local invoice model ${model.toJson()}');
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
}
