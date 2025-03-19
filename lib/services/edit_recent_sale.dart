import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/utils/global_variables.dart';

class RecentOrderPrint {
  static String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<Either<InvoiceModel, String>> getrecentorderprint(
      BuildContext context, String? transactionId) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_recent_sales_detail?transaction_id=$transactionId';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          final Map<String, dynamic> data = jsonData['data'];

          final invoicePrint = InvoiceModel.fromJson(data);
          return Left(invoicePrint);
        } else {
          return Right(jsonData['error']['info']);
        }
      } else {
        return const Right('Cannot Print');
      }
    } catch (e) {
      return const Right('Print Catch Error');
    }
  }
}
