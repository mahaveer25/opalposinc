import 'package:opalposinc/model/product.dart';

class RecentSaleInvoice {
  String? invoiceTitle;
  String? address;
  String? mobile;
  String? invoiceNumber;
  String? date;
  String? customer;
  String? customerMobile;
  List<Product>? product;
  String? subTotal;
  String? invoiceDiscount;
  String? productsDiscount;
  double? taxAmount;
  String? taxType;
  String? taxPercentage;
  double? total;
  String? paymentMethod;
  double? totalPaid;

  RecentSaleInvoice({
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
    this.productsDiscount,
    this.taxAmount,
    this.taxType,
    this.taxPercentage,
    this.total,
    this.paymentMethod,
    this.totalPaid,
  });

  factory RecentSaleInvoice.fromJson(Map<String, dynamic> json) =>
      RecentSaleInvoice(
        invoiceTitle: json['invoice_title'],
        address: json['address'],
        mobile: json['mobile'],
        invoiceNumber: json['invoice_number'],
        date: json['date'],
        customer: json['customer'],
        customerMobile: json['customer_mobile'] ?? '',
        product: List.from(json['sell_product_details'])
            .map((e) => Product.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'invoice_title': invoiceTitle,
        'address': address,
        'mobile': mobile,
        'invoice_number': invoiceNumber,
        'date': date,
        'customer': customer,
        'customer_mobile': customerMobile,
        'sell_product_details':
            product!.map((product) => product.toJson()).toList(),
      };
}
