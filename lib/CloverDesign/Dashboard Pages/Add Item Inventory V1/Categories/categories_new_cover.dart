import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/category_dialog.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/navbar.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/utils.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';

class CategoriesNewClover extends StatefulWidget {
  const CategoriesNewClover({super.key});

  @override
  State<CategoriesNewClover> createState() => _CategoriesNewCloverState();
}

class _CategoriesNewCloverState extends State<CategoriesNewClover> {
  Map<String, TextEditingController> controllers = Map();
  final List<Map<String, String>> categories = [
    {"Category": "Vapor ", "Category code": "Disposible F", "Description": "8"},
    {
      "Category": "Cigerattes ",
      "Category code": "Gold Fumes",
      "Description": "7"
    },
    {"Category": "Dollar ", "Category code": "Pencil, ", "Description": "7"},
    {
      "Category": "Energy Drink",
      "Category code": "Red Bull",
      "Description": "10"
    },
    {
      "Category": "Snacks ",
      "Category code": "Chips, Chocolate Bar",
      "Description": "15"
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<String> headings = ["Category", "Category code", "Description"];

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavBar(
                  fixedWidth: MyUtility.fixedWidthCloverNewDesign,
                  headings: headings,
                ),
                SizedBox(
                    width: MyUtility.fixedWidthCloverNewDesign,
                    child: Text("Actions",
                        style: const TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color: Constant.colorPurple,
                          height: 50,
                          width: 5,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  headings.length,
                                  (headingIndex) {
                                    return SizedBox(
                                      width:
                                          MyUtility.fixedWidthCloverNewDesign,
                                      child: Text(
                                        categories[index]
                                                [headings[headingIndex]] ??
                                            "",
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MyUtility.fixedWidthCloverNewDesign,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Constant.colorPurple),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CategoryDialog(
                                              blueButton: "Update",
                                              title: 'Edit Details',
                                              initialData: categories[index],
                                              onSubmit: (updatedData) {
                                                setState(() {
                                                  categories[index] =
                                                      updatedData;
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Constant.colorRed),
                                      onPressed: () {
                                        setState(() {
                                          categories.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Deleted ${categories[index]['Name']}")),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CategoryDialog(
                    blueButton: "Save",
                    title: 'Add Details',
                    onSubmit: (updatedData) {
                      setState(() {
                        categories.add(updatedData);
                      });
                    },
                  );
                },
              );
            },
            child: const Icon(
              Icons.add,
              color: Constant.colorWhite,
            ),
            backgroundColor: Constant.colorPurple, // Customize the color
          ),
        ),
      ],
    );
  }
}
