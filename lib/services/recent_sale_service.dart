// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalsystem/model/recent_sales_model.dart';
import 'package:opalsystem/utils/global_variables.dart';

import '../widgets/common/Top Section/Bloc/CustomBloc.dart';

class RecenetSalesService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<RecentSalesModel>> getRecentSales(
      BuildContext context, String type) async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);

    final url =
        'https://$storeUrl.opalpay.us/public/api/get_recent_sales?business_id=${loggedInUserBloc.state!.businessId}&location_id=${locationBloc.state?.id}&type=$type';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Response body: $jsonData');

        if (jsonData['success']) {
          final List<dynamic> responseData = jsonData['data'];
          print('Data type: ${responseData.runtimeType}');

          List<RecentSalesModel> recentSales = [];
          for (var item in responseData) {
            if (item is Map<String, dynamic>) {
              recentSales.add(RecentSalesModel.fromJson(item));
            } else {
              throw Exception("Data item is not in the expected format");
            }
          }

          print("list:${recentSales.map((e) => e.toJson()).toList()} ");
          return recentSales;
        } else {
          throw Exception("Missing Business ID");
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
