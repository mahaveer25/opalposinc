import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/SellreturnInvoice.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/printing.dart';
import 'package:opalposinc/services/bridge_payment.dart';
import 'package:opalposinc/services/post_sellreturn.dart';
import 'package:opalposinc/utils/commonFunction.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/platform_functions.dart';
import 'package:opalposinc/utils/toast_message.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import '../widgets/CustomWidgets/CustomIniputField.dart';

class SellReturn extends StatefulWidget {
  final double? totalAmount;
  final int? totalItems;
  final String? selectedPay;
  final InvoiceModel returnsale;
  const SellReturn(
      {super.key,
      required this.returnsale,
      this.totalAmount,
      this.totalItems,
      this.selectedPay});

  @override
  State<SellReturn> createState() => _SellReturnState();
}

class _SellReturnState extends State<SellReturn> with PrintPDF {
  List<PaymentListMethod> methodListWidget = [];
  List<TextEditingController> returnQuantityControllers = [];
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController cardAmountController = TextEditingController();
  TextEditingController cashAmountController = TextEditingController();
  TextEditingController discountType = TextEditingController();
  TextEditingController date = TextEditingController();
  String stringTax = '';
  String total = '0.0';
  String totalAmountString = '0.0';
  double discount = 0.0;
  double tax = 0.0;
  double subTotal = 0.0;
  String selectedReturningMethod = "card";

  double cashApiSend = 0.00;
  double cardApiSend = 0.00;

  bool isLoading = false;

  @override
  void initState() {
    stringTax = (widget.returnsale.taxPercentage.toString())
        .replaceAll(RegExp(r'[^\d.]'), '');
    discountType.text = (widget.returnsale.discountType) ?? '';
    discountController.text =
        double.parse(widget.returnsale.discountAmount ?? "0.0")
            .toStringAsFixed(2);
    cardAmountController.text = "0.00";
    cashAmountController.text = "0.00";
    cashTotal =
        double.parse(CommonFunctions.getCashTotalInReturn(widget.returnsale));
    cardTotal =
        double.parse(CommonFunctions.getCardTotalInReturn(widget.returnsale));

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
    cashAmountController.dispose();
    cardAmountController.dispose();
    super.dispose();
  }

  double cashTotal = 0.0;
  double cardTotal = 0.0;
  String paymentPriority = "Cash";

  void calculateCashCardReturnAmount() {
    setState(() {
      final sum = sumProduct(productList: widget.returnsale.product ?? []);
      discount = invoiceDiscount(productList: widget.returnsale.product ?? []);
      tax = taxInvoice(discount: discount == 0.0 ? sum : sum - discount);
      total = ((sum - discount) + tax).toString();
      totalAmountString = (((sum - discount) + roundToTwo(tax)).toString());
      log("sum:$sum");

      log("discount:$discount");
      log("discount round off${double.parse(discount.toString()).toStringAsFixed(2)}");

      log("tax:$tax");
      log("total after discount:$total");

      final totalAmount = double.parse(totalAmountString);
      log("total:$totalAmountString");

      final cashTotal =
          double.parse(CommonFunctions.getCashTotalInReturn(widget.returnsale));
      final cardTotal =
          double.parse(CommonFunctions.getCardTotalInReturn(widget.returnsale));

      if (paymentPriority == "Cash") {
        if (totalAmount <= cashTotal) {
          cashApiSend = totalAmount;
          cashAmountController.text = totalAmount.toStringAsFixed(2);
          cardApiSend = 0.00;
          cardAmountController.text = "0.00";
        } else {
          cashAmountController.text = cashTotal.toStringAsFixed(2);
          cashApiSend = cashTotal;
          cardAmountController.text =
              (totalAmount - cashTotal).toStringAsFixed(2);
          cardApiSend = (totalAmount - cashTotal);
        }
      } else if (paymentPriority == "Card") {
        if (totalAmount <= cardTotal) {
          cardAmountController.text = totalAmount.toStringAsFixed(2);
          cardApiSend = totalAmount;
          cashAmountController.text = "0.00";
          cashApiSend = 0.00;
        } else {
          cardAmountController.text = cardTotal.toStringAsFixed(2);
          cardApiSend = cardTotal;
          cashAmountController.text =
              (totalAmount - cardTotal).toStringAsFixed(2);
          cashApiSend = (totalAmount - cardTotal);
        }
      }

      log('subTotal:$subTotal');
    });
  }

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // const Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  height: 200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(177, 231, 230, 230),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sell Return",
                            style: TextStyle(
                              fontSize: 20,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Invoice No: ${widget.returnsale.invoiceNumber ?? ''}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Customer :${widget.returnsale.customer ?? ''}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date: ${widget.returnsale.date ?? ''}"),
                          Text(
                              "Business Location: ${widget.returnsale.address}"),
                        ],
                      ),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomInputField(
                                labelText: "Invoice Number",
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
                                widget.returnsale.product?.length ?? 0,
                                (index) {
                              Product product =
                                  widget.returnsale.product?[index] ??
                                      Product();
                              void calculateTotalReturnAmount() {
                                subtotalProduct(product: product, index: index);

                                calculateCashCardReturnAmount();
                              }

                              return DataRow(cells: [
                                DataCell(SizedBox(
                                    width: 20, child: Text('${index + 1}'))),
                                DataCell(
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      product.name ?? '',
                                    ),
                                  ),
                                ),
                                DataCell(Center(
                                  child: Text(
                                      unitPriceDiscount(product: product)
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
                                            ConstDialog(context)
                                                .showErrorDialog(
                                              error:
                                                  'Decimal points are not allowed',
                                              iconData: Icons.error,
                                              iconColor: Colors.red,
                                              iconText: 'Alert',
                                              ontap: () =>
                                                  Navigator.pop(context),
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
                                                    product.quantity
                                                        .toString()) -
                                                int.parse(product
                                                    .alreadyReturned
                                                    .toString());
                                            if (enteredQuantity >
                                                sellQuantity) {
                                              returnQuantityControllers[index]
                                                      .text =
                                                  sellQuantity.toString();
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
                              labelText: 'Discount Type',
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
                              labelText: 'Discount Amount',
                              controller: discountController,
                              enabled: false,
                              onChanged: (value) {
                                setState(() {});
                              },
                            )),
                          ],
                        ),
                        const Gap(6),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (cardTotal != 0.0 && cashTotal != 0.00)
                              Column(
                                children: [
                                  const Gap(6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                          text:
                                              "Make return priority based on:"),
                                      const Gap(10),
                                      Radio<String>(
                                        value: "Card",
                                        groupValue: paymentPriority,
                                        onChanged: (value) {
                                          setState(() {
                                            paymentPriority = value!;
                                            calculateCashCardReturnAmount();
                                          });
                                        },
                                      ),
                                      const Text("Card"),
                                      Radio<String>(
                                        value: "Cash",
                                        groupValue: paymentPriority,
                                        onChanged: (value) {
                                          setState(() {
                                            paymentPriority = value!;
                                            calculateCashCardReturnAmount();
                                          });
                                        },
                                      ),
                                      const Text("Cash"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Card Return',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Gap(10),
                                            CustomInputField(
                                              labelStyle: const TextStyle(
                                                  color: Constant.colorBlack),
                                              inputType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              hintText: "Card Amount",
                                              labelText: "Max: " +
                                                  CommonFunctions
                                                      .getCardTotalInReturn(
                                                          widget.returnsale),
                                              enabled: false,
                                              controller: cardAmountController,
                                              onChanged: (value) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Cash Return',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Gap(10),
                                            CustomInputField(
                                              labelStyle: const TextStyle(
                                                  color: Constant.colorBlack),
                                              inputType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              hintText: "Cash Amount",
                                              enabled: false,
                                              labelText: "Max: " +
                                                  CommonFunctions
                                                      .getCashTotalInReturn(
                                                          widget.returnsale),
                                              controller: cashAmountController,
                                              onChanged: (value) {},
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            const Gap(5),
                            if (CommonFunctions.getWithDrawnMode(
                                    cardTotal, cashTotal) !=
                                "")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Withdrawn mode: ",
                                    style: TextStyle(),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    CommonFunctions.getWithDrawnMode(
                                        cardTotal, cashTotal),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  )
                                ],
                              )
                            else
                              const Text(
                                "No item left for return",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Constant.colorRed),
                              ),
                            if (cardTotal != 0.0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Card return limit: "),
                                  Text(
                                    cardTotal.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            if (cashTotal != 0.0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Cash return limit: "),
                                  Text(
                                    cashTotal.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Total Return Discount: "),
                                Text(
                                  " (-) \$ ${discount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Total Return Tax - (${widget.returnsale.taxType} - ${double.parse(stringTax).toStringAsFixed(2)}%) : ",
                                  style: const TextStyle(),
                                  maxLines: 1,
                                ),
                                Text(
                                  " (+) \$ ${roundToTwo(tax)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Return Total: "),
                                Text(
                                  " \$ ${double.parse(totalAmountString).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
                                    builder: (context, loggedInUser) {
                                  return BlocBuilder<LocationBloc, Location?>(
                                      builder: (context, location) {
                                    return BlocBuilder<CustomerBloc,
                                            CustomerModel?>(
                                        builder: (context, customer) {
                                      return BlocBuilder<TaxBloc, TaxModel?>(
                                          builder: (context, tax) {
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  Constant.colorWhite,
                                              backgroundColor:
                                                  Constant.colorPurple,
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            onPressed: isLoading
                                                ? null
                                                : () async {
                                                    setLoading(true);

                                                    double totalReturnQuantity =
                                                        calculateTotalReturnQuantity();
                                                    if (totalReturnQuantity ==
                                                        0.0) {
                                                      ConstDialog(context)
                                                          .showErrorDialog(
                                                        error:
                                                            'Return Quantity Should be Greater then "0"',
                                                        iconData: Icons.error,
                                                        iconColor: Colors.red,
                                                        iconText: 'Alert',
                                                        ontap: () =>
                                                            Navigator.pop(
                                                                context),
                                                      );
                                                    } else {
                                                      await onSelltap(
                                                        loggedInUser:
                                                            loggedInUser ??
                                                                LoggedInUser(),
                                                        location: location ??
                                                            const Location(),
                                                        customerModel:
                                                            customer ??
                                                                CustomerModel(),
                                                        taxModel:
                                                            tax ?? TaxModel(),
                                                        productList: widget
                                                                .returnsale
                                                                .product ??
                                                            [],
                                                      );
                                                    }
                                                    setLoading(false);
                                                  },
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text('Save'));
                                      });
                                    });
                                  });
                                }),
                                const SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
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
                              ],
                            )
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

  double roundToTwo(double value) {
    return (value * 100).round() / 100;
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

  double invoiceDiscount({required List<Product> productList}) {
    final sum = sumProduct(productList: productList);
    final discount = double.parse(widget.returnsale.discountAmount.toString());
    final subTotal = double.parse(widget.returnsale.subTotal.toString());

    if (discount > 0.0) {
      if (widget.returnsale.discountType == "Percentage") {
        return double.parse((sum * (discount / 100)).toStringAsFixed(2));
      } else {
        return double.parse(((discount / subTotal) * sum).toStringAsFixed(2));
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
    log("sumbefortax${discount.toString()}");
    log(tax.toString());
    return double.parse(tax.toStringAsFixed(2));
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

  Future<void> onSelltap({
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
      discountType: widget.returnsale.discountType ?? 'fixed',
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
      payment: [
        PaymentListMethod(
          method: "Cash",
          amount: cashApiSend.toString(),
        ),
        PaymentListMethod(amount: cardApiSend.toString(), method: "Card")
      ],
      saleNote: '',
      staffNote: '',
      cardString: '',
    );
    final paxDeviceBloc = BlocProvider.of<PaxDeviceBloc>(context);

    log('Sending transaction payload: ${payload.toJson()}');
    // log('Sending returnsale payload: ${widget.returnsale.toJson()}');
    // log(' widget.returnsale.transactionPaxDeviceId: ${ widget.returnsale.transactionPaxDeviceId}');

    // await PostSellReturn().postSellReturn(context, payload).then((result) async {
    //   result.fold((invoice) async {
    //     log('Response from PostSellReturn: ${invoice.toJson()}');
    //     final path = await SellReturnInvoice.printInvoice(invoiceModel: invoice);
    //     log('PDF Path: $path'); // Added for debugging
    //
    //     await printPdf(path: path, context: context).whenComplete(() {
    //       CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    //       cartBloc.add(CartClearProductEvent());
    //     }).whenComplete(() => Navigator.of(context).pop());
    //   }, (error) {
    //     ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
    //   });
    // });

    if (cardTotal != 0.0 && cardAmountController.text != "0.00") {
      if (paxDeviceBloc.state != null) {
        final response = await BridgePayService.postBridgePay(
            isPrefNumAllowed: true,
            pnRefNum: widget.returnsale.transactionPaxDeviceId ?? "",
            context: context,
            invNum: "",
            amount: cardApiSend.toStringAsFixed(2),
            paxDevice: paxDeviceBloc.state ?? PaxDevice(),
            tenderType:
                CommonFunctions.getCardType(widget.returnsale) ?? "CREDIT",
            transType: "REFUND");
        log("BridgePay response refund: ${response.toString()}");
        if (response == null) {
          log("Response is null");
        } else {
          if (response["resultCode"] == "000000" ||
              response["resultCode"] == "0" ||
              response["resultTxt"] == "OK") {
            ToastUtility.showToast(
                message: "Card amount returned successfully");
            await PostSellReturn()
                .postSellReturn(context, payload)
                .then((result) async {
              result.fold((invoice) async {
                // log('Response from PostSellReturn: ${invoice.toJson()}');
                final path = await SellReturnInvoice.printInvoice(
                    invoiceModel: invoice,
                    cardTotal: cardAmountController.text,
                    cashTotal: cashAmountController.text);

                log('PDF Path: $path');
                if (cashApiSend != 0.00) {
                  MyPlatformFunctions.cashDrawerOpen();
                }
                await printPdf(path: path, context: context)
                    .whenComplete(() {})
                    .whenComplete(() {
                  if (cashApiSend != 0.00) {
                    ToastUtility.showToast(
                        message: "Cash amount returned successfully");
                  }
                  Navigator.pop(context);
                });
              }, (error) {
                ErrorFuncs(context)
                    .errRegisterClose(errorInfo: {'error': error});
              });
            });
          } else {
            if (response["resultCode"] == "2") {
              ConstDialogNew.showErrorDialogNew(
                contextNew: context,
                error:
                    "${paxDeviceBloc.state?.deviceName} is not Connected, Kindly select available device",
              );
            } else {
              ConstDialog(context).showErrorDialog(
                  error:
                      " ${response["resultTxt"]}: ${response["gatewayMessage"]}");
            }
          }
        }
      } else {
        ConstDialog(context).showErrorDialog(error: "No device is selected");
      }
    } else {
      await PostSellReturn()
          .postSellReturn(context, payload)
          .then((result) async {
        result.fold((invoice) async {
          // log('Response from PostSellReturn: ${invoice.toJson()}');
          final path = await SellReturnInvoice.printInvoice(
              invoiceModel: invoice,
              cardTotal: cardAmountController.text,
              cashTotal: cashAmountController.text);
          MyPlatformFunctions.cashDrawerOpen();
          await printPdf(path: path, context: context)
              .whenComplete(() {})
              .whenComplete(() {
            ToastUtility.showToast(
                message: "Cash amount returned successfully");
            Navigator.pop(context);
          });
        }, (error) {
          ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
        });
      });
    }
  }
}
