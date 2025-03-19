import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opalposinc/NewUi/Widgets/CustomMaterialWidget.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/ProductBloc.dart';

class CustomSearchBar extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController searchController;
  final Function(String) onSearch;
  const CustomSearchBar(
      {super.key,
      required this.focusNode,
      required this.searchController,
      required this.onSearch});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool isSearching = false;
  bool showKeynoard = false;
  TextInputType textInputType = TextInputType.none;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<FeatureBooleanBloc, bool>(builder: (context, featureState) {
          return CustomMaterialWidget(
            onPressed: () {
              featureState = !featureState;

              FeatureBooleanBloc bloc =
                  BlocProvider.of<FeatureBooleanBloc>(context);
              bloc.add(featureState);
            },
            icon: FontAwesomeIcons.wandSparkles,
            backgroundColor: featureState ? Constant.colorPurple : null,
            iconColor: featureState ? Colors.white : null,
          );
        }),
        Decorations.width5,
        AnimatedContainer(
          width: 350,
          // padding: const EdgeInsets.all(20.0),
          duration: const Duration(seconds: 1),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10.0),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // autofocus: showKeynoard,
                    // keyboardType: textInputType,
                    focusNode: widget.focusNode,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      hintText: 'Search Products',
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    controller: widget.searchController,
                    onChanged: onSearch,
                    onFieldSubmitted: onSubmitted,
                  ),
                ),
                CustomMaterialWidget(
                  icon: Icons.keyboard,
                  onPressed: onKeyboardOpen,
                  iconColor: Colors.black,
                  // padding: 0.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onSubmitted(String value) => setState(() => isSearching = false);

  void onSearch(String value) {
    setState(() {
      widget.onSearch(value);
    });

    ProductBloc bloc = BlocProvider.of<ProductBloc>(context);
    bloc.add(
        ProductFilterEvent(value, widget.searchController.text.isNotEmpty));
  }

  void onKeyboardOpen() {
    setState(() {
      showKeynoard = !showKeynoard;
    });
    log('$showKeynoard');
    if (showKeynoard) {
      // widget.focusNode.unfocus();

      textInputType = TextInputType.text;
    } else {
      // widget.focusNode.requestFocus();
      textInputType = TextInputType.none;
    }
  }
}
