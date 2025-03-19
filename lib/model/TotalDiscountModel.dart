class TotalDiscountModel {
  TotalDiscountModel({
    String? type,
    num? amount,
    num? points,
    num? redeemedAmount,
  }) {
    _type = type;
    _amount = amount;
    _points = points;
    _redeemedAmount = redeemedAmount;
  }

  TotalDiscountModel.fromJson(dynamic json) {
    _type = json['type'];
    _amount = json['amount'];
    _points = json['points'];
    _redeemedAmount = json['redeemed_amount'];
  }
  String? _type;
  num? _amount;
  num? _points;
  num? _redeemedAmount;
  TotalDiscountModel copyWith({
    String? type,
    num? amount,
    num? points,
    num? redeemedAmount,
  }) =>
      TotalDiscountModel(
        type: type ?? _type,
        amount: amount ?? _amount,
        points: points ?? _points,
        redeemedAmount: redeemedAmount ?? _redeemedAmount,
      );
  String? get type => _type;
  num? get amount => _amount;
  num? get points => _points;
  num? get redeemedAmount => _redeemedAmount;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['type'] = _type;
    map['amount'] = _amount;
    map['points'] = _points;
    map['redeemed_amount'] = _redeemedAmount ?? 0.0;
    return map;
  }
}
