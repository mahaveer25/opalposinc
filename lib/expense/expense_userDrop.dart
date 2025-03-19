import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:opalposinc/model/user.dart';
import 'package:opalposinc/services/users.dart';
import 'package:opalposinc/utils/constants.dart';

class ExpenseUser extends StatefulWidget {
  const ExpenseUser({super.key});

  @override
  State<ExpenseUser> createState() => _ExpenseUserState();
}

class _ExpenseUserState extends State<ExpenseUser> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<User> items = [];
  User? selectedValue;

  Future<void> fetchData() async {
    try {
      List<User> users = await UserDataService().getUserNames(context);

      setState(() {
        items.clear();
        items.addAll(users);
        selectedValue = items.isNotEmpty ? items[0] : null;
      });
    } catch (e) {
      print('Error fetccching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Constant.colorGrey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<User>(
            isExpanded: true,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
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
    );
  }
}
