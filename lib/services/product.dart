import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/utils/api_constants.dart';
import 'package:opalposinc/utils/global_variables.dart';

import '../model/product.dart';

class ProductService {
  static String storeUrl = GlobalData.storeUrl;

  static const String apiKey = '#bk_api_opal_v1_1_1@';

  Future<List<Product>> fetchProducts({
    required String? categoryId,
    required String? brandId,
    required String? locationId,
    required LoggedInUser loggedInUser,
  }) async {
    final headers = {'OPAL-PAY-API-KEY': apiKey};
    final url = ApiConstants.getBaseUrl(storeUrl) + ApiConstants.getProducts;

    final Map<String, dynamic> queryParameters = {
      'category_id': categoryId.toString(),
      'brand_id': brandId.toString(),
      'business_id': loggedInUser.businessId,
      'location_id': locationId,
      'user': loggedInUser.id
    };
    // 'https://$storeUrl.opalpay.us/public/api/get_products';

    log('Query parameters: $queryParameters');

    try {
      final response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success']) {
          final data = jsonData['data'];
          if (data != null && data is List) {
            return data.map((e) => Product.fromJson(e)).toList();
          } else {
            return [];
          }
        } else {
          throw Exception('Failed to fetch Product: ${jsonData['message']}');
        }
      } else {
        throw Exception(
            'API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching Product: $e');
      throw Exception('Failed to load Product. Details: $e');
    }
  }
}
