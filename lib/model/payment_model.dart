class PaymentMethod {
  String? type;
  String? name;

  PaymentMethod({this.type, this.name});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      type: json['type']??"",
      name: json['name'] ?? 'Cash',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type??"",
      'name': name ?? 'Cash',
    };
  }
}
