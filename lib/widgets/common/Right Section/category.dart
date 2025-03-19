// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/category.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class CategoriesDropdown extends StatelessWidget {
  const CategoriesDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return categoryDrop();
  }

  Widget categoryDrop() => BlocBuilder<ListCategoryBloc, List<Category>>(
          builder: (context, listCategories) {
        return BlocBuilder<CategoryBloc, Category?>(
            builder: (context, selectedCategory) {
          return DropdownButtonHideUnderline(
            child: Container(
              // Wrapping with a container to control the width of the dropdown
              constraints: const BoxConstraints(
                  maxWidth: 200), // Adjust maxWidth as needed
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Category>(
                  isExpanded:
                      true, // Ensures the dropdown takes up available width
                  value: selectedCategory,
                  items: listCategories.isEmpty
                      ? [
                          const DropdownMenuItem<Category>(
                              value: null, child: Text('No Categories')),
                        ]
                      : listCategories.map((value) {
                          return value.type == 'data'
                              ? DropdownMenuItem<Category>(
                                  enabled: true,
                                  value: value,
                                  child: Text(
                                    value.name.toString(),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle long text
                                  ),
                                )
                              : DropdownMenuItem<Category>(
                                  enabled: false,
                                  value: value,
                                  child: DropdownMenuItemSeparator(
                                      name: value.name.toString()),
                                );
                        }).toList(),
                  onChanged: (newValue) async {
                    CategoryBloc categoryBloc =
                        BlocProvider.of<CategoryBloc>(context);
                    categoryBloc.add(newValue);
                  },
                  icon: const Icon(
                      Icons.arrow_drop_down), // Customize the dropdown icon
                ),
              ),
            ),
          );
        });
      });
}

class DropdownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  final String name;
  DropdownMenuItemSeparator({required this.name, super.key})
      : super(
          child: Text(
            name,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            overflow: TextOverflow.ellipsis, // Handle long text
          ),
        );
}
