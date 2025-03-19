import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/NewUi/Widgets/CustomButton.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/multiplePay/MultiplePay.dart';
import 'package:opalposinc/services/draft_post.dart';
import 'package:opalposinc/services/quatation-Post.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/suspended_note.dart';

class CustomPaymentBar extends StatelessWidget {
  final double itemTotal;
  final int quantities;
  final TaxModel taxModel;
  final Transaction transaction;
  const CustomPaymentBar({
    super.key,
    required this.itemTotal,
    required this.quantities,
    required this.taxModel,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                BlocBuilder<IsMobile, bool>(
                  builder: (context, isMobile) {
                    return BlocBuilder<CheckConnection, bool>(
                        builder: (context, connection) {
                      if (connection) {
                        LocalTransactionBlocBloc bloc =
                            BlocProvider.of<LocalTransactionBlocBloc>(context);
                        bloc.add(CheckTransactionEvent(context: context));

                        return Expanded(
                          child: CustomButton(
                            text: 'Payments',
                            onTap: () =>
                                onPay(context: context, isMobile: isMobile),
                            elevation: 5.0,
                            backgroundColor: Colors.green.shade700,
                            textColor: Colors.white,
                            radius: 0.0,
                          ),
                        );
                      }

                      return Expanded(
                        child: CustomButton(
                          text: 'Save Locally',
                          onTap: () =>
                              onPay(context: context, isMobile: isMobile),
                          elevation: 5.0,
                          backgroundColor: Colors.deepOrange,
                          textColor: Colors.white,
                          radius: 0.0,
                        ),
                      );
                    });
                  },
                ),
                Decorations.width5,
                draftDrop(transaction: transaction),
                Decorations.width5,
                suspendDrop(transaction: transaction),
                Decorations.width5,
                quotationDrop(transaction: transaction),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget draftDrop({required Transaction transaction}) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(builder: (context, state) {
      if (int.parse(state!.posSettings!.disableDraft.toString()) == 1) {
        return Container();
      }

      return Expanded(
        child: CustomButton(
          text: 'Draft',
          onTap: () => onDraft(context: context, transaction: transaction),
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          elevation: 5.0,
          radius: 0.0,
        ),
      );
    });
  }

  Widget suspendDrop({required Transaction transaction}) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: ((context, state) {
      if (state?.posSettings?.disableSuspend != null) {
        return Container();
      }

      return Expanded(
        child: CustomButton(
          text: 'Suspended',
          onTap: () => onSuspend(context: context, transaction: transaction),
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          elevation: 5.0,
          radius: 0.0,
        ),
      );
    }));
  }

  Widget quotationDrop({required Transaction transaction}) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: ((context, state) {
      if (int.parse(state!.posSettings!.disableDraft.toString()) == 1) {
        return Container();
      }

      return Expanded(
        child: CustomButton(
          text: 'Quotation',
          onTap: () => onQuotation(context: context, transaction: transaction),
          elevation: 5.0,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          radius: 0.0,
        ),
      );
    }));
  }

  onPay({required BuildContext context, required bool isMobile}) {
    if (quantities <= 0) {
      ConstDialog(context).showErrorDialog(error: 'Cart is an empty');
    } else {
      if (isMobile) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MultiplePayUi(
                  amountWithOutTax: itemTotal,
                  totalAmount: itemTotal,
                  totalItems: quantities,
                  selectedPay: 'Card',
                  totalAmountBeforeDisc:
                      transaction.totalAmountBeforeTax!.toDouble(),
                )));
      } else {
        showDialog(
            context: context,
            builder: (context) => SimpleDialog(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: MultiplePayUi(
                        amountWithOutTax: itemTotal,
                        totalAmount: itemTotal,
                        totalItems: quantities,
                        selectedPay: 'Cash',
                        totalAmountBeforeDisc:
                            transaction.totalAmountBeforeTax!.toDouble(),
                      ),
                    )
                  ],
                ));
      }
    }
  }

  onQuotation(
      {required BuildContext context, required Transaction transaction}) async {
    if (quantities <= 0) {
      ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
    } else {
      await PostQuatationService.placeOrder(transaction)
          .then((result) => result.fold((left) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PdfPreviewPage(
                              invoice: left,
                              openFrom: 'quotation',
                            )))
                    .whenComplete(() {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(CartClearProductEvent());
                });
              }, (error) {
                ErrorFuncs(context)
                    .errRegisterClose(errorInfo: {'info': error});
              }));
    }
  }

  onSuspend({required BuildContext context, required Transaction transaction}) {
    if (quantities <= 0) {
      ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
    } else {
      showDialog(
        barrierColor: Colors.black87,
        context: context,
        builder: (BuildContext context) {
          return const SuspendedNoteDailog();
        },
      );
    }
  }

  onDraft(
      {required BuildContext context, required Transaction transaction}) async {
    if (quantities <= 0) {
      ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
    } else {
      await PostDraftService.postDraft(transaction)
          .then((result) => result.fold((left) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PdfPreviewPage(
                              invoice: left,
                              openFrom: 'quotation',
                            )))
                    .whenComplete(() {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(CartClearProductEvent());
                });
              }, (error) {
                ErrorFuncs(context)
                    .errRegisterClose(errorInfo: {'info': error});
              }));
    }
  }
}
