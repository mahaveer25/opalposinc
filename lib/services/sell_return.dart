// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/utils/api_constants.dart';

class SellReturnService {
  // static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<InvoiceModel?> getSellRetrunDetails(
      BuildContext context, String? invoiceNumber, String storeUrl) async {
    log(invoiceNumber.toString());

    final url = ApiConstants.getBaseUrl(storeUrl) +
        ApiConstants.generateParametrizedEndpoint(
            ApiConstants.getSellReturn, {"invoice_no": invoiceNumber ?? ""});
    log("This is url for getSellRetrunDetails: $url");
    final headers = {
      // 'OPAL-PAY-API-KEY': apiKey
      ApiConstants.headerAuthorizationKey: ApiConstants.headerAuthorizationValue
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        log("This is the body of sell_return${response.body}");
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          final Map<String, dynamic> data = jsonData['data'];
          final sellReturnDetails = InvoiceModel.fromJson(data);

          // print("list:${sellReturnDetails.toJson()} ");
          return sellReturnDetails;
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
