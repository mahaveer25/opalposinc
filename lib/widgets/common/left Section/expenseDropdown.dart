// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/FetchingApis/FetchApis.dart';
import 'package:opalsystem/model/expense_drop_model.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class ExpenseDropdown extends StatefulWidget {
  const ExpenseDropdown({super.key});

  @override
  State<ExpenseDropdown> createState() => _ExpenseDropdownState();
}

class _ExpenseDropdownState extends State<ExpenseDropdown> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    ExpenseDropdBloc expenseDropdBloc =
        BlocProvider.of<ExpenseDropdBloc>(context);

    List<ExpenseDrop> expenseDrop = await FetchApis(context).getExpense();
    expenseDropdBloc.add(expenseDrop);
    SelectedExpenseBloc selectedExpenseBloc =
        BlocProvider.of<SelectedExpenseBloc>(context);
    selectedExpenseBloc.add(expenseDrop[0]);
  }

  @override
  Widget build(BuildContext context) {
    return dropdownExpense();
  }

  Widget dropdownExpense() => BlocBuilder<ExpenseDropdBloc, List<ExpenseDrop>>(
          builder: (context, listExpenseDrop) {
        return BlocBuilder<SelectedExpenseBloc, ExpenseDrop?>(
            builder: (context, selectedExpense) {
          return Container(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.colorGrey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<ExpenseDrop>(
                isExpanded: true,
                items: listExpenseDrop
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedExpense,
                onChanged: (value) {
                  setState(() {
                    SelectedExpenseBloc selectedExpenseBloc =
                        BlocProvider.of<SelectedExpenseBloc>(context);
                    selectedExpenseBloc.add(value);
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
                    return item.value
                        .toString()
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ),
          );
        });
      });
}
