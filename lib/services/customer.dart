import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/utils/global_variables.dart';

class CustomerDataService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<CustomerModel>> getCustomerNames(
      BuildContext context, LoggedInUser loggedInUser) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_customers?business_id=${loggedInUser.businessId}&user_id=${loggedInUser.id}&location_id=${loggedInUser.locations}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          List<Map<String, dynamic>> data = List.from(jsonData['data']);
          return data.map((item) => CustomerModel.fromJson(item)).toList();
          // ${item['id']}-
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text("Missing Company ID 2"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
        return [];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
