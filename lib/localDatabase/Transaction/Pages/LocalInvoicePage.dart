// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/localDatabase/Invoices/bloc/local_invoice_bloc.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/multiplePay/MultiplePay.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/CustomWidgets.dart';

class LocalInvoicesPage extends StatefulWidget {
  const LocalInvoicesPage({super.key});

  @override
  State<LocalInvoicesPage> createState() => _LocalInvoicesPageState();
}

class _LocalInvoicesPageState extends State<LocalInvoicesPage> {
  @override
  void initState() {
    LocalInvoiceBloc bloc = BlocProvider.of<LocalInvoiceBloc>(context);
    bloc.add(GetInvoiceModelEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalInvoiceBloc, LocalInvoiceState>(
        builder: (context, state) {
      if (state is InvoiceModelLoadingState) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (state is InvoiceModelLoadedState) {
        return buildGridView(list: state.listInvoiceModel);
      }

      return Container();
    });
  }

  Widget buildGridView({required List<InvoiceModel> list}) =>
      BlocBuilder<CheckConnection, bool>(
        builder: (context, state) {
          list = list.reversed.toList();
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                    child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: ((context, index) {
                    InvoiceModel invoice = list[index];
                    DateTime date = DateTime.parse(invoice.date.toString());
                    String formattedDate =
                        DateFormat('yyyy/MM/dd').format(date);

                    final payments =
                        invoice.paymentMethod?.map((e) => e).toList();

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
                            children: [],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Decorations.height10,
                                  CustomRichText(
                                      textBefore: 'Offline Invoice Id: ',
                                      textAfter:
                                          invoice.offlineInvoiceNo.toString()),
                                  Decorations.height10,
                                  CustomTextWidget(
                                      text:
                                          'Product: ${invoice.product?.length}'),
                                  Decorations.height10,
                                  const CustomTextWidget(
                                      text: 'Paying Through: '),
                                  Text('$method'),
                                  const Spacer(),
                                  Material(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:
                                        Constant.colorPurple.withOpacity(0.05),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        children: [
                                          CustomTextWidget(
                                              text:
                                                  'Total Amount : ${invoice.subTotal}'),
                                          CustomTextWidget(
                                              text:
                                                  'Invoice Discount : ${invoice.discountAmount}'),
                                          CustomTextWidget(
                                              text:
                                                  'Invoice Tax : ${invoice.taxAmount}'),
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
                            onTap: () => onUploadSingleEntry(invoice),
                            tileColor: Constant.colorPurple,
                            dense: true,
                            title: const Center(
                                child: Icon(
                              Icons.print,
                              color: Colors.white,
                            )),
                          )
                        ],
                      ),
                    );
                  }),
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      mainAxisExtent: 320),
                )),
              ],
            ),
          );
        },
      );

  onUploadSingleEntry(InvoiceModel invoice) {
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
