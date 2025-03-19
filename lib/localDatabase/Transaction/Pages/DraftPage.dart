import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalsystem/connection.dart';
import 'package:opalsystem/invoices/transaction.dart';
import 'package:opalsystem/localDatabase/Invoices/LocalDatabaseInvoices.dart';
import 'package:opalsystem/localDatabase/Transaction/Bloc/darftBloc/local_draft_bloc.dart';
import 'package:opalsystem/multiplePay/MultiplePay.dart';
import 'package:opalsystem/multiplePay/PaymentListMethod.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/decorations.dart';
import 'package:opalsystem/widgets/CustomWidgets.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({super.key});

  @override
  State<DraftPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<DraftPage> {
  bool isSyncing = false;

  @override
  void initState() {
    LocalDraftBloc bloc = BlocProvider.of<LocalDraftBloc>(context);
    bloc.add(GetDraftEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalDraftBloc, LocalDraftState>(
        builder: (context, state) {
      if (state is DraftLoadingState) {
        LoggedInUserBloc loggedInUserBloc =
            BlocProvider.of<LoggedInUserBloc>(context);
        return Center(
          child: CircularProgressIndicator(
            color: Color(int.parse(loggedInUserBloc.state!.color.toString())),
            strokeWidth: 5.0,
          ),
        );
      }
      return buildGridView(list: state.listTransaction, draftApiState: state);
    });
  }

  Widget buildGridView(
          {required List<Transaction> list,
          required LocalDraftState draftApiState}) =>
      BlocBuilder<CheckConnection, bool>(
        builder: (context, state) {
          list = list.reversed.toList();
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                    child: draftApiState is DraftLoadingState
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemBuilder: ((context, index) {
                              Transaction transaction = list[index];
                              DateTime date = DateTime.parse(
                                  transaction.transactionDate.toString());
                              String formattedDate =
                                  DateFormat('yyyy/MM/dd').format(date);

                              final payments = transaction.payment
                                  ?.map((e) => PaymentListMethod.fromJson(e))
                                  .toList();

                              final method = payments?.map((e) => e.method);

                              return Material(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 5.0,
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // IconButton(
                                        //     onPressed: () {
                                        //       LocalDraftBloc bloc =
                                        //           BlocProvider.of<LocalDraftBloc>(
                                        //               context);
                                        //       bloc.add(RemoveTransactionEvent(
                                        //           offlineTransactionId:
                                        //               transaction.offlineInvoiceNo));
                                        //     },
                                        //     icon: const Icon(Icons.close))
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Decorations.height10,
                                            CustomRichText(
                                                textBefore:
                                                    'Offline Invoice Id: ',
                                                textAfter: transaction
                                                    .offlineInvoiceNo
                                                    .toString()),
                                            Decorations.height10,
                                            CustomTextWidget(
                                                text:
                                                    'Product: ${transaction.product?.length}'),
                                            Decorations.height10,
                                            const CustomTextWidget(
                                                text: 'Paying Through: '),
                                            Text('$method'),
                                            const Spacer(),
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Constant.colorPurple
                                                  .withOpacity(0.05),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  children: [
                                                    CustomTextWidget(
                                                        text:
                                                            'Total Amount : ${transaction.totalAmountBeforeTax?.toStringAsFixed(2)}'),
                                                    CustomTextWidget(
                                                        text:
                                                            'Invoice Discount : ${transaction.discountAmount?.toStringAsFixed(2)}'),
                                                    CustomTextWidget(
                                                        text:
                                                            'Invoice Tax : ${transaction.taxCalculationAmount?.toStringAsFixed(2)}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Decorations.height15,
                                            Text(
                                              'Ordered On: $formattedDate',
                                              style: const TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: state
                                          ? () =>
                                              onUploadSingleEntry(transaction)
                                          : null,
                                      tileColor: state
                                          ? Constant.colorPurple
                                          : Colors.deepOrange.shade600,
                                      dense: true,
                                      title: Center(
                                        child: Center(
                                          child: draftApiState
                                                  is DraftLoadingState
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  state
                                                      ? 'Upload Entry'
                                                      : 'No Internet',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () => onmakeInvoice(transaction),
                                      tileColor:
                                          Constant.colorPurple.withOpacity(0.2),
                                      dense: true,
                                      title: Center(
                                          child: Icon(
                                        Icons.print,
                                        color: Constant.colorPurple,
                                      )),
                                    )
                                  ],
                                ),
                              );
                            }),
                            itemCount: list.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    mainAxisExtent: 340),
                          )),
              ],
            ),
            // floatingActionButton: Builder(
            //   builder: (context) {
            //     if (!state) return Container();

            //     return FloatingActionButton.extended(
            //       onPressed: () => syncAll(list),
            //       label: const Text('Sync All Transactions'),
            //       icon: const Icon(Icons.refresh),
            //     );
            //   },
            // ),
          );
        },
      );

  onUploadSingleEntry(Transaction transaction) {
    LocalDraftBloc bloc = BlocProvider.of<LocalDraftBloc>(context);
    bloc.add(UploadDraftEvent(context: context, transaction: transaction));
  }

  syncAll(Transaction transaction) {
    LocalDraftBloc bloc = BlocProvider.of<LocalDraftBloc>(context);

    bloc.add(UploadDraftEvent(context: context, transaction: transaction));
  }

  onmakeInvoice(Transaction transaction) async {
    final invoice = await LocalDatabaseInvoices(context)
        .makeInvoice(context: context, transaction: transaction);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PdfPreviewPage(
              openFrom: 'invoice',
              invoice: invoice,
            )));
  }
}
