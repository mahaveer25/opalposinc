class OrderTaxModel {
     String? id;
     String? businessId;
     String? name;
     String? amount;

  OrderTaxModel({
      this.id,
      this.businessId,
      this.name,
      this.amount,
  });

  factory OrderTaxModel.fromJson(Map<String, dynamic> json) {
    return OrderTaxModel(
      id: json['id'],
      businessId: json['business_id'],
      name: json['name'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'amount': amount,
    };
  }

  static List<OrderTaxModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderTaxModel.fromJson(json)).toList();
  }
}
