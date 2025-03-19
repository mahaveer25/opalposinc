import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/navbar.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/units_dialog.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/variants_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/utils.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';

class UnitsNewClover extends StatefulWidget {
  const UnitsNewClover({super.key});

  @override
  State<UnitsNewClover> createState() => _UnitsNewCloverState();
}

class _UnitsNewCloverState extends State<UnitsNewClover> {
  final List<Map<String, String>> units = [
    {"Name": "Grocery", "Short name": "Gro", "Allow decimal": "Yes"},
    {"Name": "Electronics", "Short name": "Elec", "Allow decimal": "No"},
    {"Name": "Clothing", "Short name": "Cloth", "Allow decimal": "Yes"},
    {"Name": "Stationery", "Short name": "Stat", "Allow decimal": "Yes"},
    {"Name": "Furniture", "Short name": "Furn", "Allow decimal": "No"},
    {"Name": "Toys", "Short name": "Toy", "Allow decimal": "Yes"},
    {"Name": "Beverages", "Short name": "Bev", "Allow decimal": "No"},
    {"Name": "Snacks", "Short name": "Snack", "Allow decimal": "Yes"},
    {"Name": "Books", "Short name": "Book", "Allow decimal": "No"},
    {"Name": "Hardware", "Short name": "Hard", "Allow decimal": "No"}
  ];
  @override
  Widget build(BuildContext context) {
    List<String> headings = ["Name", "Short name", "Allow decimal"];

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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: units.length,
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
                                Expanded(
                                  child: Text(
                                    units[index]["Name"] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Remaining space for Values
                                Expanded(
                                  child: Text(
                                    units[index]["Short name"] ?? "",
                                    style: const TextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    units[index]["Allow decimal"] ?? "",
                                    style: const TextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: MyUtility.fixedWidthCloverNewDesign,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return UnitsDialog(
                                                    title: "Edit Unit",
                                                    blueButton: "Update",

                                                    initialData: units[
                                                        index], // Pass the current variation data
                                                    onSubmit: (data) {
                                                      setState(() {
                                                        units[index] = data;
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
                                        Gap(15),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                units.removeAt(index);
                                              });
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Constant.colorRed,
                                            )),
                                      ],
                                    ),
                                  ),
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
                  return UnitsDialog(
                    title: "Add Unit",
                    blueButton: "Save",
                    onSubmit: (data) {
                      setState(() {
                        units.add(data);
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
