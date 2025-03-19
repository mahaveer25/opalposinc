import 'dart:convert';
import 'dart:developer';

import 'package:opalsystem/multiplePay/PaymentListMethod.dart';

import '../model/product.dart';

class InvoiceModel {
  InvoiceModel({
    String? transactionId,
    String? invoiceTitle,
    String? address,
    String? mobile,
    String? invoiceNumber,
    String? date,
    String? customer,
    String? customerMobile,
    List<Product>? product,
    List<PaymentListMethod>? paymentMethod,
    List<PaymentListMethod>? previousSaleReturnPaymentMethod,
    String? taxPercentage,
    String? invoiceDiscount,
    String? discountType,
    String? discountAmount,
    String? invoiceFooterText,
    String? subTotal,
    String? total,
    String? taxType,
    String? totalPaid,
    String? balance,
    String? taxAmount,
    String? changeReturn,
    String? invoiceNoReturned,
    String? offlineInvoiceNo,
    String? transactionPaxDeviceId,


  }) {
    _transactionId = transactionId;
    _invoiceTitle = invoiceTitle;
    _address = address;
    _mobile = mobile;
    _invoiceNumber = invoiceNumber;
    _date = date;
    _customer = customer;
    _customerMobile = customerMobile;
    _products = product;
    _paymentMethod = paymentMethod;
    _taxPercentage = taxPercentage;
    _invoiceFooterText = invoiceFooterText;
    _invoiceDiscount = invoiceDiscount;
    _discountType = discountType;
    _subTotal = subTotal;
    _total = total;
    _taxType = taxType;
    _taxAmount = taxAmount;
    _totalPaid = totalPaid;
    _balance = balance;
    _changeReturn = changeReturn;
    _discountAmount = discountAmount;
    _invoiceNoReturned = invoiceNoReturned;
    _offlineInvoiceNo = offlineInvoiceNo;
    _transactionPaxDeviceId=transactionPaxDeviceId;
    _previousSaleReturnPaymentMethod=previousSaleReturnPaymentMethod;
  }

  InvoiceModel.fromJson(dynamic json) {
    _transactionId = json['transaction_id'];
    _invoiceTitle = json['invoice_title'];
    _transactionPaxDeviceId = json['transaction_pax_device_id'].toString();
    _address = json['address'];
    _mobile = json['mobile'];
    _invoiceNumber = json['invoice_number'];
    _date = json['date'];
    _customer = json['customer'];
    _customerMobile = json['customer_mobile'];

    _products = json['products'] is String
        ? List.from(jsonDecode(json['products']))
            .map((e) => Product.fromJson(e))
            .toList()
        : List.from(json['products']).map((e) => Product.fromJson(e)).toList();

    _paymentMethod = json['payment_method'] is String
        ? List.from(jsonDecode(json['payment_method'])).map((e) {
            log("$e");
            return PaymentListMethod.fromJson(e);
          }).toList()
        : List.from(json['payment_method']).map((e) {
            log("$e");
            return PaymentListMethod.fromJson(e);
          }).toList();

    if (json.containsKey('previous_sale_return_payment_method') && json['previous_sale_return_payment_method'] != null) {
      _previousSaleReturnPaymentMethod = json['previous_sale_return_payment_method'] is String
          ? List.from(jsonDecode(json['previous_sale_return_payment_method']))
          .map((e) => PaymentListMethod.fromJson(e))
          .toList()
          : List.from(json['previous_sale_return_payment_method']).map((e) => PaymentListMethod.fromJson(e)).toList();
    } else {
      _previousSaleReturnPaymentMethod = [];
    }

    _invoiceNoReturned = json['invoice_no_return'];
    _taxPercentage = json['tax_percentage'];
    _invoiceFooterText = json['invoice_footer_text'];
    _invoiceDiscount = json['invoice_discount'];
    _discountType = json['discount_type'];
    _subTotal = json['sub_total'];
    _total = json['total'];
    _taxType = json['tax_type'];
    _taxAmount = json['tax_amount'];
    _totalPaid = json['total_paid'];
    _balance = json['balance'];
    _changeReturn = json['change_return'];
    _discountAmount = json['discount_amount'];
    _offlineInvoiceNo = json['offline_invoice_no'];

  }
  String? _transactionId;
  String? _invoiceTitle;
  String? _address;
  String? _mobile;
  String? _invoiceNumber;
  String? _date;
  String? _customer;
  String? _customerMobile;
  List<Product>? _products;
  List<PaymentListMethod>? _paymentMethod;
  List<PaymentListMethod>? _previousSaleReturnPaymentMethod;
  String? _taxPercentage;
  String? _invoiceFooterText;
  String? _invoiceDiscount;
  String? _discountType;
  String? _subTotal;
  String? _total;
  String? _taxType;
  String? _taxAmount;
  String? _totalPaid;
  String? _balance;
  String? _changeReturn;
  String? _discountAmount;
  String? _invoiceNoReturned;
  String? _offlineInvoiceNo;
  String? _transactionPaxDeviceId;

  InvoiceModel copyWith({
    String? transactionId,
    String? invoiceTitle,
    String? address,
    String? mobile,
    String? invoiceNumber,
    String? date,
    String? customer,
    String? customerMobile,
    List<Product>? product,
    List<PaymentListMethod>? paymentMethod,
    List<PaymentListMethod>? previousSaleReturnPaymentMethod,
    String? taxPercentage,
    String? invoiceFooterText,
    String? invoiceDiscount,
    String? discountType,
    String? subTotal,
    String? total,
    String? taxType,
    String? taxAmount,
    String? totalPaid,
    String? balance,
    String? invoiceNoReturned,
    String? changeReturn,
    String? discountAmount,
    String? offlineInvoiceNo,
    String? transactionPaxDeviceId,


  }) =>
      InvoiceModel(
          invoiceTitle: invoiceTitle ?? _invoiceTitle,
          transactionId: transactionId ?? _transactionId,
          address: address ?? _address,
          mobile: mobile ?? _mobile,
          invoiceNumber: invoiceNumber ?? _invoiceNumber,
          date: date ?? _date,
          customer: customer ?? _customer,
          customerMobile: customerMobile ?? _customerMobile,
          product: product ?? _products,
          paymentMethod: paymentMethod ?? _paymentMethod,
          taxPercentage: taxPercentage ?? _taxPercentage,
          invoiceFooterText: invoiceFooterText ?? _invoiceFooterText,
          invoiceDiscount: invoiceDiscount ?? _invoiceDiscount,
          discountType: discountType ?? _discountType,
          subTotal: subTotal ?? _subTotal,
          total: total ?? _total,
          taxType: taxType ?? _taxType,
          totalPaid: totalPaid ?? _totalPaid,
          balance: balance ?? _balance,
          changeReturn: changeReturn ?? _changeReturn,
          discountAmount: discountAmount ?? _discountAmount,
          invoiceNoReturned: invoiceNoReturned ?? _invoiceNoReturned,
          offlineInvoiceNo: offlineInvoiceNo ?? _offlineInvoiceNo,
          transactionPaxDeviceId: transactionPaxDeviceId??_transactionPaxDeviceId,
          taxAmount: taxAmount ?? _taxAmount,
        previousSaleReturnPaymentMethod: previousSaleReturnPaymentMethod??_previousSaleReturnPaymentMethod
      );
  String? get transactionId => _transactionId;
  String? get invoiceTitle => _invoiceTitle;
  String? get address => _address;
  String? get mobile => _mobile;
  String? get invoiceNumber => _invoiceNumber;
  String? get date => _date;
  String? get customer => _customer;
  String? get customerMobile => _customerMobile;
  List<Product>? get product => _products;
  List<PaymentListMethod>? get paymentMethod => _paymentMethod;
  List<PaymentListMethod>? get previousSaleReturnPaymentMethod => _previousSaleReturnPaymentMethod;
  String? get taxPercentage => _taxPercentage;
  String? get invoiceFooterText => _invoiceFooterText;
  String? get invoiceDiscount => _invoiceDiscount;
  String? get discountType => _discountType;
  String? get subTotal => _subTotal;
  String? get total => _total;
  String? get taxType => _taxType;
  String? get taxAmount => _taxAmount;
  String? get totalPaid => _totalPaid;
  String? get balance => _balance;
  String? get changeReturn => _changeReturn;
  String? get discountAmount => _discountAmount;
  String? get invoiceNoReturned => _invoiceNoReturned;
  String? get offlineInvoiceNo => _offlineInvoiceNo;
  String? get transactionPaxDeviceId => _transactionPaxDeviceId;


  Map<String, Object?> toJson() {
    return {
      'transaction_id': _transactionId,
      'invoice_title': _invoiceTitle,
      'address': _address,
      'mobile': _mobile,
      'invoice_number': _invoiceNumber,
      'date': _date,
      'customer': _customer,
      'customer_mobile': _customerMobile,
      'product': jsonEncode(
        _products?.map((v) => v.toJson()).toList(),
      ),
      'payment_method': jsonEncode(
        _paymentMethod?.map((v) => v.toJson()).toList(),
      ),
      'previous_sale_return_payment_method': _previousSaleReturnPaymentMethod!=null?jsonEncode(
        _previousSaleReturnPaymentMethod?.map((v) => v.toJson()).toList(),
      ):[],
      'tax_percentage': _taxPercentage,
      'invoice_footer_text': _invoiceFooterText,
      'invoice_discount': _invoiceDiscount,
      'discount_type': _discountType,
      'sub_total': _subTotal,
      'total': _total,
      'tax_type': _taxType,
      'tax_amount': _taxAmount,
      'total_paid': _totalPaid,
      'balance': _balance,
      'change_return': _changeReturn,
      'discount_amount': _discountAmount,
      'invoice_no_return': _invoiceNoReturned,
      'offline_invoice_no': _offlineInvoiceNo,
      'transaction_pax_device_id':_transactionPaxDeviceId,

    };
  }
}
