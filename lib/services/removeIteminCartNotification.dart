import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/utils/api_constants.dart';
import 'package:opalposinc/utils/global_variables.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class RemoveItemCartNotification {
  static String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  static Future<Map<String, dynamic>> sendRemoveProductNotification({
    required BuildContext context,
    required Product product,
    required LoggedInUser loggedInUser,
  }) async {
    CustomerBloc customer = BlocProvider.of<CustomerBloc>(context);
    LocationBloc location = BlocProvider.of<LocationBloc>(context);

    var url = Uri.parse(ApiConstants.getBaseUrl(storeUrl) +
        ApiConstants.sendRemoveCartItemsAlert);
    var headers = {
      'OPAL-PAY-API-KEY': apiKey,
    };

    var request = http.MultipartRequest('POST', url);

    // 'https://$storeUrl.opalpay.us/public/api/send_remove_cart_item_alert'

    // Prepare request fields
    request.fields.addAll({
      'user': jsonEncode({
        'id': loggedInUser.id,
        'password': loggedInUser.password,
        'surname': loggedInUser.surname,
        'first_name': loggedInUser.firstName,
        'last_name': loggedInUser.lastName,
        'username': loggedInUser.username,
        'email': loggedInUser.email,
        'business_id': loggedInUser.businessId,
        'allow_login': loggedInUser.allowLogin.toString(),
        'status': loggedInUser.status,
        'locations': loggedInUser.locations,
        'color': loggedInUser.color,
        'business_name': loggedInUser.businessName ?? 'Opal POS Inc',
        'cash_register_status': loggedInUser.registerStatus,
        'location_list': loggedInUser.locationList,
      }),
      'business_id': loggedInUser.businessId.toString(),
      'business_name': location.state?.name ?? 'Oalana',
      'product': jsonEncode([product.toJson()]),
      'customer_name': customer.state?.name ?? 'Test Customer',
      'location_name': location.state?.name ?? 'Oalana',
      'location_id': location.state?.locationId ?? 'BL0001',
    });

    request.headers.addAll(headers);
    log('Request Body: ${(request.fields)}');
    // Send request and await response
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        log('Response Data: $responseData');
        return jsonDecode(responseData); // Return the decoded response
      } else {
        log('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return {
          'success': false,
          'message': 'Error: ${response.statusCode} - ${response.reasonPhrase}'
        };
      }
    } catch (error) {
      log('Error: $error');
      return {'success': false, 'message': 'Error: $error'};
    }
  }
}
