import 'package:opalposinc/model/payment_model.dart';

class PaymentListMethod {
  PaymentMethod? methodType;
  String? method;
  String? amount;
  String? cardNumber;
  String? cardHolderName;
  String? cardMonth;
  String? cardYear;
  String? cardType;
  String? cardSecurity;
  String? cardTransactionNumber;
  String? paymentNote;
  String? accountNumber;
  String? chequeNumber;
  String? cardString;
  PaymentListMethod(
      {this.methodType,
      this.method,
      this.amount,
      this.cardNumber,
      this.cardHolderName,
      this.cardMonth,
      this.cardYear,
      this.cardType,
      this.cardSecurity,
      this.cardTransactionNumber,
      this.paymentNote,
      this.accountNumber,
      this.chequeNumber,
      this.cardString});
  PaymentListMethod copyWith(
      {String? method,
      String? amount,
      String? cardNumber,
      String? cardHolderName,
      String? cardMonth,
      String? cardYear,
      String? cardType,
      String? cardSecurity,
      String? cardTransactionNumber,
      String? paymentNote,
      String? accountNumber,
      String? chequeNumber,
      String? cardString}) {
    return PaymentListMethod(
        method: method ?? this.method,
        amount: amount ?? this.amount,
        cardNumber: cardNumber ?? this.cardNumber,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        cardMonth: cardMonth ?? this.cardMonth,
        cardYear: cardYear ?? this.cardYear,
        cardType: cardType ?? this.cardType,
        cardSecurity: cardSecurity ?? this.cardSecurity,
        cardTransactionNumber:
            cardTransactionNumber ?? this.cardTransactionNumber,
        paymentNote: paymentNote ?? this.paymentNote,
        accountNumber: accountNumber ?? this.accountNumber,
        chequeNumber: chequeNumber ?? this.chequeNumber,
        cardString: cardString ?? this.cardString);
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'amount': amount,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'card_month': cardMonth,
      'card_year': cardYear,
      'card_type': cardType,
      'card_security': cardSecurity,
      'card_transaction_number': cardTransactionNumber,
      'payment_note': paymentNote,
      'account_number': accountNumber,
      'cheque_number': chequeNumber,
      'card_string': cardString
    };
  }

  static PaymentListMethod fromJson(Map<String, Object?> json) {
    return PaymentListMethod(
        method: json['method'] == null ? null : json['method'] as String,
        amount: json['amount'] == null ? null : json['amount'] as String,
        cardNumber:
            json['card_number'] == null ? null : json['card_number'] as String,
        cardHolderName: json['card_holder_name'] == null
            ? null
            : json['card_holder_name'] as String,
        cardMonth:
            json['card_month'] == null ? null : json['card_month'] as String,
        cardYear:
            json['card_year'] == null ? null : json['card_year'] as String,
        cardType:
            json['card_type'] == null ? null : json['card_type'] as String,
        cardSecurity: json['card_security'] == null
            ? null
            : json['card_security'] as String,
        cardTransactionNumber: json['card_transaction_number'] == null
            ? null
            : json['card_transaction_number'] as String,
        paymentNote: json['payment_note'] == null
            ? null
            : json['payment_note'] as String,
        accountNumber: json['account_number'] == null
            ? null
            : json['account_number'] as String,
        chequeNumber: json['cheque_number'] == null
            ? null
            : json['cheque_number'] as String,
        cardString:
            json['card_string'] == null ? null : json['card_string'] as String);
  }

  @override
  String toString() {
    return '''PaymentListMethod(
                method:$method,
amount:$amount,
cardNumber:$cardNumber,
cardHolderName:$cardHolderName,
cardMonth:$cardMonth,
cardYear:$cardYear,
cardType:$cardType,
cardSecurity:$cardSecurity,
cardTransactionNumber:$cardTransactionNumber,
paymentNote:$paymentNote,
accountNumber:$accountNumber,
chequeNumber:$chequeNumber,
cardString:$cardString
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentListMethod &&
        other.runtimeType == runtimeType &&
        other.method == method &&
        other.amount == amount &&
        other.cardNumber == cardNumber &&
        other.cardHolderName == cardHolderName &&
        other.cardMonth == cardMonth &&
        other.cardYear == cardYear &&
        other.cardType == cardType &&
        other.cardSecurity == cardSecurity &&
        other.cardTransactionNumber == cardTransactionNumber &&
        other.paymentNote == paymentNote &&
        other.accountNumber == accountNumber &&
        other.chequeNumber == chequeNumber &&
        other.cardString == cardString;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        method,
        amount,
        cardNumber,
        cardHolderName,
        cardMonth,
        cardYear,
        cardType,
        cardSecurity,
        cardTransactionNumber,
        paymentNote,
        accountNumber,
        chequeNumber,
        cardString);
  }
}
