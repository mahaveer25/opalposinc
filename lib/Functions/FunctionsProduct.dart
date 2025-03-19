import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/services/sell_return.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/major/left_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionProduct {
  static double applyDiscount(
      {required String selectedValue,
      required double discount,
      required double amount,
      bool? isReturnZero}) {
    // double price = double.parse(discount.toString());
    if (selectedValue == "Percentage") {
      double? discountedPrice = amount - (amount * (discount / 100));
      return discountedPrice;
    } else if (selectedValue == 'Fixed') {
      double? discountedPrice = amount - discount;
      return discountedPrice;
    } else {
      return isReturnZero ?? false ? 0.0 : amount;
    }
  }

  static int getProductLength({required List<Product> productList}) {
    List<int?> quantities = productList
        .map((product) => product.quantity == null
            ? 0
            : int.parse(product.quantity.toString()))
        .toList();

    final sum = quantities.fold(
        0, (previousValue, element) => previousValue + element!.toInt());

    return sum;
  }

  static double productstotal({required List<Product> productList}) {
    final sum = double.parse(productList
        .map((product) {
          return double.parse(product.calculate ?? 0.0.toStringAsFixed(2)) *
              double.parse(product.quantity.toString());
        })
        .toList()
        .fold(0.0, (previousValue, element) => previousValue + element)
        .toString());

    return sum;
  }

  static int getProductLengthBackScreen({required List<Product> productList}) {
    List<int> quantities = productList.map((product) {
      if (product.quantity == null || product.quantity.toString().isEmpty) {
        return 0;
      }

      try {
        return int.parse(product.quantity.toString());
      } catch (e) {
        try {
          return double.parse(product.quantity.toString()).toInt();
        } catch (e) {
          return 0;
        }
      }
    }).toList();

    final sum =
        quantities.fold(0, (previousValue, element) => previousValue + element);

    return sum;
  }

  static double applyTax({required double total, required TaxModel taxModel}) {
    double taxRate = taxModel.amount == null
        ? 0.0
        : double.parse(taxModel.amount.toString()) / 100;

    double totalTax = total * taxRate;

    double taxAmount = double.parse(totalTax.toStringAsFixed(2));
    double totalWithTax = total + taxAmount;

    return totalWithTax;
  }

  double calculateItemTotal(
      {required TotalDiscountModel? discountprice,
      required List<Product> listProduct}) {
    double itemTotal = 0.0;

    itemTotal = FunctionProduct.productstotal(productList: listProduct);

    return FunctionProduct.applyDiscount(
        selectedValue: discountprice!.type.toString(),
        discount: (discountprice.amount?.toDouble() ?? 0.0).toDouble(),
        amount: itemTotal);
  }

  static void scrollToIndex(
      ScrollController scrollController, int index, double itemHeight) {
    final double offset = index *
        itemHeight; // Calculate the offset based on item height and index

    scrollController.animateTo(
      offset, // Scroll to the calculated offset
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  static void scrollToBottom(ScrollController scrollController) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  static void getSavedSlideImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('slideImages') ?? [];
    displayManager.transferDataToPresentation(
        {'type': 'slideImages', 'slideImages': list});
  }

  static Future<void> disappearBackSuccessTransitionScreen() async {
    await displayManager.transferDataToPresentation(
        {'type': 'successTransactionSecond', 'successTransaction': null});
  }

  static Future<void> customBackScreenSendData(
      {required String type,
      required dynamic data,
      required bool isModel}) async {
    await displayManager.transferDataToPresentation({
      'type': type,
      type: isModel ? data.toJson() : data,
    });
  }

  static bool checkAllPaymentMethodsSelected(
      List<PaymentListMethod> methodListWidget) {
    for (var i in methodListWidget) {
      if (i.method == null || i.method == "") {
        return false;
      }
    }
    return true;
  }

  static double getPercentageDiscountAmount(
      {required amount, required String discountType, required double total}) {
    double discountedAmount = 0.0;
    if (discountType == "Percentage") {
      discountedAmount = (amount / 100) * total;
    } else if (discountType == "Fixed") {
      discountedAmount = amount;
    }
    log('This is discounted Amount' + discountedAmount.toString());
    return discountedAmount;
  }

  static double getCalculatedTaxAmount(
      {required double amountTotal,
      required String tax,
      required double discount}) {
    double total = amountTotal - discount;
    double taxRate = double.parse(tax.toString()) / 100;

    double taxAmount = total * taxRate;
    return taxAmount;
  }
}
