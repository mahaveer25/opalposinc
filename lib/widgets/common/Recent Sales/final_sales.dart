// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/CustomFuncs.dart';
import 'package:opalsystem/MobileView/sellreturnMobile.dart';
import 'package:opalsystem/invoices/InvoiceModel.dart';
import 'package:opalsystem/model/recent_sales_model.dart';
import 'package:opalsystem/multiplePay/MultiplePay.dart';
import 'package:opalsystem/pages/sell_retun.dart';
import 'package:opalsystem/services/edit_recent_sale.dart';
import 'package:opalsystem/services/recent_sale_service.dart';
import 'package:opalsystem/services/sell_return.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalsystem/printing.dart';

import '../../../invoices/GenerateInvoice.dart';

class FinalSale extends StatefulWidget {
  const FinalSale({super.key});

  @override
  State<FinalSale> createState() => _FinalSaleState();
}

class _FinalSaleState extends State<FinalSale> with PrintPDF {
  List<RecentSalesModel>? recentModel;
  final RecenetSalesService recentSale = RecenetSalesService();
  bool isLoading = true;
  // bool isLoadingIcon = true;
  late String type;
  @override
  void initState() {
    onInit();
    // _handlePrintIconPress();
    super.initState();
  }


  int loadingIndex=-1;

  void _startLoading(int index){
    setState(() {
      loadingIndex=index;
    });

  }

  onInit() async {
    try {
      final List<RecentSalesModel> data = await recentSale.getRecentSales(context, type = 'sell');
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


  void _onSend(int index, bool isMobile) async {
    try {
      InvoiceModel? sellReturn = await SellReturnService.getSellRetrunDetails(
              context, recentModel?[index].invoice)
          .whenComplete(() => Navigator.of(context).pop());

      if (sellReturn != null) {

        !isMobile
            ? showDialog(
                context: context,
                builder: (context) {
                  return SellReturn(returnsale: sellReturn);
                })
            : Navigator.push(context, MaterialPageRoute(builder: (context) => SellReturnMobile(returnsale: sellReturn,)));
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      log('Error fetching suspended order details: $e');
    }
    finally{
      setState(() {
        loadingIndex=-1;
      });
    }
  }

  // void _handleEditIconPress(int index) async {
  //   try {
  //     final SuspendedDetails suspendedDetails =
  //         await SuspendedOrderDetails.getsuspendedorderdetails(
  //             context, recentModel![index].transactionId);

  //     CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
  //     for (Product product in suspendedDetails.Product!) {
  //       cartBloc.add(CartAddProductEvent(product));
  //       log(product.suspendId.toString());
  //     }

  //     Navigator.of(context).pop();

  //     log('Retrieved suspended order details: ${suspendedDetails.toJson()}');
  //   } catch (e) {
  //     log('Error fetching suspended order details: $e');
  //   }
  // }

  // void _handleDeleteIconPress(int index) async {
  //   try {
  //     final String transactionId = recentModel![index].transactionId ?? '';
  //     log('TransID: $transactionId');

  //     await DeleteRecentSell.deleteRecentSell(context, transactionId, 'sell');
  //     ConstDialog(context).showErrorDialog(
  //       error: 'Deleted Successfully',
  //       iconData: Icons.check_circle,
  //       iconColor: Colors.green,
  //       iconText: 'Success',
  //     );
  //     log('Delete suspended order details}');
  //   } catch (e) {
  //     log('Error fetching suspended order details: $e');
  //   }
  // }
  void _openPdf(int index) async {
    try {
      final String transactionId = recentModel![index].transactionId ?? '';
      if (transactionId.isEmpty) {
        return;
      }

      await RecentOrderPrint.getrecentorderprint(context, transactionId)
          .then((result) async {
        result.fold((invoice) async {
          log('Invoice Data: ${invoice.toJson()}');
          print('Invoice Data: ${invoice.toJson()}');

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
      print('Error fetching Recent saler order details: $e');
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
        result.fold((invoice) async {
          log('Invoice Data: ${invoice.toJson()}');
          print('Invoice Data: ${invoice.toJson()}');
          final path =
              await GenerateInvoice.printInvoice(invoiceModel: invoice);
          print('PDF Path: $path');
          log('PDF Path: $path');
          await printPdf(path: path, context: context);
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => PdfPreviewPage(
          //       invoice: invoice,
          //       openFrom: 'invoice',
          //     )));
        }, (error) {
          ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
        });
      });
    } catch (e) {
      print('Error fetching Recent saler order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(
      builder: (context, isMobile) {
        final style = isMobile
            ? const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              )
            : const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              );
        return Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : recentModel != null && recentModel!.isNotEmpty
                  ? Container(
                      height: isMobile
                          ? MediaQuery.of(context).size.height * 0.8
                          : MediaQuery.of(context).size.height * 0.8,
                      width: isMobile
                          ? MediaQuery.of(context).size.width * 0.95
                          : MediaQuery.of(context).size.width * 0.8,
                      padding: isMobile ? null : const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: recentModel!.length,
                        itemBuilder: (context, index) {
                          final recent = recentModel![index];
                          recentModel![index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            height: isMobile ? 120 : 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Constant.colorGrey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: isMobile
                                ? Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Image.asset(
                                              'assets/images/recent.png',
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
                                              'Name: ${recent.invoiceNo ?? ''}',
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              child: Text(
                                                'Total: ${recent.finalTotal ?? ''}',
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            SizedBox(
                                              child: Text(
                                                'Invoice No: ${recent.offlineInvoiceNo == "null" ? recent.invoice.toString() : recent.offlineInvoiceNo ?? ''}',
                                                textAlign: TextAlign.start,
                                              ),
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
                                              onPressed: () {
                                                _onSend(index, isMobile);
                                              },
                                              icon: Icon(
                                                Icons.undo_rounded,
                                                size: 30,
                                                color: Constant.colorPurple,
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
                                      )
                                    ],
                                  )
                                : ListTile(
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    dense: isMobile ? true : false,
                                    leading: Image.asset(
                                      'assets/images/recent.png',
                                      width: isMobile ? 30 : 80,
                                      height: isMobile ? 100 : 150,
                                    ),
                                    title: Container(
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: isMobile ? 60 : 120,
                                            child: const Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: isMobile ? 60 : 120,
                                            child: Text(
                                              recent.offlineInvoiceNo ==
                                                          "null" ||
                                                      recent.offlineInvoiceNo ==
                                                          null
                                                  ? 'Invoice No'
                                                  : 'Offline Id',
                                              style: const TextStyle(
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
                                        SizedBox(
                                          width: isMobile ? 60 : 120,
                                          child: Text(
                                            recent.finalTotal ?? '',
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(
                                          width: isMobile ? 60 : 120,
                                          child: SelectableText(
                                            recent.offlineInvoiceNo == "null" ||
                                                    recent.offlineInvoiceNo ==
                                                        null
                                                ? recent.invoice.toString()
                                                : recent.offlineInvoiceNo ?? '',
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [



                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: (loadingIndex!=index )?IconButton(
                                              onPressed: () {
                                                _startLoading(index);
                                                _onSend(index, isMobile);

                                              },
                                              icon: Icon(
                                                Icons.undo_rounded,
                                                size: 30,
                                                color: Constant.colorPurple,
                                              )) :
                                          CupertinoActivityIndicator(color: Constant.colorPurple,),
                                        ),



                                        // IconButton(
                                        //     onPressed: () {
                                        //       _handleEditIconPress(index);
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.edit,
                                        //       size: 30,
                                        //       color: Constant.colorPurple,
                                        //     )),
                                        // IconButton(
                                        //     onPressed: () {
                                        //       showDialog(
                                        //         context: context,
                                        //         builder: (BuildContext context) {
                                        //           return AlertDialog(
                                        //             shape: RoundedRectangleBorder(
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(10)),
                                        //             title: const Row(
                                        //               children: [
                                        //                 Icon(
                                        //                   Icons.dangerous_sharp,
                                        //                   color: Colors.red,
                                        //                 ),
                                        //                 SizedBox(width: 8),
                                        //                 Text('Alert'),
                                        //               ],
                                        //             ),
                                        //             content: const Text(
                                        //               'Are you Sure?',
                                        //               style: TextStyle(),
                                        //               textAlign: TextAlign.center,
                                        //             ),
                                        //             actions: [
                                        //               TextButton(
                                        //                 onPressed: () {
                                        //                   Navigator.of(context).pop();
                                        //                 },
                                        //                 child: const Text('No'),
                                        //               ),
                                        //               TextButton(
                                        //                 onPressed: () {
                                        //                   _handleDeleteIconPress(index);
                                        //                 },
                                        //                 child: const Text('Yes'),
                                        //               ),
                                        //             ],
                                        //           );
                                        //         },
                                        //       );
                                        //     },
                                        //     icon: const Icon(
                                        //       Icons.delete,
                                        //       size: 30,
                                        //       color: Colors.red,
                                        //     )),
                                        IconButton(
                                            onPressed: () {
                                              _handlePrintIconPress(index);
                                            },
                                            icon: Icon(
                                              Icons.print_rounded,
                                              size: 30,
                                              color: Constant.colorPurple,
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              _openPdf(index);
                                            },
                                            icon: Icon(
                                              Icons.inventory_rounded,
                                              size: 30,
                                              color: Constant.colorPurple,
                                            )),
                                      ],
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
      },
    );
  }
}
