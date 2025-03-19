import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:opalsystem/model/user.dart';
import 'package:opalsystem/services/users.dart';
import 'package:opalsystem/utils/constants.dart';

class UserDropdown extends StatefulWidget {
  final Function(List<User>) onUsersSelected;
  const UserDropdown({super.key, required this.onUsersSelected});

  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  late List<MultiSelectItem<User>> _items;
  late List<User> _selectedUsers;

  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _selectedUsers = [];
    _items = [];
    _loadUserData();
  }

  _loadUserData() async {
    try {
      List<User> users = await _userDataService.getUserNames(context);
      setState(() {
        _items = users
            .map((User user) => MultiSelectItem<User>(user, user.name))
            .toList();
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: MultiSelectDialogField(
                  items: _items,
                  title: const Text("Users"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Constant.colorGrey, width: 1.0),
                  ),
                  buttonText: const Text(
                    "Assigned to:",
                    style: TextStyle(
                      color: Color.fromARGB(255, 134, 134, 134),
                      fontSize: 16,
                    ),
                  ),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (results) {
                    setState(() {
                      _selectedUsers.clear();
                      _selectedUsers.addAll(results.cast<User>());
                    });
                    widget.onUsersSelected(_selectedUsers);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
