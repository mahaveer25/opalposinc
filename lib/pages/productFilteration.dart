import 'package:flutter/cupertino.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/model/location.dart';

import '../model/product.dart';
import '../model/category.dart';

class ProductFilteration {
  final BuildContext context;
  ProductFilteration(this.context);

  List<Product> filteredProductList(
      {required Location location,
      required Category category,
      required Brand brand,
      required List<Product> list}) {
    final filteredList = list.where((element) {
      final bool locationBool = location.locationId == null
          ? true
          : element.locations?.contains(location.id) ?? false;
      final bool categoryBool =
          category.id == null || int.parse(category.id.toString()) == 0
              ? true
              : category.id == element.categoryId;
      final bool brandBool =
          brand.id == null || int.parse(brand.id.toString()) == 0
              ? true
              : brand.id == element.brandId;

      return locationBool && categoryBool && brandBool;
    }).toList();

    return filteredList;
  }
}
