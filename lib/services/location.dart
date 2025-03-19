import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/utils/global_variables.dart';

class LocationService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<Location>> getlocations(
      BuildContext context, LoggedInUser loggedInUser) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api//get_locations?business_id=${loggedInUser.businessId}&user_id=${loggedInUser.id}&location_id=${loggedInUser.locations}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          List<Map<String, dynamic>> data = List.from(jsonData['data']);
          List<Location> locations =
              data.map((item) => Location.fromJson(item)).toList();
          return locations;
        } else {
          // ignore: use_build_context_synchronously
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
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
