import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/addExpenseModal.dart';
import 'package:opalposinc/model/expense_drop_model.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/payment_model.dart';
import 'package:opalposinc/model/user.dart';
import 'package:opalposinc/multiplePay/MultiplePay.dart';
import 'package:opalposinc/multiplePay/PaymentListMethod.dart';

import 'package:opalposinc/services/add_expense.dart';
import 'package:opalposinc/services/users.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/location.dart';
import 'package:opalposinc/widgets/common/left%20Section/expenseDropdown.dart';

import 'date_widget.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({
    super.key,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  // List<PaymentListMethod> methodListWidget = [];

  TextEditingController reference = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  TextEditingController expenseNote = TextEditingController();
  TextEditingController amount = TextEditingController();
  PaymentListMethod paymentListMethod = PaymentListMethod(
      method: 'cash', methodType: PaymentMethod(type: 'cash', name: 'Cash'));
  final AddExpenses addExpense = AddExpenses();

  TextEditingController textEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<User> items = [];
  User? selectedValue;
  String? expenseFor;

  Future<void> fetchData() async {
    try {
      List<User> users = await UserDataService().getUserNames(context);

      setState(() {
        items.clear();
        items.addAll(users);
        selectedValue = items.isNotEmpty ? items[0] : null;
        expenseFor = items.isNotEmpty ? items[0].id.toString() : null;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(
      builder: (context, isMobile) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: isMobile ? 10 : 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Expenses',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
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
                ),
                SizedBox(height: isMobile ? 15 : 30),
                Builder(builder: (context) {
                  if (isMobile) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Locations:'),
                            subtitle: Container(
                                padding:
                                    const EdgeInsets.only(top: 2, bottom: 3),
                                height: 50.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constant.colorGrey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const LocationDropdown()),
                          ),
                          // const Expanded(child: LocationDropdown()),
                          const SizedBox(height: 5),
                          ListTile(
                            title: const Text('Reference No:'),
                            subtitle: CustomInputField(
                              labelText: "Reference No.",
                              hintText: "Reference No.",
                              controller: reference,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const ListTile(
                              title: Text('Date:'), subtitle: DateWidget()),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Locations:'),
                            subtitle: Container(
                                padding:
                                    const EdgeInsets.only(top: 2, bottom: 3),
                                height: 50.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constant.colorGrey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const LocationDropdown()),
                          ),
                        ),
                        // const Expanded(child: LocationDropdown()),
                        // const SizedBox(width: 5),
                        Expanded(
                          child: ListTile(
                            title: const Text('Reference No:'),
                            subtitle: CustomInputField(
                              labelText: "Reference No.",
                              hintText: "Reference No.",
                              controller: reference,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 5),
                        const Expanded(
                            child: ListTile(
                                title: Text('Date:'), subtitle: DateWidget())),
                      ],
                    ),
                  );
                }),
                Builder(builder: (context) {
                  if (isMobile) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Expense For:'),
                            subtitle: Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constant.colorGrey, width: 1.0),
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
                                        expenseFor = selectedValue!.id;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
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
                            ),
                          ),
                          const SizedBox(height: 5),
                          const ListTile(
                              title: Text('Expense Category:'),
                              subtitle: ExpenseDropdown()),
                          const SizedBox(height: 5),
                          ListTile(
                            title: const Text('Total Amount:'),
                            subtitle: CustomInputField(
                              labelText: "Total Amount",
                              hintText: "Total Amount",
                              inputType: TextInputType.number,
                              controller:
                                  totalAmount, // Fixed the controller here
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Expense For:'),
                          subtitle: Container(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Constant.colorGrey, width: 1.0),
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
                                    expenseFor = selectedValue!.id;
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
                        ),
                      ),
                      // const SizedBox(width: 5),
                      const Expanded(
                          child: ListTile(
                              title: Text('Expense Category:'),
                              subtitle: ExpenseDropdown())),
                      Expanded(
                          child: ListTile(
                        title: const Text('Total Amount:'),
                        subtitle: CustomInputField(
                          labelText: "Total Amount",
                          hintText: "Total Amount",
                          inputType: TextInputType.number,
                          controller: totalAmount, // Fixed the controller here
                        ),
                      )),
                      // const SizedBox(width: 5),

                      // const SizedBox(width: 5),
                    ],
                  );
                }),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('Expense Note:')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          labelText: "Expense Note",
                          hintText: "Expense Note",
                          controller: expenseNote,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Add Payment',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: MethodTypeWidget(
                    paymentMethod: paymentListMethod,
                    onTap: () {},
                    methodType: 'cash',
                  ),
                ),
                const SizedBox(height: 70),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    onExpessButton(),
                    const SizedBox(width: 5),
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
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget onExpessButton() {
    addExpense({
      required LoggedInUser loggedInUser,
      required Location location,
      required CustomerModel customerModel,
      required TaxModel taxModel,
      required String categoryId,
    }) async {
      if (selectedValue == 0) {
        ConstDialog(context).showErrorDialog(
          error: "Kindly Select the User",
          iconData: Icons.error,
          iconColor: Colors.red,
          iconText: 'Alert',
        );
      }
      AddExpenseModal addExpenses = AddExpenseModal(
        businessId: loggedInUser.businessId,
        userId: loggedInUser.id,
        locationId: location.id,
        userLocation: loggedInUser.locations,
        refNo: reference.text,
        categoryId: categoryId,
        contactId: customerModel.contactId,
        expenseFor: expenseFor,
        finalTotal: double.parse(totalAmount.text),
        additionalNotes: expenseNote.text,
        paymentMethods: [paymentListMethod.toJson()],
      );

      // log('${addExpenses.toJson()}');
      await AddExpenses().addExpense(context, addExpenses);
    }

    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
        builder: (context, loggedInUser) {
      return BlocBuilder<LocationBloc, Location?>(builder: (context, location) {
        return BlocBuilder<TaxBloc, TaxModel?>(builder: (context, tax) {
          return BlocBuilder<SelectedExpenseBloc, ExpenseDrop?>(
              builder: (context, expenseDrop) {
            return BlocBuilder<CustomerBloc, CustomerModel?>(
                builder: (context, customer) {
              return ElevatedButton(
                onPressed: () {
                  addExpense(
                    loggedInUser: loggedInUser!,
                    location: location!,
                    taxModel: tax!,
                    customerModel: customer!,
                    categoryId: expenseDrop!.id ?? '',
                  );
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
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            });
          });
        });
      });
    });
  }
}
