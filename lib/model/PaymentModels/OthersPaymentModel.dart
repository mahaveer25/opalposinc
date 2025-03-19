class OthersPaymentModel {
  OthersPaymentModel({
    String? method,
    String? amount,
    String? paymentNote,
  }) {
    _method = method;
    _amount = amount;
    _paymentNote = paymentNote;
  }

  OthersPaymentModel.fromJson(dynamic json) {
    _method = json['method'];
    _amount = json['amount'];
    _paymentNote = json['payment_note'];
  }
  String? _method;
  String? _amount;
  String? _paymentNote;
  OthersPaymentModel copyWith({
    String? method,
    String? amount,
    String? paymentNote,
  }) =>
      OthersPaymentModel(
        method: method ?? _method,
        amount: amount ?? _amount,
        paymentNote: paymentNote ?? _paymentNote,
      );
  String? get method => _method;
  String? get amount => _amount;
  String? get paymentNote => _paymentNote;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['method'] = _method;
    map['amount'] = _amount;
    map['payment_note'] = _paymentNote;
    return map;
  }
}
