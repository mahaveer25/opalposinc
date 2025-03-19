import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/utils/global_variables.dart';

class GetCashDenominationsService {
  String storeUrl = GlobalData
      .storeUrl; // Assuming GlobalData is defined similarly as in your other service
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<String>> getCashDenominations(
      {required BuildContext context, required String businessId}) async {
    final url =
        "https://$storeUrl.opalpay.us/public/api/get_cash_denominations?business_id=$businessId";
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Body: ${response.body}");

        if (jsonData['success']) {
          List<String> cashDenominations = List<String>.from(jsonData['data']);
          return cashDenominations;
        } else {
          // Show error dialog if 'success' is false
          ConstDialog(context).showErrorDialog(
              error:
                  jsonData['message'] ?? "Failed to fetch cash denominations");
        }
        return []; // Return an empty list if no data
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
