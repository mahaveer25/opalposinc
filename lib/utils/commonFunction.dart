import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class CommonFunctions {
  static void addPaxAndLocationIndexZero(
      LocationBloc locationBloc,
      LoggedInUser success,
      ListPaxDevicesBloc listPaxDevicesBloc,
      PaxDeviceBloc bloc) {
    if (locationBloc.state?.id != null || locationBloc.state?.id != "") {
      List<PaxDevice>? list = success.paxDevices
          ?.where(
            (element) =>
                element.businessLocationId.toString() ==
                locationBloc.state?.id.toString(),
          )
          .toList();
      if (list?.isNotEmpty ?? false) {
        listPaxDevicesBloc.add(list ?? []);
        bloc.add(PaxDeviceEvent(device: null));
      } else {
        debugPrint("PaxList in login is empty");
      }
    }
  }

  static String getCardTotalInReturn(InvoiceModel returnSale) {
    String? total = returnSale.paymentMethod
        ?.firstWhere((element) => element.method == "Card",
            orElse: () => PaymentListMethod(amount: "0.0"))
        .amount
        .toString();
    // log("This is card total"+total.toString());

    String? returnedAmount = returnSale.previousSaleReturnPaymentMethod
        ?.firstWhere((element) => element.method == "Card",
            orElse: () => PaymentListMethod(amount: "0.0"))
        .amount
        .toString();
    // log("This is card returnedAmount"+returnedAmount.toString());

    double finalResult =
        double.parse(total ?? "0.0") - double.parse(returnedAmount ?? "0.0");
    log("This is finalResult card " + finalResult.toStringAsFixed(2));

    // debugPrint("This is cardTotal: ${finalResult.toStringAsFixed(2)}");
    return finalResult.toStringAsFixed(2);
  }

  static String getCashTotalInReturn(InvoiceModel returnSale) {
    String? total = returnSale.paymentMethod
        ?.firstWhere((element) => element.method == "Cash",
            orElse: () => PaymentListMethod(amount: "0.0"))
        .amount
        .toString();
    String? returnedAmount = returnSale.previousSaleReturnPaymentMethod
        ?.firstWhere((element) => element.method == "Cash",
            orElse: () => PaymentListMethod(amount: "0.0"))
        .amount
        .toString();

    double finalResult =
        double.parse(total ?? "0.0") - double.parse(returnedAmount ?? "0.0");
    log("This is finalResult cash " + finalResult.toStringAsFixed(2));

    return finalResult.toStringAsFixed(2);
  }

  static String getWithDrawnMode(double cardTotal, double cashTotal) {
    if (cardTotal == 0.00 && cashTotal != 0.00) {
      return "Cash";
    } else if (cashTotal != 0.00 && cardTotal != 0.00) {
      return "Cash and Card";
    } else if (cashTotal == 0.00 && cardTotal != 0.00) {
      return "Card";
    } else {
      return "";
    }
  }

  static double roundNumber(double value, int places) {
    num val = math.pow(10.0, places);
    return ((value * val).round().toDouble() / val);
  }

  static String? getCardType(InvoiceModel returnSale) {
    String? cardType = returnSale.paymentMethod
        ?.firstWhere(
          (element) => element.method == "Card",
        )
        .cardType
        ?.toUpperCase();
    log("This is cardType: " + cardType.toString());

    return cardType;
  }
  // static double getRemainingCashReturn({required double cashTotal, required double returnTotal,required String selectedMethod}){
  //
  //   double remaining=cashTotal;
  //   if(selectedMethod=="cash"){
  //     remaining =cashTotal-returnTotal;
  //     return  double.parse(remaining.toStringAsFixed(2));
  //
  //   }else{
  //     return  double.parse(remaining.toStringAsFixed(2));
  //
  //   }
  // }

  // static double getRemainingCardReturn({required double cardTotal, required double returnTotal,required String selectedMethod}){
  //   double remaining=cardTotal;
  //   if(selectedMethod=="card"){
  //      remaining =cardTotal-returnTotal;
  //
  //    return  double.parse(remaining.toStringAsFixed(2));
  //
  //   }else{
  //     return  double.parse(remaining.toStringAsFixed(2));
  //
  //   }
  // }
}
