import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opalposinc/NewUi/Widgets/CustomMaterialWidget.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/expense/Expense_card.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/localDatabase/localDatabaseViewer.dart';
import 'package:opalposinc/pages/sell_retun.dart';
import 'package:opalposinc/services/sell_return.dart';
import 'package:opalposinc/settings/settingsScreen.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/calculator.dart';
import 'package:opalposinc/widgets/common/Top%20Section/register_details.dart';
import 'package:opalposinc/widgets/common/left%20Section/new_customer_form.dart';
import 'package:opalposinc/widgets/common/left%20Section/recent_sale.dart';
import 'package:opalposinc/widgets/common/left%20Section/suspended_sales.dart';

import '../widgets/common/Top Section/Bloc/CartBloc.dart';

class NewSideBar extends StatefulWidget {
  const NewSideBar({super.key});

  @override
  State<NewSideBar> createState() => _NewSideBarState();
}

class _NewSideBarState extends State<NewSideBar> {
  final returnInvoiceController = TextEditingController();
  String scanBarcode = 'Unknown';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 20.0, bottom: 20.0),
      child: Material(
        surfaceTintColor: Colors.transparent,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          children: [
            CustomMaterialWidget(onPressed: onIndex1, icon: Icons.attach_money),
            Decorations.height5,
            CustomMaterialWidget(onPressed: onIndex2, icon: Icons.undo_rounded),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: onIndex3, icon: FontAwesomeIcons.calculator),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: onIndex4, icon: FontAwesomeIcons.briefcase),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: onIndex6, icon: FontAwesomeIcons.tags),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: scanBarcodeNormal, icon: FontAwesomeIcons.camera),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: onAddCustomerPressed,
                icon: FontAwesomeIcons.userPlus),
            const Spacer(),
            BlocBuilder<LocalTransactionBlocBloc, LocalTransactionBlocState>(
              builder: (context, state) {
                if (state is TransactionUploadingState) {
                  return const CustomMaterialWidget(
                    onPressed: null,
                    child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator()),
                  );
                }

                return CustomMaterialWidget(
                    icon: Icons.save, onPressed: onMoveToViewDatabase);
              },
            ),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: onMoveToSettings, icon: FontAwesomeIcons.gear),
            Decorations.height5,
            CustomMaterialWidget(
                onPressed: onLogout, icon: FontAwesomeIcons.powerOff),
          ],
        ),
      ),
    );
  }

  onMoveToSettings() => Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => const SettingsScreen())));

  void onMoveToViewDatabase() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LocalDatabaseViewer()));
  }

  onLogout() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(CartClearProductEvent());
  }

  void scanBarcodeNormal() async {
    String barcodeScanRes;
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

    // if (!mounted) return;

    // setState(() {
    //   scanBarcode = barcodeScanRes;
    // });
  }

  onAddCustomerPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddNewCustomer();
      },
    );
  }

  void onIndex1() {
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return const ExpenseCard();
      },
    );
  }

  void onIndex2() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: const EdgeInsets.all(10.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Invoice Return',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 20,
                      color: Constant.colorPurple,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomInputField(
                labelText: 'Invoice No.',
                hintText: 'Invoice No.',
                controller: returnInvoiceController,
                onChanged: onReturnInvoiceChanged,
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(onPressed: _onSend, child: const Text('Send')),
            ],
          );
        });
  }

  void onIndex3() {
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return const Calculator();
      },
    );
  }

  void onIndex4() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RegisterDetils(
          forShow: true,
        );
      },
    );
  }

  void onIndex5() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SuspandedSales();
      },
    );
  }

  void onIndex6() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RecentSales();
      },
    );
  }

  void onReturnInvoiceChanged(String? value) => setState(() {});

  void onRecentSales() {}

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
}
