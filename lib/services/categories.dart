import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opalsystem/model/category.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/utils/global_variables.dart';

class CategoryService {
  String storeUrl = GlobalData.storeUrl;
  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<Category>> getCategories(
      {required LoggedInUser loggedInUser}) async {
    final url =
        'https://$storeUrl.opalpay.us/public/api/get_categories?business_id=${loggedInUser.businessId}&user_id=${loggedInUser.id}&location_id=${loggedInUser.locations}';
    final headers = {'OPAL-PAY-API-KEY': apiKey};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final categoriesData = data['data'] as List<dynamic>?;
        if (categoriesData == null) {
          throw Exception('Categories data is null');
        }

        final allCategoriesList = categoriesData
            .map((category) => Category(
                  id: category['id'],
                  name: category['name'] ?? 'Unknown',
                  shortCode: category['short_code'] ?? '',
                  type: category['type'] ?? '',
                ))
            .toList();

        return allCategoriesList;
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories');
    }
  }
}
