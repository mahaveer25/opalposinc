import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/GenerateInvoice.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/main.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/printing.dart';
import 'package:opalposinc/services/customer_balance.dart';
import 'package:opalposinc/services/smsSendingService.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class SuccessTransactionBackScreen extends StatefulWidget {
  final InvoiceModel invoice;
  CustomerModel? customerData;
  SettingsModel? settingsData;
  String? successEmail;
  String? successPhone;
  int? tabIndex;
  List<PaymentListMethod>? paymentList;

  SuccessTransactionBackScreen({
    super.key,
    required this.invoice,
    this.customerData,
    this.settingsData,
    this.successEmail,
    this.paymentList,
    this.successPhone,
    this.tabIndex,
  });

  @override
  State<SuccessTransactionBackScreen> createState() =>
      _SuccessTransactionState();
}

class _SuccessTransactionState extends State<SuccessTransactionBackScreen>
    with SingleTickerProviderStateMixin, PrintPDF {
  // TextEditingController emailAddressController = TextEditingController( );
  late TextEditingController emailAddressController;

  TextEditingController phoneController = TextEditingController();
  bool isLoad = false;
  int _selectedTabIndex = 0;
  bool isPressed = false;

  void _updateCustomerData(CustomerModel? customer) {
    if (mounted) {
      SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

      if (customer == null) return;

      if (_selectedTabIndex == 0) {
        phoneController.text = customer.mobile == "null"
            ? ""
            : settingsBloc.state!.enableInvoiceEmail == "0"
                ? ""
                : customer.mobile ?? '';
        emailAddressController.clear(); // Clear email field
      } else if (_selectedTabIndex == 1) {
        emailAddressController.text = customer.email == "null"
            ? ""
            : settingsBloc.state!.enableInvoiceEmail == "0"
                ? ""
                : customer.email ?? '';
        phoneController.clear(); // Clear phone field
      } else if (_selectedTabIndex == 2) {
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.tabIndex ?? 0,
    );

    _selectedTabIndex = widget.tabIndex ?? 0;

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });

    setState(() {
      emailAddressController = TextEditingController();
      emailAddressController.text = widget.successEmail ?? "";
      phoneController = TextEditingController();
      phoneController.text = widget.successPhone ?? "";

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SuccessTransactionBackScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.successEmail != oldWidget.successEmail) {
      setState(() {
        emailAddressController.text = widget.successEmail ?? "";
      });
    }
    if (widget.successPhone != oldWidget.successPhone) {
      setState(() {
        phoneController.text = widget.successPhone ?? "";
      });
    }
    if (widget.tabIndex != oldWidget.tabIndex) {
      setState(() {
        _selectedTabIndex = widget.tabIndex ?? 0;
        _tabController.animateTo(_selectedTabIndex);
        phoneController.clear();
        emailAddressController.clear();

        print("_selectedTabIndex   " + _selectedTabIndex.toString());
      });
    }
  }

  static String? _formatNumber(String? numberString) {
    if (numberString == null || numberString.isEmpty) return "0.0";
    final number = double.tryParse(numberString);
    if (number == null) return "0.0";
    return NumberFormat("#,##0.00", "en_US").format(number);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.settingsData == null || widget.customerData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Success Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          Expanded(
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Order Subtotal: "),
                        Text(
                          "\$${double.parse(widget.invoice.subTotal.toString()).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.invoice.discountType == "Percentage"
                            ? "Discount (${widget.invoice.discountAmount}%)"
                            : "Discount: "),
                        Text(
                            "(-) \$${double.parse(widget.invoice.invoiceDiscount.toString()).toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tax:"),
                        Text(
                            "(+) \$${(double.parse(widget.invoice.taxAmount.toString()) * 100).roundToDouble() / 100}",
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: widget.invoice.paymentMethod!.map((payment) {
                        DateTime dateTime =
                            DateTime.parse(widget.invoice.date.toString());
                        String formattedDate =
                            DateFormat('(dd/MM/yyyy)').format(dateTime);

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Display Payment Method and Date
                                Text(
                                  '${payment.method.toString()} $formattedDate',
                                ),

                                // Display Payment Amount
                                Text(
                                    '(-) \$${_formatNumber((payment.amount != null ? ((double.parse(payment.amount.toString()) * 100).roundToDouble() / 100).toString() : "0.0"))}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total: ", style: TextStyle(fontSize: 20)),
                        Text(
                          "\$${(double.parse(widget.invoice.total.toString()) * 100).roundToDouble() / 100}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
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
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text label above the TabBar
                Container(
                  width: double.infinity,
                  height: 36,
                  color: const Color.fromARGB(34, 130, 178, 255),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 17.0),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$${double.parse(widget.invoice.totalPaid.toString()).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          '  Payment Succesfull',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    height:
                        10), // Add some space between the text and the TabBar
                // Tab bar for SMS, EMAIL, BOTH
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const FaIcon(
                    FontAwesomeIcons.solidMoneyBill1,
                    size: 35,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    "Change: ",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "\$${double.parse(widget.invoice.changeReturn.toString()).toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ]),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "How Would you like your Reciept? ",
                      style: TextStyle(fontSize: 28),
                    )
                  ],
                ),

                const SizedBox(
                  height: 6,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor:
                          isPressed ? Colors.white : Constant.colorPurple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                        isPressed = true;
                      });

                      final path = await GenerateInvoice.printInvoice(
                          invoiceModel: widget.invoice);
                      log("invoice: pdf :${widget.invoice}");
                      await printPdf(path: path, context: context)
                          .whenComplete(() async {
                        await displayManager.transferDataToPresentation({
                          'type': 'discount',
                          'discount': TotalDiscountModel().toJson(),
                        });

                        final customer =
                            await CustomerBalanceService.getCustomerBalance(
                          context,
                          int.parse(widget.customerData!.id.toString()),
                        );
                        ListCustomerBloc customerListBloc =
                            BlocProvider.of<ListCustomerBloc>(context);
                        CustomerBloc customerBloc =
                            BlocProvider.of<CustomerBloc>(context);
                        customerBloc.add(customerListBloc.state.first);

                        CustomerBalanceBloc balanceBloc =
                            BlocProvider.of<CustomerBalanceBloc>(context);
                        balanceBloc.add(customer);
                      }).whenComplete(() => Navigator.pop(context));

                      setState(() {
                        isPressed = false; // Reset button state after action
                      });
                    },
                    child: Text(
                      'PRINT RECEIPT',
                      style: TextStyle(
                          color: isPressed
                              ? Constant.colorPurple
                              : Colors.white, // Change text color on press
                          fontSize: 20),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    if (mounted) {
                      setState(() {
                        _selectedTabIndex = index;
                        final currentCustomer =
                            context.read<CustomerBloc>().state;
                        if (currentCustomer != null) {
                          _updateCustomerData(currentCustomer);
                        }
                      });
                    }
                  },
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, // Make the text bold
                    fontSize: 16, // Adjust the font size if needed
                  ),
                  labelColor: Colors.black,
                  indicatorColor: Constant.colorPurple,
                  tabs: const [
                    Tab(text: 'SMS'),
                    Tab(text: 'EMAIL'),
                    Tab(text: 'BOTH'),
                  ],
                ),

                Flexible(
                  fit: FlexFit.loose,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      smsTab(widget.settingsData ?? const SettingsModel(),
                          widget.customerData ?? CustomerModel()),
                      emailTab(widget.settingsData ?? const SettingsModel(),
                          widget.customerData ?? CustomerModel()),
                      bothTab(widget.settingsData ?? const SettingsModel(),
                          widget.customerData ?? CustomerModel()),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Close Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8),
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constant.colorPurple,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'CLOSE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
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

      ListCustomerBloc customerListBloc =
          BlocProvider.of<ListCustomerBloc>(context);
      CustomerBloc customerBloc = BlocProvider.of<CustomerBloc>(context);
      customerBloc.add(customerListBloc.state.first);
      Navigator.pop(context);
      if (response['sms_sent'] == true) {
        ConstDialog(context)
            .showErrorDialog(error: 'SMS Invoice Sent Successfully');
      }
      if (response['email_sent'] == true) {
        ConstDialog(context)
            .showErrorDialog(error: 'Email Invoice Sent Successfully');
      }
      if (response['sms_sent'] == true && response['email_sent'] == true) {
        ConstDialog(context)
            .showErrorDialog(error: 'Email & SMS Invoice Sent Successfully');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errorof SMS: ${response['message']}')),
      );
    }
  }

// SMS Tab - Only phone number input field
  Widget smsTab(SettingsModel setting, CustomerModel customerData) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
          builder: (context, customer) {
            if (customerData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isEditable = setting.enableInvoiceSMS == "1";

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
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
                      height: 5,
                    ),
                    CustomInputField(
                      contentPadding: 12.0,
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                      controller: phoneController,
                      enabled: isEditable,
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
  Widget emailTab(SettingsModel setting, CustomerModel customerData) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
          builder: (context, customer) {
            if (customerData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isEditable = setting.enableInvoiceEmail == "1";

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
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
                      contentPadding: 12.0,
                      labelText: "Email Address",
                      hintText: "Email Address",
                      controller: emailAddressController,
                      enabled: isEditable,
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
  Widget bothTab(SettingsModel setting, CustomerModel customerData) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
          builder: (context, customer) {
            if (customerData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isEditable = setting.enableInvoiceEmail == "1" &&
                setting.enableInvoiceSMS == "1";

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
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
                      contentPadding: 12.0,
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                      controller: phoneController,
                      enabled: isEditable,
                    ),
                    const SizedBox(height: 10),
                    CustomInputField(
                      contentPadding: 12.0,
                      labelText: "Email Address",
                      hintText: "Email Address",
                      controller: emailAddressController,
                      enabled: isEditable,
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
                            // minimumSize: const Size(100, 50), // Set width and height
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
                                  'SEND SMS & EMAIL',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
