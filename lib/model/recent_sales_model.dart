class RecentSalesModel {
  String? transactionId;
  String? invoiceNo;
  String? invoice;
  String? finalTotal;
  String? offlineInvoiceNo;

  RecentSalesModel(
      {this.transactionId,
      this.invoiceNo,
      this.invoice,
      this.finalTotal,
      this.offlineInvoiceNo});

  factory RecentSalesModel.fromJson(Map<String, dynamic> json) {
    return RecentSalesModel(
        transactionId: json['id'],
        invoice: json['invoice'],
        invoiceNo: json['invoice_no'],
        finalTotal: formatFloat(json['final_total']),
        offlineInvoiceNo: json['offline_invoice_no']);
  }

  static String? formatFloat(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(2);
    } else if (value is String) {
      double? floatValue = double.tryParse(value);
      if (floatValue != null) {
        return floatValue.toStringAsFixed(2);
      }
    }
    return value?.toString();
  }

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['id'] = transactionId;
    map['invoice'] = invoice;
    map['invoice_no'] = invoiceNo;
    map['final_total'] = finalTotal;
    map['offline_invoice_no'] = offlineInvoiceNo;
    return map;
  }
}
