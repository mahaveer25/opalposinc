// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalsystem/model/suspended_sales_details.dart';
import 'package:opalsystem/utils/global_variables.dart';

class SuspendedOrderDetails {
  static String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<SuspendedDetails> getsuspendedorderdetails(
      BuildContext context, String? transactionId) async {
    log(transactionId.toString());

    final url =
        'https://$storeUrl.opalpay.us/public/api/get_suspended_order_detail?transaction_id=$transactionId';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          final Map<String, dynamic> data = jsonData['data'];
          final suspendedDetails = SuspendedDetails.fromJson(data);

          print("list:${suspendedDetails.toJson()} ");
          return suspendedDetails;
        } else {
          throw Exception("Missing Business ID");
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
