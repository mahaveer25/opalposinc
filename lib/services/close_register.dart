import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:opalsystem/utils/global_variables.dart';

class CloseRegisterService {
  static String url =
      'https://${GlobalData.storeUrl}.opalpay.us/public/api/close_cash_register';
  static const Map<String, String> headers = {
    'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
  };

  static Future<Map<String, dynamic>> clsoeCashRegister({
    String? businessId,
    String? locationId,
    String? userId,
    String? closingNote,
    Map<String, String>? cashDenominations,
  }) async {
    final Map<String, dynamic> body = {
      'business_id': businessId,
      'location_id': locationId,
      'user_id': userId,
      'closing_note': closingNote,
      'denominations':
          cashDenominations != null ? jsonEncode(cashDenominations) : "",
    };
    log("close register: $businessId, $locationId, $userId, $closingNote,$cashDenominations");
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      return jsonDecode(response.body);
    } catch (error) {
      return {
        'success': false,
        'error': {'info': error.toString()}
      };
    }
  }
}
