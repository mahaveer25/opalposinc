import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/invoices/transaction.dart';
import 'package:opalsystem/utils/api_constants.dart';
import 'package:opalsystem/utils/global_variables.dart';

class PostDraftService {
  static String storeUrl = GlobalData.storeUrl;

  static Future<Either<InvoiceModel, String>> postDraft(
      Transaction invoiceModel) async {
    try {
      log('${invoiceModel.toJson()}');
      final response = await http.post(Uri.parse(
         'https://$storeUrl.opalpay.us/public/api/post_draft'

        // ApiConstants.getBaseUrl(storeUrl)+ApiConstants.postDraft
      ),
          headers: {
            ApiConstants.headerAuthorizationKey:ApiConstants.headerAuthorizationValue,
            // 'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
          },

          body: invoiceModel.toJson());

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        log('DRAFFT234${response.body}');
        if (responseData['success'] == true) {
          log('DRAFFT${responseData['data']}');
          final model = InvoiceModel.fromJson(responseData['data']);
          return Left(model);
        } else {
          return Right(responseData['error']['info']);
        }
      } else {
        return const Right('Cannot Post Draft');
      }
    } catch (error) {
      return const Right('Draft Catch Error');
    }
  }
}
