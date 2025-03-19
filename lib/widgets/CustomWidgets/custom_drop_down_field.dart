import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:opalsystem/utils/constants.dart';

class CustomDropdownWithField extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final TextEditingController? searchController;
  final TextEditingController? outputController;
  final String hintText;

  const CustomDropdownWithField({
    Key? key,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.searchController,
    this.outputController,
    this.hintText = 'Search for an item...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width:context.width,
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Constant.colorWhite,
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(

          isExpanded: true,
          hint: Text(hintText??"",style: TextStyle(fontSize:12 ),),
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
            if (onChanged != null) onChanged!(value);
            if (outputController != null) outputController!.text = value ?? '';
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
            searchController: searchController,
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
                controller: searchController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen && searchController != null) {
              searchController?.clear();
            }
          },
        ),
      ),
    );
  }
}



class DropDownNoTextField<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final String Function(T) displayText;
  final ValueChanged<T?> onChanged;
  final double buttonHeight;
  final double buttonWidth;
  final double dropdownMaxHeight;
  final double menuItemHeight;
  final String? hintText;

  const DropDownNoTextField({
    Key? key,
     this.selectedValue,
    required this.items,
    required this.displayText,
    required this.onChanged,
    this.buttonHeight = 40,
    this.buttonWidth = 150,
    this.dropdownMaxHeight = 200,
    this.menuItemHeight = 40,
     this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: context.width,
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Constant.colorWhite,
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(

        child: DropdownButton2<T>(
          hint: Text(hintText??"",style: TextStyle(fontSize:12 ),),
          value: selectedValue,
          isExpanded: true,
          items: items
              .map(
                (item) => DropdownMenuItem(
              value: item,
              child: Text(
                displayText(item),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
              .toList(),
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(

            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: buttonHeight,
            width: buttonWidth,
          ),
          dropdownStyleData: DropdownStyleData(

            maxHeight: dropdownMaxHeight,
          ),
          menuItemStyleData: MenuItemStyleData(
            height: menuItemHeight,
          ),
        ),
      ),
    );
  }
}
