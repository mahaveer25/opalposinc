// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Invoices/LocalDatabaseInvoices.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/multiplePay/MultiplePay.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/CustomWidgets.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool isSyncing = false;

  @override
  void initState() {
    LocalTransactionBlocBloc bloc =
        BlocProvider.of<LocalTransactionBlocBloc>(context);
    bloc.add(GetTransactionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalTransactionBlocBloc, LocalTransactionBlocState>(
        builder: (context, state) {
      return buildGridView(list: state.listTransaction);
    });
  }

  Widget buildGridView({required List<Transaction> list}) =>
      BlocBuilder<IsMobile, bool>(
        builder: (context, isMobile) {
          return BlocBuilder<CheckConnection, bool>(
            builder: (context, state) {
              list = list.reversed.toList();
              return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isMobile ? 10.0 : 0),
                  child: Column(
                    children: [
                      Expanded(
                          child: GridView.builder(
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // IconButton(
                                    //     onPressed: () {
                                    //       LocalTransactionBlocBloc bloc =
                                    //           BlocProvider.of<LocalTransactionBlocBloc>(
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
                                            textBefore: 'Offline Invoice Id: ',
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
                                            padding: const EdgeInsets.all(8.0),
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
                                      ? () => onUploadSingleEntry(transaction)
                                      : null,
                                  tileColor: state
                                      ? Constant.colorPurple
                                      : Colors.deepOrange.shade600,
                                  dense: true,
                                  title: Center(
                                    child: Text(
                                      state ? 'Upload Entry' : 'No Internet',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 5,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            mainAxisExtent: 340),
                      )),
                    ],
                  ),
                ),
                floatingActionButton: Builder(
                  builder: (context) {
                    if (!state) return Container();

                    return FloatingActionButton.extended(
                      onPressed: () => syncAll(list),
                      label: const Text('Sync All Transactions'),
                      icon: const Icon(Icons.refresh),
                    );
                  },
                ),
              );
            },
          );
        },
      );

  onUploadSingleEntry(Transaction transaction) {
    LocalTransactionBlocBloc bloc =
        BlocProvider.of<LocalTransactionBlocBloc>(context);
    bloc.add(
        UploadTransactionEvent(context: context, transaction: [transaction]));
  }

  syncAll(List<Transaction> list) {
    LocalTransactionBlocBloc bloc =
        BlocProvider.of<LocalTransactionBlocBloc>(context);

    bloc.add(UploadTransactionEvent(context: context, transaction: list));
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

class StackerWidget extends StatelessWidget {
  final List<Product> list;

  const StackerWidget({super.key, required this.list});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: list.map((e) => avatar(url: e.image.toString())).toList(),
    );
  }

  Widget avatar({required String url}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
      child: Image(image: NetworkImage(url)),
    );
  }
}
