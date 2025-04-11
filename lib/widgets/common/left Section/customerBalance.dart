// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/customer_balance.dart';
import 'package:opalposinc/multiplePay/MultiplePay.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/services/customer_balance.dart';
import 'package:opalposinc/utils/commonFunction.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class CustomerBalance extends StatefulWidget {
  const CustomerBalance({super.key});

  @override
  State<CustomerBalance> createState() => _CustomerBalanceState();
}

class _CustomerBalanceState extends State<CustomerBalance> {
  final CustomerBalanceService customerService = CustomerBalanceService();
  PaymentListMethod listMethods = PaymentListMethod();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerModel?>(
      builder: (context, selectedCustomer) {
        if (selectedCustomer == null) {
          return const Text('No customer selected');
        }
        return FutureBuilder<CustomerBalanceModel>(
          future: CustomerBalanceService.getCustomerBalance(
            context,
            int.tryParse(selectedCustomer.id ?? '') ?? 0,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return const SizedBox();
            }

            double customerBalance = CommonFunctions.roundNumber(
              double.tryParse(snapshot.data?.balance ?? "0") ?? 0,
              1,
            );
            log("Customer Balance: \$customerBalance");

            if (selectedCustomer.id != '1' && customerBalance != "0") {
              return Text(
                customerBalance.toStringAsFixed(2),
                style: const TextStyle(color: Constant.colorRed),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

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
