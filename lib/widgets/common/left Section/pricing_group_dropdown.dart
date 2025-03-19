import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/FetchingApis/FetchApis.dart';
import 'package:opalposinc/model/pricinggroup.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

import '../../../model/location.dart';

class PricingGroupDropdown extends StatefulWidget {
  const PricingGroupDropdown({super.key});

  @override
  State<PricingGroupDropdown> createState() => _PricingGroupDropdownState();
}

class _PricingGroupDropdownState extends State<PricingGroupDropdown> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  // List<PricingGroup> items = [];
  // PricingGroup? selectedValue;
  //

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }

  Widget futureBuilder() =>
      BlocBuilder<LocationBloc, Location?>(builder: (context, location) {
        if (mounted) {
          if (location != null) {
            FetchApis(context).onupdatePrices(location: location);
          }
        }

        return BlocBuilder<ListPricingBloc, List<PricingGroup>>(
            builder: (context, pricinglist) {
          final data = pricinglist;

          if (data.isEmpty) {
            return Container();
          }

          return builders(data: data);
        });
      });
  Widget builders({required List<PricingGroup> data}) =>
      BlocBuilder<PricingBloc, PricingGroup?>(builder: (context, pricingModel) {
        if (data.isEmpty || pricingModel?.id == null) {
          return Container();
        }

        return priceGroupBuilder(data: data, selectedValue: pricingModel!);
      });

  Widget priceGroupBuilder(
          {required List<PricingGroup> data,
          required PricingGroup selectedValue}) =>
      Container(
        // padding: const EdgeInsets.only(top: 3.5, bottom: 3.5),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Constant.colorGrey, width: 1.0),
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<PricingGroup>(
            isExpanded: true,
            items: data
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.name.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            hint: const Text('Select Price'),
            value: selectedValue,
            onChanged: (value) {
              PricingBloc pricingBloc = BlocProvider.of<PricingBloc>(context);
              pricingBloc.add(value);

              CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
              cartBloc.add(CartClearProductEvent());
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
                return item.value.toString().contains(searchValue);
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
}
