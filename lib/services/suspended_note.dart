// PlaceOrder.dart

import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/utils/global_variables.dart';

class Suspendorder {
  String storeUrl = GlobalData.storeUrl;

  Future<Either<InvoiceModel, String>> suspendOrder(
      BuildContext context, Transaction invoiceModel) async {
    try {
      log('${invoiceModel.toJson()}');
      final response = await http.post(
          Uri.parse('https://$storeUrl.opalpay.us/public/api/suspend_order'),
          headers: {
            'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
          },
          body: invoiceModel.toJson());

      // log('${response.statusCode}');
      log('abs');

      if (response.statusCode == 200) {
        log('response OK');
        log('body response ${response.body}');
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          return Left(InvoiceModel.fromJson(responseData['data']));
        } else {
          // log(responseData['error']);
          ErrorFuncs(context).errRegisterClose(
              errorInfo: {'info': responseData['error']['info']});
          log('error2 ${responseData['error']['info']}');

          return Right(responseData['error']['info']);
        }
      } else {
        log('errorrr ${response.statusCode}');

        return Right('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      return Right('$error');
    }
  }
}
