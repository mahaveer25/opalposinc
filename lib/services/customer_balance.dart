import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalposinc/model/customer_balance.dart';
import 'package:opalposinc/utils/global_variables.dart';

class CustomerBalanceService {
  static String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<CustomerBalanceModel> getCustomerBalance(
      BuildContext context, int id) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_customer_balance?customer_id=$id';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          final data = jsonData['data'];
          // Check if 'data' is a list or a map and handle accordingly
          if (data is Map) {
            // Directly parse the map if 'data' is a map
            final customerBalance =
                CustomerBalanceModel.fromJson(data.cast<String, dynamic>());
            return customerBalance;
          } else if (data is List) {
            // If 'data' is a list, take the first item or handle it as needed
            final Map<String, dynamic> firstItem = data.first;
            final customerBalance = CustomerBalanceModel.fromJson(
                firstItem.cast<String, dynamic>());
            return customerBalance;
          } else {
            throw Exception("Unexpected data format");
          }
        } else {
          throw Exception("Failed to fetch customer balance");
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
