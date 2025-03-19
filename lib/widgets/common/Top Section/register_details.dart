// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/GenrateRegisterDetails.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/model/register_details_model.dart';
import 'package:opalposinc/multiplePay/money_denominationService.dart';
import 'package:opalposinc/printing.dart';
import 'package:opalposinc/services/close_register.dart';
import 'package:opalposinc/services/register_details_service.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/views/Register_Screen.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

import '../../CustomWidgets/CustomIniputField.dart';

class RegisterDetils extends StatefulWidget {
  final bool forShow;
  const RegisterDetils({super.key, required this.forShow});

  @override
  State<RegisterDetils> createState() => _RegisterDetilsState();
}

class _RegisterDetilsState extends State<RegisterDetils> with PrintPDF {
  RegisterDetails? registerDetails;
  final RegisterDetailService _registerDetailService = RegisterDetailService();
  TextEditingController closingNote = TextEditingController();
  final cashDenominationsService = GetCashDenominationsService();
  List<String>? cashDenominations;
  List<TextEditingController> countControllers = [];
  List<int> subtotals = [];
  int total = 0;
  bool closeprint = false;

  Future<void> getCashDenominations() async {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    List<String>? fetchedDenominations =
        await cashDenominationsService.getCashDenominations(
      context: context,
      businessId: loggedInUserBloc.state?.businessId ?? '',
    );

    setState(() {
      cashDenominations = fetchedDenominations;
      countControllers = List.generate(
          cashDenominations!.length, (index) => TextEditingController());
      subtotals = List.generate(cashDenominations!.length, (index) => 0);
    });

    log('CashDenominations: $cashDenominations');
  }

  @override
  void initState() {
    super.initState();
    getCashDenominations();
    oninit();
  }

  void updateSubtotal(int index) {
    setState(() {
      int count = int.tryParse(countControllers[index].text) ?? 0;
      int denomination = int.parse(cashDenominations![index]);
      subtotals[index] = count * denomination;
      total = subtotals.reduce((value, element) => value + element);
    });
  }

  @override
  void dispose() {
    // Dispose all TextEditingControllers
    for (var controller in countControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  oninit() async {
    final data = await _registerDetailService.getregisterdetails(context);
    if (mounted) {
      setState(() {
        registerDetails = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return registerDetails != null
        ? buildRegisterDetails(registerDetails!)
        : const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          );
  }

  Future<void> _closeCashRegister() async {
    setState(() {
      closeprint = true;
    });
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);
    RegisterStatusBloc registerStatusBloc =
        BlocProvider.of<RegisterStatusBloc>(context);
    Map<String, String> cashDenominationMap = {};
    for (int i = 0; i < cashDenominations!.length; i++) {
      String denomination = cashDenominations![i];
      String count = countControllers[i].text;
      cashDenominationMap[denomination] = count.isEmpty ? '0' : count;
    }
    final response = await CloseRegisterService.clsoeCashRegister(
      businessId: loggedInUserBloc.state?.businessId.toString(),
      locationId: registerDetails!.locationId,
      userId: loggedInUserBloc.state?.id.toString(),
      closingNote: closingNote.text,
      cashDenominations: cashDenominationMap,
    );

    if (response['success'] == true) {
      registerStatusBloc.add("close");
      final path = await GenerateRegisterPdf.printInvoice(
          registerDetails: registerDetails ?? RegisterDetails());
      if (mounted) await printPdf(path: path, context: context);
      setState(() {
        closeprint = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              Text(response['error']?['info']?.toString() ?? 'Unknown Error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget buildRegisterDetails(RegisterDetails registerDetails) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: isMobile ? 10 : 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            'Register Details ( ${registerDetails.openTime ?? ''}  -  ${registerDetails.currentTime} )',
                            style: TextStyle(
                                fontSize: isMobile ? 18 : 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) => PdfPreviewPage(
                            //               registerDetails: registerDetails,
                            //               openFrom: 'register',
                            //             ))));
                            final path = await GenerateRegisterPdf.printInvoice(
                                registerDetails: registerDetails);
                            await printPdf(path: path, context: context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Constant.colorPurple,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Print',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        closeprint == true
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  _closeCashRegister();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Constant.colorPurple,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Close Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 30,
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
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: isMobile
                              ? MediaQuery.of(context).size.width / 2.5
                              : MediaQuery.of(context).size.width / 2.95,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Payment Method',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              numeric: false,
                            ),
                            DataColumn(
                              label: Text(
                                'Sell ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              numeric: false,
                            ),
                            DataColumn(
                                label: Text(
                                  'Expense',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                numeric: true),
                          ],
                          rows: [
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text(
                                  "Cash in Hand:",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  registerDetails.cashInHand ?? '',
                                )),
                                DataCell(Text(
                                  registerDetails.totalCashExpense ?? '',
                                )),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text(
                                  "Cash Payment",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  registerDetails.totalCash ?? '',
                                )),
                                DataCell(Text(
                                  registerDetails.totalCashExpense ?? '',
                                )),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text(
                                  "Card Payment",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  registerDetails.totalCard ?? '',
                                )),
                                DataCell(Text(
                                  registerDetails.totalCardExpense ?? '',
                                )),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text(
                                  "Other Payments:",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataCell(Text(
                                  registerDetails.totalOther ?? '',
                                )),
                                DataCell(Text(
                                  registerDetails.totalOtherExpense ?? '',
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: isMobile
                            ? MediaQuery.of(context).size.width / 2.5
                            : MediaQuery.of(context).size.width / 1.4,
                        columns: const <DataColumn>[
                          DataColumn(label: Text(''), numeric: false),
                          DataColumn(label: Text(''), numeric: true),
                        ],
                        rows: [
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text(
                                "Total Sales:",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  registerDetails.totalSale ?? '',
                                  style: const TextStyle(),
                                  textAlign: TextAlign.right,
                                ),
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text(
                                "Total Refund",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              DataCell(Text(
                                registerDetails.totalRefund ?? '',
                              )),
                            ],
                          ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     const DataCell(Text(
                          //       "Total Cash Payment",
                          //       maxLines: 1,
                          //       overflow: TextOverflow.ellipsis,
                          //     )),
                          //     DataCell(Text(
                          //       registerDetails.totalCash ?? '',
                          //     )),
                          //   ],
                          // ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text(
                                "Total Payment",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              DataCell(Text(
                                registerDetails.totalRefund ?? '',
                              )),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text(
                                "Total Expenses: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              DataCell(Text(
                                registerDetails.totalRefund ?? '',
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 7,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (cashDenominations?.isNotEmpty ?? false)
                      Column(
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Cash Denominations",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              )),
                          cashDenominations == []
                              ? const CircularProgressIndicator()
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      DataTable(
                                        // columnSpacing: 80,
                                        columns: const [
                                          DataColumn(
                                              label: Text('Denomination')),
                                          DataColumn(label: Text('')),
                                          DataColumn(label: Text('Count')),
                                          DataColumn(label: Text('')),
                                          DataColumn(label: Text('Subtotal')),
                                        ],
                                        rows: List.generate(
                                            cashDenominations!.length, (index) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(
                                                child: Text(
                                                    cashDenominations![index]),
                                              )),
                                              const DataCell(Text('X')),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Center(
                                                      child: CustomInputField(
                                                        controller:
                                                            countControllers[
                                                                index],
                                                        inputType: TextInputType
                                                            .number,
                                                        labelText: '',
                                                        hintText: '0',
                                                        onChanged: (value) =>
                                                            updateSubtotal(
                                                                index),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const DataCell(Text('=')),
                                              DataCell(Center(
                                                child: Text(subtotals[index]
                                                    .toString()),
                                              )),
                                            ],
                                          );
                                        }),
                                      ),
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            'Total: $total',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      const SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomInputField(
                          hintText: 'Closing Note',
                          labelText: 'Closing Note',
                          maxLines: 4,
                          controller: closingNote,
                        ))
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'User: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(registerDetails.userName ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(registerDetails.email ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Business Location: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(registerDetails.locationName ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) => PdfPreviewPage(
                            //               registerDetails: registerDetails,
                            //               openFrom: 'register',
                            //             ))));
                            final path = await GenerateRegisterPdf.printInvoice(
                                registerDetails: registerDetails);
                            await printPdf(path: path, context: context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Constant.colorPurple,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Print',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        closeprint == true
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  _closeCashRegister();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Constant.colorPurple,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Close Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        // swapButtons(),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Constant.colorPurple,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget swapButtons() {
    return Builder(builder: ((context) {
      if (widget.forShow) {
        return ElevatedButton(
          onPressed: () async {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: ((context) => PdfPreviewPage(
            //               registerDetails: registerDetails!,
            //               openFrom: 'register',
            //             ))));
            final path = await GenerateRegisterPdf.printInvoice(
                registerDetails: registerDetails!);
            await printPdf(path: path, context: context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Constant.colorPurple,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Print',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }
      return closeprint == true
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                _closeCashRegister();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Constant.colorPurple,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Close Register',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
    }));
  }
}
