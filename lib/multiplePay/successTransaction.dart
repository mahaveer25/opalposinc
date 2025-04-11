// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/GenerateInvoice.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/main.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/printing.dart';
import 'package:opalposinc/services/customer_balance.dart';
import 'package:opalposinc/services/smsSendingService.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class SuccessTransaction extends StatefulWidget {
  final InvoiceModel invoice;

  const SuccessTransaction({
    super.key,
    required this.invoice,
  });

  @override
  State<SuccessTransaction> createState() => _SuccessTransactionState();
}

class _SuccessTransactionState extends State<SuccessTransaction> with PrintPDF {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isLoad = false;
  int _selectedTabIndex = 0;
  bool isPressed = false;

  void _updateCustomerData(CustomerModel? customer) {
    if (mounted) {
      SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

      if (customer == null) return;

      if (_selectedTabIndex == 0) {
        // SMS tab selected
        phoneController.text = customer.mobile == "null"
            ? ""
            : settingsBloc.state!.enableInvoiceEmail == "0"
                ? ""
                : customer.mobile ?? '';
        emailAddressController.clear(); // Clear email field
      } else if (_selectedTabIndex == 1) {
        // Email tab selected
        emailAddressController.text = customer.email == "null"
            ? ""
            : settingsBloc.state!.enableInvoiceEmail == "0"
                ? ""
                : customer.email ?? '';
        phoneController.clear(); // Clear phone field
      } else if (_selectedTabIndex == 2) {
        // Both tab selected
        phoneController.text = customer.mobile == "null"
            ? ""
            : settingsBloc.state!.enableInvoiceEmail == "0"
                ? ""
                : customer.mobile ?? '';
        emailAddressController.text = customer.email == "null"
            ? ""
            : settingsBloc.state!.enableInvoiceEmail == "0"
                ? ""
                : customer.email ?? '';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      final currentCustomer = context.read<CustomerBloc>().state;
      if (currentCustomer != null) {
        _updateCustomerData(currentCustomer);
      }
      context.read<CustomerBloc>().stream.listen((customer) {
        if (customer != null) {
          _updateCustomerData(customer);
          log("Customer Data: ${customer.name}");
        }
      });
    });
  }

  static String? _formatNumber(String? numberString) {
    if (numberString == null || numberString.isEmpty) return null;
    final number = double.tryParse(numberString);
    if (number == null) return null;
    return NumberFormat("#,##0.00", "en_US").format(number);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return BlocBuilder<CheckConnection, bool>(
          builder: (context, isConnected) {
        return BlocBuilder<SettingsBloc, SettingsModel?>(
            builder: (context, settings) {
          return BlocBuilder<CustomerBloc, CustomerModel?>(
              builder: (context, customerModel) {
            if (settings == null || customerModel == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Success Transaction'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                    FunctionProduct.disappearBackSuccessTransitionScreen();
                  },
                ),
              ),
              body: isMobile
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          if (isMobile)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      border: const Border(
                                        right: BorderSide(
                                            color: Color.fromARGB(
                                                108, 158, 158, 158),
                                            width: 2), // Left-side border
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Pay For This Order',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Order Subtotal: "),
                                              Text(
                                                "\$${double.parse(widget.invoice.subTotal.toString()).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(widget.invoice
                                                          .discountType ==
                                                      "Percentage"
                                                  ? "Discount (${widget.invoice.discountAmount}%)"
                                                  : "Discount: "),
                                              Text(
                                                  "(-) \$${double.parse(widget.invoice.invoiceDiscount.toString()).toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Tax: "),
                                              Text(
                                                  "(+) \$${(double.parse(widget.invoice.taxAmount.toString()) * 100).roundToDouble() / 100}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            children: widget
                                                .invoice.paymentMethod!
                                                .map((payment) {
                                              DateTime dateTime =
                                                  DateTime.parse(widget
                                                      .invoice.date
                                                      .toString());
                                              String formattedDate =
                                                  DateFormat('(dd/MM/yyyy)')
                                                      .format(dateTime);

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Display Payment Method and Date
                                                      Text(
                                                        '${payment.method.toString()} $formattedDate',
                                                      ),

                                                      // Display Payment Amount
                                                      Text(
                                                          '(-) \$${_formatNumber((payment.amount != null ? double.parse(payment.amount.toString()) : 0.0).toStringAsFixed(2))}',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Total: ",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Text(
                                                  "\$${(double.parse(widget.invoice.total.toString()) * 100).roundToDouble() / 100}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Flexible(
                                child: DefaultTabController(
                                  length: 3,
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 60,
                                                color: const Color.fromARGB(
                                                    34, 130, 178, 255),
                                                child: Center(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size:
                                                              20.0), // Adjust size and color as needed

                                                      Text(
                                                        '\$${double.parse(widget.invoice.totalPaid.toString()).toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontSize:
                                                              20, // Adjust the font size as needed
                                                          fontWeight: FontWeight
                                                              .bold, // Adjust the font weight as needed
                                                          color: Colors
                                                              .black, // Change color if needed
                                                        ),
                                                      ),
                                                      const Text(
                                                        '  Payment Successful',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors
                                                              .black, // Change color if needed
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const FaIcon(
                                                      FontAwesomeIcons
                                                          .solidMoneyBill1,
                                                      size: 50,
                                                      color: Colors.green,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Text(
                                                      "Change: ",
                                                      style: TextStyle(
                                                          fontSize: 28),
                                                    ),
                                                    Text(
                                                      "\$${double.parse(widget.invoice.changeReturn.toString()).toStringAsFixed(2)}",
                                                      style: const TextStyle(
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "How Would you like your Receipt? ",
                                                    style: TextStyle(
                                                        fontSize:
                                                            isMobile ? 22 : 35),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize: const Size(
                                                        double.infinity,
                                                        50), // Set width and height
                                                    backgroundColor: isPressed
                                                        ? Colors.white
                                                        : Constant
                                                            .colorPurple, // Change background color on press
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 15.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: BorderSide(
                                                        color: isPressed
                                                            ? Constant
                                                                .colorPurple
                                                            : Colors
                                                                .transparent, // Change border color on press
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      isPressed =
                                                          true; // Change button state on press
                                                    });

                                                    final path =
                                                        await GenerateInvoice
                                                            .printInvoice(
                                                                invoiceModel:
                                                                    widget
                                                                        .invoice);
                                                    log("invoice: pdf :${widget.invoice}");
                                                    await printPdf(
                                                            path: path,
                                                            context: context)
                                                        .whenComplete(() async {
                                                      await displayManager
                                                          .transferDataToPresentation({
                                                        'type': 'discount',
                                                        'discount':
                                                            TotalDiscountModel()
                                                                .toJson(),
                                                      });

                                                      FunctionProduct
                                                          .disappearBackSuccessTransitionScreen();

                                                      final customer =
                                                          await CustomerBalanceService
                                                              .getCustomerBalance(
                                                        context,
                                                        int.parse(customerModel!
                                                            .id
                                                            .toString()),
                                                      );
                                                      ListCustomerBloc
                                                          customerListBloc =
                                                          BlocProvider.of<
                                                                  ListCustomerBloc>(
                                                              context);
                                                      CustomerBloc
                                                          customerBloc =
                                                          BlocProvider.of<
                                                                  CustomerBloc>(
                                                              context);
                                                      customerBloc.add(
                                                          customerListBloc
                                                              .state.first);

                                                      CustomerBalanceBloc
                                                          balanceBloc =
                                                          BlocProvider.of<
                                                                  CustomerBalanceBloc>(
                                                              context);
                                                      balanceBloc.add(customer);
                                                    }).whenComplete(() =>
                                                            Navigator.pop(
                                                                context));

                                                    setState(() {
                                                      isPressed = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    'PRINT RECEIPT',
                                                    style: TextStyle(
                                                        color: isPressed
                                                            ? Constant
                                                                .colorPurple
                                                            : Colors
                                                                .white, // Change text color on press
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),

                                          TabBar(
                                            onTap: (index) async {
                                              await displayManager
                                                  .transferDataToPresentation({
                                                'type': 'tabIndex',
                                                'tabIndex': index,
                                              });
                                              if (mounted) {
                                                setState(() {
                                                  _selectedTabIndex = index;

                                                  final currentCustomer =
                                                      context
                                                          .read<CustomerBloc>()
                                                          .state;
                                                  if (currentCustomer != null) {
                                                    _updateCustomerData(
                                                        currentCustomer);
                                                  }
                                                });
                                              }
                                            },
                                            labelStyle: const TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Make the text bold
                                              fontSize:
                                                  16, // Adjust the font size if needed
                                            ),
                                            labelColor: Colors.black,
                                            indicatorColor:
                                                Constant.colorPurple,
                                            tabs: const [
                                              Tab(text: 'SMS'),
                                              Tab(text: 'EMAIL'),
                                              Tab(text: 'BOTH'),
                                            ],
                                          ),
                                          // TabBarView for different content
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: TabBarView(
                                              children: [
                                                smsTab(settings ??
                                                    const SettingsModel()),
                                                emailTab(settings ??
                                                    const SettingsModel()),
                                                bothTab(settings ??
                                                    const SettingsModel()),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Close Button
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Constant.colorPurple,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12.0,
                                                          horizontal: 15.0),
                                                      // minimumSize: const Size(
                                                      //     double.infinity,50), // Set width and height
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      FunctionProduct
                                                          .disappearBackSuccessTransitionScreen();
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'CLOSE',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: const Border(
                                right: BorderSide(
                                    color: Color.fromARGB(108, 158, 158, 158),
                                    width: 2), // Left-side border
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Pay For This Order',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Order Subtotal: "),
                                      Text(
                                        "\$${double.parse(widget.invoice.subTotal.toString()).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.invoice.discountType ==
                                              "Percentage"
                                          ? "Discount (${widget.invoice.discountAmount}%)"
                                          : "Discount: "),
                                      Text(
                                          "(-) \$${double.parse(widget.invoice.invoiceDiscount.toString()).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Tax: "),
                                      Text(
                                          "(+) \$${(double.parse(widget.invoice.taxAmount.toString()) * 100).roundToDouble() / 100}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: widget.invoice.paymentMethod!
                                        .map((payment) {
                                      DateTime dateTime = DateTime.parse(
                                          widget.invoice.date.toString());
                                      String formattedDate =
                                          DateFormat('(dd/MM/yyyy)')
                                              .format(dateTime);

                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Display Payment Method and Date
                                              Text(
                                                '${payment.method.toString()} $formattedDate',
                                              ),

                                              // Display Payment Amount
                                              Text(
                                                  '(-) \$${_formatNumber((payment.amount != null ? double.parse(payment.amount.toString()) : 0.0).toStringAsFixed(2))}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total: ",
                                          style: TextStyle(fontSize: 20)),
                                      Text(
                                          "\$${(double.parse(widget.invoice.total.toString()) * 100).roundToDouble() / 100}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: DefaultTabController(
                            length: 3,
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 60,
                                          color: const Color.fromARGB(
                                              34, 130, 178, 255),
                                          child: Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size:
                                                        20.0), // Adjust size and color as needed

                                                Text(
                                                  '\$${double.parse(widget.invoice.totalPaid.toString()).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        20, // Adjust the font size as needed
                                                    fontWeight: FontWeight
                                                        .bold, // Adjust the font weight as needed
                                                    color: Colors
                                                        .black, // Change color if needed
                                                  ),
                                                ),
                                                const Text(
                                                  '  Payment Successful',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors
                                                        .black, // Change color if needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons
                                                    .solidMoneyBill1,
                                                size: 50,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Text(
                                                "Change: ",
                                                style: TextStyle(fontSize: 28),
                                              ),
                                              Text(
                                                "\$${double.parse(widget.invoice.changeReturn.toString()).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    fontSize: 28,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ]),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "How Would you like your Receipt? ",
                                              style: TextStyle(
                                                  fontSize: isMobile ? 22 : 35),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(
                                                  double.infinity,
                                                  50), // Set width and height
                                              backgroundColor: isPressed
                                                  ? Colors.white
                                                  : Constant
                                                      .colorPurple, // Change background color on press
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 15.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                  color: isPressed
                                                      ? Constant.colorPurple
                                                      : Colors
                                                          .transparent, // Change border color on press
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                isPressed =
                                                    true; // Change button state on press
                                              });

                                              final path = await GenerateInvoice
                                                  .printInvoice(
                                                      invoiceModel:
                                                          widget.invoice);
                                              log("invoice: pdf :${widget.invoice}");
                                              await printPdf(
                                                      path: path,
                                                      context: context)
                                                  .whenComplete(() async {
                                                await displayManager
                                                    .transferDataToPresentation({
                                                  'type': 'discount',
                                                  'discount':
                                                      TotalDiscountModel()
                                                          .toJson(),
                                                });

                                                FunctionProduct
                                                    .disappearBackSuccessTransitionScreen();

                                                final customer =
                                                    await CustomerBalanceService
                                                        .getCustomerBalance(
                                                  context,
                                                  int.parse(customerModel!.id
                                                      .toString()),
                                                );
                                                ListCustomerBloc
                                                    customerListBloc =
                                                    BlocProvider.of<
                                                            ListCustomerBloc>(
                                                        context);
                                                CustomerBloc customerBloc =
                                                    BlocProvider.of<
                                                        CustomerBloc>(context);
                                                customerBloc.add(
                                                    customerListBloc
                                                        .state.first);

                                                CustomerBalanceBloc
                                                    balanceBloc = BlocProvider
                                                        .of<CustomerBalanceBloc>(
                                                            context);
                                                balanceBloc.add(customer);
                                              }).whenComplete(() =>
                                                      Navigator.pop(context));

                                              setState(() {
                                                isPressed = false;
                                              });
                                            },
                                            child: Text(
                                              'PRINT RECEIPT',
                                              style: TextStyle(
                                                  color: isPressed
                                                      ? Constant.colorPurple
                                                      : Colors
                                                          .white, // Change text color on press
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),

                                    TabBar(
                                      onTap: (index) async {
                                        await displayManager
                                            .transferDataToPresentation({
                                          'type': 'tabIndex',
                                          'tabIndex': index,
                                        });
                                        if (mounted) {
                                          setState(() {
                                            _selectedTabIndex = index;

                                            final currentCustomer = context
                                                .read<CustomerBloc>()
                                                .state;
                                            if (currentCustomer != null) {
                                              _updateCustomerData(
                                                  currentCustomer);
                                            }
                                          });
                                        }
                                      },
                                      labelStyle: const TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Make the text bold
                                        fontSize:
                                            16, // Adjust the font size if needed
                                      ),
                                      labelColor: Colors.black,
                                      indicatorColor: Constant.colorPurple,
                                      tabs: const [
                                        Tab(text: 'SMS'),
                                        Tab(text: 'EMAIL'),
                                        Tab(text: 'BOTH'),
                                      ],
                                    ),
                                    // TabBarView for different content
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: TabBarView(
                                        children: [
                                          smsTab(settings ??
                                              const SettingsModel()),
                                          emailTab(settings ??
                                              const SettingsModel()),
                                          bothTab(settings ??
                                              const SettingsModel()),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Close Button
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Constant.colorPurple,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0,
                                                        horizontal: 15.0),
                                                // minimumSize: const Size(
                                                //     double.infinity,50), // Set width and height
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              onPressed: () async {
                                                FunctionProduct
                                                    .disappearBackSuccessTransitionScreen();
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'CLOSE',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            );
          });
        });
      });
    });
  }

  Future<void> _sendSmsEmail(InvoiceModel invoice) async {
    final response = await NotificationService.sendSmsEmail(
      context: context,
      smsSendTo: phoneController.text,
      emailSendTo: emailAddressController.text,
      address: invoice.address.toString(),
      invoiceNumber: invoice.invoiceNumber.toString(),
      transactionId: invoice.transactionId.toString(),
      customer: invoice.customer.toString(),
      customerMobile: invoice.customerMobile.toString(),
      invoiceDate: invoice.date.toString(),
      mobile: invoice.mobile.toString(),
      product: invoice.product!, // Correct type fallback
      subTotal: invoice.subTotal.toString(),
      taxAmount: invoice.taxAmount.toString(),
      total: double.parse(invoice.total.toString()).toStringAsFixed(2),
    );

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      emailAddressController.text = "";
      phoneController.text = "";
      ListCustomerBloc customerListBloc =
          BlocProvider.of<ListCustomerBloc>(context);
      CustomerBloc customerBloc = BlocProvider.of<CustomerBloc>(context);
      customerBloc.add(customerListBloc.state.first);
      // FunctionProduct.disappearBackSuccessTransitionScreen();
      // Navigator.pop(context);
      if (response['sms_sent'] == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response['message'])),
        // );
        // ConstDialog(context).showErrorDialog(error: 'SMS Invoice Sent Successfully');
      }
      if (response['email_sent'] == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response['message'])),
        // );
        // ConstDialog(context).showErrorDialog(error: 'Email Invoice Sent Successfully');
      }
      if (response['sms_sent'] == true && response['email_sent'] == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response['message'])),
        // );
        // ConstDialog(context).showErrorDialog(error: 'Email & SMS Invoice Sent Successfully');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error of SMS: ${response['message']}')),
      );
    }
  }

// SMS Tab - Only phone number input field
  Widget smsTab(SettingsModel setting) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
          builder: (context, customer) {
            if (customer == null) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isEditable = setting.enableInvoiceSMS == "1";

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (setting.enableInvoiceEmail == "0")
                      const Text(
                        "Kindly Purchase the Email & SMS Service",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (setting.enableInvoiceEmail == "0")
                      const Text(
                        "If You Already Purchased and You Enable the Service while Running App Kindly Restart the App ",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const Text("Phone Number:"),
                    CustomInputField(
                      labelText: "Phone Number",
                      hintText: 'Phone Number',
                      controller: phoneController,
                      enabled: isEditable,
                      onChanged: (value) {
                        FunctionProduct.customBackScreenSendData(
                            data: phoneController.text,
                            isModel: false,
                            type: "successPhoneNumber");
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isLoad &&
                                    isConnected &&
                                    setting.enableInvoiceEmail == '1' &&
                                    setting.enableInvoiceSMS == '1'
                                ? Constant.colorPurple
                                : Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            minimumSize:
                                const Size(300, 50), // Set width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: (isLoad ||
                                  !(isConnected &&
                                      setting.enableInvoiceEmail == '1' &&
                                      setting.enableInvoiceSMS == '1'))
                              ? null
                              : () async {
                                  setState(() {
                                    isLoad = true;
                                  });

                                  await _sendSmsEmail(widget.invoice);

                                  setState(() {
                                    isLoad = false;
                                  });
                                },
                          child: isLoad
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  'SEND SMS',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Email Tab - Only email address input field
  Widget emailTab(SettingsModel setting) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
          builder: (context, customer) {
            if (customer == null) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isEditable = setting.enableInvoiceEmail == "1";

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (setting.enableInvoiceEmail == "0")
                      const Text(
                        "Kindly Purchase the Email & SMS Service",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (setting.enableInvoiceEmail == "0")
                      const Text(
                        "If You Already Purchased and You Enable the Service while Running App Kindly Restart the App ",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const Text("Email Address:"),
                    CustomInputField(
                      labelText: "Email Address",
                      hintText: "Email Address",
                      controller: emailAddressController,
                      enabled: isEditable,
                      onChanged: (value) {
                        FunctionProduct.customBackScreenSendData(
                            data: emailAddressController.text,
                            isModel: false,
                            type: "successEmail");
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isLoad &&
                                    isConnected &&
                                    setting.enableInvoiceEmail == '1' &&
                                    setting.enableInvoiceSMS == '1'
                                ? Constant.colorPurple
                                : Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            minimumSize:
                                const Size(300, 50), // Set width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: (isLoad ||
                                  !(isConnected &&
                                      setting.enableInvoiceEmail == '1' &&
                                      setting.enableInvoiceSMS == '1'))
                              ? null
                              : () async {
                                  setState(() {
                                    isLoad = true;
                                  });

                                  await _sendSmsEmail(widget.invoice);
                                  FunctionProduct
                                      .disappearBackSuccessTransitionScreen();

                                  setState(() {
                                    isLoad = false;
                                  });
                                },
                          child: isLoad
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  'SEND EMAIL',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Both Tab - Phone number and email address input fields
  Widget bothTab(SettingsModel setting) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
          builder: (context, customer) {
            if (customer == null) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isEditable = setting.enableInvoiceEmail == "1" &&
                setting.enableInvoiceSMS == "1";

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (setting.enableInvoiceEmail == "0")
                      const Text(
                        "Kindly Purchase the Email & SMS Service",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (setting.enableInvoiceEmail == "0")
                      const Text(
                        "If You Already Purchased and You Enable the Service while Running App Kindly Restart the App ",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const Text("Phone Number and Email Address:"),
                    CustomInputField(
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                      controller: phoneController,
                      enabled: isEditable,
                      onChanged: (value) {
                        FunctionProduct.customBackScreenSendData(
                            data: phoneController.text,
                            isModel: false,
                            type: "successPhoneNumber");
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomInputField(
                      labelText: "Email Address",
                      hintText: "Email Address",
                      controller: emailAddressController,
                      enabled: isEditable,
                      onChanged: (value) {
                        FunctionProduct.customBackScreenSendData(
                            data: emailAddressController.text,
                            isModel: false,
                            type: "successEmail");
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isLoad &&
                                    isConnected &&
                                    setting.enableInvoiceEmail == '1' &&
                                    setting.enableInvoiceSMS == '1'
                                ? Constant.colorPurple
                                : Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            minimumSize:
                                const Size(300, 50), // Set width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: (isLoad ||
                                  !(isConnected &&
                                      setting.enableInvoiceEmail == '1' &&
                                      setting.enableInvoiceSMS == '1'))
                              ? null
                              : () async {
                                  setState(() {
                                    isLoad = true;
                                  });

                                  await _sendSmsEmail(widget.invoice);
                                  FunctionProduct
                                      .disappearBackSuccessTransitionScreen();

                                  setState(() {
                                    isLoad = false;
                                  });
                                },
                          child: isLoad
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  'SEND SMS & EMAIL',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
