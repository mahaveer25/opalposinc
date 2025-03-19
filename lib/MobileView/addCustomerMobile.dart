import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/user.dart';
import 'package:opalposinc/services/add_customer.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/customer_group.dart';
import 'package:opalposinc/widgets/common/left%20Section/new_customer_form.dart';
import 'package:opalposinc/widgets/common/left%20Section/user_dropdown.dart';

class AddCustomerMobile extends StatefulWidget {
  const AddCustomerMobile({super.key});

  @override
  State<AddCustomerMobile> createState() => _AddCustomerMobileState();
}

class _AddCustomerMobileState extends State<AddCustomerMobile> {
  List<String> customertype = ['Select', 'individual', 'business'];
  String? selectedValue = 'Select';
  int selectedIndex = 1;
  bool showAdditionalInfo = false;
  List<User> _selectedUsers = [];
  final AddNewCustomerService _addNewCustomerService = AddNewCustomerService();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController _contactTypeController = TextEditingController();
  final TextEditingController _contactIdController = TextEditingController();
  final TextEditingController _customerGroupIdController =
      TextEditingController();
  final TextEditingController _supplierBusinessNameController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alternateContactController =
      TextEditingController();
  final TextEditingController _landLineController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();
  final TextEditingController _payTermNumberController =
      TextEditingController();
  final TextEditingController _payTermTypeController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _customField1Controller = TextEditingController();
  final TextEditingController _customField2Controller = TextEditingController();
  final TextEditingController _customField3Controller = TextEditingController();
  final TextEditingController _customField4Controller = TextEditingController();
  final TextEditingController _customField5Controller = TextEditingController();
  final TextEditingController _customField6Controller = TextEditingController();
  final TextEditingController _customField7Controller = TextEditingController();
  final TextEditingController _customField8Controller = TextEditingController();
  final TextEditingController _customField9Controller = TextEditingController();
  final TextEditingController _customField10Controller =
      TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();
  void resetControllers() {
    _supplierBusinessNameController.clear();
    _prefixController.clear();
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _dobController.clear();
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
      resetControllers();
    });
  }

  void _submitForm() async {
    final List<dynamic> assignedUserIds =
        _selectedUsers.map((user) => user.id).toList();
    LocationBloc location = BlocProvider.of<LocationBloc>(context);
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    final Map<String, dynamic> formData = {
      "business_id": loggedInUser.state!.businessId,
      "user_id": loggedInUser.state!.id,
      "location_id": location.state!.id,
      "contact_type": _contactTypeController.text,
      "contact_id": _contactIdController.text,
      "customer_group_id": _customerGroupIdController.text,
      "supplier_business_name": _supplierBusinessNameController.text,
      "prefix": _prefixController.text,
      "first_name": _firstNameController.text,
      "middle_name": _middleNameController.text,
      "last_name": _lastNameController.text,
      "mobile": _mobileController.text,
      "alternate_number": _alternateContactController.text,
      "landline": _landLineController.text,
      "email": _emailController.text,
      "dob": _dobController.text,
      "assigned_to_users": assignedUserIds.toString(),
      "tax_number": _taxNumberController.text,
      "opening_balance": _openingBalanceController.text,
      "pay_term_number": _payTermNumberController.text,
      "pay_term_type": _payTermTypeController.text,
      "credit_limit": _creditLimitController.text,
      "address_line_1": _addressLine1Controller.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "country": _countryController.text,
      "zip_code": _zipCodeController.text,
      "custom_field1": _customField1Controller.text,
      "custom_field2": _customField2Controller.text,
      "custom_field3": _customField3Controller.text,
      "custom_field4": _customField4Controller.text,
      "custom_field5": _customField5Controller.text,
      "custom_field6": _customField6Controller.text,
      "custom_field7": _customField7Controller.text,
      "custom_field8": _customField8Controller.text,
      "custom_field9": _customField9Controller.text,
      "custom_field10": _customField10Controller.text,
      "shipping_address": _shippingAddressController.text,
    };
    print('Form Data: $formData');

    try {
      final result = await _addNewCustomerService.addCustomer(formData);

      if (result['success'] == true) {
        // widget.onSubmit();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text('Success'),
                ],
              ),
              content: const Text('New Customer Added Successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        final errorMessage = result['error']['info'];
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text('Alert'),
                ],
              ),
              content: Text('$errorMessage'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Errors: $e');
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
    selectedValue = customertype[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Add New Customer',
      //     style: TextStyle(
      //       fontSize: 25,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Customer',
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
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Constant.colorGrey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          items: customertype
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
                              selectedValue = value;
                              updateSelectedIndex(customertype.indexOf(value!));
                              _contactTypeController.text = value;
                              print(
                                  _contactTypeController.text = selectedValue!);
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
                                  hintText: 'Search for an item...',
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
                                  .contains(searchValue);
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Expanded(child: CustomerGroupDropDown()),
                ],
              ),
              const SizedBox(height: 8),
              CustomInputField(
                controller: _contactIdController,
                labelText: 'Contact ID:',
                hintText: 'Contact ID:',
                toHide: false,
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: selectedIndex == 2,
                child: CustomInputField(
                  controller: _supplierBusinessNameController,
                  labelText: 'Business Name:',
                  hintText: 'Business Name:',
                  toHide: false,
                ),
              ),
              Visibility(
                  visible: selectedIndex == 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: _prefixController,
                          labelText: 'Prefix',
                          hintText: 'Enter Prefix',
                          toHide: true,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: CustomInputField(
                          controller: _firstNameController,
                          labelText: 'First Name*',
                          hintText: 'First Name',
                          toHide: false,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 8),
              Visibility(
                  visible: selectedIndex == 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: _middleNameController,
                          labelText: 'Middle Name',
                          hintText: ' Middle Name',
                          toHide: false,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: CustomInputField(
                          controller: _lastNameController,
                          labelText: 'Last Name*',
                          hintText: ' Last Name',
                          toHide: false,
                        ),
                      ),
                    ],
                  )),
              Visibility(
                  visible: selectedIndex == 1,
                  child: const SizedBox(height: 8)),
              Visibility(
                  visible: selectedIndex == 2,
                  child: const SizedBox(height: 8)),
              Visibility(
                visible: selectedIndex == 1,
                child: CustomDateInputField(
                  controller: _dobController,
                  labelText: 'Date of Birth',
                  hintText: 'YYYY/MM/DD',
                ),
              ),
              Row(
                children: [
                  UserDropdown(
                    onUsersSelected: (users) {
                      setState(() {
                        _selectedUsers = users;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Toggle the visibility of additional information
                      setState(() {
                        showAdditionalInfo = !showAdditionalInfo;
                      });
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
                      'More Information',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: showAdditionalInfo,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    CustomInputField(
                      controller: _taxNumberController,
                      labelText: 'Tax Number',
                      hintText: 'Enter Tax Number',
                      toHide: false,
                    ),
                    const SizedBox(height: 8),
                    CustomInputField(
                      controller: _openingBalanceController,
                      labelText: 'Opening Balance',
                      hintText: 'Enter Opening Balance',
                      toHide: false,
                    ),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _payTermNumberController,
                        labelText: 'Pay Term Number',
                        hintText: 'Enter Pay Term Number',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _addressLine1Controller,
                        labelText: 'Address Line 1',
                        hintText: 'Enter Address Line 1',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _addressLine2Controller,
                        labelText: 'Address Line 2',
                        hintText: 'Enter Address Line 2',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _cityController,
                        labelText: 'City',
                        hintText: 'Enter City',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _stateController,
                        labelText: 'State',
                        hintText: 'Enter State',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _countryController,
                        labelText: 'Country',
                        hintText: 'Enter Country',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _zipCodeController,
                        labelText: 'Zip Code',
                        hintText: 'Enter Zip Code',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField1Controller,
                        labelText: 'Custom Field 1',
                        hintText: 'Enter Custom Field 1',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField2Controller,
                        labelText: 'Custom Field 2 ',
                        hintText: 'Enter Custom Field 3',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField3Controller,
                        labelText: 'Custom Field 3',
                        hintText: 'Enter Custom Field 3',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField4Controller,
                        labelText: 'Custom Field 4',
                        hintText: 'Enter Custom Field 4',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField4Controller,
                        labelText: 'Custom Field 4',
                        hintText: 'Enter Custom Field 4',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField5Controller,
                        labelText: 'Custom Field 5',
                        hintText: 'Enter Custom Field 5',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField6Controller,
                        labelText: 'Custom Field 6',
                        hintText: 'Enter Custom Field 6',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField7Controller,
                        labelText: 'Custom Field 7',
                        hintText: 'Enter Custom Field 7',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField8Controller,
                        labelText: 'Custom Field 8',
                        hintText: 'Enter Custom Field 8',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField9Controller,
                        labelText: 'Custom Field 9',
                        hintText: 'Enter Custom Field 9',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _customField10Controller,
                        labelText: 'Custom Field 10',
                        hintText: 'Enter Custom Field 10',
                        toHide: false),
                    const SizedBox(height: 8),
                    CustomInputField(
                        controller: _shippingAddressController,
                        labelText: 'Shipping Address',
                        hintText: 'Enter Shipping Address',
                        toHide: false),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
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
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: ElevatedButton(
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
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
