// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/MobileView/addCustomerMobile.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/location.dart';
import 'package:opalposinc/widgets/common/left%20Section/customerBalance.dart';
import 'package:opalposinc/widgets/common/left%20Section/new_customer_form.dart';
import 'package:opalposinc/widgets/common/left%20Section/pricing_group_dropdown.dart';

class LeftSecDropdown extends StatefulWidget {
  const LeftSecDropdown({
    super.key,
  });

  @override
  State<LeftSecDropdown> createState() => _LeftSecDropdownState();
}

class _LeftSecDropdownState extends State<LeftSecDropdown> {
  final String _scanBarcodeResult = '';
  TextEditingController searchController = TextEditingController();
  String selectedCustomerId = '';
  List<String> items = [];

  String? selectedValue;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          selectedTime = TimeOfDay.now();
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _refreshData() async {
    // await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);

    return BlocBuilder<CheckConnection, bool>(builder: (context, isConnected) {
      return BlocBuilder<CustomerBloc, CustomerModel?>(
        builder: (context, customer) {
          return BlocBuilder<IsMobile, bool>(
            builder: (context, isMobile) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        // const SizedBox(width: 5),
                        Expanded(
                            child: Decorations.contain(
                                child: const LocationDropdown())),
                        if (!isMobile)
                          const SizedBox(
                            width: 5,
                          ),
                        if (!isMobile)
                          Expanded(
                            child: Decorations.contain(
                                child: const DropDownCustomer()),
                          ),
                        const SizedBox(width: 5),

                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Constant.colorPurple,
                          ),
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 30,
                            onPressed: () => isMobile
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddCustomerMobile()))
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AddNewCustomer();
                                    },
                                  ),
                          ),
                        )

                        // const SizedBox(width: 8),
                        // Expanded(
                        //   child: Container(
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                        //     height: 50.0,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Constant.colorGrey, width: 1.0),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     child: Center(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             '$formattedDate:${selectedTime.hour}:${selectedTime.minute}',
                        //             style: const TextStyle(fontSize: 18),
                        //           ),
                        //           GestureDetector(
                        //             onTap: () => _selectDate(context),
                        //             child: Icon(
                        //               Icons.calendar_month_rounded,
                        //               size: 32,
                        //               color: Constant.colorPurple,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    if (customer!.id != '1')
                      const Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  "Customer Due: \$",
                                  style: TextStyle(color: Colors.red),
                                ),
                                CustomerBalance(),
                              ],
                            ),
                          ),
                        ],
                      ),

                    Row(
                      children: [
                        if (!isMobile)
                          Expanded(
                            child: Container(
                              // padding:
                              //     const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                              height: 50.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Constant.colorGrey, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$formattedDate:${selectedTime.hour}:${selectedTime.minute}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    GestureDetector(
                                      onTap: () => _selectDate(context),
                                      child: Icon(
                                        Icons.calendar_month_rounded,
                                        size: 32,
                                        color: Constant.colorPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (!isMobile)
                          const SizedBox(
                            width: 8,
                          ),
                        if (isConnected)
                          Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constant.colorGrey, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: PricingGroupDropdown(),
                                  ))),
                      ],
                    ),
                    // Row(
                    //   children: [Text("Barcode result $_scanBarcodeResult")],
                    // )
                  ],
                ),
              );
            },
          );
        },
      );
    });
  }
}

class DropDownCustomer extends StatefulWidget {
  const DropDownCustomer({super.key});

  @override
  State<DropDownCustomer> createState() => _DropDownCustomerState();
}

class _DropDownCustomerState extends State<DropDownCustomer> {
  TextEditingController textEditingController = TextEditingController();

  // late int CustomerBalanceId;

  @override
  Widget build(BuildContext context) {
    return dropDownCustomer();
  }

  Widget dropDownCustomer() =>
      BlocBuilder<ListCustomerBloc, List<CustomerModel>>(
          builder: (context, listCustomers) {
        return BlocBuilder<CustomerBloc, CustomerModel?>(
            builder: (context, selectedCustomer) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2<CustomerModel>(
              isExpanded: true,
              items: listCustomers
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!.isNotEmpty
                              ? '${item.name} (${item.contactId})-${item.mobile == "null" ? "" : item.mobile}'
                              : '(${item.contactId ?? ''})-${item.mobile == "null" ? "" : item.mobile}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedCustomer,
              onChanged: (value) {
                setState(() {
                  CustomerBloc customerBloc =
                      BlocProvider.of<CustomerBloc>(context);
                  customerBloc.add(value);
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: 40,
                width: 150,
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for Customer...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  final customer = item.value as CustomerModel;
                  final nameMatch = customer.name!
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                  final mobileMatch = customer.mobile != null &&
                      customer.mobile!
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());

                  return nameMatch || mobileMatch;
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
            ),
          );
        });
      });
}
