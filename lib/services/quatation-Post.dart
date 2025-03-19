// PlaceOrder.dart

import 'dart:convert';
import 'dart:developer';
// import 'dart:js_interop';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/utils/api_constants.dart';
import 'package:opalposinc/utils/global_variables.dart';

class PostQuatationService {
  static String storeUrl = GlobalData.storeUrl;

  static Future<Either<InvoiceModel, String>> placeOrder(
      Transaction invoiceModel) async {
    try {
      log('${invoiceModel.toJson()}');
      final response = await http.post(
          Uri.parse(
              ApiConstants.getBaseUrl(storeUrl) + ApiConstants.posQuotation),
          headers: {
            'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
          },
          body: invoiceModel.toJson());

      // 'https://$storeUrl.opalpay.us/public/api/pos_quotation'

      if (response.statusCode == 200) {
        log('response OK');
        log('body response ${response.body}');
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final model = InvoiceModel.fromJson(responseData['data']);
          return Left(model);
        } else {
          return Right(responseData['error']['info']);
        }
      } else {
        log('HTTP Error: ${response.statusCode}');
        return const Right('Quatation Order Failed');
      }
    } catch (error) {
      log('Errors: $error');
      return const Right('Quatation Catch Error');
    }
  }
}
