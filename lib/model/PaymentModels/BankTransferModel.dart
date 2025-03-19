/// method : "cash"
/// amount : "100"
/// payment_note : "cash payment note"
/// account_number : ""
library;

class BankTransferModel {
  BankTransferModel({
      String? method, 
      String? amount, 
      String? paymentNote, 
      String? accountNumber,}){
    _method = method;
    _amount = amount;
    _paymentNote = paymentNote;
    _accountNumber = accountNumber;
}

  BankTransferModel.fromJson(dynamic json) {
    _method = json['method'];
    _amount = json['amount'];
    _paymentNote = json['payment_note'];
    _accountNumber = json['account_number'];
  }
  String? _method;
  String? _amount;
  String? _paymentNote;
  String? _accountNumber;
BankTransferModel copyWith({  String? method,
  String? amount,
  String? paymentNote,
  String? accountNumber,
}) => BankTransferModel(  method: method ?? _method,
  amount: amount ?? _amount,
  paymentNote: paymentNote ?? _paymentNote,
  accountNumber: accountNumber ?? _accountNumber,
);
  String? get method => _method;
  String? get amount => _amount;
  String? get paymentNote => _paymentNote;
  String? get accountNumber => _accountNumber;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['method'] = _method;
    map['amount'] = _amount;
    map['payment_note'] = _paymentNote;
    map['account_number'] = _accountNumber;
    return map;
  }

}