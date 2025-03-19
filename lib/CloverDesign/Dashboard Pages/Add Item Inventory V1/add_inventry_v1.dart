import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:opalposinc/CloverDesign/Bloc/inventory_bloc.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/common_app_barV1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/menuItem.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/sidebar_item.dart';
import 'package:opalposinc/utils/assets.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/utils.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';

class AddInventoryV1 extends StatefulWidget {
  const AddInventoryV1({super.key});

  @override
  State<AddInventoryV1> createState() => _AddInventoryV1State();
}

class _AddInventoryV1State extends State<AddInventoryV1> {
  String selectedMenu = '';

  final TextEditingController _searchController = TextEditingController();

  void _performSearch(String query) {
    setState(() {
      // searchResults =
      //     .where((item) => item.toLowerCase().contains(query.toLowerCase()))
      //     .toList();
    });
    log('Search query: $query');
  }

  @override
  void initState() {
    context
        .read<InventoryBloc>()
        .add(MenuSelectionEvent(selectedMenu: "Items"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CloverMenuItem> menu = [
      CloverMenuItem(
        title: 'Items',
        icon: Icons.inventory,
      ),
      CloverMenuItem(
        title: 'Categories',
        icon: Icons.category,
      ),
      CloverMenuItem(
        title: 'Variants',
        icon: Icons.layers,
      ),
      CloverMenuItem(
        title: 'Units',
        icon: Icons.straighten,
      ),
      CloverMenuItem(
        title: 'Brands',
        icon: Icons.storefront,
      ),
      CloverMenuItem(
        title: 'Selling Price Group',
        icon: Icons.attach_money,
      ),
    ];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Constant.colorWhite,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppBarV1(
              imagePath: Myassets.addInventory,
              title: "Inventory",
              actionList: actionList(context),
            )),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            String selectedMenu = '';
            if (state is MenuSelectionState) {
              selectedMenu = state.selectedMenu;
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 240,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        menu.length,
                        (index) => SideBarItemClover(
                          items: menu,
                          backgroundColor: MyUtility.getParentState(
                                      selectedMenu) ==
                                  menu[index].title
                              ? Constant.colorPurple
                                  .withOpacity(0.3) // Selected background
                              : Colors
                                  .white, // Default backgroundDefault background
                          index: index,
                          onSelected: (item) {
                            context.read<InventoryBloc>().add(
                                MenuSelectionEvent(selectedMenu: item.title));
                          },
                          depth: 0,
                          iconColor: MyUtility.getParentState(selectedMenu) ==
                                  menu[index].title
                              ? Colors.white
                              : Colors.black,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: MyUtility.getParentState(selectedMenu) ==
                                    menu[index].title
                                ? Colors.white // Selected background
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Constant.colorHomeBg,
                    alignment: Alignment.topLeft,
                    child: MyUtility.getScreenContent(selectedMenu),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> actionList(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () {},
      ),
      SizedBox(
        width: 200,
        child: TextField(
          autofocus: false,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          controller: _searchController,
          decoration: InputDecoration(
            isDense: true, // Reduces the height of the TextField
            contentPadding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 10), // Adjusts padding
            hintText: 'Search for items',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 14), // Smaller font size
          onChanged: (value) {
            setState(
                () {}); // Force the widget to rebuild when the text changes
            _performSearch(value);
          },
        ),
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {},
      ),
      PopupMenuButton<String>(
        onSelected: (value) {
          // Handle menu item actions
        },
        itemBuilder: (BuildContext context) {
          return ['Option 1', 'Option 2', 'Option 3']
              .map((option) => PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList();
        },
      ),
    ];
  }
}
