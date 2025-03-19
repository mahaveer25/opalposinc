
class CardModel {
  CardModel({
      String? method, 
      String? amount, 
      String? paymentNote, 
      String? cardNumber, 
      String? cardHolderName, 
      String? cardType, 
      String? cardMonth, 
      String? cardYear, 
      String? cardSecurity, 
      String? cardTransactionNumber,}){
    _method = method;
    _amount = amount;
    _paymentNote = paymentNote;
    _cardNumber = cardNumber;
    _cardHolderName = cardHolderName;
    _cardType = cardType;
    _cardMonth = cardMonth;
    _cardYear = cardYear;
    _cardSecurity = cardSecurity;
    _cardTransactionNumber = cardTransactionNumber;
}

  CardModel.fromJson(dynamic json) {
    _method = json['method'];
    _amount = json['amount'];
    _paymentNote = json['payment_note'];
    _cardNumber = json['card_number'];
    _cardHolderName = json['card_holder_name'];
    _cardType = json['card_type'];
    _cardMonth = json['card_month'];
    _cardYear = json['card_year'];
    _cardSecurity = json['card_security'];
    _cardTransactionNumber = json['card_transaction_number'];
  }
  String? _method;
  String? _amount;
  String? _paymentNote;
  String? _cardNumber;
  String? _cardHolderName;
  String? _cardType;
  String? _cardMonth;
  String? _cardYear;
  String? _cardSecurity;
  String? _cardTransactionNumber;
CardModel copyWith({  String? method,
  String? amount,
  String? paymentNote,
  String? cardNumber,
  String? cardHolderName,
  String? cardType,
  String? cardMonth,
  String? cardYear,
  String? cardSecurity,
  String? cardTransactionNumber,
}) => CardModel(  method: method ?? _method,
  amount: amount ?? _amount,
  paymentNote: paymentNote ?? _paymentNote,
  cardNumber: cardNumber ?? _cardNumber,
  cardHolderName: cardHolderName ?? _cardHolderName,
  cardType: cardType ?? _cardType,
  cardMonth: cardMonth ?? _cardMonth,
  cardYear: cardYear ?? _cardYear,
  cardSecurity: cardSecurity ?? _cardSecurity,
  cardTransactionNumber: cardTransactionNumber ?? _cardTransactionNumber,
);
  String? get method => _method;
  String? get amount => _amount;
  String? get paymentNote => _paymentNote;
  String? get cardNumber => _cardNumber;
  String? get cardHolderName => _cardHolderName;
  String? get cardType => _cardType;
  String? get cardMonth => _cardMonth;
  String? get cardYear => _cardYear;
  String? get cardSecurity => _cardSecurity;
  String? get cardTransactionNumber => _cardTransactionNumber;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['method'] = _method;
    map['amount'] = _amount;
    map['payment_note'] = _paymentNote;
    map['card_number'] = _cardNumber;
    map['card_holder_name'] = _cardHolderName;
    map['card_type'] = _cardType;
    map['card_month'] = _cardMonth;
    map['card_year'] = _cardYear;
    map['card_security'] = _cardSecurity;
    map['card_transaction_number'] = _cardTransactionNumber;
    return map;
  }

}