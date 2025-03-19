
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/Add%20Item/add_item_inventory.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/widgets/common_app_barV1.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/widgets/save_and_cancel_buttons.dart';
import 'package:opalsystem/CustomFuncs.dart';
import 'package:opalsystem/NewUi/Widgets/invoice_return_popup.dart';
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/invoices/SellreturnInvoice.dart';
import 'package:opalsystem/invoices/transaction.dart';
import 'package:opalsystem/model/CustomerModel.dart';
import 'package:opalsystem/model/TaxModel.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/multiplePay/PaymentListMethod.dart';
import 'package:opalsystem/printing.dart';
import 'package:opalsystem/services/bridge_payment.dart';
import 'package:opalsystem/services/post_sellreturn.dart';
import 'package:opalsystem/services/sell_return.dart';
import 'package:opalsystem/utils/assets.dart';
import 'package:opalsystem/utils/commonFunction.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/toast_message.dart';
import 'package:opalsystem/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_text_widgets.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

import '../../../model/product.dart';

class Refundv1 extends StatefulWidget {
   Refundv1({super.key});

  @override
  State<Refundv1> createState() => _Refundv1State();
}
TextEditingController invoiceController=TextEditingController();
TextEditingController popUpInvoiceController=TextEditingController();

class _Refundv1State extends State<Refundv1> with PrintPDF {

  List<PaymentListMethod> methodListWidget = [];
  List<TextEditingController> returnQuantityControllers = [];
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController cardAmountController = TextEditingController();
  TextEditingController cashAmountController = TextEditingController();
  TextEditingController discountType = TextEditingController();
  TextEditingController date = TextEditingController();
  String total = '0.0';
  double discount = 0.0;
  double tax = 0.0;
  double subTotal = 0.0;
  String selectedReturningMethod = "card";
  double cashApiSend = 0.00;
  double cardApiSend = 0.00;

  bool isLoadingGetDetails=false;
  bool isLoadingSave=false;


  void setLoadingGetDetails( bool value) {
    setState(() {
      isLoadingGetDetails = value;
    });
  }
  void setLoadingSave( bool value) {
    setState(() {
      isLoadingSave = value;
    });
  }
  InvoiceModel? returnsale;
  @override
  void initState() {
    super.initState();


    cardAmountController.text ="0.00";
    cashAmountController.text ="0.00";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInvoiceReturnDialog();
    });
  }




  void showInvoiceReturnDialog(){
    showDialog(
        context: context,
        builder: (context) {
          return InvoiceReturnPopup(returnInvoiceController: popUpInvoiceController,
            onPressed: () async {
            await getSellReturn(popUpInvoiceController,);
            Navigator.pop(context);
          },);
        });

  }

  Future<void> getSellReturn(TextEditingController controller) async {
    try {
      returnsale = await SellReturnService.getSellRetrunDetails(context, controller.text.trim());

      if (returnsale != null) {
        setState(() {});
        discountType.text = (returnsale?.discountType) ?? '';
        discountController.text = double.parse(returnsale?.discountAmount??"0.0").toStringAsFixed(2);
        date.text = returnsale?.date ?? "";
        returnsale?.product?.forEach((_) {
          returnQuantityControllers.add(TextEditingController());
        });
        cashTotal=double.parse(CommonFunctions.getCashTotalInReturn(returnsale??InvoiceModel()));
        cardTotal= double.parse(CommonFunctions.getCardTotalInReturn(returnsale??InvoiceModel()));
        controller.clear();
        log("This is sell return ${returnsale?.toJson()}");
      }
    } catch (e) {
      log('Error fetching sell return details: $e');
    } finally {
    }
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

  double invoiceDiscount({required List<Product> productList}) {
    final sum = sumProduct(productList: productList);
    final discount = double.parse(returnsale?.discountAmount.toString()??"0.0");
    final subTotal = double.parse(returnsale?.subTotal.toString()??"0.0");

    if (discount > 0.0) {
      if (returnsale?.discountType == "Percentage") {
        return (sum * (discount / 100));
      } else {
        return (discount / subTotal) * sum;
      }
    } else {
      return 0.0;
    }
  }

  double taxInvoice({required double discount}) {
    String stringTax = (returnsale?.taxPercentage.toString())?.replaceAll(RegExp(r'[^\d.]'), '')??"";
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



  void calculateCashCardReturnAmount() {

    setState(() {
      final sum = sumProduct(productList: returnsale?.product??[]);
      discount = invoiceDiscount(productList:returnsale?.product??[]);
      tax = taxInvoice(
          discount: discount == 0.0
              ? sum
              : sum - discount);
      total = ((sum - discount) + tax).toString();

      final totalAmount = double.parse(total);
      final cashTotal = double.parse(CommonFunctions.getCashTotalInReturn(returnsale??InvoiceModel()));
      final cardTotal = double.parse(CommonFunctions.getCardTotalInReturn(returnsale??InvoiceModel()));

      if (paymentPriority == "Cash") {
        if (totalAmount <= cashTotal) {
          cashApiSend=totalAmount;
          cashAmountController.text = totalAmount.toStringAsFixed(2);
          cardApiSend=0.00;
          cardAmountController.text = "0.00";
        } else {
          cashAmountController.text = cashTotal.toStringAsFixed(2);
          cashApiSend=cashTotal;
          cardAmountController.text = (totalAmount - cashTotal).toStringAsFixed(2);
          cardApiSend=(totalAmount-cashTotal);
        }
      } else if (paymentPriority == "Card") {
        if (totalAmount <= cardTotal) {
          cardAmountController.text = totalAmount.toStringAsFixed(2);
          cardApiSend=totalAmount;
          cashAmountController.text = "0.00";
          cashApiSend=0.00;
        } else {
          cardAmountController.text = cardTotal.toStringAsFixed(2);
          cardApiSend=cardTotal;
          cashAmountController.text = (totalAmount - cardTotal).toStringAsFixed(2);
          cashApiSend=(totalAmount-cardTotal);
        }
      }



      log('subTotal:$subTotal');

    });

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
  double cashTotal=0.0 ;
  double cardTotal =0.0;
  String paymentPriority = "Cash";


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:PreferredSize( preferredSize: const Size.fromHeight(60.0),
          child: CommonAppBarV1(
            actionList: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 6),
                  width:300,child: CustomInputField(
                controller: invoiceController,

                  labelText: "Enter Invoice no", hintText: "Enter Invoice no")),
             const Gap(10),
              CustomElevatedButton(

                fontSize: 14,
                isLoadingCheck: isLoadingGetDetails,
                padding: EdgeInsets.symmetric(horizontal: 5),
                text: "Get Details", onPressed: () async {
                setLoadingGetDetails(true);
                await getSellReturn(invoiceController);
                setLoadingGetDetails(false);


              },),

              Gap(40)

            ],
            imagePath:    Myassets.refund, title: "Refund",)),
      body: returnsale==null?

      Center(child: Lottie.asset(Myassets.emptyLottie,height: 450)):
      Row(
        children: [
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // const Padding(padding: EdgeInsets.only(top: 15)),
                    Container(
                      height: context.height*0.31,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(177, 231, 230, 230),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.start,
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
                            ],
                          ),
                          const SizedBox(height: 10),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [


                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [



                                  if(CommonFunctions.getWithDrawnMode(cardTotal, cashTotal)!="")
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Withdrawn mode: ",
                                          style: const TextStyle(),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          CommonFunctions.getWithDrawnMode(cardTotal, cashTotal),
                                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                        )
                                      ],
                                    )
                                  else
                                    const Text(
                                      "No item left for return",
                                      style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Constant.colorRed),

                                    ),

                                  if(cardTotal!=0.0)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                            "Card return limit: "),
                                        Text(
                                          cardTotal.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                        )
                                      ],
                                    ),
                                  if(cashTotal!=0.0)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                            "Cash return limit: "),
                                        Text(
                                          cashTotal.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                        )
                                      ],
                                    ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          "Total Return Discount: "),
                                      Text(
                                        " (-) \$ ${discount.toStringAsFixed(2)}",
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                      )
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Total Return Tax - (No Tax - 0.00%) : ",
                                        style: const TextStyle(),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        " (+) \$ ${tax.toStringAsFixed(2)}",
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                      )
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          "Return Total: "),
                                      Text(
                                        " \$ ${double.parse(total).toStringAsFixed(2)}",
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Invoice No: ${returnsale?.invoiceNumber ?? ''}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Customer :${returnsale?.customer ?? ''}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text("Date: ${returnsale?.date ?? ''}"),
                                  Text(
                                      "Business Location: ${returnsale?.address}"),
                                ],
                              ),

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
                                columnSpacing: 30,
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
                                    label: Text('Return Subtotal', style: TextStyle(fontWeight: FontWeight.bold,),),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                    returnsale?.product?.length??0, (index) {
                                  Product product = returnsale?.product?[index]??Product();
                                  void calculateTotalReturnAmount() {
                                    subtotalProduct(product: product, index: index);
                                    calculateCashCardReturnAmount();
                                  }


                                  return DataRow(cells: [
                                    DataCell(SizedBox(width: 2, child: Text('${index + 1}'))),
                                    DataCell(SizedBox(width: 300, child: Text(product.name ?? '',),),),
                                    DataCell(Center(child: Text(unitPriceDiscount(product: product).toStringAsFixed(2)),)),
                                    DataCell(Center(child: Text('${product.quantity}'))),
                                    DataCell(Center(child: Text('${product.alreadyReturned}'))),
                                    DataCell(
                                      Center(child: CustomInputField(
                                        inputType: const TextInputType.numberWithOptions(decimal: false),
                                        labelText: "Quantity", hintText: "0", controller: returnQuantityControllers[index], onChanged: (value) {
                                        setState(() {
                                          calculateTotalReturnAmount();
                                          if (value.contains('.')) {
                                            ConstDialog(context).showErrorDialog(error: 'Decimal points are not allowed', iconData: Icons.error, iconColor: Colors.red, iconText: 'Alert', ontap: () => Navigator.pop(context),);
                                            final newValue = value.substring(0, value.length - 1);
                                            returnQuantityControllers[index].text = newValue;
                                            returnQuantityControllers[index].selection =TextSelection.fromPosition(TextPosition(offset: newValue.length),
                                            );
                                          } else if (value.isNotEmpty) {
                                            int enteredQuantity = int.parse(value);
                                            int? sellQuantity = int.parse(product.quantity.toString()) -
                                                int.parse(product.alreadyReturned.toString());
                                            if (enteredQuantity > sellQuantity) {
                                              returnQuantityControllers[index].text = sellQuantity.toString();
                                              ConstDialog(context).showErrorDialog(
                                                error: 'Return quantity cannot exceed available quantity',
                                                iconData: Icons.error, iconColor: Colors.red, iconText: 'Alert',);
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
                            Gap(6),
                            if(cardTotal!=0.0 && cashTotal!=0.00)
                              Column(
                                children: [
                                  Gap(6),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomText(text: "Make return priority based on:"),
                                      Gap(10),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,


                                          children: [
                                            Text(
                                              'Card Return',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Gap(10),
                                            CustomInputField(
                                              labelStyle: TextStyle(color:  Constant.colorBlack),

                                              inputType: TextInputType.numberWithOptions(decimal: true),

                                              hintText: "Card Amount",
                                              labelText: "Max: "+CommonFunctions.getCardTotalInReturn(returnsale??InvoiceModel()),
                                              enabled: false,
                                              controller: cardAmountController,
                                              onChanged: (value) {
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Gap(6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Text(
                                              'Cash Return',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Gap(10),

                                            CustomInputField(
                                              labelStyle: TextStyle(color:  Constant.colorBlack),

                                              inputType: TextInputType.numberWithOptions(decimal: true),
                                              hintText: "Cash Amount",
                                              enabled: false,
                                              labelText: "Max: "+CommonFunctions.getCashTotalInReturn(returnsale??InvoiceModel()),
                                              controller: cashAmountController,
                                              onChanged: (value) {

                                              },
                                            ),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                ],
                              ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            endIndent:15,
            indent: 15,
            color: Colors.black,
            thickness: 0.5,
          ),

          BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
              builder: (context, loggedInUser) {
                return BlocBuilder<LocationBloc, Location?>(builder: (context, location) {
                  return BlocBuilder<CustomerBloc, CustomerModel?>(
                      builder: (context, customer) {
                        return BlocBuilder<TaxBloc, TaxModel?>(builder: (context, tax) {
                          return BlueAndWhiteButtons(
                            onPressedWhite: () {
                              Navigator.pop(context);


                            },
                            whiteButtonTitle: "Close",
                            blueButtonTitle: 'Save',
                            isLoadingCheckBlue: isLoadingSave,


                            onPressedBlue: () async {
                              setLoadingSave(true);

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
                                await  onSelltap(
                                  loggedInUser: loggedInUser??LoggedInUser(),
                                  location: location??Location(),
                                  customerModel: customer??CustomerModel(),
                                  taxModel: tax??TaxModel(),
                                  productList: returnsale?.product ?? [],
                                );
                              }
                              setLoadingSave(false);

                            },);

                        });
                      });
                });
              }) ,

        ],
      )

    );
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
      invoiceNo: returnsale?.invoiceNumber,
      invoiceNoReturned: invoiceNo.text,
      transactionId: returnsale?.transactionId,
      userId: loggedInUser.id,
      businessId: loggedInUser.businessId,
      locationId: location.id,
      contactId: customerModel.id,
      transactionDate: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      product: productList,
      discountType: returnsale?.discountType ?? 'fixed',
      discountAmount: discount,
      totalAmountBeforeTax: subTotal,
      taxRateId: taxModel.taxId,
      taxCalculationPercentage: taxModel.amount == null
          ? 0.0
          : double.parse(taxModel.amount.toString()),
      taxCalculationAmount: tax,
      orderTaxModal: int.parse(taxModel.taxId.toString()),
      discountTypeModal: returnsale?.discountType,
      discountAmountModal: returnsale?.invoiceDiscount == null
          ? 0.0
          : double.parse(returnsale?.invoiceDiscount.toString()??"0.0"),
      userLocation: loggedInUser.locations,
      payment: [
        PaymentListMethod(method: "Cash", amount: cashApiSend.toString(),),
        PaymentListMethod(
            amount: cardApiSend.toString(),
            method: "Card"
        )

      ],
      saleNote: '',
      staffNote: '',
      cardString: '',
    );
    final paxDeviceBloc = BlocProvider.of<PaxDeviceBloc>(context);

    log('Sending transaction payload: ${payload.toJson()}');
    log('Sending returnsale payload: ${returnsale?.toJson()}');
    log(' returnsale.transactionPaxDeviceId: ${ returnsale?.transactionPaxDeviceId}');



    if(cardTotal!=0.0 && cardAmountController.text!="0.00"){
      if (paxDeviceBloc.state != null) {
        final response = await BridgePayService.postBridgePay(
            isPrefNumAllowed: true,
            pnRefNum: returnsale?.transactionPaxDeviceId??"",
            context: context,
            invNum: "",
            amount:cardApiSend.toString(),
            paxDevice: paxDeviceBloc.state ?? PaxDevice(),
            tenderType: CommonFunctions.getCardType(returnsale??InvoiceModel())??"CREDIT",
            transType: "REFUND"
        );
        log("BridgePay response refund: ${response.toString()}");
        if (response == null) {
          log("Response is null");
        } else {
          if (response["resultCode"] == "000000" || response["resultCode"] == "0" || response["resultTxt"] == "OK") {
            // if(cashTotal!=0.0){
            ToastUtility.showToast(message: "Card amount returned successfully");
            await PostSellReturn().postSellReturn(context, payload).then((result) async {
              result.fold((invoice) async {
                log('Response from PostSellReturn: ${invoice.toJson()}');
                final path = await SellReturnInvoice.printInvoice(invoiceModel: invoice,cardTotal: cardAmountController.text,cashTotal: cashAmountController.text);
                log('PDF Path: $path'); // Added for debugging

                await printPdf(path: path, context: context).whenComplete(() {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(CartClearProductEvent());
                }).whenComplete((){
                  if(cashTotal!=0.00){
                    ToastUtility.showToast(message: "Cash amount returned successfully");

                  }

                  Navigator.pop(context);
                });
              }, (error) {
                ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
              });
            });


          } else {
            if (response["resultCode"] == "2") {
              ConstDialogNew.showErrorDialogNew(contextNew: context, error: "${paxDeviceBloc.state?.deviceName} is not Connected, Kindly select available device",
              );
            } else {
              ConstDialog(context).showErrorDialog(error: response["resultTxt"]);
            }
          }
        }

      }

      else {
        ConstDialog(context).showErrorDialog(error: "No device is selected");
      }
    }else{
      await PostSellReturn().postSellReturn(context, payload).then((result) async {
        result.fold((invoice) async {
          log('Response from PostSellReturn: ${invoice.toJson()}');
          final path = await SellReturnInvoice.printInvoice(invoiceModel: invoice,cardTotal: cardAmountController.text,cashTotal: cashAmountController.text);


          await printPdf(path: path, context: context).whenComplete(() {
            CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
            cartBloc.add(CartClearProductEvent());
          }).whenComplete((){
            ToastUtility.showToast(message: "Cash amount returned successfully");

            Navigator.pop(context);
          });
        }, (error) {
          ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
        });
      });

    }

  }
}
