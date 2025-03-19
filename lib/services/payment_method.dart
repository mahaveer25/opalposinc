// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/utils/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

import '../model/payment_model.dart';

class PaymentMethodService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<PaymentMethod>> getPaymentMethods(BuildContext context) async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);

    final url =
        'http://$storeUrl.opalpay.us/public/api/get_payment_methods?business_id=${loggedInUserBloc.state?.businessId}&location_id=${locationBloc.state?.id}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          List<Map<String, dynamic>> data = List.from(jsonData['data']);
          List<PaymentMethod> paymentMethod =
              data.map((item) => PaymentMethod.fromJson(item)).toList();
          return paymentMethod;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text("Missing Bussiness ID"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
        return [];
      } else {
        throw Exception('Failed to load Payment data:${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error of Method: $e");
    }
  }
}
