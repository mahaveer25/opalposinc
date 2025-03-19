import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalsystem/CustomFuncs.dart';
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/invoices/transaction.dart';
import 'package:opalsystem/model/CustomerModel.dart';
import 'package:opalsystem/model/TaxModel.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/model/product.dart';
import 'package:opalsystem/multiplePay/MultiplePay.dart';
import 'package:opalsystem/multiplePay/PaymentListMethod.dart';
import 'package:opalsystem/services/post_sellreturn.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import '../widgets/CustomWidgets/CustomIniputField.dart';

class SellReturnMobile extends StatefulWidget {
  final double? totalAmount;
  final int? totalItems;
  final String? selectedPay;
  final InvoiceModel returnsale;
  const SellReturnMobile(
      {super.key,
      this.totalAmount,
      this.totalItems,
      this.selectedPay,
      required this.returnsale});

  @override
  State<SellReturnMobile> createState() => _SellReturnMobileState();
}

class _SellReturnMobileState extends State<SellReturnMobile> {
  List<PaymentListMethod> methodListWidget = [];
  List<TextEditingController> returnQuantityControllers = [];
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController discountType = TextEditingController();
  TextEditingController date = TextEditingController();
  String total = '0.0';
  double discount = 0.0;
  double tax = 0.0;
  double subTotal = 0.0;

  @override
  void initState() {
    discountType.text = (widget.returnsale.discountType) ?? '';
    discountController.text =
        double.parse(widget.returnsale.discountAmount.toString())
            .toStringAsFixed(2);
    date.text = widget.returnsale.date ?? "";
    widget.returnsale.product?.forEach((_) {
      returnQuantityControllers.add(TextEditingController());
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in returnQuantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Sell Return",
      //     style: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //     textAlign: TextAlign.start,
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sell Return',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 30,
                      color: Constant.colorPurple,
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(177, 231, 230, 230),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice No: ${widget.returnsale.invoiceNumber ?? ''}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Customer :${widget.returnsale.customer ?? ''}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text("Date: ${widget.returnsale.date ?? ''}"),
                    Text("Business Location: ${widget.returnsale.address}"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(177, 231, 230, 230),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomInputField(
                              labelText: "",
                              hintText: "Invoice Number",
                              // enabled: false,
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: invoiceNo,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: CustomInputField(
                            labelText: "Date",
                            hintText: "Date",
                            enabled: false,
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: date,
                          )),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 65,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                '#',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  'Product Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Unit Price',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Sell Quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Returned',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Return Quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Return Subtotal',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              widget.returnsale.product!.length, (index) {
                            Product product = widget.returnsale.product![index];

                            void calculateTotalReturnAmount() {
                              subtotalProduct(product: product, index: index);

                              setState(() {
                                final sum = sumProduct(
                                    productList: widget.returnsale.product!);
                                discount = invoiceDicount(
                                    productList: widget.returnsale.product!);
                                tax = taxInvoice(
                                    discount:
                                        discount == 0.0 ? sum : sum - discount);
                                total = ((sum - discount) + tax).toString();

                                log('subTotal:$subTotal');
                              });
                            }

                            return DataRow(cells: [
                              DataCell(SizedBox(
                                  width: 2, child: Text('${index + 1}'))),
                              DataCell(
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    product.name ?? '',
                                  ),
                                ),
                              ),
                              DataCell(Center(
                                child: Text(unitPriceDiscount(product: product)
                                    .toStringAsFixed(2)),
                              )),
                              DataCell(
                                  Center(child: Text('${product.quantity}'))),
                              DataCell(Center(
                                  child: Text('${product.alreadyReturned}'))),
                              DataCell(
                                Center(
                                  child: CustomInputField(
                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: false),
                                    labelText: "Quantity",
                                    hintText: "0",
                                    controller:
                                        returnQuantityControllers[index],
                                    onChanged: (value) {
                                      setState(() {
                                        calculateTotalReturnAmount();
                                        if (value.contains('.')) {
                                          ConstDialog(context).showErrorDialog(
                                            error:
                                                'Decimal points are not allowed',
                                            iconData: Icons.error,
                                            iconColor: Colors.red,
                                            iconText: 'Alert',
                                            ontap: () => Navigator.pop(context),
                                          );
                                          final newValue = value.substring(
                                              0, value.length - 1);
                                          returnQuantityControllers[index]
                                              .text = newValue;
                                          returnQuantityControllers[index]
                                                  .selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                                offset: newValue.length),
                                          );
                                        } else if (value.isNotEmpty) {
                                          int enteredQuantity =
                                              int.parse(value);
                                          int? sellQuantity = int.parse(
                                                  product.quantity.toString()) -
                                              int.parse(product.alreadyReturned
                                                  .toString());
                                          if (enteredQuantity > sellQuantity) {
                                            returnQuantityControllers[index]
                                                .text = sellQuantity.toString();
                                            ConstDialog(context)
                                                .showErrorDialog(
                                              error:
                                                  'Return quantity cannot exceed available quantity',
                                              iconData: Icons.error,
                                              iconColor: Colors.red,
                                              iconText: 'Alert',
                                              ontap: () =>
                                                  Navigator.pop(context),
                                            );
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              DataCell(Center(
                                child: Text(
                                  ((product.returnSubtotal ?? 0.0.toString())
                                      .toString()),
                                ),
                              )),
                            ]);
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomInputField(
                            hintText: "Discount Type",
                            labelText: '',
                            controller: discountType,
                            enabled: false,
                            onChanged: (value) {
                              setState(() {});
                            },
                          )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: CustomInputField(
                            hintText: "Discount Amount",
                            labelText: '',
                            controller: discountController,
                            enabled: false,
                            onChanged: (value) {
                              setState(() {});
                            },
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "Total Return Discount:  (-) \$ ${discount.toStringAsFixed(2)}")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Total Return Tax - (No Tax - 0.00%) :  (+) \$ ${tax.toStringAsFixed(2)}",
                                style: const TextStyle(),
                                maxLines: 1,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "Return Total:\$ ${double.parse(total).toStringAsFixed(2)}")
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            onSellReturn(),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Constant.colorPurple,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  double unitPriceDiscount({required Product product}) {
    double price = double.parse(product.unit_price.toString());
    double discount = double.parse(product.lineDiscountAmount.toString());

    if (product.lineDiscountType == "Percentage") {
      final unitPrice = price - (price * (discount / 100));
      return unitPrice;
    } else {
      final unitPrice = price - discount;
      return unitPrice;
    }
  }

  subtotalProduct({required Product product, required int index}) {
    if (returnQuantityControllers[index].text.isNotEmpty) {
      product.returnQuantity =
          double.parse(returnQuantityControllers[index].text)
              .toStringAsFixed(2);
      final returnQuantity = product.returnQuantity == null
          ? 0.00
          : double.parse(product.returnQuantity ?? '0.0');
      final quantity = (int.parse(product.quantity.toString()) -
          int.parse(product.alreadyReturned.toString()));
      final total = returnQuantity > quantity
          ? quantity * unitPriceDiscount(product: product)
          : returnQuantity * unitPriceDiscount(product: product);

      product.returnSubtotal =
          double.parse(double.parse(total.toString()).toStringAsFixed(2));
    } else {
      product.returnSubtotal = 0.0;
    }
  }

  double sumProduct({required List<Product> productList}) {
    final sum = productList.map((e) => e.returnSubtotal ?? 0.00).fold(
        0.0, (previousValue, element) => previousValue + element.toDouble());

    subTotal = sum;

    return sum;
  }

  double invoiceDicount({required List<Product> productList}) {
    final sum = sumProduct(productList: productList);
    final discount = double.parse(widget.returnsale.discountAmount.toString());
    final subTotal = double.parse(widget.returnsale.subTotal.toString());

    if (discount > 0.0) {
      if (widget.returnsale.discountType == "Percentage") {
        return (sum * (discount / 100));
      } else {
        return (discount / subTotal) * sum;
      }
    } else {
      return 0.0;
    }
  }

  double taxInvoice({required double discount}) {
    String stringTax = (widget.returnsale.taxPercentage.toString())
        .replaceAll(RegExp(r'[^\d.]'), '');
    double totalTax = double.parse(stringTax);
    final tax = (discount / 100) * totalTax;
    log(discount.toString());
    log(tax.toString());
    return tax;
  }

  double calculateTotalReturnQuantity() {
    double totalReturnQuantity = 0.0;
    for (int i = 0; i < returnQuantityControllers.length; i++) {
      if (returnQuantityControllers[i].text.isNotEmpty) {
        totalReturnQuantity += double.parse(returnQuantityControllers[i].text);
      }
    }
    return totalReturnQuantity;
  }

  Widget onSellReturn() {
    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
        builder: (context, loggedInUser) {
      return BlocBuilder<LocationBloc, Location?>(builder: (context, location) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
            builder: (context, customer) {
          return BlocBuilder<TaxBloc, TaxModel?>(builder: (context, tax) {
            return Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Constant.colorPurple,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    double totalReturnQuantity = calculateTotalReturnQuantity();
                    if (totalReturnQuantity == 0.0) {
                      ConstDialog(context).showErrorDialog(
                        error: 'Return Quantity Should be Greater then "0"',
                        iconData: Icons.error,
                        iconColor: Colors.red,
                        iconText: 'Alert',
                        ontap: () => Navigator.pop(context),
                      );
                    } else {
                      (onSelltap(
                        loggedInUser: loggedInUser!,
                        location: location!,
                        customerModel: customer!,
                        taxModel: tax!,
                        productList: widget.returnsale.product ?? [],
                      ));
                    }
                  },
                  child: const Text('Save')),
            );
          });
        });
      });
    });
  }

  onSelltap({
    required LoggedInUser loggedInUser,
    required Location location,
    required CustomerModel customerModel,
    required TaxModel taxModel,
    required List<Product> productList,
  }) async {
    for (int i = 0; i < productList.length; i++) {
      final inputQuantity = returnQuantityControllers[i].text.isNotEmpty
          ? double.parse(returnQuantityControllers[i].text)
          : 0.0; // Default to 0.0 if empty
      productList[i].returnQuantity =
          inputQuantity.toStringAsFixed(2); // Update the product list
    }
    Transaction payload = Transaction(
      invoiceNo: widget.returnsale.invoiceNumber,
      invoiceNoReturned: invoiceNo.text,
      transactionId: widget.returnsale.transactionId,
      userId: loggedInUser.id,
      businessId: loggedInUser.businessId,
      locationId: location.id,
      contactId: customerModel.id,
      transactionDate: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      product: productList,
      discountType: widget.returnsale.discountType,
      discountAmount: discount,
      totalAmountBeforeTax: subTotal,
      taxRateId: taxModel.taxId,
      taxCalculationPercentage: taxModel.amount == null
          ? 0.0
          : double.parse(taxModel.amount.toString()),
      taxCalculationAmount: tax,
      orderTaxModal: int.parse(taxModel.taxId.toString()),
      discountTypeModal: widget.returnsale.discountType,
      discountAmountModal: widget.returnsale.invoiceDiscount == null
          ? 0.0
          : double.parse(widget.returnsale.invoiceDiscount.toString()),
      userLocation: loggedInUser.locations,
      payment: widget.returnsale.paymentMethod!.map((e) => e.toJson()).toList(),
      saleNote: '',
      staffNote: '',
      cardString: '',
    );

    log('Sending transaction payload: ${payload.toJson()}');

    await PostSellReturn()
        .postSellReturn(context, payload)
        .then((result) async {
      result.fold((invoice) {
        log('Response from PostSellReturn: ${invoice.toJson()}');

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => PdfPreviewPage(
                      invoice: invoice,
                      openFrom: 'sell',
                    )))
            .whenComplete(() {
          CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
          cartBloc.add(CartClearProductEvent());
        }).whenComplete(() => Navigator.of(context).pop());
      }, (error) {
        ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
      });
    });
  }
}
