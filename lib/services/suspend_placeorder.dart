// PlaceOrder.dart

import 'dart:convert';
import 'dart:developer';
// import 'dart:js_interop';
import 'package:http/http.dart' as http;
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/utils/global_variables.dart';

class SuspendPlaceOrder {
  String storeUrl = GlobalData.storeUrl;

  Future<InvoiceModel> suspendPlaceOrder(Transaction invoiceModel) async {
    try {
      // log('${invoiceModel.toJson()}');
      final response = await http.post(
          Uri.parse(
              'https://$storeUrl.opalpay.us/public/api/suspended_order_update'),
          headers: {
            'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
          },
          body: invoiceModel.toJson());

      if (response.statusCode == 200) {
        log('response OK');
        log('suspend body response ${response.body}');
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          // log('${responseData['data']}');
          return InvoiceModel.fromJson(responseData['data']);
        } else {
          log('Response Error: ${responseData['error']}');
          return InvoiceModel();
        }
      } else {
        log('HTTP Error: ${response.statusCode}');
        return InvoiceModel();
      }
    } catch (error) {
      log('Errors: $error');
      return InvoiceModel();
    }
  }
}
