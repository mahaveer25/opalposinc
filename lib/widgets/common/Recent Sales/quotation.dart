import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:opalsystem/CustomFuncs.dart';
import 'package:opalsystem/model/recent_sales_model.dart';
import 'package:opalsystem/multiplePay/MultiplePay.dart';
import 'package:opalsystem/services/delete_recent_sale.dart';
import 'package:opalsystem/services/edit_recent_sale.dart';
import 'package:opalsystem/services/recent_sale_service.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/constants.dart';

class QuotationSale extends StatefulWidget {
  const QuotationSale({super.key});

  @override
  State<QuotationSale> createState() => _QuotationSaleState();
}

class _QuotationSaleState extends State<QuotationSale> {
  List<RecentSalesModel>? recentModel;
  final RecenetSalesService recentSale = RecenetSalesService();
  bool isLoading = true;
  late String type;
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    try {
      final List<RecentSalesModel> data =
          await recentSale.getRecentSales(context, type = 'quotation');
      if (mounted) {
        setState(() {
          recentModel = data;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching suspended orders: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handleDeleteIconPress(int index) async {
    try {
      final String transactionId = recentModel![index].transactionId ?? '';
      log('TransID: $transactionId');

      await DeleteRecentSell.deleteRecentSell(context, transactionId, 'sell');
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

  void _handlePrintIconPress(int index) async {
    try {
      final String transactionId = recentModel![index].transactionId ?? '';
      if (transactionId.isEmpty) {
        return;
      }

      await RecentOrderPrint.getrecentorderprint(context, transactionId)
          .then((result) async {
        result.fold((invoice) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PdfPreviewPage(
                    invoice: invoice,
                    openFrom: 'invoice',
                  )));
        }, (error) {
          ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
        });
      });
    } catch (e) {
      log('Error fetching Recent saler order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator() // Show loader while data is loading
          : recentModel != null && recentModel!.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: recentModel!.length,
                    itemBuilder: (context, index) {
                      final recent = recentModel![index];
                      recentModel![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Constant.colorGrey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/recent.png',
                              width: 150,
                              height: 150,
                            ),
                            title: Container(
                              decoration: const BoxDecoration(),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    recent.invoiceNo ?? '',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    recent.finalTotal ?? '',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Constant.colorPurple,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: const Row(
                                              children: [
                                                Icon(
                                                  Icons.dangerous_sharp,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 8),
                                                Text('Alert'),
                                              ],
                                            ),
                                            content: const Text(
                                              'Are you Sure?',
                                              style: TextStyle(),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _handleDeleteIconPress(index);
                                                },
                                                child: const Text('Yes'),
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
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _handlePrintIconPress(index);
                                    },
                                    icon: Icon(
                                      Icons.print_rounded,
                                      size: 30,
                                      color: Constant.colorPurple,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Text(
                  'No Recent Transaction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
    );
  }
}
