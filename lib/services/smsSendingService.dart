import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/model/product.dart';
import 'package:opalsystem/utils/api_constants.dart';
import 'package:opalsystem/utils/global_variables.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class NotificationService {
  static String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<Map<String, dynamic>> sendSmsEmail({
    required BuildContext context,
    required String smsSendTo,
    required String emailSendTo,
    required String address,
    required String invoiceNumber,
    required String transactionId,
    required String customer,
    required String customerMobile,
    required String invoiceDate,
    required String mobile,
    required List<Product> product,
    required String subTotal,
    required String taxAmount,
    required String total,
  }) async {
    LoggedInUserBloc loggedInUserBloc = BlocProvider.of<LoggedInUserBloc>(context);

   final url= 'https://$storeUrl.opalpay.us/public/api/api/send_sms_email_api';


    final headers = {'OPAL-PAY-API-KEY': apiKey};

    final Map<String, dynamic> body = {
      'business_id': loggedInUserBloc.state!.businessId,
      'user_id': loggedInUserBloc.state!.id,
      'sms_send_to': smsSendTo,
      'email_send_to': emailSendTo,
      'store_name': loggedInUserBloc.state!.businessName ?? '',
      'address': address,
      'invoice_number': invoiceNumber,
      'transaction_id': transactionId,
      'customer': customer,
      'customer_mobile': customerMobile,
      'invoice_date': invoiceDate,
      'mobile': mobile,
      'products':
          jsonEncode(product.map((product) => product.toJson()).toList()),
      'sub_total': subTotal,
      'tax_amount': taxAmount,
      'total': total,
    };

    log('Request Body: $body');
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      log('Response Status: ${response.statusCode}');
      log('Response Body of sms: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log('Error of sms api: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': {
            'message': 'Failed with status code ${response.statusCode}'
          },
        };
      }
    } catch (error) {
      log('Error: $error');
      return {
        'success': false,
        'error': {'info': error.toString()},
      };
    }
  }
}
