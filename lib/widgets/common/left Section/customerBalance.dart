// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/CustomerModel.dart';
import 'package:opalsystem/model/customer_balance.dart';
import 'package:opalsystem/multiplePay/MultiplePay.dart';
import 'package:opalsystem/multiplePay/PaymentListMethod.dart';
import 'package:opalsystem/services/customer_balance.dart';
import 'package:opalsystem/utils/commonFunction.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class CustomerBalance extends StatefulWidget {
  const CustomerBalance({super.key});

  @override
  State<CustomerBalance> createState() => _CustomerBalanceState();
}

class _CustomerBalanceState extends State<CustomerBalance> {
  final CustomerBalanceService customerService = CustomerBalanceService();
  List<CustomerBalanceModel>? customerBalance;
  late String customerbalance;
  PaymentListMethod listMethods = PaymentListMethod();

  @override
  Widget build(BuildContext context) {
    return customerBalanceWidget();
  }

  Widget customerBalanceWidget() => BlocBuilder<CustomerBloc, CustomerModel?>(
        builder: (context, selectedCustomer) {
          if (selectedCustomer == null) {
            return const Text('No customer selected');
          }
          return BlocBuilder<CustomerBalanceBloc, CustomerBalanceModel?>(
            builder: (context, customerBalance) {
              return FutureBuilder<CustomerBalanceModel>(
                future: CustomerBalanceService.getCustomerBalance(
                  context,
                  int.parse(selectedCustomer.id ?? ''),
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<CustomerBalanceModel> snapshot) {

                  double customerBalance=CommonFunctions.roundNumber(double.parse(snapshot.data?.balance??"0.0"), 1);
                  log("This is customerBalance: ${customerBalance}");
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  // double Balance = double.parse(snapshot.data!.balance.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: 0,
                      height: 0,
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('');
                  } else if (
                      // snapshot.hasData &&
                      //   snapshot.data != null &&
                      //   snapshot.data!.name

                      selectedCustomer.id != '1' && customerBalance!=0) {
                    customerbalance = snapshot.data!.balance!;
                    return Row(
                      children: [
                        Text(double.parse(customerbalance).toStringAsFixed(2),
                            style: const TextStyle(color: Constant.colorRed)),
                        // IconButton(
                        //     padding: const EdgeInsets.all(2.0),
                        //     onPressed: onCustomerPay,
                        //     icon: Icon(
                        //       Icons.price_change,
                        //       color: Constant.colorPurple,
                        //     )),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          );
        },
      );

  void onCustomerPay() {
    showDialog(
        context: context,
        builder: ((context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text(
                          'Add Payment',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close))
                      ]),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: const Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Text('Customer Name: ${'Mr. Kashan'}'),
                            ),
                          )),
                          const SizedBox(width: 10.0),
                          Expanded(
                              child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(5.0),
                            child: const Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Total Sale: ${'3,0332.22'}'),
                                  Text('Total Paid: ${'3,0332.22'}'),
                                  Text('Total Sale Due: ${'3,0332.22'}'),
                                  Text('Opening Balance: ${'3,0332.22'}'),
                                  Text('Opening Balance Due: ${'3,0332.22'}'),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      MethodTypeWidget(paymentMethod: listMethods),
                      const SizedBox(height: 20.0),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.white),
                                    backgroundColor: WidgetStateProperty.all(
                                        Constant.colorPurple)),
                                onPressed: () {},
                                child: const Text('Save')),
                            const SizedBox(
                              width: 5.0,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'))
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
