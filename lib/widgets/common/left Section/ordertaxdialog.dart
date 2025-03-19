// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/OrderTaxModel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/services/getordertax.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class OrderTaxDropdown extends StatefulWidget {
  const OrderTaxDropdown({super.key});

  @override
  _OrderTaxDropdownState createState() => _OrderTaxDropdownState();
}

class _OrderTaxDropdownState extends State<OrderTaxDropdown> {
  List<OrderTaxModel> orderTaxList = [];
  OrderTaxModel? selectedTax;
  final GetOrderTaxServices _orderTaxServices = GetOrderTaxServices();

  @override
  void initState() {
    super.initState();
    fetchTaxes();
  }

  Future<void> fetchTaxes() async {
    try {
      List<OrderTaxModel> taxes =
          await _orderTaxServices.getOrderTaxList(context: context);
      setState(() {
        orderTaxList = taxes;
        selectedTax = orderTaxList[1];
      });
    } catch (e) {
      print("Error fetching taxes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Dialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Order Tax',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded)),
              ],
            ),
            SizedBox(height: 6),
            const Text(
              'Order Tax:*',
              style: TextStyle(fontSize: 20),
            ),
            Decorations.contain(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<OrderTaxModel>(
                  isExpanded: true,
                  items: orderTaxList
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              '${item.name}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedTax,
                  onChanged: (value) {
                    setState(() {
                      selectedTax = value;
                      TaxBloc taxBloc = BlocProvider.of<TaxBloc>(context);
                      taxBloc.add(selectedTax != null
                          ? TaxModel(
                              taxId: selectedTax?.id,
                              amount: selectedTax?.amount,
                              businessId: selectedTax?.businessId,
                              name: selectedTax?.name)
                          : TaxModel());
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
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildBtn(
                  height: 50,
                  width: 100,
                  btnBorder: 8,
                  btnColor: Constant.colorPurple,
                  btnName: "Update",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                buildBtn(
                  height: 50,
                  width: 100,
                  btnBorder: 8,
                  btnColor: Constant.colorPurple,
                  btnName: "Cancel",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBtn({
    required double height,
    required double width,
    required String btnName,
    required Color btnColor,
    required double btnBorder,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(btnBorder),
        ),
        child: Center(
          child: Text(
            btnName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
