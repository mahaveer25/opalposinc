import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalposinc/invoices/chargeInvoiceModel.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/utils/global_variables.dart';

import '../model/loggedInUser.dart';

class ChargeCardService {
  // String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<ChargeInvoiceModel?> chargeCard(
      {required BuildContext context,
      required Location? location,
      required PaymentListMethod? listMethods,
      required LoggedInUser? loggedInUser}) async {
    final url = 'https://${GlobalData.storeUrl}.opalpay.us/public/api/charge';
    final headers = {'OPAL-PAY-API-KEY': apiKey};
    print('brand api check:$url');

    final Map<String, dynamic> body = {
      "business_id": loggedInUser?.businessId,
      "location_id": location?.id,
      "cc_number": listMethods?.cardNumber,
      "cc_holder_name": listMethods?.cardHolderName,
      "cvv": listMethods?.cardSecurity,
      "expiry_month": listMethods?.cardMonth,
      "expiry_year": listMethods?.cardYear,
      "amount": listMethods?.amount
    };

    log('$body');

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Body: ${response.body}");
        if (jsonData['success'] == true) {
          return ChargeInvoiceModel.fromJson(jsonData['data']);
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text("Missing Business ID"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
        return const ChargeInvoiceModel();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
