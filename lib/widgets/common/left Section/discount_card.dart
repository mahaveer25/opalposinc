// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import '../../CustomWidgets/CustomIniputField.dart';
import '../../major/left_section.dart';

class DiscountCard extends StatefulWidget {
  final double total;
  const DiscountCard({super.key, required this.total});

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  // TextEditingController textEditingController = TextEditingController();

  List<String> items = ['Fixed', 'Percentage'];
  String selectedValue = "Fixed";
  final productDiscount = TextEditingController();
  final redeemedValueController = TextEditingController();
  @override
  void initState() {
    alreadyDiscount();
    super.initState();
  }

  void alreadyDiscount() {
    TotalDiscountBloc discountBloc =
        BlocProvider.of<TotalDiscountBloc>(context);
    selectedValue = discountBloc.state!.type ?? selectedValue;
    productDiscount.text = discountBloc.state?.amount?.toString() ?? "";
  }

  @override
  void dispose() {
    productDiscount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(30),
            child: Form(child: BlocBuilder<IsMobile, bool>(
              builder: (context, isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Discount Opal Points",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Edit Discount',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Constant.colorGrey, width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: items
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value.toString();
                                    log(selectedValue);
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
                                onMenuStateChange: (isOpen) {
                                  // if (!isOpen) {
                                  //   textEditingController.clear();
                                  // }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (!isMobile)
                          Expanded(
                              child: CustomInputField(
                            hintText: 'Discount Amount',
                            labelText: 'Discount Amount',
                            controller: productDiscount,
                            onChanged: onDiscountChanged,
                          ))
                      ],
                    ),
                    if (isMobile)
                      const SizedBox(
                        height: 10,
                      ),
                    if (isMobile)
                      CustomInputField(
                        hintText: 'Discount Amount',
                        labelText: 'Discount Amount',
                        controller: productDiscount,
                        onChanged: onDiscountChanged,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    showRedeemedPoints(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () async {
                            TotalDiscountModel discountModel =
                                TotalDiscountModel(
                              type: selectedValue,
                              amount: productDiscount.text.isNotEmpty
                                  ? double.parse(productDiscount.text)
                                  : 0.0,
                              points: redeemedValueController.text.isNotEmpty
                                  ? double.parse(redeemedValueController.text)
                                  : 0.0,
                            );

                            await displayManager.transferDataToPresentation({
                              'type': 'discount',
                              'discount': discountModel.toJson()
                            });

                            TotalDiscountBloc discountBloc =
                                BlocProvider.of<TotalDiscountBloc>(context);
                            discountBloc.add(discountModel);

                            Navigator.of(context).pop();
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
                            'Apply',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ],
                );
              },
            )),
          ))),
    );
  }

  onDiscountChanged(String value) {
    if (productDiscount.text.isNotEmpty) {
      if (selectedValue == 'Fixed') {
        if (int.parse(productDiscount.text) > widget.total) {
          setState(() {
            productDiscount.text =
                double.parse(widget.total.toString()).toInt().toString();
          });
        }
      } else {
        if (int.parse(productDiscount.text) > 100.0) {
          setState(() {
            productDiscount.text = 100.0.toStringAsFixed(2);
          });
        }
      }
    }
  }

  showRedeemedPoints() {
    return BlocBuilder<IsMobile, bool>(
      builder: (context, isMobile) {
        return BlocBuilder<SettingsBloc, SettingsModel?>(
            builder: ((context, state) {
          return BlocBuilder<CustomerBloc, CustomerModel?>(
              builder: (context, customer) {
            if (int.parse(state!.enableRp.toString()) == 0) {
              return Container();
            }

            return Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Opal Points',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        labelText: "Redeemed",
                        hintText: "Redeemed",
                        controller: redeemedValueController,
                        enabled: int.parse(customer!.id.toString()) != 1,
                        onChanged: (value) {
                          setState(() {
                            log("customerID:${customer.id}");
                            log("customerID:${customer.rewardPoints}");
                            int enteredRp = int.parse(value);
                            int rewardPoints =
                                int.parse(customer.rewardPoints.toString());

                            if (enteredRp > rewardPoints) {
                              redeemedValueController.text =
                                  rewardPoints.toString();
                              ConstDialog(context).showErrorDialog(
                                error:
                                    'Redeemed Point cannot exceed to available Redeemed Point',
                                iconData: Icons.error,
                                iconColor: Colors.red,
                                iconText: 'Alert',
                                ontap: () => Navigator.pop(context),
                              );
                            }
                          });
                        },
                      ),
                    ),
                    if (!isMobile)
                      const SizedBox(
                        width: 5,
                      ),
                    if (!isMobile)
                      const Expanded(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Available:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Redeemed Amount: \$0.00',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ))
                  ],
                ),
                if (isMobile)
                  const SizedBox(
                    width: 5,
                  ),
                if (isMobile)
                  const Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Available:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Redeemed Amount: \$0.00',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          });
        }));
      },
    );
  }
}
