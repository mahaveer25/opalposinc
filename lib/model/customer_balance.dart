class CustomerBalanceModel {
  String? name;
  String? balance;

  CustomerBalanceModel({
    this.name,
    this.balance,
  });

  factory CustomerBalanceModel.fromJson(Map<String, dynamic> json) {
    return CustomerBalanceModel(
      name: json['name'],
      balance: json['balance'],
    );
  }
  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['name'] = name;
    map['balance'] = balance;

    return map;
  }
}
