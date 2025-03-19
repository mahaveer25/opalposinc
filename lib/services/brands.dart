import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/utils/global_variables.dart';

import '../model/loggedInUser.dart';

class BrandsService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<Brand>> getBrands(
      {required BuildContext context,
      required LoggedInUser loggedInUser}) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_brands?business_id= ${loggedInUser.businessId}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};
    print('brand api check:$url');
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Body: ${response.body}");
        if (jsonData['success']) {
          List<Map<String, dynamic>> data = List.from(jsonData['data']);
          return data.map((item) => Brand.fromJson(item)).toList();
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
        return [];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
