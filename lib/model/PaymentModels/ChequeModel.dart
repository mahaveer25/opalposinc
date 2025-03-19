class ChequeModel {
  ChequeModel({
      String? method, 
      String? amount, 
      String? paymentNote, 
      String? chequeNumber,}){
    _method = method;
    _amount = amount;
    _paymentNote = paymentNote;
    _chequeNumber = chequeNumber;
}

  ChequeModel.fromJson(dynamic json) {
    _method = json['method'];
    _amount = json['amount'];
    _paymentNote = json['payment_note'];
    _chequeNumber = json['cheque_number'];
  }
  String? _method;
  String? _amount;
  String? _paymentNote;
  String? _chequeNumber;
ChequeModel copyWith({  String? method,
  String? amount,
  String? paymentNote,
  String? chequeNumber,
}) => ChequeModel(  method: method ?? _method,
  amount: amount ?? _amount,
  paymentNote: paymentNote ?? _paymentNote,
  chequeNumber: chequeNumber ?? _chequeNumber,
);
  String? get method => _method;
  String? get amount => _amount;
  String? get paymentNote => _paymentNote;
  String? get chequeNumber => _chequeNumber;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['method'] = _method;
    map['amount'] = _amount;
    map['payment_note'] = _paymentNote;
    map['cheque_number'] = _chequeNumber;
    return map;
  }

}