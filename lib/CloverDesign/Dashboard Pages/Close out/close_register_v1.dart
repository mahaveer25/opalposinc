import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Open%20Register/open_registerV1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/common_app_barV1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/save_and_cancel_buttons.dart';
import 'package:opalposinc/GenrateRegisterDetails.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/model/register_details_model.dart';
import 'package:opalposinc/multiplePay/money_denominationService.dart';
import 'package:opalposinc/printing.dart';
import 'package:opalposinc/services/close_register.dart';
import 'package:opalposinc/services/register_details_service.dart';
import 'package:opalposinc/utils/assets.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/views/Register_Screen.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class CloseRegisterV1 extends StatefulWidget {
  const CloseRegisterV1({super.key});

  @override
  State<CloseRegisterV1> createState() => _CloseRegisterV1State();
}

class _CloseRegisterV1State extends State<CloseRegisterV1> with PrintPDF {
  RegisterDetails? registerDetails;
  final RegisterDetailService _registerDetailService = RegisterDetailService();
  TextEditingController closingNote = TextEditingController();
  final cashDenominationsService = GetCashDenominationsService();
  List<String>? cashDenominations;
  List<TextEditingController> countControllers = [];
  List<int> subtotals = [];
  int total = 0;

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

  Future<void> _closeCashRegister() async {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OpenRegisterv1()),
      );
      // Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorHomeBg.withOpacity(1),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: CommonAppBarV1(
            imagePath: Myassets.closeOut,
            title: "Closeout",
          )),
      body: BlocBuilder<IsMobile, bool>(
        builder: (context, isMobile) {
          if (registerDetails != null) {
            return IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Register Details ',
                                    style: TextStyle(
                                        fontSize: isMobile ? 18 : 22,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    '( ${registerDetails?.openTime ?? ''}  -  ${registerDetails?.currentTime} ) ',
                                    style: TextStyle(
                                        fontSize: isMobile ? 18 : 12,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'User: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(registerDetails?.userName ?? ''),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text('Email: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(registerDetails?.email ?? ''),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text('Business Location: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(registerDetails?.locationName ?? ''),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            color: Constant.colorWhite,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: isMobile
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.97,
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
                                                registerDetails?.cashInHand ??
                                                    '',
                                              )),
                                              DataCell(Text(
                                                registerDetails
                                                        ?.totalCashExpense ??
                                                    '',
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
                                                registerDetails?.totalCash ??
                                                    '',
                                              )),
                                              DataCell(Text(
                                                registerDetails
                                                        ?.totalCashExpense ??
                                                    '',
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
                                                registerDetails?.totalCard ??
                                                    '',
                                              )),
                                              DataCell(Text(
                                                registerDetails
                                                        ?.totalCardExpense ??
                                                    '',
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
                                                registerDetails?.totalOther ??
                                                    '',
                                              )),
                                              DataCell(Text(
                                                registerDetails
                                                        ?.totalOtherExpense ??
                                                    '',
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
                                          ? MediaQuery.of(context).size.width /
                                              2.4
                                          : MediaQuery.of(context).size.width /
                                              1.85,
                                      columns: const <DataColumn>[
                                        DataColumn(
                                            label: Text(''), numeric: false),
                                        DataColumn(
                                            label: Text(''), numeric: true),
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
                                                registerDetails?.totalSale ??
                                                    '',
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
                                              registerDetails?.totalRefund ??
                                                  '',
                                            )),
                                          ],
                                        ),
                                        DataRow(
                                          cells: <DataCell>[
                                            const DataCell(Text(
                                              "Total Payment",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                            DataCell(Text(
                                              registerDetails?.totalRefund ??
                                                  '',
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
                                              registerDetails?.totalRefund ??
                                                  '',
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
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        cashDenominations == []
                                            ? const CircularProgressIndicator()
                                            : Align(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    DataTable(
                                                      // columnSpacing: 80,
                                                      columns: const [
                                                        DataColumn(
                                                            label: Text(
                                                                'Denomination')),
                                                        DataColumn(
                                                            label: Text('')),
                                                        DataColumn(
                                                            label:
                                                                Text('Count')),
                                                        DataColumn(
                                                            label: Text('')),
                                                        DataColumn(
                                                            label: Text(
                                                                'Subtotal')),
                                                      ],
                                                      rows: List.generate(
                                                          cashDenominations!
                                                              .length, (index) {
                                                        return DataRow(
                                                          cells: [
                                                            DataCell(Center(
                                                              child: Text(
                                                                  cashDenominations![
                                                                      index]),
                                                            )),
                                                            const DataCell(
                                                                Text('X')),
                                                            DataCell(
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        5.0),
                                                                child: SizedBox(
                                                                  width: 80,
                                                                  child: Center(
                                                                    child:
                                                                        CustomInputField(
                                                                      controller:
                                                                          countControllers[
                                                                              index],
                                                                      inputType:
                                                                          TextInputType
                                                                              .number,
                                                                      labelText:
                                                                          '',
                                                                      hintText:
                                                                          '0',
                                                                      onChanged:
                                                                          (value) =>
                                                                              updateSubtotal(index),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const DataCell(
                                                                Text('=')),
                                                            DataCell(Center(
                                                              child: Text(
                                                                  subtotals[
                                                                          index]
                                                                      .toString()),
                                                            )),
                                                          ],
                                                        );
                                                      }),
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          'Total: $total',
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(
                    endIndent: 30,
                    indent: 30,
                    color: Colors.black,
                    thickness: 0.5,
                  ),
                  BlueAndWhiteButtons(
                    onPressedWhite: () {
                      _closeCashRegister();
                    },
                    whiteButtonTitle: "Close Register",
                    blueButtonTitle: 'Print',
                    onPressedBlue: () async {
                      final path = await GenerateRegisterPdf.printInvoice(
                          registerDetails:
                              registerDetails ?? RegisterDetails());
                      await printPdf(path: path, context: context);
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Constant.colorPurple,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
