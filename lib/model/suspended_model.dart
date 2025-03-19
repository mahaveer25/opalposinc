class SuspendedModel {
  String? id;
  String? suspendNote;
  String? invoiceNo;
  String? transactionDate;
  String? customerName;
  String? totalItems;
  String? total;

  SuspendedModel({
    this.id,
    this.suspendNote,
    this.invoiceNo,
    this.transactionDate,
    this.customerName,
    this.totalItems,
    this.total,
  });

  factory SuspendedModel.fromJson(Map<String, dynamic> json) {
    return SuspendedModel(
      id: json['id'] ?? '',
      suspendNote: json['suspend_note'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      customerName: json['customer_name'] ?? '',
      totalItems: json['total_items'] ?? '',
      total: json['total'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'suspend_note': suspendNote,
      'invoice_no': invoiceNo,
      'transaction_date': transactionDate,
      'customer_name': customerName,
      'total_items': totalItems,
      'total': total,
    };
  }
}