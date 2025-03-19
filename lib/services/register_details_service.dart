// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalposinc/model/register_details_model.dart';
import 'package:opalposinc/utils/global_variables.dart';

import '../widgets/common/Top Section/Bloc/CustomBloc.dart';

class RegisterDetailService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<RegisterDetails> getregisterdetails(BuildContext context) async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);

    var currentDate = DateTime.now();

    final url =
        'https://$storeUrl.opalpay.us/public/api/get_register_details?business_id=${loggedInUserBloc.state!.businessId}&user_id=${loggedInUserBloc.state!.id}&start_date=$currentDate';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          final Map<String, dynamic> data = jsonData['data'];
          final registerDetail = RegisterDetails.fromJson(data);

          print("list:${registerDetail.toJson()} ");
          return registerDetail;
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
