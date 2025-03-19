import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opalposinc/utils/api_constants.dart';
import 'package:opalposinc/utils/global_variables.dart';

class AddNewCustomerService {
  String storeUrl = GlobalData.storeUrl;

  static const String apiKey = "OPAL-PAY-API-KEY";
  static const String apiValue = "#bk_api_opal_v1_1_1@";

  Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(
          // ApiConstants.getBaseUrl(storeUrl)+ApiConstants.addCustomer
          'https://$storeUrl.opalpay.us/public/api/add_customer'),
      headers: {
        ApiConstants.headerAuthorizationKey:
            ApiConstants.headerAuthorizationValue,
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}
