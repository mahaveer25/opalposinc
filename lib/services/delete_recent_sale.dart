// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/global_variables.dart';

class DeleteRecentSell {
  static const String apiKey = "#bk_api_opal_v1_1_1@";

  static Future<void> deleteRecentSell(
      BuildContext context, String transaction_id, String type) async {
    final headers = {
      'OPAL-PAY-API-KEY': apiKey,
    };

    try {
      final response = await http.get(
        Uri.parse(
            'https://${GlobalData.storeUrl}.opalpay.us/public/api/recent_sales_delete?transaction_id=$transaction_id&type=$type'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          ConstDialog(context).showErrorDialog(error: 'Deleted Successfully');
        } else {
          ConstDialog(context).showErrorDialog(error: 'Something went wrong');
        }
      } else {
        ConstDialog(context).showErrorDialog(error: 'Something went wrong');
      }
    } catch (e) {
      log('print Error');
      ConstDialog(context).showErrorDialog(error: 'Invalid Store Url');
    }
  }
}
