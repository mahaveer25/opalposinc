import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/model/user.dart';
import 'package:opalposinc/utils/global_variables.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class UserDataService {
  String storeUrl = GlobalData.storeUrl;

  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<User>> getUserNames(BuildContext context) async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_users?business_id=${loggedInUserBloc.state!.businessId}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        log("Expense User: ${response.body}");
        if (jsonResponse['success'] == true) {
          final List<dynamic> usersData = jsonResponse['data'];
          List<User> users = usersData.map((userJson) {
            return User.fromJson(userJson);
          }).toList();

          return users;
        } else {
          log('API request was successful, but API indicates failure: ${jsonResponse['message']}');
          throw Exception(
              'API request was successful, but API indicates failure: ${jsonResponse['message']}');
        }
      } else {
        log('Failed to load user names. Status Code: ${response.statusCode}');
        throw Exception(
            'Failed to load user names. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error loading user names: $e');
      throw Exception('Error loading user names: $e');
    }
  }
}
