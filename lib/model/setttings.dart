class SettingsModel {
  final String? enableInvoiceEmail;
  final String? enableInvoiceSMS;
  final PosSettings? posSettings;
  final String? enableBrand;
  final String? enableCategory;
  final String? enableRow;
  final String? enableRp;
  final String? rpName;
  final String? amountForUnitRp;
  final String? minOrderTotalForRp;
  final String? maxRpPerOrder;
  final String? redeemAmountPerUnitRp;
  final String? minOrderTotalForRedeem;
  final String? minRedeemPoint;
  final String? maxRedeemPoint;
  final String? rpExpiryPeriod;
  final String? rpExpiryType;
  const SettingsModel(
      {this.enableInvoiceEmail,
      this.enableInvoiceSMS,
      this.posSettings,
      this.enableBrand,
      this.enableCategory,
      this.enableRow,
      this.enableRp,
      this.rpName,
      this.amountForUnitRp,
      this.minOrderTotalForRp,
      this.maxRpPerOrder,
      this.redeemAmountPerUnitRp,
      this.minOrderTotalForRedeem,
      this.minRedeemPoint,
      this.maxRedeemPoint,
      this.rpExpiryPeriod,
      this.rpExpiryType});
  SettingsModel copyWith(
      {String? enableInvoiceEmail,
      String? enableInvoiceSMS,
      PosSettings? posSettings,
      String? enableBrand,
      String? enableCategory,
      String? enableRow,
      String? enableRp,
      String? rpName,
      String? amountForUnitRp,
      String? minOrderTotalForRp,
      String? maxRpPerOrder,
      String? redeemAmountPerUnitRp,
      String? minOrderTotalForRedeem,
      String? minRedeemPoint,
      String? maxRedeemPoint,
      String? rpExpiryPeriod,
      String? rpExpiryType}) {
    return SettingsModel(
        enableInvoiceEmail: enableInvoiceEmail ?? this.enableInvoiceEmail,
        enableInvoiceSMS: enableInvoiceSMS ?? this.enableInvoiceSMS,
        posSettings: posSettings ?? this.posSettings,
        enableBrand: enableBrand ?? this.enableBrand,
        enableCategory: enableCategory ?? this.enableCategory,
        enableRow: enableRow ?? this.enableRow,
        enableRp: enableRp ?? this.enableRp,
        rpName: rpName ?? this.rpName,
        amountForUnitRp: amountForUnitRp ?? this.amountForUnitRp,
        minOrderTotalForRp: minOrderTotalForRp ?? this.minOrderTotalForRp,
        maxRpPerOrder: maxRpPerOrder ?? this.maxRpPerOrder,
        redeemAmountPerUnitRp:
            redeemAmountPerUnitRp ?? this.redeemAmountPerUnitRp,
        minOrderTotalForRedeem:
            minOrderTotalForRedeem ?? this.minOrderTotalForRedeem,
        minRedeemPoint: minRedeemPoint ?? this.minRedeemPoint,
        maxRedeemPoint: maxRedeemPoint ?? this.maxRedeemPoint,
        rpExpiryPeriod: rpExpiryPeriod ?? this.rpExpiryPeriod,
        rpExpiryType: rpExpiryType ?? this.rpExpiryType);
  }

  Map<String, Object?> toJson() {
    return {
      'enable_invoice_email': enableInvoiceEmail,
      'enable_invoice_sms': enableInvoiceSMS,
      'pos_settings': posSettings?.toJson(),
      'enable_brand': enableBrand,
      'enable_category': enableCategory,
      'enable_row': enableRow,
      'enable_rp': enableRp,
      'rp_name': rpName,
      'amount_for_unit_rp': amountForUnitRp,
      'min_order_total_for_rp': minOrderTotalForRp,
      'max_rp_per_order': maxRpPerOrder,
      'redeem_amount_per_unit_rp': redeemAmountPerUnitRp,
      'min_order_total_for_redeem': minOrderTotalForRedeem,
      'min_redeem_point': minRedeemPoint,
      'max_redeem_point': maxRedeemPoint,
      'rp_expiry_period': rpExpiryPeriod,
      'rp_expiry_type': rpExpiryType
    };
  }

  static SettingsModel fromJson(Map<String, Object?> json) {
    return SettingsModel(
        enableInvoiceEmail: json['enable_invoice_email'] == null
            ? null
            : json['enable_invoice_email'] as String?,
        enableInvoiceSMS: json['enable_invoice_sms'] == null
            ? null
            : json['enable_invoice_sms'] as String?,
        posSettings: json['pos_settings'] == null
            ? null
            : PosSettings.fromJson(
                json['pos_settings'] as Map<String, Object?>),
        enableBrand: json['enable_brand'] == null
            ? null
            : json['enable_brand'] as String?,
        enableCategory: json['enable_category'] == null
            ? null
            : json['enable_category'] as String?,
        enableRow:
            json['enable_row'] == null ? null : json['enable_row'] as String?,
        enableRp:
            json['enable_rp'] == null ? null : json['enable_rp'] as String?,
        rpName: json['rp_name'] == null ? null : json['rp_name'] as String?,
        amountForUnitRp: json['amount_for_unit_rp'] == null
            ? null
            : json['amount_for_unit_rp'] as String?,
        minOrderTotalForRp: json['min_order_total_for_rp'] == null
            ? null
            : json['min_order_total_for_rp'] as String?,
        maxRpPerOrder: json['max_rp_per_order'] as String?,
        redeemAmountPerUnitRp: json['redeem_amount_per_unit_rp'] == null
            ? null
            : json['redeem_amount_per_unit_rp'] as String?,
        minOrderTotalForRedeem: json['min_order_total_for_redeem'] == null
            ? null
            : json['min_order_total_for_redeem'] as String?,
        minRedeemPoint: json['min_redeem_point'] as String?,
        maxRedeemPoint: json['max_redeem_point'] == null
            ? null
            : json['max_redeem_point'] as String?,
        rpExpiryPeriod: json['rp_expiry_period'] as String?,
        rpExpiryType: json['rp_expiry_type'] == null
            ? null
            : json['rp_expiry_type'] as String?);
  }

  @override
  String toString() {
    return '''SettingsModel(
enableInvoiceEmail:$enableInvoiceEmail,
enableInvoiceSMS:$enableInvoiceSMS,
posSettings:${posSettings.toString()},
enableBrand:$enableBrand,
enableCategory:$enableCategory,
enableRow:$enableRow,
enableRp:$enableRp,
rpName:$rpName,
amountForUnitRp:$amountForUnitRp,
minOrderTotalForRp:$minOrderTotalForRp,
maxRpPerOrder:$maxRpPerOrder,
redeemAmountPerUnitRp:$redeemAmountPerUnitRp,
minOrderTotalForRedeem:$minOrderTotalForRedeem,
minRedeemPoint:$minRedeemPoint,
maxRedeemPoint:$maxRedeemPoint,
rpExpiryPeriod:$rpExpiryPeriod,
rpExpiryType:$rpExpiryType
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is SettingsModel &&
        other.runtimeType == runtimeType &&
        other.enableInvoiceEmail == enableInvoiceEmail &&
        other.enableInvoiceSMS == enableInvoiceSMS &&
        other.posSettings == posSettings &&
        other.enableBrand == enableBrand &&
        other.enableCategory == enableCategory &&
        other.enableRow == enableRow &&
        other.enableRp == enableRp &&
        other.rpName == rpName &&
        other.amountForUnitRp == amountForUnitRp &&
        other.minOrderTotalForRp == minOrderTotalForRp &&
        other.maxRpPerOrder == maxRpPerOrder &&
        other.redeemAmountPerUnitRp == redeemAmountPerUnitRp &&
        other.minOrderTotalForRedeem == minOrderTotalForRedeem &&
        other.minRedeemPoint == minRedeemPoint &&
        other.maxRedeemPoint == maxRedeemPoint &&
        other.rpExpiryPeriod == rpExpiryPeriod &&
        other.rpExpiryType == rpExpiryType;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        enableInvoiceEmail,
        enableInvoiceSMS,
        posSettings,
        enableBrand,
        enableCategory,
        enableRow,
        enableRp,
        rpName,
        amountForUnitRp,
        minOrderTotalForRp,
        maxRpPerOrder,
        redeemAmountPerUnitRp,
        minOrderTotalForRedeem,
        minRedeemPoint,
        maxRedeemPoint,
        rpExpiryPeriod,
        rpExpiryType);
  }
}

class PosSettings {
  final String? amountRoundingMethod;
  final String? allowOverselling;
  final String? cmmsnCalculationType;
  final String? razorPayKeyId;
  final String? razorPayKeySecret;
  final String? stripePublicKey;
  final String? stripeSecretKey;
  final String? disableDraft;
  final String? disableExpressCheckout;
  final String? disableOrderTax;
  final String? isPosSubtotalEditable;
  final String? disableSuspend;
  final String? enableTransactionDate;
  final String? disableCreditSaleButton;
  final String? showPricingOnProductSugesstion;
  final String? cashDenominations;
  final String? enableCashDenominationOn;
  final String? disablePayCheckout;
  final String? hideProductSuggestion;
  final String? hideRecentTrans;
  final String? disableDiscount;
  const PosSettings(
      {this.amountRoundingMethod,
      this.allowOverselling,
      this.cmmsnCalculationType,
      this.razorPayKeyId,
      this.razorPayKeySecret,
      this.stripePublicKey,
      this.stripeSecretKey,
      this.disableDraft,
      this.disableExpressCheckout,
      this.disableOrderTax,
      this.isPosSubtotalEditable,
      this.disableSuspend,
      this.enableTransactionDate,
      this.disableCreditSaleButton,
      this.showPricingOnProductSugesstion,
      this.cashDenominations,
      this.enableCashDenominationOn,
      this.disablePayCheckout,
      this.hideProductSuggestion,
      this.hideRecentTrans,
      this.disableDiscount});
  PosSettings copyWith(
      {String? amountRoundingMethod,
      String? allowOverselling,
      String? cmmsnCalculationType,
      String? razorPayKeyId,
      String? razorPayKeySecret,
      String? stripePublicKey,
      String? stripeSecretKey,
      String? disableDraft,
      String? disableExpressCheckout,
      String? disableOrderTax,
      String? isPosSubtotalEditable,
      String? disableSuspend,
      String? enableTransactionDate,
      String? disableCreditSaleButton,
      String? showPricingOnProductSugesstion,
      String? cashDenominations,
      String? enableCashDenominationOn,
      String? disablePayCheckout,
      String? hideProductSuggestion,
      String? hideRecentTrans,
      String? disableDiscount}) {
    return PosSettings(
        amountRoundingMethod: amountRoundingMethod ?? this.amountRoundingMethod,
        allowOverselling: allowOverselling ?? this.allowOverselling,
        cmmsnCalculationType: cmmsnCalculationType ?? this.cmmsnCalculationType,
        razorPayKeyId: razorPayKeyId ?? this.razorPayKeyId,
        razorPayKeySecret: razorPayKeySecret ?? this.razorPayKeySecret,
        stripePublicKey: stripePublicKey ?? this.stripePublicKey,
        stripeSecretKey: stripeSecretKey ?? this.stripeSecretKey,
        disableDraft: disableDraft ?? this.disableDraft,
        disableExpressCheckout:
            disableExpressCheckout ?? this.disableExpressCheckout,
        disableOrderTax: disableOrderTax ?? this.disableOrderTax,
        isPosSubtotalEditable:
            isPosSubtotalEditable ?? this.isPosSubtotalEditable,
        disableSuspend: disableSuspend ?? this.disableSuspend,
        enableTransactionDate:
            enableTransactionDate ?? this.enableTransactionDate,
        disableCreditSaleButton:
            disableCreditSaleButton ?? this.disableCreditSaleButton,
        showPricingOnProductSugesstion: showPricingOnProductSugesstion ??
            this.showPricingOnProductSugesstion,
        cashDenominations: cashDenominations ?? this.cashDenominations,
        enableCashDenominationOn:
            enableCashDenominationOn ?? this.enableCashDenominationOn,
        disablePayCheckout: disablePayCheckout ?? this.disablePayCheckout,
        hideProductSuggestion:
            hideProductSuggestion ?? this.hideProductSuggestion,
        hideRecentTrans: hideRecentTrans ?? this.hideRecentTrans,
        disableDiscount: disableDiscount ?? this.disableDiscount);
  }

  Map<String, Object?> toJson() {
    return {
      'amount_rounding_method': amountRoundingMethod,
      'allow_overselling': allowOverselling,
      'cmmsn_calculation_type': cmmsnCalculationType,
      'razor_pay_key_id': razorPayKeyId,
      'razor_pay_key_secret': razorPayKeySecret,
      'stripe_public_key': stripePublicKey,
      'stripe_secret_key': stripeSecretKey,
      'disable_draft': disableDraft,
      'disable_express_checkout': disableExpressCheckout,
      'disable_order_tax': disableOrderTax,
      'is_pos_subtotal_editable': isPosSubtotalEditable,
      'disable_suspend': disableSuspend,
      'enable_transaction_date': enableTransactionDate,
      'disable_credit_sale_button': disableCreditSaleButton,
      'show_pricing_on_product_sugesstion': showPricingOnProductSugesstion,
      'cash_denominations': cashDenominations,
      'enable_cash_denomination_on': enableCashDenominationOn,
      'disable_pay_checkout': disablePayCheckout,
      'hide_product_suggestion': hideProductSuggestion,
      'hide_recent_trans': hideRecentTrans,
      'disable_discount': disableDiscount
    };
  }

  static PosSettings fromJson(Map<String, Object?> json) {
    return PosSettings(
        amountRoundingMethod: json['amount_rounding_method'] as dynamic,
        allowOverselling: json['allow_overselling'] == null
            ? null
            : json['allow_overselling'] as String?,
        cmmsnCalculationType: json['cmmsn_calculation_type'] == null
            ? null
            : json['cmmsn_calculation_type'] as String?,
        razorPayKeyId: json['razor_pay_key_id'] as String?,
        razorPayKeySecret: json['razor_pay_key_secret'] as String?,
        stripePublicKey: json['stripe_public_key'] == null
            ? null
            : json['stripe_public_key'] as String?,
        stripeSecretKey: json['stripe_secret_key'] as String?,
        disableDraft: json['disable_draft'] == null
            ? null
            : json['disable_draft'] as String?,
        disableExpressCheckout: json['disable_express_checkout'] == null
            ? null
            : json['disable_express_checkout'] as String?,
        disableOrderTax: json['disable_order_tax'] == null
            ? null
            : json['disable_order_tax'] as String?,
        isPosSubtotalEditable: json['is_pos_subtotal_editable'] == null
            ? null
            : json['is_pos_subtotal_editable'] as String?,
        disableSuspend: json['disable_suspend'] == null
            ? null
            : json['disable_suspend'] as String?,
        enableTransactionDate: json['enable_transaction_date'] == null
            ? null
            : json['enable_transaction_date'] as String?,
        disableCreditSaleButton: json['disable_credit_sale_button'] == null
            ? null
            : json['disable_credit_sale_button'] as String?,
        showPricingOnProductSugesstion:
            json['show_pricing_on_product_sugesstion'] == null
                ? null
                : json['show_pricing_on_product_sugesstion'] as String?,
        cashDenominations: json['cash_denominations'] as String?,
        enableCashDenominationOn: json['enable_cash_denomination_on'] == null
            ? null
            : json['enable_cash_denomination_on'] as String?,
        disablePayCheckout: json['disable_pay_checkout'] == null
            ? null
            : json['disable_pay_checkout'] as String?,
        hideProductSuggestion: json['hide_product_suggestion'] == null
            ? null
            : json['hide_product_suggestion'] as String?,
        hideRecentTrans: json['hide_recent_trans'] == null
            ? null
            : json['hide_recent_trans'] as String?,
        disableDiscount: json['disable_discount'] == null
            ? null
            : json['disable_discount'] as String?);
  }

  @override
  String toString() {
    return '''PosSettings(
                amountRoundingMethod:$amountRoundingMethod,
allowOverselling:$allowOverselling,
cmmsnCalculationType:$cmmsnCalculationType,
razorPayKeyId:$razorPayKeyId,
razorPayKeySecret:$razorPayKeySecret,
stripePublicKey:$stripePublicKey,
stripeSecretKey:$stripeSecretKey,
disableDraft:$disableDraft,
disableExpressCheckout:$disableExpressCheckout,
disableOrderTax:$disableOrderTax,
isPosSubtotalEditable:$isPosSubtotalEditable,
disableSuspend:$disableSuspend,
enableTransactionDate:$enableTransactionDate,
disableCreditSaleButton:$disableCreditSaleButton,
showPricingOnProductSugesstion:$showPricingOnProductSugesstion,
cashDenominations:$cashDenominations,
enableCashDenominationOn:$enableCashDenominationOn,
disablePayCheckout:$disablePayCheckout,
hideProductSuggestion:$hideProductSuggestion,
hideRecentTrans:$hideRecentTrans,
disableDiscount:$disableDiscount
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is PosSettings &&
        other.runtimeType == runtimeType &&
        other.amountRoundingMethod == amountRoundingMethod &&
        other.allowOverselling == allowOverselling &&
        other.cmmsnCalculationType == cmmsnCalculationType &&
        other.razorPayKeyId == razorPayKeyId &&
        other.razorPayKeySecret == razorPayKeySecret &&
        other.stripePublicKey == stripePublicKey &&
        other.stripeSecretKey == stripeSecretKey &&
        other.disableDraft == disableDraft &&
        other.disableExpressCheckout == disableExpressCheckout &&
        other.disableOrderTax == disableOrderTax &&
        other.isPosSubtotalEditable == isPosSubtotalEditable &&
        other.disableSuspend == disableSuspend &&
        other.enableTransactionDate == enableTransactionDate &&
        other.disableCreditSaleButton == disableCreditSaleButton &&
        other.showPricingOnProductSugesstion ==
            showPricingOnProductSugesstion &&
        other.cashDenominations == cashDenominations &&
        other.enableCashDenominationOn == enableCashDenominationOn &&
        other.disablePayCheckout == disablePayCheckout &&
        other.hideProductSuggestion == hideProductSuggestion &&
        other.hideRecentTrans == hideRecentTrans &&
        other.disableDiscount == disableDiscount;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        amountRoundingMethod,
        allowOverselling,
        cmmsnCalculationType,
        razorPayKeyId,
        razorPayKeySecret,
        stripePublicKey,
        stripeSecretKey,
        disableDraft,
        disableExpressCheckout,
        disableOrderTax,
        isPosSubtotalEditable,
        disableSuspend,
        enableTransactionDate,
        disableCreditSaleButton,
        showPricingOnProductSugesstion,
        cashDenominations,
        enableCashDenominationOn,
        disablePayCheckout,
        hideProductSuggestion);
  }
}
