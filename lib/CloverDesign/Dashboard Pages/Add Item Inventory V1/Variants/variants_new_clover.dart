import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/navbar.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/variants_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/utils.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';

class VariantsNewClover extends StatefulWidget {
  const VariantsNewClover({super.key});

  @override
  State<VariantsNewClover> createState() => _VariantsNewCloverState();
}

class _VariantsNewCloverState extends State<VariantsNewClover> {
  final List<Map<String, String>> variations = [
    {
      "Variations": "Burger",
      "Values":
          "Cheese, Lettuce, Tomato,Cheese, Lettuce, Tomato,Cheese, Lettuce, Tomato,Cheese, Lettuce, Tomato"
    },
    {"Variations": "Pizza", "Values": "Pepperoni, Olives, Mushrooms "},
    {"Variations": "Pasta", "Values": "Alfredo Sauce, Spicy Sauce "},
    {"Variations": "Sandwich", "Values": "Grilled, Toasted "},
    {"Variations": "Salad", "Values": "Croutons, Dressing, Cheese"},
  ];

  @override
  Widget build(BuildContext context) {
    List<String> headings = ["Variations", "Values"];

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBar(
                  fixedWidth: MyUtility.fixedWidthCloverNewDesign,
                  headings: headings,
                ),
                SizedBox(
                  width: MyUtility.fixedWidthCloverNewDesign,
                  child: Text("Actions",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: variations.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          color: Constant.colorPurple,
                          width: 5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Fixed width for Variations
                                SizedBox(
                                  width: MyUtility.fixedWidthCloverNewDesign,
                                  child: Text(
                                    variations[index]["Variations"] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Remaining space for Values
                                Expanded(
                                  child: Text(
                                    variations[index]["Values"] ?? "",
                                    style: const TextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Fixed size for the edit icon
                                SizedBox(
                                  width: MyUtility.fixedWidthCloverNewDesign,
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return VariationsDialog(
                                              title: "Edit Variation",
                                              blueButton: "Update",
                                              initialData: variations[
                                                  index], // Pass the current variation data
                                              onSubmit: (data) {
                                                setState(() {
                                                  variations[index] = data;
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Constant.colorPurple,
                                      )),
                                ),
                              ],
                            ),
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
                builder: (context) {
                  return VariationsDialog(
                    title: "Add Variation",
                    blueButton: "Save",
                    onSubmit: (data) {
                      debugPrint(data.toString());
                      setState(() {
                        variations.add(data);
                      });
                    },
                  );
                },
              );
            },
            child: const Icon(Icons.add, color: Constant.colorWhite),
            backgroundColor: Constant.colorPurple, // Customize the color
          ),
        ),
      ],
    );
  }
}
