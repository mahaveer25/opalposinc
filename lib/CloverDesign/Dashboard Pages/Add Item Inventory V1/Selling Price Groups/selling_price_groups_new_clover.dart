import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/navbar.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/selling_price_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/utils.dart';

class SellingPriceGroupsNewClover extends StatefulWidget {
  const SellingPriceGroupsNewClover({super.key});

  @override
  State<SellingPriceGroupsNewClover> createState() =>
      _SellingPriceGroupsNewCloverState();
}

class _SellingPriceGroupsNewCloverState
    extends State<SellingPriceGroupsNewClover> {
  final List<Map<String, String>> sellingPrices = [
    {
      "Name": "Grocery",
      "Description": "Items: Apples, Bananas, Oranges; Quantity: 10"
    },
    {
      "Name": "Electronics",
      "Description": "Items: Mobile Phones, Chargers, Headphones; Quantity: 5"
    },
    {
      "Name": "Clothing",
      "Description": "Items: T-Shirts, Jeans, Jackets; Quantity: 20"
    },
    {
      "Name": "Stationery",
      "Description": "Items: Pens, Notebooks, Erasers; Quantity: 50"
    },
    {
      "Name": "Furniture",
      "Description": "Items: Chairs, Tables, Sofas; Quantity: 15"
    },
    {
      "Name": "Toys",
      "Description": "Items: Dolls, Cars, Puzzles; Quantity: 30"
    },
    {
      "Name": "Beverages",
      "Description": "Items: Juices, Sodas, Water Bottles; Quantity: 25"
    },
    {
      "Name": "Snacks",
      "Description": "Items: Chips, Biscuits, Chocolates; Quantity: 40"
    },
    {
      "Name": "Books",
      "Description": "Items: Novels, Comics, Magazines; Quantity: 12"
    },
    {
      "Name": "Hardware",
      "Description": "Items: Nails, Screws, Hammers; Quantity: 100"
    }
  ];

  int activeIndex = -1;
  List<int> deactivateIndex = [];

  @override
  Widget build(BuildContext context) {
    List<String> headings = ["Name", "Description"];

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: MyUtility.fixedWidthCloverNewDesign,
                      child: Text("Name",
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Description",
                          style: const TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(
                    width: MyUtility.fixedWidthCloverNewDesign,
                    child: Text("Actions",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sellingPrices.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    sellingPrices[index]["Name"] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Remaining space for Values
                                Expanded(
                                  child: Text(
                                    sellingPrices[index]["Description"] ?? "",
                                    style: const TextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: MyUtility.fixedWidthCloverNewDesign,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return SellingPriceDialog(
                                                  title: "Edit Selling ",
                                                  blueButton: "Update",

                                                  initialData: sellingPrices[
                                                      index], // Pass the current variation data
                                                  onSubmit: (data) {
                                                    setState(() {
                                                      sellingPrices[index] =
                                                          data;
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
                                              sellingPrices.removeAt(index);
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Constant.colorRed,
                                          )),
                                      Gap(15),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (!deactivateIndex
                                                  .contains(index)) {
                                                deactivateIndex.add(index);
                                              } else {
                                                deactivateIndex.removeWhere(
                                                  (element) => element == index,
                                                );
                                              }
                                            });
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.powerOff,
                                            color:
                                                deactivateIndex.contains(index)
                                                    ? Constant.colorGreen
                                                    : Constant.colorRed,
                                            size: 20,
                                          )),
                                    ],
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
                  return SellingPriceDialog(
                    title: "Add selling price group",
                    blueButton: "Save",
                    onSubmit: (data) {
                      setState(() {
                        sellingPrices.add(data);
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
