// PlaceOrder.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
// import 'dart:js_interop';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Transaction/localTransaction.dart';
import 'package:opalposinc/utils/api_constants.dart';
import 'package:opalposinc/utils/global_variables.dart';

class PlaceOrder {
  String storeUrl = GlobalData.storeUrl;
  LocalTransaction localTransaction = LocalTransaction();

  Future<Either<InvoiceModel, String>> placeOrder(
      BuildContext context, Transaction invoiceModel) async {
    try {
      log('${invoiceModel.toJson()}');

      final response = await http.post(
          Uri.parse(
              ApiConstants.getBaseUrl(storeUrl) + ApiConstants.placeOrder),
          headers: {
            ApiConstants.headerAuthorizationKey:
                ApiConstants.headerAuthorizationValue
          },
          body: invoiceModel.toJson());
      // 'https://$storeUrl.opalpay.us/public/api/place_order'
      // 'http://localhost/project/opal_pos/public/api/place_order'
      log("This is url for postSellReturn: ${ApiConstants.getBaseUrl(storeUrl) + ApiConstants.placeOrder} ");

      // log('${response.statusCode}');
      log('abs');

      if (response.statusCode == 200) {
        // log('response OK');
        log('body response place order ${response.body}');
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          responseData['data']['offline_invoice_no'] == null
              ? log("offline invoice no: null")
              : await localTransaction.removeFromLocal(
                  id: responseData['data']['offline_invoice_no'].toString());
          log(
              "offline invoice no: ${responseData['data']['offline_invoice_no']}");
          return Left(InvoiceModel.fromJson(responseData['data']));
        } else {
          log(responseData['error']);
          ErrorFuncs(context).errRegisterClose(
              errorInfo: {'error': responseData['error']});
          return Right(responseData['error']['info']);
        }
      } else {
        log('status response place order ${response.body}');

        return Right('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      return Right('$error');
    }
  }
}
