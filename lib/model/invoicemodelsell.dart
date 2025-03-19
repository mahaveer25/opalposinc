import 'package:opalposinc/model/product.dart';

class InvoiceSellReturn {
  final String? invoiceTitle;
  final String? address;
  final String? mobile;
  final String? invoiceNumber;
  final String? date;
  final String? customer;
  final String? customerMobile;
  final List<Product>? product;
  final double? subTotal;
  final String? invoiceDiscount;
  final String? discountType;
  final int? productsDiscount;
  final double? taxAmount;
  final String? taxType;
  final String? taxPercentage;
  final double? total;
  final List<PaymentMethod>? paymentMethod;
  final double? balance;
  final double? totalPaid;
  final String? invoiceFooterText;
  final String? changeReturn;
  const InvoiceSellReturn({
    this.invoiceTitle,
    this.address,
    this.mobile,
    this.invoiceNumber,
    this.date,
    this.customer,
    this.customerMobile,
    this.product,
    this.subTotal,
    this.invoiceDiscount,
    this.discountType,
    this.productsDiscount,
    this.taxAmount,
    this.taxType,
    this.taxPercentage,
    this.total,
    this.paymentMethod,
    this.balance,
    this.totalPaid,
    this.invoiceFooterText,
    this.changeReturn,
  });
  InvoiceSellReturn copyWith(
      {String? invoiceTitle,
      String? address,
      String? mobile,
      String? invoiceNumber,
      String? date,
      String? customer,
      String? customerMobile,
      List<Product>? product,
      double? subTotal,
      String? invoiceDiscount,
      String? discountType,
      int? productsDiscount,
      double? taxAmount,
      String? taxType,
      String? taxPercentage,
      double? total,
      List<PaymentMethod>? paymentMethod,
      double? balance,
      double? totalPaid,
      String? invoiceFooterText,
      String? changeReturn}) {
    return InvoiceSellReturn(
        invoiceTitle: invoiceTitle ?? this.invoiceTitle,
        address: address ?? this.address,
        mobile: mobile ?? this.mobile,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        date: date ?? this.date,
        customer: customer ?? this.customer,
        customerMobile: customerMobile ?? this.customerMobile,
        product: product ?? this.product,
        subTotal: subTotal ?? this.subTotal,
        invoiceDiscount: invoiceDiscount ?? this.invoiceDiscount,
        discountType: discountType ?? this.discountType,
        productsDiscount: productsDiscount ?? this.productsDiscount,
        taxAmount: taxAmount ?? this.taxAmount,
        taxType: taxType ?? this.taxType,
        taxPercentage: taxPercentage ?? this.taxPercentage,
        total: total ?? this.total,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        balance: balance ?? this.balance,
        totalPaid: totalPaid ?? this.totalPaid,
        invoiceFooterText: invoiceFooterText ?? this.invoiceFooterText,
        changeReturn: changeReturn ?? this.changeReturn);
  }

  Map<String, Object?> toJson() {
    return {
      'invoice_title': invoiceTitle,
      'address': address,
      'mobile': mobile,
      'invoice_number': invoiceNumber,
      'date': date,
      'customer': customer,
      'customer_mobile': customerMobile,
      'product':
          product?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      'sub_total': subTotal,
      'invoice_discount': invoiceDiscount,
      'discount_type': discountType,
      'products_discount': productsDiscount,
      'tax_amount': taxAmount,
      'tax_type': taxType,
      'tax_percentage': taxPercentage,
      'total': total,
      'payment_method': paymentMethod
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'balance': balance,
      'total_paid': totalPaid,
      'invoice_footer_text': invoiceFooterText,
      'change_return': changeReturn
    };
  }

  static InvoiceSellReturn fromJson(Map<String, Object?> json) {
    return InvoiceSellReturn(
      invoiceTitle: json['invoice_title'] == null
          ? null
          : json['invoice_title'] as String,
      address: json['address'] == null ? null : json['address'] as String,
      mobile: json['mobile'] == null ? null : json['mobile'] as String,
      invoiceNumber: json['invoice_number'] == null
          ? null
          : json['invoice_number'] as String,
      date: json['date'] == null ? null : json['date'] as String,
      customer: json['customer'] == null ? null : json['customer'] as String,
      customerMobile: json['customer_mobile'] == null
          ? null
          : json['customer_mobile'] as String,
      product: json['product'] == null
          ? null
          : (json['product'] as List)
              .map((data) => Product.fromJson(data as Map<String, Object?>))
              .toList(),
      subTotal: json['sub_total'] == null ? null : json['sub_total'] as double,
      invoiceDiscount: json['invoice_discount'] == null
          ? null
          : json['invoice_discount'] as String,
      discountType: json['discount_type'] == null
          ? null
          : json['discount_type'] as String,
      productsDiscount: json['products_discount'] == null
          ? null
          : json['products_discount'] as int,
      taxAmount:
          json['tax_amount'] == null ? null : json['tax_amount'] as double,
      taxType: json['tax_type'] == null ? null : json['tax_type'] as String,
      taxPercentage: json['tax_percentage'] == null
          ? null
          : json['tax_percentage'] as String,
      total: json['total'] == null ? null : json['total'] as double,
      paymentMethod: json['payment_method'] == null
          ? null
          : (json['payment_method'] as List?)
              ?.map<PaymentMethod>((data) =>
                  PaymentMethod.fromJson(data as Map<String, Object?>) ??
                  const PaymentMethod())
              .toList(),
      balance: json['balance'] == null ? null : json['balance'] as double,
      totalPaid:
          json['total_paid'] == null ? null : json['total_paid'] as double,
      invoiceFooterText: json['invoice_footer_text'] == null
          ? null
          : json['invoice_footer_text'] as String,
      changeReturn: json['change_return'] == null
          ? null
          : json['change_return'] as String,
    );
  }

  @override
  String toString() {
    return '''InvoiceSellReturn(
                invoiceTitle:$invoiceTitle,
address:$address,
mobile:$mobile,
invoiceNumber:$invoiceNumber,
date:$date,
customer:$customer,
customerMobile:$customerMobile,
product:${product.toString()},
subTotal:$subTotal,
invoiceDiscount:$invoiceDiscount,
discountType:$discountType,
productsDiscount:$productsDiscount,
taxAmount:$taxAmount,
taxType:$taxType,
taxPercentage:$taxPercentage,
total:$total,
paymentMethod:${paymentMethod.toString()},
balance:$balance,
totalPaid:$totalPaid,
invoiceFooterText:$invoiceFooterText
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceSellReturn &&
        other.runtimeType == runtimeType &&
        other.invoiceTitle == invoiceTitle &&
        other.address == address &&
        other.mobile == mobile &&
        other.invoiceNumber == invoiceNumber &&
        other.date == date &&
        other.customer == customer &&
        other.customerMobile == customerMobile &&
        other.product == product &&
        other.subTotal == subTotal &&
        other.invoiceDiscount == invoiceDiscount &&
        other.discountType == discountType &&
        other.productsDiscount == productsDiscount &&
        other.taxAmount == taxAmount &&
        other.taxType == taxType &&
        other.taxPercentage == taxPercentage &&
        other.total == total &&
        other.paymentMethod == paymentMethod &&
        other.balance == balance &&
        other.totalPaid == totalPaid &&
        other.invoiceFooterText == invoiceFooterText;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        invoiceTitle,
        address,
        mobile,
        invoiceNumber,
        date,
        customer,
        customerMobile,
        product,
        subTotal,
        invoiceDiscount,
        discountType,
        productsDiscount,
        taxAmount,
        taxType,
        taxPercentage,
        total,
        paymentMethod,
        balance,
        totalPaid);
  }
}

class PaymentMethod {
  final String? paymentMethod;
  final double? amount;
  final dynamic note;

  const PaymentMethod({this.paymentMethod, this.amount, this.note});

  PaymentMethod copyWith({
    String? paymentMethod,
    double? amount,
    dynamic note,
  }) {
    return PaymentMethod(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'payment_method': paymentMethod,
      'amount': amount,
      'note': note,
    };
  }

  static PaymentMethod? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    try {
      return PaymentMethod(
        paymentMethod: json['payment_method'] as String?,
        amount: (json['amount'] ?? 0.0) is double
            ? json['amount'] as double?
            : double.tryParse(json['amount'].toString()),
        note: json['note'],
      );
    } catch (e) {
      print('Error parsing PaymentMethod from JSON: $e');
      return null;
    }
  }

  @override
  String toString() {
    return '''PaymentMethod(
      paymentMethod: $paymentMethod,
      amount: $amount,
      note: $note,
    )''';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentMethod &&
            runtimeType == other.runtimeType &&
            paymentMethod == other.paymentMethod &&
            amount == other.amount &&
            note == other.note;
  }

  @override
  int get hashCode {
    return paymentMethod.hashCode ^ amount.hashCode ^ note.hashCode;
  }
}
