import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/utils/constant_dialog.dart';

class ResetPasswordService {
  static const String apiKey = "#bk_api_opal_v1_1_1@";

  Future<Map<String, dynamic>> resetUser(
      BuildContext context, String email, String url) async {
    final body = {
      'email': email,
    };
    final headers = {
      'OPAL-PAY-API-KEY': apiKey,
    };

    try {
      final response = await http.post(
        Uri.parse('https://$url.opalpay.us/public/api/send_reset_link'),
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseBody =
            json.decode(response.body) as Map<String, dynamic>?;

        if (responseBody == null) {
          log('Response body is null');
          ConstDialog(context)
              .showErrorDialog(error: 'Unexpected error: Response is null');
          return {
            'status': false,
            'error': 'Unexpected error: Response is null'
          };
        }

        if (responseBody['status'] == true) {
          return {'status': true, 'message': 'Reset link sent successfully'};
        } else {
          log('Store URL is correct but can\'t login');
          ConstDialog(context).showErrorDialog(
              error: responseBody['error']?['info'] ?? 'Unknown error');
          return {
            'status': false,
            'error': responseBody['error'] ?? {'info': 'Unknown error'}
          };
        }
      } else {
        log('Request failed with status: ${response.statusCode}');
        final Map<String, dynamic>? responseBody =
            json.decode(response.body) as Map<String, dynamic>?;

        ConstDialog(context).showErrorDialog(
            error: responseBody?['error']?['info'] ?? 'Network error');
        return {
          'status': false,
          'error': {'info': 'Network error'}
        };
      }
    } catch (e) {
      log('Error: $e');
      ConstDialog(context).showErrorDialog(error: 'Invalid Store URL');
      return {
        'status': false,
        'error': {'info': 'Network error: $e'}
      };
    }
  }
}
