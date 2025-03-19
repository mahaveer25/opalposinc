class Product {
  String? suspendId;
  String? productId;
  String? variationId;
  String? enableStock;
  String? productType;
  String? name;
  String? subSku;
  String? defaultSellPrice;
  String? brandId;
  String? categoryId;
  String? subCategoryId;
  String? image;
  String? lineDiscountType;
  String? lineDiscountAmount;
  String? itemTax;
  String? quantity = "1";
  String? alreadyReturned = "1";
  String? returnQuantity = "0.00";
  double? returnSubtotal = 0.00;
  String? unitPriceIncTax;
  String? unit_price;
  String? calculate;
  String? availableLocationsString;
  List<PricingGroups>? pricingGroups;
  bool? isFeatured;
  List<dynamic>? locations;
  Product(
      {this.suspendId,
      this.productId,
      this.variationId,
      this.enableStock,
      this.productType,
      this.name,
      this.subSku,
      this.defaultSellPrice,
      this.brandId,
      this.categoryId,
      this.subCategoryId,
      this.image,
      this.lineDiscountType,
      this.lineDiscountAmount,
      this.itemTax,
      this.quantity,
      this.returnQuantity,
      this.returnSubtotal,
      this.unitPriceIncTax,
      this.unit_price,
      this.alreadyReturned,
      this.calculate,
      this.availableLocationsString,
      this.pricingGroups,
      this.isFeatured,
      this.locations});
  Product copyWith(
      {String? suspendid,
      String? productId,
      String? variationId,
      String? enableStock,
      String? productType,
      String? name,
      String? subSku,
      String? defaultSellPrice,
      String? brandId,
      String? categoryId,
      String? subCategoryId,
      String? image,
      String? lineDiscountType,
      String? lineDiscountAmount,
      String? itemTax,
      String? quantity = '1',
      String? returnQuantity = '0.0',
      double? returnSubtotal = 0.0,
      String? unitPriceIncTax,
      String? unit_price,
      String? calculate,
      String? alreadyReturned,
      String? availableLocationsString,
      List<PricingGroups>? pricingGroups,
      bool? isFeatured,
      List<dynamic>? locations}) {
    return Product(
        suspendId: suspendId ?? suspendId,
        productId: productId ?? this.productId,
        variationId: variationId ?? this.variationId,
        enableStock: enableStock ?? this.enableStock,
        productType: productType ?? this.productType,
        name: name ?? this.name,
        subSku: subSku ?? this.subSku,
        defaultSellPrice: defaultSellPrice ?? this.defaultSellPrice,
        brandId: brandId ?? this.brandId,
        categoryId: categoryId ?? this.categoryId,
        subCategoryId: subCategoryId ?? this.subCategoryId,
        image: image ?? this.image,
        lineDiscountType: lineDiscountType ?? this.lineDiscountType,
        lineDiscountAmount: lineDiscountAmount ?? this.lineDiscountAmount,
        itemTax: itemTax ?? this.itemTax,
        quantity: quantity ?? this.quantity,
        returnQuantity: returnQuantity ?? this.returnQuantity,
        returnSubtotal: returnSubtotal ?? this.returnSubtotal,
        unitPriceIncTax: unitPriceIncTax ?? this.unitPriceIncTax,
        unit_price: unit_price ?? this.unit_price,
        alreadyReturned: alreadyReturned ?? this.alreadyReturned,
        calculate: calculate ?? this.calculate,
        availableLocationsString:
            availableLocationsString ?? this.availableLocationsString,
        pricingGroups: pricingGroups ?? this.pricingGroups,
        isFeatured: isFeatured ?? this.isFeatured,
        locations: locations ?? this.locations);
  }

  Map<String, Object?> toJson() {
    return {
      'id': suspendId.toString(),
      'product_id': productId,
      'variation_id': variationId,
      'enable_stock': enableStock,
      'product_type': productType,
      'name': name,
      'sub_sku': subSku,
      'default_sell_price': defaultSellPrice,
      'brand_id': brandId,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'image': image,
      'line_discount_type': lineDiscountType ?? 'fixed',
      'line_discount_amount': lineDiscountAmount ?? 0.0.toString(),
      'item_tax': itemTax ?? 0.0.toString(),
      'quantity': double.parse(quantity.toString()).toString(),
      'already_returned': double.parse(alreadyReturned.toString()).toString(),
      'quantity_returned':
          double.parse(returnQuantity ?? 0.00.toString()).toStringAsFixed(2),
      // 'return_subtotal': returnSubtotal,
      'unit_price_inc_tax': unit_price,
      'unit_price': unit_price,
      'calculate': calculate,
      'available_locations_string': availableLocationsString,
      'pricing_groups': pricingGroups?.map((data) => data.toJson()).toList(),
      'is_featured': isFeatured,
      'available_locations': locations
    };
  }

  static Product fromJson(Map<String, Object?> json) {
    return Product(
        suspendId: json['id'] as String?,
        productId:
            json['product_id'] == null ? null : json['product_id'] as String?,
        variationId: json['variation_id'] == null
            ? null
            : json['variation_id'] as String?,
        enableStock: json['enable_stock'] == null
            ? null
            : json['enable_stock'] as String?,
        productType: json['product_type'] == null
            ? null
            : json['product_type'] as String?,
        name: json['name'] == null ? null : json['name'] as String?,
        subSku: json['sub_sku'] == null ? null : json['sub_sku'] as String?,
        defaultSellPrice: json['default_sell_price'] == null
            ? null
            : json['default_sell_price'] as String?,
        brandId: json['brand_id'] as String?,
        categoryId:
            json['category_id'] == null ? null : json['category_id'] as String?,
        subCategoryId: json['sub_category_id'] as String?,
        image: json['image'] == null ? null : json['image'] as String?,
        lineDiscountType: json['line_discount_type'] == null
            ? null
            : json['line_discount_type'] as String?,
        lineDiscountAmount: json['line_discount_amount'] == null
            ? null
            : json['line_discount_amount'] as String?,
        itemTax: json['item_tax'] == null ? null : json['item_tax'] as String?,
        quantity: json['quantity'] == null
            ? 1.toString()
            : double.parse(json['quantity'].toString()).toInt().toString()
                as String?,
        alreadyReturned: json['already_returned'] == null
            ? 1.toString()
            : double.parse(json['already_returned'].toString())
                .toInt()
                .toString(),
        returnQuantity: json['quantity_returned'] == null
            ? 1.toString()
            : double.parse(json['quantity_returned'].toString())
                .toInt()
                .toString() as String?,
        returnSubtotal: json['return_subtotal'] == null
            ? null
            : json['return_subtotal'] as double?,
        unitPriceIncTax: json['unit_price_inc_tax'] == null
            ? null
            : json['unit_price_inc_tax'] as String?,
        unit_price:
            json['unit_price'] == null ? null : json['unit_price'] as String?,
        calculate:
            json['calculate'] == null ? null : json['calculate'] as String?,
        availableLocationsString: json['available_locations_string'] == null
            ? null
            : json['available_locations_string'] as String?,
        pricingGroups: json['pricing_groups'] == null
            ? <PricingGroups>[]
            : List.from((json['pricing_groups'] as List<dynamic>)
                .map((v) => PricingGroups.fromJson(v))
                .toList()),
        isFeatured:
            json['is_featured'] == null ? null : json['is_featured'] as bool?,
        locations: json['available_locations'] == null
            ? null
            : json['available_locations'] as List<dynamic>);
  }

  @override
  String toString() {
    return '''Product(
                id:$suspendId,
productId:$productId,
variationId:$variationId,
enableStock:$enableStock,
productType:$productType,
name:$name,
subSku:$subSku,
defaultSellPrice:$defaultSellPrice,
brandId:$brandId,
categoryId:$categoryId,
subCategoryId:$subCategoryId,
image:$image,
lineDiscountType:$lineDiscountType,
lineDiscountAmount:$lineDiscountAmount,
itemTax:$itemTax,
quantity:$quantity,
returnQuantity:$returnQuantity,
returnSubtotal:$returnSubtotal,
unitPriceIncTax:$unitPriceIncTax,
unit_price:$unit_price,
calculate:$calculate,
availableLocationsString:$availableLocationsString,
pricingGroups:${pricingGroups.toString()},
isFeatured:$isFeatured,
locations:$locations
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Product &&
        other.runtimeType == runtimeType &&
        other.suspendId == suspendId &&
        other.productId == productId &&
        other.variationId == variationId &&
        other.enableStock == enableStock &&
        other.productType == productType &&
        other.name == name &&
        other.subSku == subSku &&
        other.defaultSellPrice == defaultSellPrice &&
        other.brandId == brandId &&
        other.categoryId == categoryId &&
        other.subCategoryId == subCategoryId &&
        other.image == image &&
        other.lineDiscountType == lineDiscountType &&
        other.lineDiscountAmount == lineDiscountAmount &&
        other.itemTax == itemTax &&
        other.quantity == quantity &&
        other.returnQuantity == returnQuantity &&
        other.returnSubtotal == returnSubtotal &&
        other.unitPriceIncTax == unitPriceIncTax &&
        other.unit_price == unit_price &&
        other.calculate == calculate &&
        other.availableLocationsString == availableLocationsString &&
        other.pricingGroups == pricingGroups &&
        other.isFeatured == isFeatured &&
        other.locations == locations;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        suspendId,
        productId,
        variationId,
        enableStock,
        productType,
        name,
        subSku,
        defaultSellPrice,
        brandId,
        categoryId,
        subCategoryId,
        image,
        lineDiscountType,
        lineDiscountAmount,
        itemTax,
        quantity,
        returnQuantity,
        returnSubtotal,
        unitPriceIncTax);
  }
}

class PricingGroups {
  final String? id;
  final String? name;
  final String? price;
  const PricingGroups({this.id, this.name, this.price});
  PricingGroups copyWith({String? id, String? name, String? price}) {
    return PricingGroups(
        id: id ?? this.id, name: name ?? this.name, price: price ?? this.price);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }

  static PricingGroups fromJson(Map<String, Object?> json) {
    return PricingGroups(
        id: json['id'] == null ? null : json['id'] as String,
        name: json['name'] == null ? null : json['name'] as String,
        price: json['price'] == null ? null : json['price'] as String);
  }

  @override
  String toString() {
    return '''PricingGroups(
                id:$id,
name:$name,
price:$price
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is PricingGroups &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, price);
  }
}
