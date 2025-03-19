import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/utils/constant_dialog.dart';

import '../model/TaxModel.dart';
import '../utils/global_variables.dart';
import 'package:http/http.dart' as http;

class GetTaxServices {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<TaxModel> getTaxModel(
      {required BuildContext context,
      required LoggedInUser loggedInUser}) async {
    final url =
        "https://$storeUrl.opalpay.us/public/api/get_default_sale_tax?business_id=${loggedInUser.businessId}";
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        log("Body: ${response.body}");
        if (jsonData['success']) {
          Map<String, dynamic> data = jsonData['data'];

          TaxModel toTextModel = TaxModel.fromJson(data);
          log("${toTextModel.toJson()}");

          return toTextModel;
        } else {
          // ignore: use_build_context_synchronously
          ConstDialog(context).showErrorDialog(error: "Missing Business ID");
        }
        return TaxModel();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
