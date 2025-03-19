import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/CustomFuncs.dart';
import 'package:opalsystem/model/setttings.dart';
import 'package:opalsystem/utils/global_variables.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class SettingsApi {
  static String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<void> getAppSetting(
      {required BuildContext context, required String businessid}) async {
    final url =
        'http://$storeUrl.opalpay.us/public/api/business_setting?business_id=${businessid.toString()}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final Map<String, dynamic> data = jsonData['data'];
          final settings = SettingsModel.fromJson(data);

          log('Settings${settings.toJson()}');
          log('SMS enable${settings.enableInvoiceSMS}');
          log('Email enable${settings.enableInvoiceEmail}');

          SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
          settingsBloc.add(settings);
        } else {
          ErrorFuncs(context).errRegisterClose(errorInfo: jsonData['error']);
          throw Exception("Missing Business ID");
        }
      } else {
        ErrorFuncs(context)
            .errRegisterClose(errorInfo: {'info': 'Failed to get setting'});
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      ErrorFuncs(context)
          .errRegisterClose(errorInfo: {'info': 'Stuck at settings catch'});
      throw Exception('Error: $e');
    }
  }
}
