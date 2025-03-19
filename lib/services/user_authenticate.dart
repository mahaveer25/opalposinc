import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/main.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/utils/constant_dialog.dart';

class AuthService {
  static const String apiKey = "#bk_api_opal_v1_1_1@";

  Future<Map<String, dynamic>> loginUser(BuildContext context, String username,
      String password, String url) async {
    log('Starting loginUser method with username: $username and URL: $url');

    final headers = {
      'OPAL-PAY-API-KEY': apiKey,
    };
    log('Request headers set: $headers');

    final body = {
      'username': username,
      'password': password,
    };
    log('Request body set: $body');

    try {
      log('Attempting to send POST request to https://$url.opalpay.us/public/api/authenticate_user');

      final response = await http
          .post(
            Uri.parse('https://$url.opalpay.us/public/api/authenticate_user'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10)); // Set a timeout duration

      log('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        log('Response body decoded successfully: $responseBody');

        if (responseBody['success'] == true) {
          log('Login success: User authenticated successfully.');

          // Convert user data to LoggedInUser object and map
          LoggedInUser loggedInUser =
              LoggedInUser.fromJson(responseBody['data']);
          Map<String, dynamic> map = loggedInUser.toJson();

          // Log the converted LoggedInUser data to check if business and other details are correctly set
          log('LoggedInUser object after conversion: ${loggedInUser.toJson()}');
          log('LoggedInUser business details: ${loggedInUser.business}'); // Log the business details
          log('LoggedInUser bridgePayDetails: ${loggedInUser.business?.bridgePayDetails.toString()}'); // Log bridgePayDetails

          await displayManager
              .transferDataToPresentation({'type': 'login', 'login': map});
          log('Data transferred to presentation successfully');

          return map;
        } else {
          log('Login failed: Incorrect credentials or other error. Error: ${responseBody['error']['info']}');
          ConstDialog(context)
              .showErrorDialog(error: responseBody['error']['info']);
          return {
            'success': false,
            'error': responseBody['error'] ?? 'Unknown error'
          };
        }
      } else {
        log('Response status code not 200: Authentication failed with status code: ${response.statusCode}');
        final Map<String, dynamic> responseBody = json.decode(response.body);
        log('Response error info: ${responseBody['error']['info']}');

        ConstDialog(context)
            .showErrorDialog(error: responseBody['error']['info']);
        return {
          'success': false,
          'error': responseBody['error'] ?? {'info': 'Network error'}
        };
      }
    } catch (e) {
      log('Exception caught during network request: $e');
      ConstDialog(context)
          .showErrorDialog(error: 'Invalid Store Url or network error.');
      return {
        'success': false,
        'error': {'info': 'Network error: $e'}
      };
    }
  }
}
