import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:opalposinc/utils/global_variables.dart';

class CashRegisterService {
  static String url =
      'https://${GlobalData.storeUrl}.opalpay.us/public/api/open_cash_register';
  static const Map<String, String> headers = {
    'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
  };

  static Future<Map<String, dynamic>> openCashRegister({
    required String businessId,
    required String locationId,
    required String userId,
    required String amount,
  }) async {
    final Map<String, dynamic> body = {
      'business_id': businessId,
      'location_id': locationId,
      'user_id': userId,
      'amount': amount,
    };
    log('register body$body');
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      log('response body open ${response.body}');
      return jsonDecode(response.body);
    } catch (error) {
      return {
        'success': false,
        'error': {'info': error.toString()}
      };
    }
  }
}
