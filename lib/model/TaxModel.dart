class TaxModel {
  TaxModel(
      {String? businessId,
      String? taxId,
      String? name,
      String? amount,
      String? appliedAmount}) {
    _businessId = businessId;
    _taxId = taxId;
    _name = name;
    _amount = amount;
    _appliedAmount = appliedAmount;
  }

  TaxModel.fromJson(dynamic json) {
    _businessId = json['business_id'];
    _taxId = json['tax_id'];
    _name = json['name'];
    _amount = json['amount'];
    _appliedAmount = json['appliedAmount'];
  }
  String? _businessId;
  String? _taxId;
  String? _name;
  String? _amount;
  String? _appliedAmount;
  TaxModel copyWith(
          {String? businessId,
          String? taxId,
          String? name,
          String? amount,
          String? appliedAmount}) =>
      TaxModel(
          businessId: businessId ?? _businessId,
          taxId: taxId ?? _taxId,
          name: name ?? _name,
          amount: amount ?? _amount,
          appliedAmount: appliedAmount ?? _appliedAmount);
  String? get businessId => _businessId;
  String? get taxId => _taxId;
  String? get name => _name;
  String? get amount => _amount;
  String? get appliedAmount => _appliedAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['business_id'] = _businessId;
    map['tax_id'] = _taxId;
    map['name'] = _name;
    map['amount'] = _amount;
    map['appliedAmount'] = _appliedAmount;
    return map;
  }
}
