import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:opalposinc/CloverDesign/Bloc/inventory_bloc.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/navbar.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/utils.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart'; // Assuming this is your custom text widget file

class ItemsNewClover extends StatefulWidget {
  const ItemsNewClover({super.key});

  @override
  State<ItemsNewClover> createState() => _ItemsNewCloverState();
}

class _ItemsNewCloverState extends State<ItemsNewClover> {
  final List<Map<String, String>> items = [
    {
      "name": "Gold Fume Wp",
      "code": "A123",
      "sku": "SKU123",
      "price": "\$10.00"
    },
    {"name": "Gold Fume", "code": "B456", "sku": "SKU456", "price": "\$20.00"},
    {"name": "Wapor css", "code": "C789", "sku": "SKU789", "price": "\$30.00"},
    {"name": "Wapor css", "code": "C789", "sku": "SKU789", "price": "\$30.00"},
    {"name": "Wapor css", "code": "C789", "sku": "SKU789", "price": "\$30.00"},
    {"name": "Wapor css", "code": "C789", "sku": "SKU789", "price": "\$30.00"},
    {"name": "Wapor css", "code": "C789", "sku": "SKU789", "price": "\$30.00"},
  ];
  List<String> headings = ["name", "code", "sku", "price"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavBar(
          fixedWidth: MyUtility.fixedWidthCloverNewDesign,
          headings: headings,
        ),

        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                color: Colors.white,
                // color: Constant.w.withOpacity(0.1),

                child: Row(
                  children: [
                    Container(
                      color: Constant.colorPurple,
                      height: 50,
                      width: 5,
                    ),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            headings.length,
                            (headingIndex) => SizedBox(
                                width: MyUtility.fixedWidthCloverNewDesign,
                                child: Text(
                                  items[index][headings[headingIndex]] ?? "",
                                )),
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Bottom buttons
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  elevation: 2,
                  text: 'Add Items',
                  backgroundColor: Constant.colorPurple,
                  onPressed: () {
                    context.read<InventoryBloc>().add(
                        MenuSelectionEvent(selectedMenu: MyUtility.addItem));
                  },
                ),
              ),
              Gap(10),
              Expanded(
                child: CustomElevatedButton(
                  textColor: Constant.colorBlack,
                  backgroundColor: Constant.colorWhite,
                  elevation: 2,
                  foregroundColor: Constant.colorWhite,
                  text: ' Add item with variants',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
