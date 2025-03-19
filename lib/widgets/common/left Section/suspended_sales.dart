// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/suspended_model.dart';
import 'package:opalposinc/model/suspended_sales_details.dart';
import 'package:opalposinc/services/delete_suspended_order.dart';
import 'package:opalposinc/services/suspended_order.dart';
import 'package:opalposinc/services/suspended_order_details.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';

import '../../../model/product.dart';
import '../Top Section/Bloc/CustomBloc.dart';

class SuspandedSales extends StatefulWidget {
  const SuspandedSales({super.key});

  @override
  _SuspandedSalesState createState() => _SuspandedSalesState();
}

class _SuspandedSalesState extends State<SuspandedSales> {
  List<SuspendedModel>? suspendedModels;
  bool isLoading = true;
  final SuspendedOrders _suspendedOrdersService = SuspendedOrders();

  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() async {
    try {
      final List<SuspendedModel> data =
          await _suspendedOrdersService.getSuspendedOrders(context);
      setState(() {
        suspendedModels = data;
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching suspended orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleEditIconPress(int index) async {
    try {
      final String transactionId = suspendedModels![index].id ?? '';
      final SuspendedDetails suspendedDetails =
          await SuspendedOrderDetails.getsuspendedorderdetails(
              context, transactionId);
      GetSuspenddetailsBloc suspendTransactionId =
          BlocProvider.of<GetSuspenddetailsBloc>(context);
      suspendTransactionId.add(transactionId);

      CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
      for (Product product in suspendedDetails.product!) {
        cartBloc.add(CartAddProductEvent(product));
        log(product.suspendId.toString());
      }

      Navigator.of(context).pop();

      log('Retrieved suspended order details: ${suspendedDetails.toJson()}');
    } catch (e) {
      log('Error fetching suspended order details: $e');
    }
  }

  void _handleDeleteIconPress(int index) async {
    try {
      final String transactionId = suspendedModels![index].id ?? '';
      log('message: $transactionId');
      await DeleteSuspendedOrder.deleteSunspendedOrder(context, transactionId);
      ConstDialog(context).showErrorDialog(
        error: 'Deleted Successfully',
        iconData: Icons.check_circle,
        iconColor: Colors.green,
        iconText: 'Success',
      );
      log('Delete suspended order details}');
    } catch (e) {
      log('Error fetching suspended order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Suspended Sale',
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
              ),
              SizedBox(
                height: isMobile ? 10 : 20,
              ),
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : suspendedModels != null && suspendedModels!.isNotEmpty
                        ? Container(
                            height: isMobile
                                ? MediaQuery.of(context).size.height * 0.88
                                : MediaQuery.of(context).size.height * 0.75,
                            width: isMobile
                                ? MediaQuery.of(context).size.width * 100
                                : MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(20),
                            child: ListView.builder(
                              itemCount: suspendedModels!.length,
                              itemBuilder: (context, index) {
                                final reversedList = suspendedModels!.reversed
                                    .toList(); // Reverse the list
                                final suspendedModel = reversedList[
                                    index]; // Access reversed items
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Constant.colorGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: isMobile
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Image.asset(
                                                      'assets/images/suspend.jpg',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Suspend Note: ${suspendedModel.suspendNote ?? ''}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      'Customer Name: ${suspendedModel.customerName ?? ''}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      'Invoice No: ${suspendedModel.invoiceNo ?? ''}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      'Date: ${suspendedModel.transactionDate ?? ''}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      _handleEditIconPress(
                                                          index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 30,
                                                      color: Color(0xff4f55a5),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // Show confirmation dialog
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            title: const Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .warning_rounded,
                                                                  color: Colors
                                                                      .yellow,
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text('Alert'),
                                                              ],
                                                            ),
                                                            content: const Text(
                                                              'Are you Sure?',
                                                              style:
                                                                  TextStyle(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  _handleDeleteIconPress(
                                                                      index);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: ListTile(
                                            leading: Image.asset(
                                              'assets/images/suspend.jpg',
                                              width: isMobile ? 50 : 100,
                                              height: isMobile ? 50 : 100,
                                            ),
                                            title: Container(
                                              decoration: const BoxDecoration(),
                                              child: const Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Suspend Note',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Customer Name',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Invoice No.',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Date',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    suspendedModel
                                                            .suspendNote ??
                                                        '',
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    suspendedModel
                                                            .customerName ??
                                                        '',
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    suspendedModel.invoiceNo ??
                                                        '',
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    suspendedModel
                                                            .transactionDate ??
                                                        '',
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    _handleEditIconPress(index);
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 30,
                                                    color: Color(0xff4f55a5),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    // Show confirmation dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          title: const Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .warning_rounded,
                                                                color: Colors
                                                                    .yellow,
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Text('Alert'),
                                                            ],
                                                          ),
                                                          content: const Text(
                                                            'Are you Sure?',
                                                            style: TextStyle(),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                _handleDeleteIconPress(
                                                                    index);
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 30,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                );
                              },
                            ),
                          )
                        : const Text(
                            'No Suspended Sales',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ShowDialog() {
    return SimpleDialog(
        insetPadding: const EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        children: const [
          Column(children: [Text('afffs')])
        ]);
  }
}
