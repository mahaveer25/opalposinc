import 'dart:convert';

import 'package:opalposinc/model/product.dart';

class Transaction {
  String? userId;
  String? businessId;
  String? locationId;
  String? contactId;
  String? transactionDate;
  int? priceGroup;
  List<Product>? product;
  String? discountType;
  double? discountAmount;
  double? totalAmountBeforeTax;
  String? taxRateId;
  double? taxCalculationPercentage;
  double? taxCalculationAmount;
  List<dynamic>? payment;
  String? discountTypeModal;
  double? discountAmountModal;
  int? orderTaxModal;
  String? saleNote;
  String? staffNote;
  String? cardString;
  String? userLocation;
  String? suspendNote;
  String? transactionId;
  String? invoiceNo;
  String? offlineInvoiceNo;
  String? invoiceNoReturned;
  String? changeReturn;
  String? enableRp;
  String? amountForUnitRp;

  String? rpRedeemed;
  String? rpRedeemedDiscountTypes;
  String? redeemAmountPerUnitRp;
  String? customerId;
  String? customerEmail;
  String? customerFirstName;
  String? customerPhone;
  String? transactionPaxDeviceId;

  Transaction(
      {this.userId,
      this.invoiceNoReturned,
      this.businessId,
      this.locationId,
      this.contactId,
      this.transactionDate,
      this.priceGroup,
      this.product,
      this.discountType,
      this.discountAmount,
      this.totalAmountBeforeTax,
      this.taxRateId,
      this.taxCalculationPercentage,
      this.taxCalculationAmount,
      this.payment,
      this.discountTypeModal,
      this.discountAmountModal,
      this.orderTaxModal,
      this.saleNote,
      this.staffNote,
      this.cardString,
      this.userLocation,
      this.suspendNote,
      this.transactionId,
      this.changeReturn,
      this.enableRp,
      this.amountForUnitRp,
      this.invoiceNo,
      this.rpRedeemed,
      this.rpRedeemedDiscountTypes,
      this.redeemAmountPerUnitRp,
      this.offlineInvoiceNo,
      this.customerId,
      this.customerEmail,
      this.customerFirstName,
      this.customerPhone,
      this.transactionPaxDeviceId});
  Transaction copyWith({
    String? userId,
    String? businessId,
    String? locationId,
    String? contactId,
    String? transactionDate,
    int? priceGroup,
    List<Product>? product,
    String? discountType,
    double? discountAmount,
    double? totalAmountBeforeTax,
    String? taxRateId,
    double? taxCalculationPercentage,
    double? taxCalculationAmount,
    List<dynamic>? payment,
    String? discountTypeModal,
    double? discountAmountModal,
    int? orderTaxModal,
    String? saleNote,
    String? staffNote,
    String? cardString,
    String? userLocation,
    String? suspendNote,
    String? transactionId,
    String? invoiceNo,
    String? offlineInvoiceNo,
    String? invoiceNoReturned,
    String? changeReturn,
    String? enableRp,
    String? amountForUnitRp,
    String? rpRedeemed,
    String? rpRedeemedDiscountTypes,
    String? redeemAmountPerUnitRp,
    String? customerId,
    String? customerEmail,
    String? customerFirstName,
    String? customerPhone,
    String? transactionPaxDeviceId,
  }) {
    return Transaction(
        userId: userId ?? this.userId,
        businessId: businessId ?? this.businessId,
        locationId: locationId ?? this.locationId,
        contactId: contactId ?? this.contactId,
        transactionDate: transactionDate ?? this.transactionDate,
        priceGroup: priceGroup ?? this.priceGroup,
        product: product ?? this.product,
        discountType: discountType ?? this.discountType,
        discountAmount: discountAmount ?? this.discountAmount,
        totalAmountBeforeTax: totalAmountBeforeTax ?? this.totalAmountBeforeTax,
        taxRateId: taxRateId ?? this.taxRateId,
        taxCalculationPercentage:
            taxCalculationPercentage ?? this.taxCalculationPercentage,
        taxCalculationAmount: taxCalculationAmount ?? this.taxCalculationAmount,
        payment: payment ?? this.payment,
        discountTypeModal: discountTypeModal ?? this.discountTypeModal,
        discountAmountModal: discountAmountModal ?? this.discountAmountModal,
        orderTaxModal: orderTaxModal ?? this.orderTaxModal,
        saleNote: saleNote ?? this.saleNote,
        staffNote: staffNote ?? this.staffNote,
        cardString: cardString ?? this.cardString,
        userLocation: userLocation ?? this.userLocation,
        suspendNote: suspendNote ?? this.suspendNote,
        transactionId: transactionId ?? this.transactionId,
        invoiceNo: invoiceNo ?? this.invoiceNo,
        offlineInvoiceNo: offlineInvoiceNo ?? this.offlineInvoiceNo,
        changeReturn: changeReturn ?? this.changeReturn,
        enableRp: enableRp ?? this.enableRp,
        amountForUnitRp: amountForUnitRp ?? this.amountForUnitRp,
        invoiceNoReturned: invoiceNoReturned ?? this.invoiceNoReturned,
        rpRedeemed: rpRedeemed ?? this.rpRedeemed,
        rpRedeemedDiscountTypes:
            rpRedeemedDiscountTypes ?? this.rpRedeemedDiscountTypes,
        redeemAmountPerUnitRp:
            redeemAmountPerUnitRp ?? this.redeemAmountPerUnitRp,
        customerId: customerId ?? this.customerId,
        customerEmail: customerEmail ?? this.customerEmail,
        customerFirstName: customerFirstName ?? this.customerFirstName,
        customerPhone: customerPhone ?? this.customerPhone,
        transactionPaxDeviceId:
            transactionPaxDeviceId ?? this.transactionPaxDeviceId);
  }

  Map<String, Object?> toJson() {
    return {
      'user_id': userId.toString(),
      'business_id': businessId.toString(),
      'location_id': locationId.toString(),
      'contact_id': contactId.toString(),
      'transaction_date': transactionDate.toString(),
      'price_group': priceGroup.toString(),
      'products':
          jsonEncode(product?.map((product) => product.toJson()).toList()),
      'discount_type': discountType ?? 'fixed',
      'discount_amount': discountAmount.toString(),
      'total_amount_before_tax': totalAmountBeforeTax.toString(),
      'tax_rate_id': taxRateId.toString(),
      'tax_calculation_percentage': taxCalculationPercentage.toString(),
      'tax_calculation_amount': taxCalculationAmount.toString(),
      'payment': jsonEncode(payment?.map((e) => e).toList()),
      'discount_type_modal': discountTypeModal.toString(),
      'discount_amount_modal': discountAmountModal.toString(),
      'order_tax_modal': orderTaxModal.toString(),
      'sale_note': saleNote.toString(),
      'staff_note': staffNote.toString(),
      'card_string': cardString.toString(),
      'user_location': userLocation.toString(),
      'suspend_note': suspendNote.toString(),
      'transaction_id': transactionId.toString(),
      'invoice_no': invoiceNo.toString(),
      'offline_invoice_no': offlineInvoiceNo.toString(),
      'invoice_no_return': invoiceNoReturned.toString(),
      'change_return': changeReturn.toString(),
      'enable_rp': changeReturn.toString(),
      'amount_for_unit_rp': amountForUnitRp.toString(),
      'rp_redeemed': rpRedeemed.toString(),
      'rp_redeemed_discount_types': rpRedeemedDiscountTypes.toString(),
      'redeem_amount_per_unit_rp': redeemAmountPerUnitRp.toString(),
      'customer_id': customerId.toString(),
      'customer_email': customerEmail.toString(),
      'customer_firstname': customerFirstName.toString(),
      'customer_phone': customerPhone.toString(),
      'transaction_pax_device_id': transactionPaxDeviceId.toString()
    };
  }

  static Transaction fromJson(Map<String, Object?> json) {
    final map = jsonDecode(json['products'].toString()) as List<dynamic>;
    final product = map.map((e) => Product.fromJson(e)).toList();
    // log('$product');

    return Transaction(
        userId: json['user_id'] == null
            ? null
            : int.parse(json['user_id'].toString()).toString(),
        businessId: json['business_id'] == null
            ? null
            : int.parse(json['business_id'].toString()).toString(),
        locationId: json['location_id'] == null
            ? null
            : int.parse(json['location_id'].toString()).toString(),
        contactId: json['contact_id'] == null
            ? null
            : int.parse(json['contact_id'].toString()).toString(),
        transactionDate: json['transaction_date'] == null
            ? null
            : json['transaction_date'] as String?,
        priceGroup: json['price_group'] == null
            ? null
            : int.parse(json['price_group'].toString()),
        product: json['products'] == null ? null : product,
        discountType: json['discount_type'] == null
            ? "fixed"
            : json['discount_type'].toString(),
        discountAmount: json['discount_amount'] == null
            ? null
            : double.parse(json['discount_amount'].toString()),
        totalAmountBeforeTax: json['total_amount_before_tax'] == null
            ? null
            : double.parse(json['total_amount_before_tax'].toString()),
        taxRateId: json['tax_rate_id'] == null
            ? null
            : int.parse(json['tax_rate_id'].toString()).toString(),
        taxCalculationPercentage: json['tax_calculation_percentage'] == null
            ? null
            : double.parse(json['tax_calculation_percentage'].toString()),
        taxCalculationAmount: json['tax_calculation_amount'] == null
            ? null
            : double.parse(json['tax_calculation_amount'].toString()),
        payment: json['payment'] == null
            ? null
            : jsonDecode(json['payment'].toString()) as List<dynamic>,
        discountTypeModal: json['discount_type_modal'] == null
            ? "fixed"
            : json['discount_type_modal'] as String?,
        discountAmountModal: json['discount_amount_modal'] == null
            ? null
            : double.parse(json['discount_amount_modal'].toString()),
        orderTaxModal: json['order_tax_modal'] == null
            ? null
            : int.parse(json['order_tax_modal'].toString()),
        saleNote:
            json['sale_note'] == null ? null : json['sale_note'] as String?,
        staffNote:
            json['staff_note'] == null ? null : json['staff_note'] as String?,
        cardString:
            json['card_string'] == null ? null : json['card_string'] as String?,
        userLocation: json['user_location'] == null
            ? null
            : json['user_location'] as String?,
        suspendNote: json['suspend_note'] == null
            ? null
            : json['suspend_note'] as String?,
        transactionId: json['transaction_id'] == null
            ? null
            : json['transaction_id'] as String?,
        invoiceNo:
            json['invoice_no'] == null ? null : json['invoice_no'] as String?,
        offlineInvoiceNo: json['offline_invoice_no'] == null
            ? null
            : json['offline_invoice_no'] as String?,
        invoiceNoReturned: json['invoice_no_return'] == null
            ? null
            : json['invoice_no_return'] as String?,
        changeReturn: json['change_return'] as String?,
        enableRp: json['enable_rp'] as String?,
        amountForUnitRp: json['amount_for_unit_rp'] as String?,
        rpRedeemed: json['rp_redeemed'] as String?,
        rpRedeemedDiscountTypes: json['rp_redeemed_discount_types'] as String?,
        redeemAmountPerUnitRp: json['redeem_amount_per_unit_rp'] as String?,
        customerId: json['customer_id'] as String?,
        customerFirstName: json['customer_firstname'] as String?,
        customerEmail: json['customer_email'] as String?,
        customerPhone: json['customer_phone'] as String?,
        transactionPaxDeviceId: json['transaction_pax_device_id'] as String?);
  }

  @override
  String toString() {
    return '''Transaction(
                user_id:$userId,
businessId:$businessId,
locationId:$locationId,
contactId:$contactId,
transactionDate:$transactionDate,
priceGroup:$priceGroup,
product:$product,
discountType:$discountType,
discountAmount:$discountAmount,
totalAmountBeforeTax:$totalAmountBeforeTax,
taxRateId:$taxRateId,
taxCalculationPercentage:$taxCalculationPercentage,
taxCalculationAmount:$taxCalculationAmount,
payment:$payment,
discountTypeModal:$discountTypeModal,
discountAmountModal:$discountAmountModal,
orderTaxModal:$orderTaxModal,
saleNote:$saleNote,
staffNote:$staffNote,
cardString:$cardString,
userLocation:$userLocation,
suspendNote:$suspendNote,
transactionId:$transactionId,
invoiceNo:$invoiceNo,
offlineInvoiceNumber:$offlineInvoiceNo,
invoiceReturned:$invoiceNoReturned,
rp_redeemed:$rpRedeemed,
rpRedeemedDiscountTypes:$rpRedeemedDiscountTypes,
redeemAmountPerUnitRp:$redeemAmountPerUnitRp,
customerId:$customerId,
customerFirstName:$customerFirstName,
customerEmail:$customerEmail,
customerPhone:$customerPhone
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Transaction &&
        other.runtimeType == runtimeType &&
        other.userId == userId &&
        other.businessId == businessId &&
        other.locationId == locationId &&
        other.contactId == contactId &&
        other.transactionDate == transactionDate &&
        other.priceGroup == priceGroup &&
        other.product == product &&
        other.discountType == discountType &&
        other.discountAmount == discountAmount &&
        other.totalAmountBeforeTax == totalAmountBeforeTax &&
        other.taxRateId == taxRateId &&
        other.taxCalculationPercentage == taxCalculationPercentage &&
        other.taxCalculationAmount == taxCalculationAmount &&
        other.payment == payment &&
        other.discountTypeModal == discountTypeModal &&
        other.discountAmountModal == discountAmountModal &&
        other.orderTaxModal == orderTaxModal &&
        other.saleNote == saleNote &&
        other.staffNote == staffNote &&
        other.cardString == cardString &&
        other.userLocation == userLocation &&
        other.suspendNote == suspendNote &&
        other.transactionId == transactionId &&
        other.invoiceNo == invoiceNo &&
        other.offlineInvoiceNo == offlineInvoiceNo &&
        other.invoiceNoReturned == invoiceNoReturned &&
        other.rpRedeemed == rpRedeemed &&
        other.rpRedeemedDiscountTypes == rpRedeemedDiscountTypes &&
        other.redeemAmountPerUnitRp == redeemAmountPerUnitRp &&
        other.customerId == customerId &&
        other.customerFirstName == customerFirstName &&
        other.customerEmail == customerEmail &&
        other.customerPhone == customerPhone;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      userId,
      businessId,
      locationId,
      contactId,
      transactionDate,
      priceGroup,
      product,
      discountType,
      discountAmount,
      totalAmountBeforeTax,
      taxRateId,
      taxCalculationPercentage,
      taxCalculationAmount,
      payment,
      discountTypeModal,
      discountAmountModal,
      orderTaxModal,
      saleNote,
      staffNote,
    );
  }
}
