import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/model/pricinggroup.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/global_variables.dart';

class PricingGroupService {
  String storeUrl = GlobalData.storeUrl;

  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<PricingGroup>> getPricingGroup({
    required BuildContext context,
    required LoggedInUser loggedInUser,
    required Location location,
  }) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_pricing_group?business_id=${loggedInUser.businessId}&user_id=${loggedInUser.id}&location_id=${location.id}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          List<Map<String, dynamic>> data = List.from(jsonData['data']);

          // log('pricing group: $data');
          return data.map((item) {
            var dat = PricingGroup.fromJson(item);
            // log('${dat.id}');
            return dat;
          }).toList();
        } else {
          ConstDialog(context).showErrorDialog(error: "Missing Company ID 3");

          return []; // Return an empty list in case of failure
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
