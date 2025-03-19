import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/brand.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class BrandsDropdown extends StatefulWidget {
 final  Function(Brand?) onBrandChange;
  const BrandsDropdown({
    super.key, required this.onBrandChange,
  });

  @override
  State<BrandsDropdown> createState() => _BrandsDropdownDropdownState();
}

class _BrandsDropdownDropdownState extends State<BrandsDropdown> {
  TextEditingController textEditingController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return brandDrop();
  }

  Widget brandDrop() =>
      BlocBuilder<ListBrandBloc, List<Brand>>(builder: (context, listBrand) {
        return BlocBuilder<BrandBloc, Brand?>(
            builder: (context, selectedBrand) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2<Brand>(
              isExpanded: true,
              items: listBrand
                  .map((brand) => DropdownMenuItem<Brand>(
                        value: brand,
                        child: Text(
                          brand.name.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedBrand,
              onChanged: widget.onBrandChange,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: 47,
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
                  return item.value.toString().contains(searchValue);
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
