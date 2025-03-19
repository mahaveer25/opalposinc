import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

import '../model/OrderTaxModel.dart';
import '../utils/global_variables.dart';
import 'package:http/http.dart' as http;

class GetOrderTaxServices {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';
  List<OrderTaxModel> orderTaxModels = [];

  Future<List<OrderTaxModel>> getOrderTaxList({
    required BuildContext context,
  }) async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    final url =
        "https://$storeUrl.opalpay.us/public/api/get_default_sale_tax?business_id=${loggedInUserBloc.state?.businessId}";
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        log("Body: ${response.body}");

        if (jsonData['success']) {
          List<dynamic> taxList = jsonData['data']['businesses_all_taxes'];
          orderTaxModels =
              taxList.map((e) => OrderTaxModel.fromJson(e)).toList();
          log("Parsed TaxModel: ${orderTaxModels.map((e) => e.toJson()).toList()}");

          return orderTaxModels;
        } else {
          ConstDialog(context).showErrorDialog(error: "Missing Business ID");
        }
        return [];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
