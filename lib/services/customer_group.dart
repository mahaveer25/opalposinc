import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:opalposinc/utils/global_variables.dart';

class CustomerGroupService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<String>> getCustomerGroupNames(BuildContext context) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_customer_groups?business_id=${GlobalData().loggedInUser.businessId}&user_id=${GlobalData().loggedInUser.id}&location_id=${GlobalData().loggedInUser.locations}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          List<Map<String, dynamic>> data = List.from(jsonData['data']);
          return data.map((item) => item['name'].toString()).toList();
          // ${item['id']}-
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text("Missing Company ID 1"),
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
        return [];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
