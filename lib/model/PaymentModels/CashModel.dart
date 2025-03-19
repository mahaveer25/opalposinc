/// method : "cash"
/// amount : "100"
/// payment_note : "cash payment note"
library;

class CashModel {
  CashModel({
      String? method, 
      String? amount, 
      String? paymentNote,}){
    _method = method;
    _amount = amount;
    _paymentNote = paymentNote;
}

  CashModel.fromJson(dynamic json) {
    _method = json['method'];
    _amount = json['amount'];
    _paymentNote = json['payment_note'];
  }
  String? _method;
  String? _amount;
  String? _paymentNote;
CashModel copyWith({  String? method,
  String? amount,
  String? paymentNote,
}) => CashModel(  method: method ?? _method,
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