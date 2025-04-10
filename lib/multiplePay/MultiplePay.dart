// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:math' as imath;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/GenrateRegisterDetails.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/GenerateChargeInvoice.dart';
import 'package:opalposinc/invoices/GenerateInvoice.dart';
import 'package:opalposinc/invoices/GenerateQuotation.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/invoices/SellreturnInvoice.dart';
import 'package:opalposinc/invoices/chargeInvoiceModel.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Transaction/localTransaction.dart';
import 'package:opalposinc/main.dart';
import 'package:opalposinc/model/CustomerModel.dart';

import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/payment_model.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/model/register_details_model.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/multiplePay/money_denominationService.dart';
import 'package:opalposinc/multiplePay/successTransaction.dart';
import 'package:opalposinc/printing.dart';
import 'package:opalposinc/services/bridge_payment.dart';
import 'package:opalposinc/services/charge.dart';
import 'package:opalposinc/services/customer_balance.dart';
import 'package:opalposinc/services/placeorder.dart';
import 'package:opalposinc/utils/Reg_Function/Reg_Functions.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/platform_functions.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/customerBalance.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import '../model/pricinggroup.dart';
import '../widgets/CustomWidgets/CustomIniputField.dart';

class MultiplePayUi extends StatefulWidget {
  final double? totalAmount, amountWithOutTax;
  final int? totalItems;
  final double totalAmountBeforeDisc;
  final String? selectedPay;

  const MultiplePayUi({super.key, this.totalAmount, this.totalItems, this.amountWithOutTax, this.selectedPay, required this.totalAmountBeforeDisc});

  @override
  State<StatefulWidget> createState() => _MultiplePayuI();
}

class _MultiplePayuI extends State<MultiplePayUi> with PrintPDF {
  double remainingBalance = 0.0;
  List<PaymentListMethod> methodListWidget = [];

  final sellController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final staffController = TextEditingController();
  bool _isLoading = false;
  bool isCardMethod = false;

  double afterPayPrice = 0.0;
  // final bool _isLoadingNoPrint = false;

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void setLoadingPrint(bool isLoadingNoPrint) {
    setState(() {
      isLoadingNoPrint = isLoadingNoPrint;
    });
  }

  void _refreshPaymentDetails() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    remainingBalance = widget.totalAmount ?? 0.0;
    setState(() {
      if (widget.selectedPay == 'Card') {
        methodListWidget.add(PaymentListMethod(amount: widget.totalAmount.toString(), method: 'card', methodType: PaymentMethod(type: 'card', name: 'Card')));
      } else {
        methodListWidget.add(PaymentListMethod(amount: widget.totalAmount.toString(), method: 'cash', methodType: PaymentMethod(type: 'cash', name: 'Cash')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle heading = const TextStyle(fontWeight: FontWeight.w700, fontSize: 22);
    TextStyle smallHeading = const TextStyle(fontWeight: FontWeight.w400, fontSize: 18);

    return BlocBuilder<CustomerBloc, CustomerModel?>(
      builder: (context, customer) {
        return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Payment',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Colors.white,
            body: GestureDetector(
              onPanUpdate: (_) => _refreshPaymentDetails(), // Refresh on touch
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: isMobile ? 20 : 0,
                      ),
                      BlocBuilder<IsMobile, bool>(
                        builder: (context, isMobile) {
                          if (isMobile) {
                            return Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        if (!isMobile)
                                          Text(
                                            'Payment',
                                            style: heading,
                                          ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Advance Balance : \$',
                                              style: smallHeading,
                                            ),
                                            customer!.id == '1' ? const Text("0.00") : const CustomerBalance(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        paymentListWidget(isMobile: isMobile),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        addMethodButton(),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 400, child: paymentDetails(isMobile: isMobile)),
                                ],
                              ),
                            );
                          }

                          return Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Advance Balance : \$ ',
                                                style: smallHeading,
                                              ),
                                              customer!.id == '1'
                                                  ? Text(
                                                      "0.00",
                                                      style: smallHeading,
                                                    )
                                                  : const CustomerBalance(),
                                            ],
                                          ),
                                          addMethodButton(),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      paymentListWidget(isMobile: isMobile),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      addMethodButton(),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      sellStaffNotes(isMobile: isMobile),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 370, height: 550, child: Center(child: paymentDetails(isMobile: isMobile))),
                              ],
                            ),
                          );
                        },
                      ),
                      finalyzePayment()
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  double total() {
    double total = methodListWidget.fold(0.0, (previousValue, element) {
      if (element.amount == null || element.amount!.isEmpty) {
        return previousValue; // Skip invalid or null amounts
      } else {
        try {
          return ((previousValue + double.parse(element.amount!)));
        } catch (e) {
          // Handle the parse error
          log('Failed to parse amount: ${element.amount}');
          return previousValue - afterPayPrice; // Skip this element if parsing fails
        }
      }
    });

    return total;
  }

  Widget paymentDetails({required bool isMobile}) {
    const textStyle = TextStyle(fontSize: 20, color: Colors.white);
    const textStyleMobile = TextStyle(fontSize: 14, color: Colors.black);
    final densed = isMobile ? true : false;

    // final double afterPayChangeReturn = widget.totalAmount!.toDouble() - afterPayPrice;
    // final returnChanges = afterPayChangeReturn < total() ? total() - afterPayChangeReturn : 0.0;
    // // final balance = remainingBalance - total();
    final balance = afterPayPrice == 0 ? imath.max(0.0, remainingBalance - total()) : 0.0;

    final double balanceDue = widget.totalAmount! - (afterPayPrice != 0 ? afterPayPrice : total());
    final double changeReturn = balanceDue < 0 ? balanceDue.abs() : 0.0;

    List<Widget> commonListItems = [
      Expanded(
        child: ListTile(
          dense: densed,
          title: Text('Total Items', style: isMobile ? textStyleMobile : textStyle),
          trailing: Text(widget.totalItems.toString(), style: isMobile ? textStyleMobile : textStyle),
        ),
      ),
      if (!isMobile) const Divider(color: Colors.white),
      Expanded(
        child: ListTile(
          dense: densed,
          title: Text('Total Payable', style: isMobile ? textStyleMobile : textStyle),
          trailing: Text('\$${widget.totalAmount!.toStringAsFixed(2)}', style: isMobile ? textStyleMobile : textStyle),
        ),
      ),
      if (!isMobile) const Divider(color: Colors.white),
      Expanded(
        child: ListTile(
          dense: densed,
          title: Text('Total Paying', style: isMobile ? textStyleMobile : textStyle),
          trailing: Text('\$${total().toStringAsFixed(2)}', style: isMobile ? textStyleMobile : textStyle),
        ),
      ),
      if (!isMobile) const Divider(color: Colors.white),
      Visibility(
        visible: afterPayPrice != 0,
        child: Expanded(
          child: ListTile(
            dense: densed,
            title: Text('Paid Amount', style: isMobile ? textStyleMobile : textStyle),
            trailing: Text('\$${afterPayPrice.toStringAsFixed(2)}', style: isMobile ? textStyleMobile : textStyle),
          ),
        ),
      ),
      if (!isMobile) Visibility(visible: afterPayPrice != 0, child: const Divider(color: Colors.white)),
      Expanded(
        child: ListTile(
          dense: densed,
          title: Text('Change Return', style: isMobile ? textStyleMobile : textStyle),
          trailing: Text('\$${changeReturn.toStringAsFixed(2)}', style: isMobile ? textStyleMobile : textStyle),
        ),
      ),
      if (!isMobile) const Divider(color: Colors.white),
      Expanded(
        child: ListTile(
          dense: densed,
          title: Text('Balance', style: isMobile ? textStyleMobile : textStyle),
          trailing: Text('\$${balance.toStringAsFixed(2)}', style: isMobile ? textStyleMobile : textStyle),
        ),
      ),
    ];

    return Padding(
      padding: isMobile ? const EdgeInsets.all(10.0) : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Constant.colorPurple,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: commonListItems,
          ),
        ),
      ),
    );
  }

  Widget paymentListWidget({required bool isMobile}) {
    var balance = widget.totalAmount!.toDouble() > total() ? widget.totalAmount!.toDouble() - total() : 0.0;
    Future.delayed(const Duration(milliseconds: 500), () => _refreshPaymentDetails());

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: methodListWidget.length,
      itemBuilder: (context, index) {
        final method = methodListWidget[index]; // Define the method here
        return MethodTypeWidget(
          key: ValueKey(method),
          methodType: widget.selectedPay,
          paymentMethod: method,
          totalAmount: balance,
          onTap: () {
            setState(() {
              methodListWidget.removeAt(index);
              isCardMethod = true;
              methodListWidget[index].amount = "";
              log("on cancel click: ${widget.totalAmount}");

              // (method.methodType?.toString().toLowerCase().trim() ==
              //         "card" ||
              //     method.method?.toString().toLowerCase().trim() == "card");
            });
          },
          methodList: methodListWidget,
          afterPayPrice: afterPayPrice,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget sellStaffNotes({required bool isMobile}) {
    return Row(
      children: [
        Expanded(
          child: CustomInputField(
            labelText: 'Sell Note',
            hintText: 'Sell Note',
            controller: sellController,
            maxLines: 3,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: CustomInputField(
            labelText: 'Staff Note',
            hintText: 'Staff Note',
            controller: staffController,
            maxLines: 3,
          ),
        )
      ],
    );
  }

  Widget finalyzePayment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Spacer(),
        ElevatedButton(
            onPressed: onCloseDialog,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Constant.colorPurple,
              elevation: 5,
              fixedSize: const Size(150, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'CLOSE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          width: 7.0,
        ),
        finalyzePaymentButton(),
      ]),
    );
  }

  onCloseDialog() {
    Navigator.of(context).pop();
  }

  Widget finalyzePaymentButton() {
    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
      builder: (context, loggedInUser) {
        return BlocBuilder<LocationBloc, Location?>(
          builder: (context, location) {
            return BlocBuilder<CustomerBloc, CustomerModel?>(
              builder: (context, customer) {
                return BlocBuilder<PricingBloc, PricingGroup?>(
                  builder: (context, pricing) {
                    return BlocBuilder<TotalDiscountBloc, TotalDiscountModel?>(
                      builder: (context, discount) {
                        return BlocBuilder<SettingsBloc, SettingsModel?>(
                          builder: (context, settingsModel) {
                            return BlocBuilder<CartBloc, CartState?>(
                              builder: (context, cart) {
                                if (cart is CartLoadedState) {
                                  return BlocBuilder<TaxBloc, TaxModel?>(
                                    builder: (context, tax) {
                                      return BlocBuilder<CheckConnection, bool>(
                                        builder: (context, isConnected) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: const Color(0xff59BA47),
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                fixedSize: const Size(300, 60)),
                                            onPressed: _isLoading
                                                ? null
                                                : () async {
                                                    setLoading(true); // Start loading
                                                    // TotalDiscountBloc bloc = BlocProvider.of<TotalDiscountBloc>(context);
                                                    // bloc.add(null);
                                                    // await displayManager.transferDataToPresentation({'type': 'discount', 'discount': TotalDiscountModel().toJson()});
                                                    FunctionProduct.disappearBackSuccessTransitionScreen();
                                                    await onFinalizeInvoice(
                                                      loggedInUser: loggedInUser!,
                                                      location: location!,
                                                      customerModel: customer!,
                                                      pricing: pricing!,
                                                      totalDiscountModel: discount ?? TotalDiscountModel(),
                                                      taxModel: tax!,
                                                      productList: cart.listProduct,
                                                      settingsModel: settingsModel!,
                                                      isConnected: isConnected,
                                                    );
                                                    setLoading(false);
                                                    // End loading
                                                  },
                                            child: _isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text(
                                                    'PAY NOW',
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                  ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                                return Container();
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  onFinalizeInvoice(
      {required LoggedInUser loggedInUser,
      required Location location,
      required CustomerModel customerModel,
      required PricingGroup pricing,
      required TotalDiscountModel totalDiscountModel,
      required TaxModel taxModel,
      required SettingsModel settingsModel,
      required List<Product> productList,
      required bool isConnected}) async {
    String pnRefNum = "0";
    Transaction payload = Transaction(
      userId: loggedInUser.id,
      businessId: loggedInUser.businessId,
      locationId: location.id,
      contactId: customerModel.id,
      transactionDate: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      priceGroup: int.parse(pricing.id.toString()),
      product: productList,
      discountType: totalDiscountModel.type,
      discountAmount: totalDiscountModel.amount == null ? 0.0 : double.parse(totalDiscountModel.amount.toString()),
      totalAmountBeforeTax: widget.totalAmountBeforeDisc,
      taxRateId: taxModel.taxId,
      taxCalculationPercentage: taxModel.amount == null ? 0.0 : double.parse(taxModel.amount.toString()),
      taxCalculationAmount: widget.totalAmount!.toDouble() - widget.amountWithOutTax!.toDouble(),
      orderTaxModal: int.parse(taxModel.taxId.toString()),
      discountTypeModal: totalDiscountModel.type,
      discountAmountModal: totalDiscountModel.amount == null ? 0.0 : double.parse(totalDiscountModel.amount.toString()),
      enableRp: settingsModel.enableRp,
      amountForUnitRp: settingsModel.amountForUnitRp,
      redeemAmountPerUnitRp: settingsModel.redeemAmountPerUnitRp.toString(),
      saleNote: sellController.text,
      staffNote: staffController.text,
      userLocation: loggedInUser.locations,
      payment: methodListWidget.map((e) => e.toJson()).toList(),
      changeReturn: (widget.totalAmount!.toDouble() < total() ? total() - widget.totalAmount!.toDouble() : 0.0).toString(),
      rpRedeemed: totalDiscountModel.points.toString(),
      rpRedeemedDiscountTypes: "Fixed",
      customerId: customerModel.id == '1' ? '0' : customerModel.id,
      customerEmail: emailAddressController.text,
      customerFirstName: firstNameController.text,
      customerPhone: phoneController.text,
    );

    log("totalamount : ${widget.totalAmount!.toDouble()}");
    log('This is payload while sending place order: ${payload.toJson()}');
    if (!isConnected) {
      if (FunctionProduct.checkAllPaymentMethodsSelected(methodListWidget)) {
        var cardMethodContain = methodListWidget.any((method) => method.method.toString().toLowerCase() == "card");
        if (cardMethodContain) {
          ConstDialog(context).showErrorDialog(error: "No internet connection.\nKindly connect internet to process further.");
        } else {
          final uuid = const Uuid().v1().substring(1, 6);
          final uniqueKey = '$uuid-${loggedInUser.id}';
          payload.transactionPaxDeviceId = "0";

          Transaction transaction = payload..offlineInvoiceNo = uniqueKey;

          final invoice = await LocalTransaction().addToLocal(transaction: transaction, context: context);
          CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
          TotalDiscountBloc bloc = BlocProvider.of<TotalDiscountBloc>(context);

          if (invoice.offlineInvoiceNo != null) {
            cartBloc.add(CartClearProductEvent());
            bloc.add(null);
            await displayManager.transferDataToPresentation({'type': 'discount', 'discount': TotalDiscountModel().toJson()});
            await displayManager.transferDataToPresentation({'type': 'delete'});
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuccessTransaction(invoice: invoice)));
            var isCashMethod = methodListWidget.any((method) => method.method.toString().toLowerCase() == "cash");

            if (isCashMethod) {
              log("Card method found in methodListWidget.");
              MyPlatformFunctions.cashDrawerOpen();
            } else {
              log("No card method found in methodListWidget.");
            }
          }
        }
      } else {
        ConstDialog(context).showErrorDialog(error: "Please select payment method");
      }
    } else {
      if (FunctionProduct.checkAllPaymentMethodsSelected(methodListWidget)) {
        try {
          // Create a DEEP COPY of card methods to process
          final cardMethodsToProcess = methodListWidget.where((element) => element.method == "card").map((e) => PaymentListMethod.fromJson(e.toJson())).toList();

          int successfulTransactions = 0;
          double totalPaid = 0.0;
          bool hasErrors = false;
          List<PaymentListMethod> successfullyProcessed = [];
          double tempPaidAmount = 0.0;

          // Process each transaction in the independent copy
          for (var method in cardMethodsToProcess) {
            try {
              // Validate amount exists and is valid
              if (method.amount == null || method.amount!.isEmpty) {
                log("Empty amount for card transaction - skipping");
                hasErrors = true;
                continue;
              }

              double amount;
              try {
                amount = double.parse(method.amount!);
                if (amount <= 0) {
                  throw FormatException("Amount must be positive");
                }
              } catch (e) {
                log("Invalid amount format: ${method.amount}");
                hasErrors = true;
                continue;
              }

              log("Processing transaction with amount: ${amount.toStringAsFixed(2)}");

              // Process the transaction with timeout
              String res = await perFormCardTransaction(
                cardAmount: amount,
                loggedInUser: loggedInUser,
                payload: payload,
                customerModel: customerModel,
                pnRefNum: pnRefNum,
                settingsModel: settingsModel,
              ).timeout(const Duration(seconds: 30));

              if (res == "000000" || res == "0" || res == "OK") {
                remainingBalance = 0.0;
                successfulTransactions++;
                // totalPaid += amount;
                tempPaidAmount += double.parse(method.amount!);
                successfullyProcessed.add(method); // Track successful transactions
                if (mounted) {
                  setState(() {
                    // afterPayPrice = totalPaid; // Update paid amount in UI
                    afterPayPrice = tempPaidAmount;
                    remainingBalance = widget.totalAmount! - totalPaid;
                    if (remainingBalance <= 0.0) {
                      remainingBalance = 0.0;
                    }
                  });
                }
                log("Transaction successful: $amount");
              } else {
                remainingBalance = 0.0;
                setState(() {

                });
                log("Transaction failed with response: $res");
                hasErrors = true;
                // Don't process further transactions if one fails
                break;
              }
            } catch (e) {
              remainingBalance = 0.0;
              setState(() {

              });
              log("Transaction processing error: $e");
              hasErrors = true;
              if (e is TimeoutException && mounted) {
                await ConstDialog(context).showErrorDialog(error: "Transaction timed out");
              }
              // Don't process further transactions if one fails
              break;
            }
          }

          // Update UI only after all transactions are processed
          if (mounted) {
            setState(() {
              // Remove only successfully processed transactions
              for (var method in successfullyProcessed) {
                methodListWidget.removeWhere((m) => m.method == method.method && m.amount == method.amount && m.cardType == method.cardType);
              }
              afterPayPrice = tempPaidAmount;
              remainingBalance = widget.totalAmount! - tempPaidAmount;
              if (remainingBalance <= 0.0) {
                remainingBalance = 0.0;
              }
            });
          }

          // Handle completion only if all transactions succeeded
          if (!hasErrors && successfullyProcessed.length == cardMethodsToProcess.length) {
            CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
            payload.transactionPaxDeviceId = "0";

            if (mounted) {
              {
                // setState(() {
                //   // afterPayPrice = tempPaidAmount;
                //   // Remove successful transactions
                //   methodListWidget.removeWhere((m) => successfullyProcessed.contains(m));
                //   remainingBalance = widget.totalAmount! - tempPaidAmount;
                //   if (remainingBalance <= 0.0) {
                //     remainingBalance = 0.0;
                //   }
                // });

                CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                // cartBloc.add(CartClearProductEvent());
                payload.transactionPaxDeviceId = "0";

                TotalDiscountBloc bloc = BlocProvider.of<TotalDiscountBloc>(context);
                // bloc.add(null);
                await PlaceOrder().placeOrder(context, payload).then((result) async {
                  cartBloc.add(CartClearProductEvent());
                  bloc.add(null);

                  result.fold((invoice) async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuccessTransaction(invoice: invoice)));

                    await displayManager.transferDataToPresentation({'type': 'discount', 'discount': TotalDiscountModel().toJson()});
                    await displayManager.transferDataToPresentation({
                      'type': 'successTransaction',
                      'successTransaction': invoice.toJson(),
                    });

                    await displayManager.transferDataToPresentation({
                      'type': 'customerData',
                      'customerData': customerModel.toJson(),
                    });

                    await displayManager.transferDataToPresentation({
                      'type': 'settingsData',
                      'settingsData': settingsModel.toJson(),
                    });

                    log("method list $methodListWidget");

                    var isCashMethod = methodListWidget.any((method) => method.method.toString().toLowerCase() == "cash");

                    if (isCashMethod) {
                      log("Card method found in methodListWidget.");
                      MyPlatformFunctions.cashDrawerOpen();
                    } else {
                      log("No card method found in methodListWidget.");
                    }

                    if (mounted) {
                      final customer = await CustomerBalanceService.getCustomerBalance(context, int.parse(customerModel.id.toString()));
                      // log('PDF Path: $path'); // Added for debugging
                      await displayManager.transferDataToPresentation({'type': 'discount', 'discount': TotalDiscountModel().toJson()});
                      CustomerBalanceBloc balanceBloc = BlocProvider.of<CustomerBalanceBloc>(context);
                      balanceBloc.add(customer);
                    }
                  }, (error) {
                    ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
                  });
                });
              }
            }
          } else if (hasErrors && mounted) {
            remainingBalance = 0.0;
            setState(() {

            });
            await ConstDialog(context).showErrorDialog(error: "Could not complete all transactions. Please check payments.");
          }
        } catch (e) {
          log("Fatal error in transaction processing: $e");
          if (mounted) {
            await ConstDialog(context).showErrorDialog(error: "A system error occurred. Please restart the process.");
          }
        } finally {
          if (mounted) {
            setLoading(false);
          }
        }
      } else {
        ConstDialog(context).showErrorDialog(error: "Please select payment method");
      }
    }
  }

  Widget addMethodButton() {
    return BlocBuilder<PaymentListBloc, List<PaymentMethod>>(
      builder: (context, listMethods) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Constant.colorPurple,
              elevation: 5,
              fixedSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              onAddPaymentMethod(listMethods);
            },
            child: const Text(
              'SPLIT PAYMENT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
      ),
    );
  }

  void onAddPaymentMethod(List<PaymentMethod> listMethods) {
    setState(() {
      // double remainingBalance = widget.totalAmount! - total();
      // final balance = imath.max(0.0, remainingBalance - total());
      final balance = imath.max(0.0, remainingBalance - total());
      print("balance is: $balance");
      if (balance >= 1.0) {
        PaymentMethod? availableMethod;
        for (var method in listMethods) {
          bool alreadyExists = methodListWidget.any(
            (element) => element.methodType?.type == method.type,
          );

          if (!alreadyExists) {
            availableMethod = method;
            break;
            // continue;
          }
        }
        if (availableMethod != null) {
          methodListWidget.add(PaymentListMethod(method: availableMethod.type, methodType: availableMethod));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All payment methods already added')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No remaining balance to split')));
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _refreshPaymentDetails();
    });
  }

  void showCustomerDetailsDialog(BuildContext context, InvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: customerDetails(invoice),
        );
      },
    );
  }

  Widget customerDetails(InvoiceModel invoice) {
    return Container(
      width: 500,
      height: 400,
      padding: const EdgeInsets.all(20),
      child: SuccessTransaction(invoice: invoice),
    );
  }

  Future<String> perFormCardTransaction(
      {required LoggedInUser loggedInUser,
      required double cardAmount,
      required,
      required String pnRefNum,
      required Transaction payload,
      required CustomerModel customerModel,
      required SettingsModel settingsModel}) async {
    String cardType = methodListWidget.firstWhere((element) => element.method == "card").cardType ?? "Credit";
    final paxDeviceBloc = BlocProvider.of<PaxDeviceBloc>(context);

    final uuid = const Uuid().v1().substring(1, 6);
    final uniqueKey = '$uuid-${loggedInUser.id}';
    debugPrint("paxDeviceBloc.state is ${paxDeviceBloc.state?.toJson()}");

    if (paxDeviceBloc.state != null) {
      final response = await BridgePayService.postBridgePay(
          isPrefNumAllowed: false,
          pnRefNum: "",
          context: context,
          invNum: uniqueKey,
          amount: cardAmount.toStringAsFixed(2),
          paxDevice: paxDeviceBloc.state ?? PaxDevice(),
          tenderType: cardType,
          transType: "SALE");
      log("moeez - BridgePay response: ${response.toString()}");

      if (response == null) {
        setLoading(false);
        return "";
      } else {
        if (response["resultCode"] == "000000" || response["resultCode"] == "0" || response["resultTxt"] == "OK") {
          pnRefNum = response["pnRefNum"];
          payload.transactionPaxDeviceId = pnRefNum;
          log('This is payload: ${payload.toJson()}');

          debugPrint("This is pnRefNum:${response["pnRefNum"]} from api response");
          debugPrint("This is pnRefNum:${pnRefNum} saving to variable");

          CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
          TotalDiscountBloc bloc = BlocProvider.of<TotalDiscountBloc>(context);
// cartBloc.add(CartClearProductEvent());
// bloc.add(null);
          log('This is payload while sending place order: ${payload.toJson()}');
          setLoading(true);
          return response["resultCode"];
        } else if (response["resultCode"] == "2") {
          ConstDialogNew.showErrorDialogNew(
            contextNew: context,
            error: "${paxDeviceBloc.state?.deviceName} is not connected.\n Please check internet connection",
          );
          setLoading(false);
          return response["resultCode"];
        } else {
          ConstDialog(context).showErrorDialog(error: "Message:  ${response["resultTxt"]}");
          setLoading(false);
          return "";
        }
      }
    } else {
      ConstDialog(context).showErrorDialog(error: "No device is selected");
      setLoading(false);
      return "";
    }
  }
}

// ignore: must_be_immutable
class MethodTypeWidget extends StatefulWidget {
  final PaymentListMethod paymentMethod;
  final List<PaymentListMethod>? methodList;
  String? methodType;
  double? totalAmount = 0.0;
  final bool? isMobile;
  final Function()? onTap;
  final double afterPayPrice;

  MethodTypeWidget({
    super.key,
    required this.paymentMethod,
    this.onTap,
    this.methodType,
    this.isMobile,
    this.totalAmount,
    this.methodList,
    this.afterPayPrice = 0.0,
  });

  @override
  State<StatefulWidget> createState() => _MethodTypeWidget();
}

class _MethodTypeWidget extends State<MethodTypeWidget> {
  PaymentMethod? methodOptions;
  final cardTypes = ['credit', 'debit'];

  final amountController = TextEditingController();
  final paymentNoteController = TextEditingController();
  final cardNumber = TextEditingController();
  final cardHolderName = TextEditingController();
  final cardSecurity = TextEditingController();
  final cardTransactionNumber = TextEditingController();

  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final cardDataController = TextEditingController();

  final chequeController = TextEditingController();
  final bankTransferController = TextEditingController();

  String selectedCardType = 'credit';
  double currentAmount = 0.0;
  bool doCharge = false;
  Map<String, int> denominationCounts = {};
  final cashDenominationsService = GetCashDenominationsService();
  List<String>? cashDenominations;
  Future<void> getCashDenominations() async {
    LoggedInUserBloc loggedInUserBloc = BlocProvider.of<LoggedInUserBloc>(context);
    List<String>? fetchedDenominations = await cashDenominationsService.getCashDenominations(
      context: context,
      businessId: loggedInUserBloc.state?.businessId ?? '',
    );

    setState(() {
      cashDenominations = fetchedDenominations;
    });

    log('CashDenominations: $cashDenominations');
  }

  void _refreshPaymentDetails() {
    setState(() {
// Force the widget to rebuild
      log('Payment Details Refreshed');
    });
  }

  @override
  void initState() {
    super.initState();
    widget.paymentMethod.method = null;
    widget.paymentMethod.methodType = null;
    widget.methodType = null;
    getCashDenominations();

// Initialize the amountController.text with default value
    String amountText = '0.00';

    log('Initial values - totalAmount: ${widget.totalAmount}, afterPayPrice: ${widget.afterPayPrice}, paymentMethod.amount: ${widget.paymentMethod.amount}');

// Check if totalAmount is 0.0 or not
    if (widget.totalAmount != null && widget.totalAmount == 0.0) {
// Use paymentMethod.amount when totalAmount is 0.0
      if (widget.paymentMethod.amount != null) {
        try {
          amountText = (double.parse(widget.paymentMethod.amount.toString()) - widget.afterPayPrice).toStringAsFixed(2);
        } catch (e) {
// Handle parsing error, use default value
          log('Error parsing paymentMethod.amount: $e');
        }
      }
    } else if (widget.totalAmount != null) {
// Use totalAmount when it's greater than 0.0
      try {
        log('after cancel: totalAmount: ${widget.totalAmount.toString()} & afterPayPrice: ${widget.afterPayPrice}');

        if (widget.afterPayPrice > 0) {
          log("afterPayPrice is greater then zero");
          // amountText = (double.parse(widget.totalAmount.toString()) - widget.afterPayPrice).toStringAsFixed(2);
          amountText = widget.afterPayPrice == 0 ? (double.parse(widget.totalAmount.toString()) - widget.afterPayPrice).toStringAsFixed(2) : widget.paymentMethod.amount.toString();
        } else if (widget.paymentMethod.amount != null && widget.paymentMethod.amount!.isNotEmpty) {
          log("paymentMethod aount is not null | ${widget.paymentMethod.amount!.toString()}");
          amountText = widget.paymentMethod.amount!.toString();
        } else if (widget.totalAmount != null) {
          log("totalAmount is not null | ${widget.totalAmount!.toStringAsFixed(2)}");
          amountText = widget.totalAmount!.toStringAsFixed(2);
        }
      } catch (e) {
// Handle parsing error, use default value
        log('Error parsing totalAmount: $e');
      }
    }
    amountController.text = amountText;
    widget.paymentMethod.amount = amountText.toString();

    setState(() {
      widget.paymentMethod.cardType = selectedCardType;
    });

    log('amount of Balance ${amountController.text}');
    log('Final amount in paymentMethod: ${widget.paymentMethod.amount}');
  }

  void _onDenominationPressed(double denomination) {
    setState(() {
// Add the clicked denomination to the current amount
      currentAmount = denomination;
// Update the amountController with the new amount
      amountController.text = currentAmount.toStringAsFixed(2);
      widget.paymentMethod.amount = double.parse(currentAmount.toString()).toStringAsFixed(2);

// Debugging output
      log('Current Amount: $currentAmount');
      log('Amount Controller Text: ${amountController.text}');
      log('Payment Method Amount: ${widget.paymentMethod.amount}');
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget cardState = BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return Column(
        children: [
          cardDataRow(),
          const SizedBox(height: 5.0),
          cardDetails(isMobile: isMobile),
        ],
      );
    });

    Widget methodWidget() => BlocBuilder<PaymentListBloc, List<PaymentMethod>>(builder: (context, listMethods) {
          return BlocBuilder<PaymentOptionsBloc, PaymentMethod?>(builder: (context, selectedMethod) {
            return BlocBuilder<LocationBloc, Location?>(
              builder: (context, location) {
                return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
                  builder: (context, loggedInUser) {
                    return Material(
                        color: const Color.fromARGB(73, 174, 174, 174),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [IconButton(onPressed: widget.onTap, icon: const Icon(Icons.close))],
                              ),
                              selectionMethodRow(
                                paymentList: listMethods,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              if (widget.paymentMethod.method == 'card') cardState,
                              const SizedBox(
                                height: 5.0,
                              ),
                              if (widget.paymentMethod.method == 'cheque') chequeWidget(),
                              if (widget.paymentMethod.method == 'Bank Transfer') bankTransferWidget(),
                              const SizedBox(
                                height: 5.0,
                              ),
                              paymentNote(),
                              if (widget.paymentMethod.method == 'card')
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Spacer(),
                                        Builder(builder: (context) {
                                          if (doCharge == true) {
                                            return const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: SizedBox(width: 30.0, height: 30.0, child: CircularProgressIndicator()),
                                            );
                                          }

                                          return OutlinedButton(
                                              onPressed: () => onChargeCard(location: location ?? Location(), loggedInUser: loggedInUser ?? LoggedInUser()),
                                              child: const Text('CHARGE'));
                                        })
                                      ],
                                    )
                                  ],
                                )
                            ],
                          ),
                        ));
                  },
                );
              },
            );
          });
        });

    return methodWidget();
  }

  onChargeCard({required Location location, required LoggedInUser loggedInUser}) async {
    setState(() {
      doCharge = true;
    });

    ChargeInvoiceModel? chargeModel = await ChargeCardService.chargeCard(context: context, location: location, listMethods: widget.paymentMethod, loggedInUser: loggedInUser);

    if (chargeModel!.success == 1) {
      setState(() {
        widget.paymentMethod.cardTransactionNumber = chargeModel.transactionId.toString();

        doCharge = false;
      });

      if (chargeModel.name != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PdfPreviewPage(
                  openFrom: 'charge',
                  chargeInvoiceModel: chargeModel,
                )));
      }
    } else {
      ConstDialog(context).showErrorDialog(error: 'payment Unsuccessful');
    }

    setState(() {
      doCharge = false;
    });
  }

  Widget selectionMethodRow({
    required List<PaymentMethod> paymentList,
  }) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                hintText: 'Amount',
                icon: IconButton(
                  icon: amountController.text.isNotEmpty ? const Icon(Icons.cancel_rounded) : const Icon(Icons.attach_money_rounded),
                  onPressed: amountController.text.isNotEmpty
                      ? () {
                          setState(() {
                            amountController.clear();
                            widget.paymentMethod.amount = '0.0';
                            currentAmount = 0.0;
                            denominationCounts.clear();
                          });
                        }
                      : () {},
                ),
                labelText: '',
                controller: amountController,
                onChanged: onAmountChanged,
                inputType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: Row(
                children: paymentList.map((e) {
// Check if this method is already in use elsewhere in the list
                  bool isSelectedInList =
                      widget.methodList != null && widget.methodList!.any((selected) => selected.methodType?.type == e.type && selected != widget.paymentMethod);

// Check if this specific method is selected for this widget
                  bool isSelected = widget.paymentMethod.methodType?.type == e.type;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Constant.colorPurple : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : Colors.black,
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          minimumSize: const Size(double.infinity, 55.0),
                        ),
                        onPressed: () {
                          if (isSelectedInList && isSelected) {
// Show error if method is already selected elsewhere
                            ConstDialog(context).showErrorDialog(
                              error: "${e.type} already selected",
                            );
                          } else {
                            setState(() {
                              if (isSelected) {
// Unselect if already selected
                                onMethodChanged(paymentList, null);
                              } else {
// Select the new method
                                onMethodChanged(paymentList, e.type);
                              }
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (isSelected) const Icon(Icons.check, color: Colors.white),
                              const SizedBox(width: 8.0),
                              Text(
                                e.name.toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 5.0),
            if (widget.paymentMethod.method == 'card')
              Expanded(
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Select Card Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: selectedCardType,
                  onChanged: onCardTypeChanged,
                  items: cardTypes
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget chequeWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        CustomInputField(
          hintText: 'Cheque',
          labelText: 'CN',
          controller: chequeController,
          onChanged: onChequeChanged,
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget bankTransferWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        CustomInputField(
          hintText: 'Bank Transfer No.',
          labelText: 'BT',
          controller: bankTransferController,
          onChanged: onBankTransferChanged,
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget cardDataRow() {
    return Row(children: [
      Expanded(
        child: CustomInputField(
          hintText: 'Select Field When Swiping Card',
          labelText: 'CD',
          controller: cardDataController,
          onChanged: onCardDateChanged,
        ),
      ),
      const SizedBox(width: 5.0),
      SizedBox(
        width: 250,
        child: CustomInputField(hintText: 'Card Number', labelText: 'CN', controller: cardNumber, onChanged: onCardNumberChanged, inputType: TextInputType.number),
      ),
    ]);
  }

  Widget cardDetails({required bool isMobile}) {
    if (isMobile) {
      return Column(children: [
        CustomInputField(
          hintText: 'Card Holder Name',
          labelText: 'HN',
          controller: cardHolderName,
          onChanged: onCardHolderNameChanged,
        ),
        const SizedBox(
          height: 5.0,
        ),
        CustomInputField(
// enabled: true,
            hintText: 'CVV2',
            labelText: '*',
            controller: cardSecurity,
            onChanged: oncardSecurityChanged,
            inputType: TextInputType.number),
        const SizedBox(height: 5.0),
        CustomInputField(hintText: 'Month', labelText: 'MM', controller: monthController, onChanged: onMonthControllerChanged, inputType: TextInputType.number),
        const SizedBox(
          height: 5.0,
        ),
        CustomInputField(
          hintText: 'Year',
          labelText: 'YY',
          controller: yearController,
          onChanged: onYearControllerChanged,
          inputType: TextInputType.number,
        ),
      ]);
    }

    return Row(children: [
      Expanded(
        child: CustomInputField(
          hintText: 'Card Holder Name',
          labelText: 'HN',
          controller: cardHolderName,
          onChanged: onCardHolderNameChanged,
        ),
      ),
      const SizedBox(
        width: 5.0,
      ),
      SizedBox(
        width: 120,
        child: CustomInputField(
// enabled: true,
            hintText: 'CVV2',
            labelText: '*',
            controller: cardSecurity,
            onChanged: oncardSecurityChanged,
            inputType: TextInputType.number),
      ),
      const SizedBox(width: 5.0),
      SizedBox(
        width: 100.0,
        child: CustomInputField(hintText: 'Month', labelText: 'MM', controller: monthController, onChanged: onMonthControllerChanged, inputType: TextInputType.number),
      ),
      const SizedBox(
        width: 5.0,
      ),
      SizedBox(
        width: 100.0,
        child: CustomInputField(
          hintText: 'Year',
          labelText: 'YY',
          controller: yearController,
          onChanged: onYearControllerChanged,
          inputType: TextInputType.number,
        ),
      ),
    ]);
  }

  Widget paymentNote() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: CustomInputField(
              labelText: 'Payment Note',
              hintText: 'Note',
              controller: paymentNoteController,
              onChanged: onPaymentControllerChanged,
// maxLines: 3,
            ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        cashDenominations == null
            ? const Center(
                child: Text(''), // Show loading indicator
              )
            : Wrap(
                alignment: WrapAlignment.center,
                children: cashDenominations!.map((denomination) {
                  return GestureDetector(
                    onPanUpdate: (_) => _refreshPaymentDetails(),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  double denominationValue = double.tryParse(denomination) ?? 0.0;
                                  _onDenominationPressed(denominationValue);
// denominationCounts[denomination] =
//     (denominationCounts[denomination] ?? 0) +
//         1;
                                });
                              },
                              icon: const FaIcon(FontAwesomeIcons.moneyBill1),
                              label: Text(
                                denomination,
                                style: const TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xfff0f0f0),
                                foregroundColor: const Color(0xff525f7f),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
        if (widget.paymentMethod.cardTransactionNumber != null && widget.paymentMethod.method == 'card')
          Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                tileColor: Colors.green,
                title: const Text(
                  'Payment Successful',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Your Transaction Id: ${widget.paymentMethod.cardTransactionNumber.toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
      ],
    );
  }

  void onAmountChanged(String? value) {
    setState(() {
// Update the amount in the current payment method
      widget.paymentMethod.amount = value;
    });
  }

  oncardSecurityChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardSecurity = value;
    });
  }

  onPaymentControllerChanged(String? value) {
    setState(() {
      widget.paymentMethod.paymentNote = value;
    });
  }

  onYearControllerChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardYear = value;
    });
  }

  onMonthControllerChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardMonth = value;
    });
  }

  onCardHolderNameChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardHolderName = value;
    });
  }

  onCardNumberChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardNumber = value;
    });
  }

  onCardDateChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardString = value;

      Future.delayed(const Duration(milliseconds: 700)).whenComplete(() {
        cardNumber.text = RegFunctions.getCardNumber(card_Data: cardDataController.text).toString();
        if (cardNumber.text.isNotEmpty) {
          widget.paymentMethod.cardNumber = RegFunctions.getCardNumber(card_Data: cardDataController.text).toString();
        }

        cardHolderName.text = RegFunctions.extractAndRearrangeName(cardDataController.text).toString();
        if (cardHolderName.text.isNotEmpty) {
          widget.paymentMethod.cardHolderName = RegFunctions.extractAndRearrangeName(cardDataController.text).toString();
        }

        monthController.text = RegFunctions.extractInfo(cardDataController.text)?['info2'] ?? '';
        if (monthController.text.isNotEmpty) {
          widget.paymentMethod.cardMonth = RegFunctions.extractInfo(cardDataController.text)?['info2'] ?? '';
        }

        yearController.text = RegFunctions.extractInfo(cardDataController.text)?['info1'] ?? '';
        if (yearController.text.isNotEmpty) {
          widget.paymentMethod.cardYear = RegFunctions.extractInfo(cardDataController.text)?['info1'] ?? '';
        }
      });
    });
  }

  onChequeChanged(String? value) {
    setState(() {
      widget.paymentMethod.chequeNumber = value;
    });
  }

  onBankTransferChanged(String? value) {
    setState(() {
      widget.paymentMethod.accountNumber = value;
    });
  }

  onCardTypeChanged(String? value) {
    setState(() {
      widget.paymentMethod.cardType = value.toString();
    });
  }

  void onMethodChanged(List<PaymentMethod> paymentList, String? value) {
    setState(() {
      if (value == null) {
// Deselect case
        widget.paymentMethod.method = null;
        widget.paymentMethod.methodType = null;
        widget.methodType = null;
      } else {
// Select a method from paymentList
        final selectedMethod = paymentList.firstWhere(
          (method) => method.type == value,
          orElse: () => PaymentMethod(type: value), // Fallback
        );
        widget.paymentMethod.method = value.toLowerCase();
        widget.paymentMethod.methodType = selectedMethod;
        widget.methodType = value;
      }
    });
  }
}

class PdfPreviewPage extends StatelessWidget with PrintPDF {
  final InvoiceModel? invoice;
  final ChargeInvoiceModel? chargeInvoiceModel;
  final String openFrom;
  final RegisterDetails? registerDetails;
  const PdfPreviewPage({super.key, this.invoice, required this.openFrom, this.chargeInvoiceModel, this.registerDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        onPrinted: (context) async {
          final path = await GenerateInvoice.printInvoice(invoiceModel: invoice!);
          await printPdf(path: path, context: context);
        },
        build: (context) => openPdf(openFrom),
      ),
    );
  }

  FutureOr<Uint8List> openPdf(String openFrom) async {
    return switch (openFrom) {
      'register' => await GenerateRegisterPdf.generateInvoice(registerDetails: registerDetails!),
      'sell' => await SellReturnInvoice.generateInvoice(invoiceModel: invoice!),
      'charge' => await GenerateChargeInvoice.generateChargeInvoice(invoiceModel: chargeInvoiceModel!),
      'invoice' => await GenerateInvoice.generateInvoice(invoiceModel: invoice!),
      'quotation' => await GenerateQuotation.generateInvoice(invoiceModel: invoice!),
      _ => await GenerateInvoice.generateInvoice(invoiceModel: invoice!)
    };
  }
}
