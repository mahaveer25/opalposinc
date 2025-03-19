import 'package:opalposinc/model/PaymentModels/CardModel.dart';
import 'package:opalposinc/model/PaymentModels/CashModel.dart';
import 'package:opalposinc/model/PaymentModels/OthersPaymentModel.dart';

import '../model/PaymentModels/BankTransferModel.dart';
import '../model/PaymentModels/ChequeModel.dart';

abstract class PaymentMethodStates {}

class CardState extends PaymentMethodStates {
  final CardModel cardModel;

  CardState(this.cardModel);
}

class CashState extends PaymentMethodStates {
  final CashModel cashModel;

  CashState(this.cashModel);
}

class ChequeState extends PaymentMethodStates {
  final ChequeModel chequeModel;

  ChequeState(this.chequeModel);
}

class BankTransferState extends PaymentMethodStates {
  final BankTransferModel bankTransferModel;

  BankTransferState(this.bankTransferModel);
}

class OtherState extends PaymentMethodStates {
  final OthersPaymentModel paymentModel;

  OtherState(this.paymentModel);
}
