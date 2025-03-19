// // ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:opalposinc/Functions/FunctionsProduct.dart';
// import 'package:opalposinc/invoices/InvoiceModel.dart';
// import 'package:opalposinc/model/CustomerModel.dart';
// import 'package:opalposinc/model/TaxModel.dart';
// import 'package:opalposinc/model/TotalDiscountModel.dart';
// import 'package:opalposinc/model/location.dart';
// import 'package:opalposinc/model/loggedInUser.dart';
// import 'package:opalposinc/model/setttings.dart';
// import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
// import 'package:opalposinc/widgets/common/left%20Section/carouselwidget.dart';

// import 'package:presentation_displays/secondary_display.dart';

// import '../model/product.dart';
// import '../multiplePay/successTransactionBackSceen.dart';
// import '../utils/constants.dart';

// class CustomerScreen extends StatefulWidget {
//   const CustomerScreen({super.key});

//   @override
//   _CustomerScreenState createState() => _CustomerScreenState();
// }

// class _CustomerScreenState extends State<CustomerScreen> {
//   ValueNotifier<List<Product>> productListNotifier = ValueNotifier([]);

//   String? price, tax, payable;
//   TotalDiscountModel? discount;
//   TaxModel? taxModel;
//   InvoiceModel? invoice;
//   int? tabIndex;
//   List<PaymentListMethod>? paymentList;
//   CustomerModel? customer;
//   SettingsModel? settings;
//   String? successEmail;
//   String? successPhoneNumber;
//   String? storeName;
//   List<String> slideImages = [];
//   Map<String, dynamic>? data;
//   String? value = "This";

//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: productListNotifier,
//         builder: (context, list, child) => homeCustomer(
//             list: productListNotifier, scrollController: _scrollController));
//   }

//   Widget homeCustomer(
//       {required ValueNotifier<List<Product>> list,
//       required ScrollController scrollController}) {
//     double sideInvoiceFont = 15;

//     double frontInvoiceFont = 28;
//     double discountedAmount = 0.0;
//     // final totalitems = list.value.length.toString();
//     final totalitems =
//         FunctionProduct.getProductLengthBackScreen(productList: list.value);

//     list.notifyListeners();
//     double calculateItemTotal() {
//       double itemTotal = 0.0;

//       itemTotal = list.value
//           .map((product) {
//             return double.parse(product.calculate.toString()) *
//                 double.parse(product.quantity.toString());
//           })
//           .toList()
//           .fold(0.0, (previousValue, element) => previousValue + element)
//           .toDouble();

//       if (discount?.amount != null) {
//         if (discount?.type == "Percentage") {
//           discountedAmount = (itemTotal * ((discount?.amount ?? 0) / 100));
//           itemTotal = itemTotal - discountedAmount;

//           return itemTotal;
//         } else if (discount?.type == "Fixed") {
//           discountedAmount = discount!.amount!.toDouble();
//           itemTotal = (itemTotal - discountedAmount);

//           return itemTotal;
//         } else {
//           return itemTotal;
//         }
//       } else {
//         return itemTotal;
//       }
//     }

//     double CalculateTaxAmount() {
//       double total = calculateItemTotal();
//       double taxRate = taxModel?.amount == null
//           ? 0.0
//           : double.parse(taxModel!.amount.toString()) / 100;

//       double taxAmount = total * taxRate;
//       return taxAmount;
//     }

//     double totalWithTax() {
//       double total = calculateItemTotal();
//       double taxRate = taxModel?.amount == null
//           ? 0.0
//           : double.parse(taxModel!.amount.toString()) / 100;

//       double taxAmount = total * taxRate;
//       double totalWithTax = total + taxAmount;

//       return totalWithTax;
//     }

//     return Scaffold(
//         body: SecondaryDisplay(
//             callback: (dynamic argument) {
//               setState(() {
//                 list.notifyListeners();

//                 if (argument['type'] == 'add') {
//                   Product product = Product(
//                     returnQuantity:
//                         argument['product']['quantity_returned'].toString(),
//                     lineDiscountAmount:
//                         argument['product']['line_discount_amount'].toString(),
//                     enableStock: argument['product']['enable_stock'].toString(),
//                     defaultSellPrice:
//                         argument['product']['default_sell_price'].toString(),
//                     itemTax: argument['product']['item_tax'].toString(),
//                     categoryId: argument['product']['category_id'].toString(),
//                     alreadyReturned:
//                         argument['product']['already_returned'].toString(),
//                     productId: argument['product']['product_id'].toString(),
//                     calculate: argument['product']['calculate'].toString(),
//                     image: argument['product']['image'].toString(),
//                     quantity: argument['product']['quantity'].toString(),
//                     unit_price: argument['product']['unit_price'].toString(),
//                     brandId: argument['product']['brand_id'].toString(),
//                     availableLocationsString:
//                         argument['product']['available_locations'].toString(),
//                     productType: argument['product']['product_type'].toString(),
//                     unitPriceIncTax:
//                         argument['product']['unit_price_inc_tax'].toString(),
//                     lineDiscountType:
//                         argument['product']['line_discount_type'].toString(),
//                     variationId: argument['product']['variation_id'].toString(),
//                     name: argument['product']['name'].toString(),
//                     subSku: argument['product']['sub_sku'].toString(),
//                     isFeatured: bool.parse(
//                         argument['product']['is_featured'].toString()),
//                   );

//                   if (list.value.isNotEmpty) {
//                     Product selected = list.value.firstWhere(
//                         (element) => element.variationId == product.variationId,
//                         orElse: () => new Product(productId: null));
//                     list.notifyListeners();
//                     if (selected.productId == null ||
//                         selected.productId == "") {
//                       setState(() {
//                         list.value.add(product);

//                         FunctionProduct.scrollToBottom(scrollController);
//                         list.notifyListeners();
//                       });
//                     }
//                     {
//                       setState(() {
//                         selected.quantity = product.quantity;
//                         selected.lineDiscountType = product.lineDiscountType;
//                         selected.lineDiscountAmount =
//                             product.lineDiscountAmount;
//                         list.notifyListeners();
//                       });
//                     }
//                   } else {
//                     setState(() {
//                       list.value.add(product);
//                       FunctionProduct.scrollToBottom(scrollController);
//                       list.notifyListeners();
//                     });
//                   }
//                 } else if (argument['type'] == 'remove') {
//                   Product product = Product(
//                     returnQuantity:
//                         argument['product']['quantity_returned'].toString(),
//                     lineDiscountAmount:
//                         argument['product']['line_discount_amount'].toString(),
//                     enableStock: argument['product']['enable_stock'].toString(),
//                     defaultSellPrice:
//                         argument['product']['default_sell_price'].toString(),
//                     itemTax: argument['product']['item_tax'].toString(),
//                     categoryId: argument['product']['category_id'].toString(),
//                     alreadyReturned:
//                         argument['product']['already_returned'].toString(),
//                     productId: argument['product']['product_id'].toString(),
//                     calculate: argument['product']['calculate'].toString(),
//                     image: argument['product']['image'].toString(),
//                     quantity: argument['product']['quantity'].toString(),
//                     unit_price: argument['product']['unit_price'].toString(),
//                     brandId: argument['product']['brand_id'].toString(),
//                     availableLocationsString:
//                         argument['product']['available_locations'].toString(),
//                     productType: argument['product']['product_type'].toString(),
//                     unitPriceIncTax:
//                         argument['product']['unit_price_inc_tax'].toString(),
//                     lineDiscountType:
//                         argument['product']['line_discount_type'].toString(),
//                     variationId: argument['product']['variation_id'].toString(),
//                     name: argument['product']['name'].toString(),
//                     subSku: argument['product']['sub_sku'].toString(),
//                     isFeatured: bool.parse(
//                         argument['product']['is_featured'].toString()),
//                   );

//                   setState(() {
//                     list.value.removeWhere((element) =>
//                         element.variationId == product.variationId);
//                     list.notifyListeners();
//                   });
//                 } else if (argument['type'] == 'delete') {
//                   setState(() {
//                     list.value.clear();
//                     list.notifyListeners();
//                   });
//                 } else if (argument['type'] == 'update') {
//                   setState(() {
//                     Product product = Product(
//                       returnQuantity:
//                           argument['product']['quantity_returned'].toString(),
//                       lineDiscountAmount: argument['product']
//                               ['line_discount_amount']
//                           .toString(),
//                       enableStock:
//                           argument['product']['enable_stock'].toString(),
//                       defaultSellPrice:
//                           argument['product']['default_sell_price'].toString(),
//                       itemTax: argument['product']['item_tax'].toString(),
//                       categoryId: argument['product']['category_id'].toString(),
//                       alreadyReturned:
//                           argument['product']['already_returned'].toString(),
//                       productId: argument['product']['product_id'].toString(),
//                       calculate: argument['product']['calculate'].toString(),
//                       image: argument['product']['image'].toString(),
//                       quantity: argument['product']['quantity'].toString(),
//                       unit_price: argument['product']['unit_price'].toString(),
//                       brandId: argument['product']['brand_id'].toString(),
//                       availableLocationsString:
//                           argument['product']['available_locations'].toString(),
//                       productType:
//                           argument['product']['product_type'].toString(),
//                       unitPriceIncTax:
//                           argument['product']['unit_price_inc_tax'].toString(),
//                       lineDiscountType:
//                           argument['product']['line_discount_type'].toString(),
//                       variationId:
//                           argument['product']['variation_id'].toString(),
//                       name: argument['product']['name'].toString(),
//                       subSku: argument['product']['sub_sku'].toString(),
//                       isFeatured: bool.parse(
//                           argument['product']['is_featured'].toString()),
//                     );

//                     Product selected = list.value
//                         .where((element) =>
//                             element.variationId == product.variationId)
//                         .single;
//                     int index = list.value.indexWhere((element) =>
//                         element.variationId == product.variationId);

//                     FunctionProduct.scrollToIndex(scrollController, index, 50);
//                     selected.calculate = product.calculate;
//                     selected.unit_price = product.unit_price;
//                     selected.quantity = product.quantity;
//                     selected.lineDiscountType = product.lineDiscountType;
//                     selected.lineDiscountAmount = product.lineDiscountAmount;

//                     list.notifyListeners();
//                   });
//                 } else if (argument['type'] == 'discount') {
//                   TotalDiscountModel discountPrice = TotalDiscountModel(
//                     amount: argument["discount"]["amount"] != null
//                         ? num.tryParse(
//                                 argument["discount"]["amount"].toString()) ??
//                             0
//                         : 0,
//                     points: argument["discount"]["points"] != null
//                         ? num.tryParse(
//                                 argument["discount"]["points"].toString()) ??
//                             0
//                         : 0,
//                     redeemedAmount: argument["discount"]["redeemed_amount"] !=
//                             null
//                         ? num.tryParse(argument["discount"]["redeemed_amount"]
//                                 .toString()) ??
//                             0
//                         : 0,
//                     type: argument["discount"]["type"]?.toString() ?? '',
//                   );
//                   list.notifyListeners();

//                   setState(() {
//                     discount = discountPrice;
//                     list.notifyListeners();
//                   });
//                 } else if (argument['type'] == 'tax') {
//                   TaxModel tax = TaxModel(
//                     amount: argument['tax']["amount"].toString(),
//                     name: argument['tax']["name"].toString(),
//                     appliedAmount: argument['tax']["appliedAmount"].toString(),
//                     businessId: argument['tax']["business_id"].toString(),
//                     taxId: argument['tax']["tax_id"].toString(),
//                   );
//                   list.notifyListeners();

//                   setState(() {
//                     taxModel = tax;
//                     list.notifyListeners();
//                   });
//                 } else if (argument['type'] == 'successTransaction') {
//                   // log("Invoice data in Customer ${argument['successTransaction']}");

//                   try {
//                     var successTransaction = argument['successTransaction'];

//                     // Ensure products are not null and process accordingly
//                     var productsData = successTransaction["products"];
//                     List<Product> products = [];
//                     if (productsData != null) {
//                       products = productsData is String
//                           ? List.from(jsonDecode(productsData))
//                               .map((e) => Product(
//                                     suspendId: e['id'] as String?,
//                                     productId: e['product_id']?.toString(),
//                                     variationId: e['variation_id']?.toString(),
//                                     enableStock: e['enable_stock']?.toString(),
//                                     productType: e['product_type']?.toString(),
//                                     name: e['name']?.toString(),
//                                     subSku: e['sub_sku']?.toString(),
//                                     defaultSellPrice:
//                                         e['default_sell_price']?.toString(),
//                                     brandId: e['brand_id']?.toString(),
//                                     categoryId: e['category_id']?.toString(),
//                                     subCategoryId:
//                                         e['sub_category_id']?.toString(),
//                                     image: e['image']?.toString(),
//                                     lineDiscountType:
//                                         e['line_discount_type']?.toString(),
//                                     lineDiscountAmount:
//                                         e['line_discount_amount']?.toString(),
//                                     itemTax: e['item_tax']?.toString(),
//                                     quantity: e['quantity'] == null
//                                         ? '1'
//                                         : int.tryParse(e['quantity'].toString())
//                                                 ?.toString() ??
//                                             '1',
//                                     alreadyReturned:
//                                         e['already_returned'] == null
//                                             ? '1'
//                                             : int.tryParse(e['already_returned']
//                                                         .toString())
//                                                     ?.toString() ??
//                                                 '1',
//                                     returnQuantity: e['quantity_returned'] ==
//                                             null
//                                         ? '1'
//                                         : int.tryParse(e['quantity_returned']
//                                                     .toString())
//                                                 ?.toString() ??
//                                             '1',
//                                     returnSubtotal:
//                                         e['return_subtotal'] as double?,
//                                     unitPriceIncTax:
//                                         e['unit_price_inc_tax']?.toString(),
//                                     unit_price: e['unit_price']?.toString(),
//                                     calculate: e['calculate']?.toString(),
//                                     availableLocationsString:
//                                         e['available_locations_string']
//                                             ?.toString(),
//                                     pricingGroups: e['pricing_groups'] != null
//                                         ? List.from((e['pricing_groups']
//                                                 as List<dynamic>)
//                                             .map((v) =>
//                                                 PricingGroups.fromJson(v))
//                                             .toList())
//                                         : <PricingGroups>[],
//                                     isFeatured: e['is_featured'] as bool?,
//                                     locations: e['available_locations'] != null
//                                         ? e['available_locations']
//                                             as List<dynamic>?
//                                         : null,
//                                   ))
//                               .toList()
//                           : List.from(productsData)
//                               .map((e) => Product(
//                                     suspendId: e['id'].toString(),
//                                     // other properties as above
//                                   ))
//                               .toList();
//                     }

//                     // Ensure payment_method is not null and process accordingly
//                     var paymentMethodData =
//                         successTransaction["payment_method"];
//                     List<PaymentListMethod> paymentMethod = [];
//                     if (paymentMethodData != null) {
//                       paymentMethod = paymentMethodData is String
//                           ? List.from(jsonDecode(paymentMethodData))
//                               .map((e) => PaymentListMethod(
//                                     method: e['method']?.toString(),
//                                     amount: e['amount']?.toString(),
//                                     cardNumber: e['card_number']?.toString(),
//                                     cardHolderName:
//                                         e['card_holder_name']?.toString(),
//                                     cardMonth: e['card_month']?.toString(),
//                                     cardYear: e['card_year']?.toString(),
//                                     cardType: e['card_type']?.toString(),
//                                     cardSecurity:
//                                         e['card_security']?.toString(),
//                                     cardTransactionNumber:
//                                         e['card_transaction_number']
//                                             ?.toString(),
//                                     paymentNote: e['payment_note']?.toString(),
//                                     accountNumber:
//                                         e['account_number']?.toString(),
//                                     chequeNumber:
//                                         e['cheque_number']?.toString(),
//                                     cardString: e['card_string']?.toString(),
//                                   ))
//                               .toList()
//                           : List.from(paymentMethodData)
//                               .map((e) => PaymentListMethod(
//                                     method: e['method']?.toString(),
//                                     // other properties as above
//                                   ))
//                               .toList();
//                     }

//                     // Construct the InvoiceModel
//                     InvoiceModel invoiceModel = InvoiceModel(
//                       transactionId:
//                           successTransaction["transaction_id"]?.toString() ??
//                               '',
//                       invoiceTitle:
//                           successTransaction["invoice_title"]?.toString() ?? '',
//                       address: successTransaction["address"]?.toString() ?? '',
//                       mobile: successTransaction["mobile"]?.toString() ?? '',
//                       invoiceNumber:
//                           successTransaction["invoice_number"]?.toString() ??
//                               '',
//                       date: successTransaction["date"]?.toString() ?? '',
//                       customer:
//                           successTransaction["customer"]?.toString() ?? '',
//                       customerMobile:
//                           successTransaction["customer_mobile"]?.toString() ??
//                               '',
//                       product: products, // Use the products list
//                       paymentMethod:
//                           paymentMethod, // Use the payment method list
//                       taxPercentage:
//                           successTransaction["tax_percentage"]?.toString() ??
//                               '',
//                       invoiceFooterText:
//                           successTransaction["invoice_footer_text"]
//                                   ?.toString() ??
//                               '',
//                       invoiceDiscount:
//                           successTransaction["invoice_discount"]?.toString() ??
//                               '',
//                       discountType:
//                           successTransaction["discount_type"]?.toString() ?? '',
//                       subTotal:
//                           successTransaction["sub_total"]?.toString() ?? '',
//                       total: successTransaction["total"]?.toString() ?? '',
//                       taxType: successTransaction["tax_type"]?.toString() ?? '',
//                       totalPaid:
//                           successTransaction["total_paid"]?.toString() ?? '',
//                       balance: successTransaction["balance"]?.toString() ?? '',
//                       changeReturn:
//                           successTransaction["change_return"]?.toString() ?? '',
//                       discountAmount:
//                           successTransaction["discount_amount"]?.toString() ??
//                               '',
//                       invoiceNoReturned:
//                           successTransaction["invoice_no_return"]?.toString() ??
//                               '',
//                       offlineInvoiceNo: successTransaction["offline_invoice_no"]
//                               ?.toString() ??
//                           '',
//                       taxAmount:
//                           successTransaction["tax_amount"]?.toString() ?? '',
//                     );

//                     list.notifyListeners();
//                     setState(() {
//                       invoice = invoiceModel;
//                       list.notifyListeners();
//                     });
//                   } catch (e) {
//                     log("Error parsing invoice data: $e");
//                   }

//                   // try {
//                   //   List<dynamic> paymentListData = argument['paymentList'] as List<dynamic>;
//                   //
//                   //     for (var e in paymentListData) {
//                   //       PaymentListMethod paymentObj = PaymentListMethod(
//                   //         method: e['method'] == null ? null : e['method'] as String,
//                   //         amount: e['amount'] == null ? null : e['amount'] as String,
//                   //         cardNumber: e['card_number'] == null ? null : e['card_number'] as String,
//                   //         cardHolderName: e['card_holder_name'] == null ? null : e['card_holder_name'] as String,
//                   //         cardMonth: e['card_month'] == null ? null : e['card_month'] as String,
//                   //         cardYear: e['card_year'] == null ? null : e['card_year'] as String,
//                   //         cardType: e['card_type'] == null ? null : e['card_type'] as String,
//                   //         cardSecurity: e['card_security'] == null ? null : e['card_security'] as String,
//                   //         cardTransactionNumber: e['card_transaction_number'] == null ? null : e['card_transaction_number'] as String,
//                   //         paymentNote: e['payment_note'] == null ? null : e['payment_note'] as String,
//                   //         accountNumber: e['account_number'] == null ? null : e['account_number'] as String,
//                   //         chequeNumber: e['cheque_number'] == null ? null : e['cheque_number'] as String,
//                   //         cardString: e['card_string'] == null ? null : e['card_string'] as String,
//                   //
//                   //       );
//                   //       setState(() {
//                   //         paymentList?.add(paymentObj);
//                   //         log("data from paymentList"+paymentObj.toJson().toString());
//                   //
//                   //       });
//                   //     }
//                   //
//                   //     // List<dynamic> paymentListData = argument['paymentList'] as List<dynamic>;
//                   //
//                   //     // Convert each map to a PaymentListMethod object
//                   //     // List<PaymentListMethod> paymentList = paymentListData.map((paymentMap) {
//                   //     //   return PaymentListMethod.fromJson(paymentMap as Map<String, dynamic>);
//                   //     // }).toList();
//                   //
//                   //     // Log and work with the paymentList
//                   //     log("Parsed paymentList: $paymentList");
//                   //
//                   //     list.notifyListeners();
//                   // } catch (e) {
//                   //   log("Error parsing invoice data: $e");
//                   // }
//                 } else if (argument['type'] == 'successTransactionSecond') {
//                   setState(() {
//                     invoice = null;
//                     customer = null;
//                     settings = null;
//                     successEmail = null;
//                     successPhoneNumber = null;
//                     tabIndex = null;
//                   });
//                 } else if (argument['type'] == 'tabIndex') {
//                   // log("Invoice data in Customer ${argument['successTransaction']}");

//                   try {
//                     setState(() {
//                       tabIndex = int.parse(argument['tabIndex'].toString());
//                       log("tabIndex---->" + tabIndex.toString());
//                       list.notifyListeners();
//                     });
//                   } catch (e) {
//                     log("Error parsing tabIndex data: $e");
//                   }
//                 } else if (argument['type'] == 'customerData') {
//                   log("data in customerData ${argument['customerData']}");

//                   try {
//                     var customerData = argument['customerData'];

//                     CustomerModel customerModel = CustomerModel(
//                       id: customerData["id"]?.toString() ?? '',
//                       businessId: customerData["business_id"]?.toString() ?? '',
//                       name: customerData["name"]?.toString() ?? '',
//                       email: customerData["email"]?.toString() ?? '',
//                       mobile: customerData["mobile"]?.toString() ?? '',
//                       zipCode: customerData["zip_code"] ??
//                           '', // Assuming zipCode can be dynamic
//                       contactId: customerData["contact_id"]?.toString() ?? '',
//                       // assignedToUsers: (customerData["assigned_to_users"] is String
//                       //     ? (List.from(jsonDecode(customerData["assigned_to_users"])).map((e) => e).toList())
//                       //     : (customerData["assigned_to_users"] is List
//                       //     ? List.from(customerData["assigned_to_users"]).map((e) => e).toList()
//                       //     : [])),
//                       rewardPoints:
//                           customerData["Reward_Point"]?.toString() ?? '',
//                       rewardPointsUsed:
//                           customerData["Reward_Point_used"]?.toString() ?? '',
//                     );

//                     list.notifyListeners();

//                     setState(() {
//                       customer = customerModel;
//                       log("Customer data in Customer123 ${customer?.toJson()}");
//                       list.notifyListeners();
//                     });
//                   } catch (e) {
//                     log("Error parsing customer data: $e");
//                   }
//                 } else if (argument['type'] == 'settingsData') {
//                   log("data in settingsData ${argument['settingsData']}");

//                   try {
//                     var settingsData = argument['settingsData'];

//                     SettingsModel settingsModel = SettingsModel(
//                       enableInvoiceEmail:
//                           settingsData["enable_invoice_email"]?.toString() ??
//                               '',
//                       enableInvoiceSMS:
//                           settingsData["enable_invoice_sms"]?.toString() ?? '',
//                       // posSettings: settingsData["pos_settings"] == null
//                       //     ? null
//                       //     : PosSettings.fromJson(settingsData["pos_settings"]),
//                       enableBrand:
//                           settingsData["enable_brand"]?.toString() ?? '',
//                       enableCategory:
//                           settingsData["enable_category"]?.toString() ?? '',
//                       enableRow: settingsData["enable_row"]?.toString() ?? '',
//                       enableRp: settingsData["enable_rp"]?.toString() ?? '',
//                       rpName: settingsData["rp_name"]?.toString() ?? '',
//                       amountForUnitRp:
//                           settingsData["amount_for_unit_rp"]?.toString() ?? '',
//                       minOrderTotalForRp:
//                           settingsData["min_order_total_for_rp"]?.toString() ??
//                               '',
//                       maxRpPerOrder:
//                           settingsData["max_rp_per_order"]?.toString() ?? '',
//                       redeemAmountPerUnitRp:
//                           settingsData["redeem_amount_per_unit_rp"]
//                                   ?.toString() ??
//                               '',
//                       minOrderTotalForRedeem:
//                           settingsData["min_order_total_for_redeem"]
//                                   ?.toString() ??
//                               '',
//                       minRedeemPoint:
//                           settingsData["min_redeem_point"]?.toString() ?? '',
//                       maxRedeemPoint:
//                           settingsData["max_redeem_point"]?.toString() ?? '',
//                       rpExpiryPeriod:
//                           settingsData["rp_expiry_period"]?.toString() ?? '',
//                       rpExpiryType:
//                           settingsData["rp_expiry_type"]?.toString() ?? '',
//                     );

//                     list.notifyListeners();

//                     setState(() {
//                       settings = settingsModel;

//                       // log("Settings data: ${settings?.toJson()}");
//                       list.notifyListeners();
//                     });
//                   } catch (e) {
//                     log("Error parsing settings data: $e");
//                   }
//                 } else if (argument['type'] == 'successEmail') {
//                   log("data in successEmail ${argument['successEmail']}");
//                   setState(() {
//                     successEmail = argument['successEmail'].toString();
//                   });
//                 } else if (argument['type'] == 'successPhoneNumber') {
//                   log("data in successPhoneNumber ${argument['successPhoneNumber']}");
//                   setState(() {
//                     successPhoneNumber =
//                         argument['successPhoneNumber'].toString();
//                   });
//                 }
//                 else if (argument['type'] == 'location') {
//                   Location location = Location(
//                     name: argument['location']["name"].toString(),
//                   );

//                   list.notifyListeners();

//                   setState(() {
//                     storeName = "${location.name}";
//                     log("Store Name: $storeName");
//                     list.notifyListeners();
//                   });
//                 } else if (argument['type'] == 'slideImages') {
//                   setState(() {
//                     setState(() {
//                       slideImages =
//                           List<String>.from(argument['slideImages'] ?? []);
//                       list.notifyListeners();
//                     });
//                     list.notifyListeners();
//                   });
//                 }
//               });
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (invoice != null)
//                   SizedBox(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: SuccessTransactionBackScreen(
//                         invoice: invoice ?? InvoiceModel(),
//                         tabIndex: tabIndex,
//                         customerData: customer,
//                         settingsData: settings,
//                         paymentList: paymentList,
//                         successEmail: successEmail,
//                         successPhone: successPhoneNumber,
//                       ))
//                 else
//                   list.value.isEmpty && slideImages.isNotEmpty
//                       ? CarousalWidget(imgList: slideImages ?? [])
//                       : Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // log(""),

//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         storeName ?? 'Customer Display',
//                                         style: TextStyle(
//                                           fontSize: frontInvoiceFont,
//                                           fontWeight: FontWeight.bold,
//                                           color: Constant.colorPurple,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   )),
//                               cartListView(
//                                   cartList: list.value,
//                                   scrollController: scrollController),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 10.0, right: 10.0, bottom: 10.0),
//                                 child: SizedBox(
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             children: [
//                                               Text(
//                                                 'Total Items',
//                                                 style: TextStyle(
//                                                     fontSize: sideInvoiceFont,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           Column(
//                                             children: [
//                                               Text(totalitems.toString(),
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             children: [
//                                               Text('Sub Total',
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                           Column(
//                                             children: [
//                                               Text(
//                                                   calculateItemTotal()
//                                                       .toStringAsFixed(2)
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             children: [
//                                               Text(
//                                                   'Discount ${discount?.type == "Percentage" ? "( ${discount?.amount.toString()}% )" : ""}',
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                           Column(
//                                             children: [
//                                               Text(
//                                                   discount?.amount != null
//                                                       ? discountedAmount
//                                                           .toStringAsFixed(2)
//                                                       : 0.0.toString(),
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             children: [
//                                               Text(
//                                                   taxModel?.amount != null
//                                                       ? 'Tax (${double.parse(taxModel!.amount.toString()).toStringAsFixed(2)}% )'
//                                                       : "Tax",
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                           Column(
//                                             children: [
//                                               Text(
//                                                   CalculateTaxAmount()
//                                                       .toStringAsFixed(2),
//                                                   style: TextStyle(
//                                                       fontSize: sideInvoiceFont,
//                                                       fontWeight:
//                                                           FontWeight.bold))
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Center(
//                                             child: Column(
//                                               children: [
//                                                 Text(
//                                                   'Total Payable: \$${totalWithTax().toStringAsFixed(2)}',
//                                                   style: TextStyle(
//                                                     fontSize: frontInvoiceFont,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Constant.colorPurple,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//               ],
//             )));
//   }

//   Widget cartListView(
//       {required List<Product> cartList,
//       required ScrollController scrollController}) {
//     return Expanded(
//       child: ListView.separated(
//         padding: const EdgeInsets.only(bottom: 80),
//         itemCount: cartList.length,
//         controller: scrollController,
//         separatorBuilder: (BuildContext context, int index) => const Divider(),
//         itemBuilder: (context, index) {
//           final Product product = cartList.toList()[index];
//           final quantity = double.parse(product.quantity.toString());
//           String integerProductQuantity =
//               double.parse(product.quantity ?? "0.0").toStringAsFixed(0);

//           return Column(
//             children: [
//               Row(
//                 children: [
//                   const SizedBox(width: 7),
//                   CircleAvatar(
//                     child: Text(
//                       integerProductQuantity,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: Constant.colorRed,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListTile(
//                       dense: true,
//                       onTap: () {},
//                       leading: Image.network(
//                         height: 100,
//                         width: 100,
//                         product.image.toString(),
//                       ),
//                       title: Text(
//                         product.name.toString(),
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Color.fromARGB(255, 0, 0, 0),
//                         ),
//                       ),
//                       subtitle: Row(
//                         children: <Widget>[
//                           Text(
//                             '\$${(double.parse(product.calculate.toString()) * quantity.toInt()).toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w900,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class CarousalWidget extends StatefulWidget {
//   const CarousalWidget({
//     super.key,
//     required this.imgList,
//   });
//   final List<String> imgList;
//   @override
//   State<CarousalWidget> createState() => _CarousalWidgetState();
// }

// class _CarousalWidgetState extends State<CarousalWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.imgList.isNotEmpty) {
//       return Expanded(
//         child: VideoCarouselCustom(
//           mediaUrls: widget.imgList,
//         ),
//       );
//     } else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//             Text("Initializing videos"),
//           ],
//         ),
//       );
//     }
//   }
// }
// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/multiplePay/successTransactionBackSceen.dart';
import 'package:opalposinc/widgets/common/left%20Section/carouselwidget.dart';

import 'package:presentation_displays/secondary_display.dart';

import '../model/product.dart';
import '../utils/constants.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  ValueNotifier<List<Product>> productListNotifier = ValueNotifier([]);

  String? price, tax, payable;
  TotalDiscountModel? discount;
  TaxModel? taxModel;
  InvoiceModel? invoice;
  int? tabIndex;
  List<PaymentListMethod>? paymentList;
  CustomerModel? customer;
  SettingsModel? settings;
  String? successEmail;
  String? successPhoneNumber;
  String? storeName;
  List<String> slideImages = [];
  List<String> sortedSlideImages = [];
  List<int> mediaOrder = [];

  Map<String, dynamic>? data;
  String? value = "This";

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
        valueListenable: productListNotifier,
        builder: (context, list, child) => homeCustomer(
              height: height,
              width: width,
              list: productListNotifier,
              scrollController: _scrollController,
            ));
  }

  Widget homeCustomer(
      {required ValueNotifier<List<Product>> list,
      required ScrollController scrollController,
      required double width,
      required double height}) {
    double sideInvoiceFont = 15;

    double frontInvoiceFont = 28;
    double discountedAmount = 0.0;
    final totalitems =
        FunctionProduct.getProductLengthBackScreen(productList: list.value);

    list.notifyListeners();
    double calculateItemTotal() {
      double itemTotal = 0.0;

      itemTotal = list.value
          .map((product) {
            return double.parse(product.calculate.toString()) *
                double.parse(product.quantity.toString());
          })
          .toList()
          .fold(0.0, (previousValue, element) => previousValue + element)
          .toDouble();

      if (discount?.amount != null) {
        if (discount?.type == "Percentage") {
          discountedAmount = (itemTotal * ((discount?.amount ?? 0) / 100));
          itemTotal = itemTotal - discountedAmount;

          return itemTotal;
        } else if (discount?.type == "Fixed") {
          discountedAmount = discount!.amount!.toDouble();
          itemTotal = (itemTotal - discountedAmount);

          return itemTotal;
        } else {
          return itemTotal;
        }
      } else {
        return itemTotal;
      }
    }

    double CalculateTaxAmount() {
      double total = calculateItemTotal();
      double taxRate = taxModel?.amount == null
          ? 0.0
          : double.parse(taxModel!.amount.toString()) / 100;

      double taxAmount = total * taxRate;
      return taxAmount;
    }

    double totalWithTax() {
      double total = calculateItemTotal();
      double taxRate = taxModel?.amount == null
          ? 0.0
          : double.parse(taxModel!.amount.toString()) / 100;

      double taxAmount = total * taxRate;
      double totalWithTax = total + taxAmount;

      return totalWithTax;
    }

    return Scaffold(
        body: SecondaryDisplay(
            callback: (dynamic argument) {
              setState(() {
                list.notifyListeners();

                if (argument['type'] == 'add') {
                  Product product = Product(
                    returnQuantity:
                        argument['product']['quantity_returned'].toString(),
                    lineDiscountAmount:
                        argument['product']['line_discount_amount'].toString(),
                    enableStock: argument['product']['enable_stock'].toString(),
                    defaultSellPrice:
                        argument['product']['default_sell_price'].toString(),
                    itemTax: argument['product']['item_tax'].toString(),
                    categoryId: argument['product']['category_id'].toString(),
                    alreadyReturned:
                        argument['product']['already_returned'].toString(),
                    productId: argument['product']['product_id'].toString(),
                    calculate: argument['product']['calculate'].toString(),
                    image: argument['product']['image'].toString(),
                    quantity: argument['product']['quantity'].toString(),
                    unit_price: argument['product']['unit_price'].toString(),
                    brandId: argument['product']['brand_id'].toString(),
                    availableLocationsString:
                        argument['product']['available_locations'].toString(),
                    productType: argument['product']['product_type'].toString(),
                    unitPriceIncTax:
                        argument['product']['unit_price_inc_tax'].toString(),
                    lineDiscountType:
                        argument['product']['line_discount_type'].toString(),
                    variationId: argument['product']['variation_id'].toString(),
                    name: argument['product']['name'].toString(),
                    subSku: argument['product']['sub_sku'].toString(),
                    isFeatured: bool.parse(
                        argument['product']['is_featured'].toString()),
                  );

                  if (list.value.isNotEmpty) {
                    Product selected = list.value.firstWhere(
                        (element) => element.variationId == product.variationId,
                        orElse: () => Product(productId: null));
                    list.notifyListeners();
                    if (selected.productId == null ||
                        selected.productId == "") {
                      setState(() {
                        list.value.add(product);

                        FunctionProduct.scrollToBottom(scrollController);
                        list.notifyListeners();
                      });
                    }
                    {
                      setState(() {
                        selected.quantity = product.quantity;
                        selected.lineDiscountType = product.lineDiscountType;
                        selected.lineDiscountAmount =
                            product.lineDiscountAmount;
                        list.notifyListeners();
                      });
                    }
                  } else {
                    setState(() {
                      list.value.add(product);
                      FunctionProduct.scrollToBottom(scrollController);
                      list.notifyListeners();
                    });
                  }
                } else if (argument['type'] == 'remove') {
                  Product product = Product(
                    returnQuantity:
                        argument['product']['quantity_returned'].toString(),
                    lineDiscountAmount:
                        argument['product']['line_discount_amount'].toString(),
                    enableStock: argument['product']['enable_stock'].toString(),
                    defaultSellPrice:
                        argument['product']['default_sell_price'].toString(),
                    itemTax: argument['product']['item_tax'].toString(),
                    categoryId: argument['product']['category_id'].toString(),
                    alreadyReturned:
                        argument['product']['already_returned'].toString(),
                    productId: argument['product']['product_id'].toString(),
                    calculate: argument['product']['calculate'].toString(),
                    image: argument['product']['image'].toString(),
                    quantity: argument['product']['quantity'].toString(),
                    unit_price: argument['product']['unit_price'].toString(),
                    brandId: argument['product']['brand_id'].toString(),
                    availableLocationsString:
                        argument['product']['available_locations'].toString(),
                    productType: argument['product']['product_type'].toString(),
                    unitPriceIncTax:
                        argument['product']['unit_price_inc_tax'].toString(),
                    lineDiscountType:
                        argument['product']['line_discount_type'].toString(),
                    variationId: argument['product']['variation_id'].toString(),
                    name: argument['product']['name'].toString(),
                    subSku: argument['product']['sub_sku'].toString(),
                    isFeatured: bool.parse(
                        argument['product']['is_featured'].toString()),
                  );

                  setState(() {
                    list.value.removeWhere((element) =>
                        element.variationId == product.variationId);
                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'delete') {
                  setState(() {
                    list.value.clear();
                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'update') {
                  setState(() {
                    Product product = Product(
                      returnQuantity:
                          argument['product']['quantity_returned'].toString(),
                      lineDiscountAmount: argument['product']
                              ['line_discount_amount']
                          .toString(),
                      enableStock:
                          argument['product']['enable_stock'].toString(),
                      defaultSellPrice:
                          argument['product']['default_sell_price'].toString(),
                      itemTax: argument['product']['item_tax'].toString(),
                      categoryId: argument['product']['category_id'].toString(),
                      alreadyReturned:
                          argument['product']['already_returned'].toString(),
                      productId: argument['product']['product_id'].toString(),
                      calculate: argument['product']['calculate'].toString(),
                      image: argument['product']['image'].toString(),
                      quantity: argument['product']['quantity'].toString(),
                      unit_price: argument['product']['unit_price'].toString(),
                      brandId: argument['product']['brand_id'].toString(),
                      availableLocationsString:
                          argument['product']['available_locations'].toString(),
                      productType:
                          argument['product']['product_type'].toString(),
                      unitPriceIncTax:
                          argument['product']['unit_price_inc_tax'].toString(),
                      lineDiscountType:
                          argument['product']['line_discount_type'].toString(),
                      variationId:
                          argument['product']['variation_id'].toString(),
                      name: argument['product']['name'].toString(),
                      subSku: argument['product']['sub_sku'].toString(),
                      isFeatured: bool.parse(
                          argument['product']['is_featured'].toString()),
                    );

                    Product selected = list.value
                        .where((element) =>
                            element.variationId == product.variationId)
                        .single;
                    int index = list.value.indexWhere((element) =>
                        element.variationId == product.variationId);

                    FunctionProduct.scrollToIndex(scrollController, index, 50);
                    selected.calculate = product.calculate;
                    selected.unit_price = product.unit_price;
                    selected.quantity = product.quantity;
                    selected.lineDiscountType = product.lineDiscountType;
                    selected.lineDiscountAmount = product.lineDiscountAmount;

                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'discount') {
                  TotalDiscountModel discountPrice = TotalDiscountModel(
                    amount: argument["discount"]["amount"] != null
                        ? num.tryParse(
                                argument["discount"]["amount"].toString()) ??
                            0
                        : 0,
                    points: argument["discount"]["points"] != null
                        ? num.tryParse(
                                argument["discount"]["points"].toString()) ??
                            0
                        : 0,
                    redeemedAmount: argument["discount"]["redeemed_amount"] !=
                            null
                        ? num.tryParse(argument["discount"]["redeemed_amount"]
                                .toString()) ??
                            0
                        : 0,
                    type: argument["discount"]["type"]?.toString() ?? '',
                  );
                  list.notifyListeners();

                  setState(() {
                    discount = discountPrice;
                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'tax') {
                  TaxModel tax = TaxModel(
                    amount: argument['tax']["amount"].toString(),
                    name: argument['tax']["name"].toString(),
                    businessId: argument['tax']["business_id"].toString(),
                    taxId: argument['tax']["tax_id"].toString(),
                  );
                  list.notifyListeners();

                  setState(() {
                    taxModel = tax;
                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'successTransaction') {
                  try {
                    var successTransaction = argument['successTransaction'];

                    var productsData = successTransaction["products"];
                    List<Product> products = [];
                    if (productsData != null) {
                      products = productsData is String
                          ? List.from(jsonDecode(productsData))
                              .map((e) => Product(
                                    suspendId: e['id'] as String?,
                                    productId: e['product_id']?.toString(),
                                    variationId: e['variation_id']?.toString(),
                                    enableStock: e['enable_stock']?.toString(),
                                    productType: e['product_type']?.toString(),
                                    name: e['name']?.toString(),
                                    subSku: e['sub_sku']?.toString(),
                                    defaultSellPrice:
                                        e['default_sell_price']?.toString(),
                                    brandId: e['brand_id']?.toString(),
                                    categoryId: e['category_id']?.toString(),
                                    subCategoryId:
                                        e['sub_category_id']?.toString(),
                                    image: e['image']?.toString(),
                                    lineDiscountType:
                                        e['line_discount_type']?.toString(),
                                    lineDiscountAmount:
                                        e['line_discount_amount']?.toString(),
                                    itemTax: e['item_tax']?.toString(),
                                    quantity: e['quantity'] == null
                                        ? '1'
                                        : int.tryParse(e['quantity'].toString())
                                                ?.toString() ??
                                            '1',
                                    alreadyReturned:
                                        e['already_returned'] == null
                                            ? '1'
                                            : int.tryParse(e['already_returned']
                                                        .toString())
                                                    ?.toString() ??
                                                '1',
                                    returnQuantity: e['quantity_returned'] ==
                                            null
                                        ? '1'
                                        : int.tryParse(e['quantity_returned']
                                                    .toString())
                                                ?.toString() ??
                                            '1',
                                    returnSubtotal:
                                        e['return_subtotal'] as double?,
                                    unitPriceIncTax:
                                        e['unit_price_inc_tax']?.toString(),
                                    unit_price: e['unit_price']?.toString(),
                                    calculate: e['calculate']?.toString(),
                                    availableLocationsString:
                                        e['available_locations_string']
                                            ?.toString(),
                                    pricingGroups: e['pricing_groups'] != null
                                        ? List.from((e['pricing_groups']
                                                as List<dynamic>)
                                            .map((v) =>
                                                PricingGroups.fromJson(v))
                                            .toList())
                                        : <PricingGroups>[],
                                    isFeatured: e['is_featured'] as bool?,
                                    locations: e['available_locations'] != null
                                        ? e['available_locations']
                                            as List<dynamic>?
                                        : null,
                                  ))
                              .toList()
                          : List.from(productsData)
                              .map((e) => Product(
                                    suspendId: e['id'].toString(),
                                    // other properties as above
                                  ))
                              .toList();
                    }

                    var paymentMethodData =
                        successTransaction["payment_method"];
                    List<PaymentListMethod> paymentMethod = [];
                    if (paymentMethodData != null) {
                      paymentMethod = paymentMethodData is String
                          ? List.from(jsonDecode(paymentMethodData))
                              .map((e) => PaymentListMethod(
                                    method: e['method']?.toString(),
                                    amount: e['amount']?.toString(),
                                    cardNumber: e['card_number']?.toString(),
                                    cardHolderName:
                                        e['card_holder_name']?.toString(),
                                    cardMonth: e['card_month']?.toString(),
                                    cardYear: e['card_year']?.toString(),
                                    cardType: e['card_type']?.toString(),
                                    cardSecurity:
                                        e['card_security']?.toString(),
                                    cardTransactionNumber:
                                        e['card_transaction_number']
                                            ?.toString(),
                                    paymentNote: e['payment_note']?.toString(),
                                    accountNumber:
                                        e['account_number']?.toString(),
                                    chequeNumber:
                                        e['cheque_number']?.toString(),
                                    cardString: e['card_string']?.toString(),
                                  ))
                              .toList()
                          : List.from(paymentMethodData)
                              .map((e) => PaymentListMethod(
                                    method: e['method']?.toString(),
                                    // other properties as above
                                  ))
                              .toList();
                    }

                    // Construct the InvoiceModel
                    InvoiceModel invoiceModel = InvoiceModel(
                      transactionId:
                          successTransaction["transaction_id"]?.toString() ??
                              '',
                      invoiceTitle:
                          successTransaction["invoice_title"]?.toString() ?? '',
                      address: successTransaction["address"]?.toString() ?? '',
                      mobile: successTransaction["mobile"]?.toString() ?? '',
                      invoiceNumber:
                          successTransaction["invoice_number"]?.toString() ??
                              '',
                      date: successTransaction["date"]?.toString() ?? '',
                      customer:
                          successTransaction["customer"]?.toString() ?? '',
                      customerMobile:
                          successTransaction["customer_mobile"]?.toString() ??
                              '',
                      product: products, // Use the products list
                      paymentMethod:
                          paymentMethod, // Use the payment method list
                      taxPercentage:
                          successTransaction["tax_percentage"]?.toString() ??
                              '',
                      invoiceFooterText:
                          successTransaction["invoice_footer_text"]
                                  ?.toString() ??
                              '',
                      invoiceDiscount:
                          successTransaction["invoice_discount"]?.toString() ??
                              '',
                      discountType:
                          successTransaction["discount_type"]?.toString() ?? '',
                      subTotal:
                          successTransaction["sub_total"]?.toString() ?? '',
                      total: successTransaction["total"]?.toString() ?? '',
                      taxType: successTransaction["tax_type"]?.toString() ?? '',
                      totalPaid:
                          successTransaction["total_paid"]?.toString() ?? '',
                      balance: successTransaction["balance"]?.toString() ?? '',
                      changeReturn:
                          successTransaction["change_return"]?.toString() ?? '',
                      discountAmount:
                          successTransaction["discount_amount"]?.toString() ??
                              '',
                      invoiceNoReturned:
                          successTransaction["invoice_no_return"]?.toString() ??
                              '',
                      offlineInvoiceNo: successTransaction["offline_invoice_no"]
                              ?.toString() ??
                          '',
                      taxAmount:
                          successTransaction["tax_amount"]?.toString() ?? '',
                    );

                    list.notifyListeners();
                    setState(() {
                      invoice = invoiceModel;
                      list.notifyListeners();
                    });
                  } catch (e) {
                    log("Error parsing invoice data: $e");
                  }
                } else if (argument['type'] == 'successTransactionSecond') {
                  setState(() {
                    invoice = null;
                    customer = null;
                    settings = null;
                    successEmail = null;
                    successPhoneNumber = null;
                    tabIndex = null;
                  });
                } else if (argument['type'] == 'tabIndex') {
                  try {
                    setState(() {
                      tabIndex = int.parse(argument['tabIndex'].toString());
                      list.notifyListeners();
                    });
                  } catch (e) {
                    log("Error parsing tabIndex data: $e");
                  }
                } else if (argument['type'] == 'customerData') {
                  log("data in customerData ${argument['customerData']}");

                  try {
                    var customerData = argument['customerData'];

                    CustomerModel customerModel = CustomerModel(
                      id: customerData["id"]?.toString() ?? '',
                      businessId: customerData["business_id"]?.toString() ?? '',
                      name: customerData["name"]?.toString() ?? '',
                      email: customerData["email"]?.toString() ?? '',
                      mobile: customerData["mobile"]?.toString() ?? '',
                      zipCode: customerData["zip_code"] ??
                          '', // Assuming zipCode can be dynamic
                      contactId: customerData["contact_id"]?.toString() ?? '',
                      // assignedToUsers: (customerData["assigned_to_users"] is String
                      //     ? (List.from(jsonDecode(customerData["assigned_to_users"])).map((e) => e).toList())
                      //     : (customerData["assigned_to_users"] is List
                      //     ? List.from(customerData["assigned_to_users"]).map((e) => e).toList()
                      //     : [])),
                      rewardPoints:
                          customerData["Reward_Point"]?.toString() ?? '',
                      rewardPointsUsed:
                          customerData["Reward_Point_used"]?.toString() ?? '',
                    );

                    list.notifyListeners();

                    setState(() {
                      customer = customerModel;
                      log("Customer data in Customer123 ${customer?.toJson()}");
                      list.notifyListeners();
                    });
                  } catch (e) {
                    log("Error parsing customer data: $e");
                  }
                } else if (argument['type'] == 'settingsData') {
                  log("data in settingsData ${argument['settingsData']}");

                  try {
                    var settingsData = argument['settingsData'];

                    SettingsModel settingsModel = SettingsModel(
                      enableInvoiceEmail:
                          settingsData["enable_invoice_email"]?.toString() ??
                              '',
                      enableInvoiceSMS:
                          settingsData["enable_invoice_sms"]?.toString() ?? '',
                      // posSettings: settingsData["pos_settings"] == null
                      //     ? null
                      //     : PosSettings.fromJson(settingsData["pos_settings"]),
                      enableBrand:
                          settingsData["enable_brand"]?.toString() ?? '',
                      enableCategory:
                          settingsData["enable_category"]?.toString() ?? '',
                      enableRow: settingsData["enable_row"]?.toString() ?? '',
                      enableRp: settingsData["enable_rp"]?.toString() ?? '',
                      rpName: settingsData["rp_name"]?.toString() ?? '',
                      amountForUnitRp:
                          settingsData["amount_for_unit_rp"]?.toString() ?? '',
                      minOrderTotalForRp:
                          settingsData["min_order_total_for_rp"]?.toString() ??
                              '',
                      maxRpPerOrder:
                          settingsData["max_rp_per_order"]?.toString() ?? '',
                      redeemAmountPerUnitRp:
                          settingsData["redeem_amount_per_unit_rp"]
                                  ?.toString() ??
                              '',
                      minOrderTotalForRedeem:
                          settingsData["min_order_total_for_redeem"]
                                  ?.toString() ??
                              '',
                      minRedeemPoint:
                          settingsData["min_redeem_point"]?.toString() ?? '',
                      maxRedeemPoint:
                          settingsData["max_redeem_point"]?.toString() ?? '',
                      rpExpiryPeriod:
                          settingsData["rp_expiry_period"]?.toString() ?? '',
                      rpExpiryType:
                          settingsData["rp_expiry_type"]?.toString() ?? '',
                    );

                    list.notifyListeners();

                    setState(() {
                      settings = settingsModel;

                      // log("Settings data: ${settings?.toJson()}");
                      list.notifyListeners();
                    });
                  } catch (e) {
                    log("Error parsing settings data: $e");
                  }
                } else if (argument['type'] == 'successEmail') {
                  log("data in successEmail ${argument['successEmail']}");
                  setState(() {
                    successEmail = argument['successEmail'].toString();
                  });
                } else if (argument['type'] == 'successPhoneNumber') {
                  log("data in successPhoneNumber ${argument['successPhoneNumber']}");
                  setState(() {
                    successPhoneNumber =
                        argument['successPhoneNumber'].toString();
                  });
                } else if (argument['type'] == 'location') {
                  Location location = Location(
                    name: argument['location']["name"].toString(),
                  );

                  list.notifyListeners();

                  setState(() {
                    storeName = "${location.name}";
                    log("Store Name: $storeName");
                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'slideImages') {
                  setState(() {
                    setState(() {
                      slideImages =
                          List<String>.from(argument['slideImages'] ?? []);
                      list.notifyListeners();
                    });
                    list.notifyListeners();
                  });
                } else if (argument['type'] == 'mediaOrder') {
                  setState(() async {
                    List<String> mediaOrderList =
                        List<String>.from(argument['mediaOrder'] ?? []);
                    mediaOrder = mediaOrderList
                        .where((o) => o.isNotEmpty)
                        .map((o) => int.parse(o))
                        .toList();
                    slideImages =
                        slideImages.where((m) => m.isNotEmpty).toList();
                    sortedSlideImages = List.generate(
                        slideImages.length, (index) => index.toString());

                    for (int i = 0; i < slideImages.length; i++) {
                      setState(() {
                        sortedSlideImages[mediaOrder[i] - 1] = slideImages[i];
                      });
                    }
                  });
                } else if (argument['type'] == 'slideImages') {
                  setState(() {
                    setState(() {
                      List<String> slideImagesValue =
                          List<String>.from(argument['slideImages'] ?? []);
                      slideImages =
                          slideImagesValue.where((m) => m.isNotEmpty).toList();

                      sortedSlideImages = List.generate(
                          slideImages.length, (index) => index.toString());

                      for (int i = 0; i < slideImages.length; i++) {
                        setState(() {
                          sortedSlideImages[mediaOrder[i] - 1] = slideImages[i];
                        });
                      }

                      list.notifyListeners();
                    });
                  });
                  list.notifyListeners();
                }
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (invoice != null)
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SuccessTransactionBackScreen(
                        invoice: invoice ?? InvoiceModel(),
                        tabIndex: tabIndex,
                        customerData: customer,
                        settingsData: settings,
                        paymentList: paymentList,
                        successEmail: successEmail,
                        successPhone: successPhoneNumber,
                      ))
                else
                  list.value.isNotEmpty ||
                          slideImages.isEmpty ||
                          slideImages.every((image) => image.isEmpty)
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        storeName ?? 'Customer Display',
                                        style: TextStyle(
                                          fontSize: frontInvoiceFont,
                                          fontWeight: FontWeight.bold,
                                          color: Constant.colorPurple,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )),
                              cartListView(
                                  cartList: list.value,
                                  scrollController: scrollController),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 10.0),
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Total Items',
                                                style: TextStyle(
                                                    fontSize: sideInvoiceFont,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(totalitems.toString(),
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text('Sub Total',
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  calculateItemTotal()
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                  'Discount ${discount?.type == "Percentage" ? "( ${discount?.amount.toString()}% )" : ""}',
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  discount?.amount != null
                                                      ? " (-) ${discountedAmount.toStringAsFixed(2)}"
                                                      : " (-) 0.00",
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                  taxModel?.amount != null
                                                      ? 'Tax (${double.parse(taxModel!.amount.toString()).toStringAsFixed(2)}% )'
                                                      : "Tax ",
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  " (+) ${CalculateTaxAmount().toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: sideInvoiceFont,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Total Payable: \$${totalWithTax().toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: frontInvoiceFont,
                                                    fontWeight: FontWeight.bold,
                                                    color: Constant.colorPurple,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : CarousalWidget(imgList: slideImages ?? [])
              ],
            )));
  }

  Widget cartListView(
      {required List<Product> cartList,
      required ScrollController scrollController}) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: cartList.length,
        controller: scrollController,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          final Product product = cartList.toList()[index];
          final quantity = double.parse(product.quantity.toString());
          String integerProductQuantity =
              double.parse(product.quantity ?? "0.0").toStringAsFixed(0);

          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 7),
                  CircleAvatar(
                    child: Text(
                      integerProductQuantity,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Constant.colorRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      dense: true,
                      onTap: () {},
                      leading: Image.network(
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Image.asset('assets/images/ErrorImage.png');
                        },
                        height: 100,
                        width: 100,
                        product.image.toString(),
                      ),
                      title: Text(
                        product.name.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                            '\$${(double.parse(product.calculate.toString()) * quantity.toInt()).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class CarousalWidget extends StatefulWidget {
  const CarousalWidget({
    super.key,
    required this.imgList,
  });
  final List<String> imgList;
  @override
  State<CarousalWidget> createState() => _CarousalWidgetState();
}

class _CarousalWidgetState extends State<CarousalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imgList.isNotEmpty) {
      return Expanded(
        child: VideoCarouselCustom(
          mediaUrls: widget.imgList,
        ),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            Text("Initializing videos"),
          ],
        ),
      );
    }
  }
}
