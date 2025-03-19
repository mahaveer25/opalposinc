import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/model/suspended_model.dart';
import 'package:opalposinc/utils/global_variables.dart';

import '../widgets/common/Top Section/Bloc/CustomBloc.dart';

class SuspendedOrders {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<SuspendedModel>> getSuspendedOrders(BuildContext context) async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_suspended_order?business_id=${loggedInUserBloc.state!.businessId}&location_id=${locationBloc.state?.id}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      log('Response body: $jsonData');

      if (jsonData['success']) {
        final List<dynamic> responseData = jsonData['data'];
        log('Data type: ${responseData.runtimeType}');

        List<SuspendedModel> suspendedOrdersList = [];
        for (var item in responseData) {
          if (item is Map<String, dynamic>) {
            suspendedOrdersList.add(SuspendedModel.fromJson(item));
          } else {
            throw Exception("Data item is not in the expected format");
          }
        }

        log("list:${suspendedOrdersList.map((e) => e.toJson()).toList()} ");
        return suspendedOrdersList;
      } else {
        throw Exception("Missing Business ID");
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
