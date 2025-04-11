// PlaceOrder.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/utils/api_constants.dart';
import 'package:opalposinc/utils/global_variables.dart';

class PostSellReturn {
  String storeUrl = GlobalData.storeUrl;

  Future<Either<InvoiceModel, String>> postSellReturn(
      BuildContext context, Transaction sellPost) async {
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.getBaseUrl(storeUrl) + ApiConstants.postSell),
          headers: {
            ApiConstants.headerAuthorizationKey:
                ApiConstants.headerAuthorizationValue,
          },
          body: sellPost.toJson());
      // 'https://$storeUrl.opalpay.us/public/api/sell_return'
      // 'http://localhost/project/opal_pos/public/api/sell_return'
      log("This is url for postSellReturn: ${ApiConstants.getBaseUrl(storeUrl) + ApiConstants.postSell} ");
      log("This is body for postSellReturn: ${sellPost.toJson()} ");

      if (response.statusCode == 200) {
        log('response OK');
        // log('${response.body}');
        final responseData = jsonDecode(response.body);

        log('${responseData['success']}');
        // log(response.body);

        if (responseData['success'] == true) {
          final model = InvoiceModel.fromJson(responseData['data']);
          log('${model.toJson()}');
          return Left(model);
        } else {
          ErrorFuncs(context)
              .errRegisterClose(errorInfo: responseData['error']);
          return Right(responseData['error']['info']);
        }
      } else {
        return const Right('Http Error!');
      }
    } catch (error) {
      log("sell post error:$error");
      return const Right('Error In Sell Return Catch!');
    }
  }
}
