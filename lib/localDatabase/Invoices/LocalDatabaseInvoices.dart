import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class LocalDatabaseInvoices {
  final BuildContext context;
  LocalDatabaseInvoices(this.context);

  Future<InvoiceModel> makeInvoice(
      {required BuildContext context, required Transaction transaction}) async {
    Location? location = BlocProvider.of<LocationBloc>(context).state;
    CustomerModel? customer = BlocProvider.of<CustomerBloc>(context).state;
    TaxModel? taxModel = BlocProvider.of<TaxBloc>(context).state;

    // Map<String, dynamic> productMap = jsonDecode(transaction.Product);
    log('${transaction.toJson()}');

    final subTotal = makeSubtotal(listProduct: transaction.product ?? []);
    final wholeInvoiceDIscount = FunctionProduct.applyDiscount(
        selectedValue: transaction.discountType.toString(),
        discount: transaction.discountAmount?.toDouble() ?? 0.0,
        amount: subTotal,
        isReturnZero: true);
    final taxApplied =
        makeTax(listProduct: transaction.product ?? [], taxModel: taxModel!);

    final total = subTotal - wholeInvoiceDIscount + taxApplied;
    final totalPaid = transaction.payment
        ?.map((e) => PaymentListMethod.fromJson(e).amount)
        .toList()
        .fold(
            0.0,
            (previousValue, element) =>
                previousValue + double.parse(element.toString()));
    final blalance =
        total > (totalPaid ?? 0.0) ? total - (totalPaid ?? 0.0) : 0.0;
    final changeReturn =
        total < (totalPaid ?? 0.0) ? (totalPaid ?? 0.0) - total : 0.0;

    InvoiceModel invoiceModel = InvoiceModel(
      transactionId: null,
      invoiceTitle: location?.name.toString(),
      address: '${location?.city}, ${location?.state}, ${location?.zipCode}',
      mobile: location?.alternateNumber.toString(),
      invoiceNumber: null,
      invoiceDiscount: wholeInvoiceDIscount.toString(),
      invoiceFooterText: "THANK YOU FOR SHOPPING WITH US !!",
      invoiceNoReturned: null,
      offlineInvoiceNo: transaction.offlineInvoiceNo,
      date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()).toString(),
      discountAmount: transaction.discountAmount.toString(),
      discountType: transaction.discountAmount.toString(),
      taxAmount: taxApplied.toStringAsFixed(2),
      taxPercentage: double.parse(taxModel.amount ?? 0.0.toString()).toString(),
      taxType: taxModel.name,
      total: total.toString(),
      totalPaid:
          (totalPaid ?? 0.0 + double.parse(transaction.changeReturn.toString()))
              .toString(),
      subTotal: subTotal.toString(),
      customer: customer?.name.toString(),
      changeReturn: changeReturn.toString(),
      customerMobile: customer?.mobile.toString(),
      balance: blalance.toString(),
      paymentMethod: transaction.payment
          ?.map((e) => PaymentListMethod.fromJson(e))
          .toList(),
      product: transaction.product,
    );

    log('${invoiceModel.toJson()}');

    return invoiceModel;
  }

  double makeSubtotal({required List<Product> listProduct}) {
    double subtotal = 0.0;

    for (var e in listProduct) {
      double discountAmount = 0.0;

      if (e.lineDiscountType == 'Percentage') {
        discountAmount = double.parse(e.unit_price.toString()) *
            double.parse(e.lineDiscountAmount.toString()) /
            100;
      } else {
        discountAmount = double.parse(e.lineDiscountAmount.toString());
      }

      subtotal += (double.parse(e.unit_price.toString()) - discountAmount) *
          double.parse(e.quantity.toString());
    }

    return subtotal;
  }

  double makeTax(
      {required List<Product> listProduct, required TaxModel taxModel}) {
    final taxAmount = (makeSubtotal(listProduct: listProduct) *
            double.parse(taxModel.amount.toString())) /
        100;
    return taxAmount;
  }
}
