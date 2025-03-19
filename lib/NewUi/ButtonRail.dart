// ignore_for_file: unused_field, unrelated_type_equality_checks

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opalposinc/NewUi/Widgets/invoice_return_popup.dart';
import 'package:opalposinc/ReportsTab/TabView.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/expense/Expense_card.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/localDatabase/localDatabaseViewer.dart';

import 'package:opalposinc/pages/sell_retun.dart';
import 'package:opalposinc/services/sell_return.dart';
import 'package:opalposinc/settings/settingsScreen.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/views/paxDevice.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/calculator.dart';
import 'package:opalposinc/widgets/common/left%20Section/recent_sale.dart';
import 'package:opalposinc/widgets/common/left%20Section/slide_image_pick.dart';
import 'package:opalposinc/widgets/common/left%20Section/suspended_sales.dart';

import '../model/setttings.dart';
import '../widgets/common/Top Section/Bloc/ProductBloc.dart';
import '../widgets/common/Top Section/register_details.dart';

class ButtonRails extends StatefulWidget {
  const ButtonRails({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonRails();
}

class _ButtonRails extends State<ButtonRails> {
  int selectedIndex = 0;
  final returnInvoiceController = TextEditingController();
  final String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
      builder: (context, settings) {
        return railHomeBar(
          destinations: _buildDestinations(settings),
          selectedIndex: selectedIndex,
        );
      },
    );
  }

  List<NavigationRailDestination> _buildDestinations(SettingsModel? settings) {
    List<NavigationRailDestination> destinations = [
      NavigationRailDestination(
          icon: Icon(Icons.attach_money_outlined, color: Constant.colorPurple),
          label: const Text('scan')),
      NavigationRailDestination(
          icon: Icon(Icons.undo_rounded, color: Constant.colorPurple),
          label: const Text('scan')),
      NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.calculator, color: Constant.colorPurple),
          label: const Text('calculate')),
      NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.briefcase, color: Constant.colorPurple),
          label: const Text('briefcase')),
      NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.tags, color: Constant.colorPurple),
          label: const Text('tags')),
      NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.image, color: Constant.colorPurple),
          label: const Text('Slide')),
      NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.creditCard, color: Constant.colorPurple),
          label: const Text('Pax Device')),
    ];

    // Conditional destination based on settings
    if (settings!.posSettings!.disableSuspend == null) {
      log("setting: ${settings.posSettings!.disableSuspend}");
      destinations.add(NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.pause, color: Constant.colorPurple),
          label: const Text('suspend')));
    }
    return destinations;
  }

  Widget railHomeBar(
      {required List<NavigationRailDestination> destinations,
      required int selectedIndex}) {
    return SizedBox(
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: NavigationRail(
                useIndicator: false,
                // elevation: 8.0,
                trailing: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // IconButton(
                      //     icon: const Icon(FontAwesomeIcons.file),
                      //     onPressed: onReports),

                      // IconButton(
                      //   icon: Icon(
                      //     Icons.dashboard,
                      //     color: Constant.colorPurple,
                      //   ),
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      BlocBuilder<LocalTransactionBlocBloc,
                          LocalTransactionBlocState>(
                        builder: (context, state) {
                          if (state is TransactionUploadingState) {
                            return const IconButton(
                              icon: SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator()),
                              onPressed: null,
                            );
                          }

                          return IconButton(
                              icon: Image.asset(
                                'assets/images/offlineicon.jpg', // Path to your WebP image
                                width: 30, // Adjust size as needed
                                // height: 40,
                              ),
                              onPressed: onMoveToViewDatabase);
                        },
                      ),
                      // IconButton(
                      //     icon: Icon(FontAwesomeIcons.gear,
                      //         color: Constant.colorPurple),
                      //     onPressed: onMoveToSettings),
                      // IconButton(
                      //     icon: Icon(
                      //       FontAwesomeIcons.cameraAlt,
                      //       color: Constant.colorPurple,
                      //     ),
                      //     onPressed: scanBarcodeNormal),
                      IconButton(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Constant.colorPurple,
                        ),
                        onPressed: onLogout,
                      ),
                    ],
                  ),
                ),
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected),
          )
        ],
      ),
    );
  }

  onMoveToSettings() => Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => const SettingsScreen())));

  onAddCustomerPressed() async {}

  onLogout() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));

    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);

    cartBloc.add(CartClearProductEvent());
    // Reset ProductBloc
    productBloc.add(ProductResetEvent());
    PaxDeviceBloc paxDeviceBloc = BlocProvider.of<PaxDeviceBloc>(context);
    ListPaxDevicesBloc listPaxDevicesBloc =
        BlocProvider.of<ListPaxDevicesBloc>(context);
    paxDeviceBloc.add(PaxDeviceEvent(device: null));
    listPaxDevicesBloc.add([]);
    log("ProductBloc has been reset.");
  }

  void scanBarcodeNormal() async {
    // String barcodeScanRes;
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

    if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }

  onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) onIndex1(context);
    if (index == 1) onIndex2();
    if (index == 2) onIndex3();
    if (index == 3) onIndex4();
    if (index == 7) onIndex5();
    if (index == 4) onIndex6();
    if (index == 5) onIndex7();
    if (index == 6) onIndex8();
  }

  void _onSend() async {
    try {
      InvoiceModel? sellReturn = await SellReturnService.getSellRetrunDetails(
          context, returnInvoiceController.text);

      if (sellReturn != null) {
        showDialog(
            context: context,
            builder: (context) {
              return SellReturn(returnsale: sellReturn);
            });
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      log('Error fetching suspended order details: $e');
    }
  }

  void onIndex1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: ExpenseCard(),
            ),
          ),
        );
      },
    );
  }

  void onIndex2() {
    showDialog(
        context: context,
        builder: (context) {
          return InvoiceReturnPopup(
              returnInvoiceController: returnInvoiceController,
              onPressed: _onSend);
          // return SimpleDialog(
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0)),
          //   contentPadding: const EdgeInsets.all(10.0),
          //   clipBehavior: Clip.hardEdge,
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         const Text(
          //           'Invoice Return',
          //           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          //         ),
          //         IconButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           icon: Icon(
          //             Icons.cancel_rounded,
          //             size: 20,
          //             color: Constant.colorPurple,
          //           ),
          //         )
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 20.0,
          //     ),
          //     CustomInputField(
          //       labelText: 'Invoice No.',
          //       hintText: 'Invoice No.',
          //       controller: returnInvoiceController,
          //       // onChanged: onReturnInvoiceChanged,
          //     ),
          //     const SizedBox(
          //       height: 10.0,
          //     ),
          //     ElevatedButton(onPressed:_onSend, child: const Text('Send')),
          //   ],
          // );
        });
  }

  void onIndex3() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Dialog(
                backgroundColor: Colors.black54,
                shadowColor: Colors.black,
                alignment: Alignment.centerLeft,
                insetPadding: const EdgeInsets.only(
                    right: 850, left: 100, top: 50, bottom: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                child: const Calculator()));
      },
    );
  }

  void onIndex4() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: RegisterDetils(
                  forShow: true,
                ),
              ),
            ));
      },
    );
  }

  void onIndex5() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: SuspandedSales(),
            ),
          ),
        );
      },
    );
  }

  void onIndex7() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: SlideImagePick(),
            ),
          ),
        );
      },
    );
  }

  void onIndex8() {
    showDialog(
        context: context,
        builder: (context) {
          return const PaxDeviceRailWidget();
        });
  }

  void onIndex6() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: RecentSales(),
            ),
          ),
        );
      },
    );
  }

  // void onReturnInivoice() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const SellReturn();
  //     },
  //   );
  // }

  void onReturnInvoiceChanged(String? value) {}

  void onReports() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TabView()));
  }

  void onMoveToViewDatabase() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LocalDatabaseViewer()));
  }
}
