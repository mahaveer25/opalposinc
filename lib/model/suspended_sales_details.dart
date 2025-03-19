import 'package:opalsystem/model/product.dart';

class SuspendedDetails {
  String? id;
  String? invoiceNo;
  String? transactionDate;
  String? totalBeforeTax;
  String? discountType;
  String? discountAmount;
  String? rpRedeemed;
  String? rpRedeemedAmount;
  String? additionalNotes;
  String? finalTotal;
  String? sellingPriceGroupId;
  List<Product>? product;

  SuspendedDetails({
    this.id,
    this.invoiceNo,
    this.transactionDate,
    this.totalBeforeTax,
    this.discountType,
    this.discountAmount,
    this.rpRedeemed,
    this.rpRedeemedAmount,
    this.additionalNotes,
    this.finalTotal,
    this.sellingPriceGroupId,
    this.product,
  });

  factory SuspendedDetails.fromJson(Map<String, dynamic> json) {
    return SuspendedDetails(
      id: json['id'],
      invoiceNo: json['invoice_no'],
      transactionDate: json['transaction_date'],
      totalBeforeTax: json['total_before_tax'],
      discountType: json['discount_type'],
      discountAmount: json['discount_amount'],
      rpRedeemed: json['rp_redeemed'],
      rpRedeemedAmount: json['rp_redeemed_amount'],
      additionalNotes: json['additional_notes'],
      finalTotal: json['final_total'],
      sellingPriceGroupId: json['selling_price_group_id'],
      product: List.from(json['product_details'])
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_no': invoiceNo,
      'transaction_date': transactionDate,
      'total_before_tax': totalBeforeTax,
      'discount_type': discountType,
      'discount_amount': discountAmount,
      'rp_redeemed': rpRedeemed,
      'rp_redeemed_amount': rpRedeemedAmount,
      'additional_notes': additionalNotes,
      'final_total': finalTotal,
      'selling_price_group_id': sellingPriceGroupId,
      'product_details': product!.map((product) => product.toJson()).toList(),
    };
  }
}
