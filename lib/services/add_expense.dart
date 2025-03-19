import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/model/addExpenseModal.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/global_variables.dart';

class AddExpenses {
  String storeUrl = GlobalData.storeUrl;

  Future<void> addExpense(
      BuildContext context, AddExpenseModal addExpenses) async {
    log('uutftf${addExpenses.toJson()}');
    try {
      log(storeUrl);
      final response = await http.post(
          Uri.parse(
              'https://${GlobalData.storeUrl}.opalpay.us/public/api/add_expense'),
          headers: {
            'OPAL-PAY-API-KEY': '#bk_api_opal_v1_1_1@',
          },
          body: addExpenses.toJson());

      if (response.statusCode == 200) {
        log('response OK');
        log('body response ${response.body}');
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          log('${responseData['data']}');
          ConstDialog(context).showErrorDialog(
            error: "Expense Added Successfully",
            iconData: Icons.check_circle,
            iconColor: Colors.green,
            iconText: 'Success',
          );
        } else {
          log('Response Error: ${responseData['error']}');
          ConstDialog(context).showErrorDialog(
            error: responseData['error'] ?? "An unknown error occurred",
            iconData: Icons.error,
            iconColor: Colors.red,
            iconText: 'Error',
          );
        }
      } else {
        log('HTTP Error: ${response.statusCode}');
        ConstDialog(context).showErrorDialog(
          error: "HTTP Error: ${response.statusCode}",
          iconData: Icons.error,
          iconColor: Colors.red,
          iconText: 'Error',
        );
      }
    } catch (error) {
      log('Errors: $error');
      ConstDialog(context).showErrorDialog(
        error: "$error",
        iconData: Icons.error,
        iconColor: Colors.red,
        iconText: 'Alert',
      );
    }
  }
}
