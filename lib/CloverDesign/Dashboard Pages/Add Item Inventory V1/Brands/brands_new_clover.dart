import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/widgets/brands_dialog.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/widgets/navbar.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/utils.dart';

class BrandsNewClover extends StatefulWidget {
  const BrandsNewClover({super.key});

  @override
  State<BrandsNewClover> createState() => _BrandsNewCloverState();
}
final List<Map<String, String>> brands = [
  {
    "Brand": "Grocery",
    "Description": "Items: Apples, Bananas, Oranges; Quantity: 10"
  },
  {
    "Brand": "Electronics",
    "Description": "Items: Mobile Phones, Chargers, Headphones; Quantity: 5"
  },
  {
    "Brand": "Clothing",
    "Description": "Items: T-Shirts, Jeans, Jackets; Quantity: 20"
  },
  {
    "Brand": "Stationery",
    "Description": "Items: Pens, Notebooks, Erasers; Quantity: 50"
  },
  {
    "Brand": "Furniture",
    "Description": "Items: Chairs, Tables, Sofas; Quantity: 15"
  },
  {
    "Brand": "Toys",
    "Description": "Items: Dolls, Cars, Puzzles; Quantity: 30"
  },
  {
    "Brand": "Beverages",
    "Description": "Items: Juices, Sodas, Water Bottles; Quantity: 25"
  },
  {
    "Brand": "Snacks",
    "Description": "Items: Chips, Biscuits, Chocolates; Quantity: 40"
  },
  {
    "Brand": "Books",
    "Description": "Items: Novels, Comics, Magazines; Quantity: 12"
  },
  {
    "Brand": "Hardware",
    "Description": "Items: Nails, Screws, Hammers; Quantity: 100"
  },
];


class _BrandsNewCloverState extends State<BrandsNewClover> {




  List<String> headings=["Brand", "Description",];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NavBar(
                    fixedWidth: MyUtility.fixedWidthCloverNewDesign,
                    headings: headings,
                  ),
                  SizedBox(
                    width: MyUtility.fixedWidthCloverNewDesign,
                    child: Text("Actions", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Container(
                          color: Constant.colorPurple,
                          width: 5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                SizedBox(
                                  width:MyUtility.fixedWidthCloverNewDesign,
                                  child: Text(
                                    brands[index]["Brand"] ?? "",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Remaining space for Values
                                Expanded(
                                  child: Text(
                                    brands[index]["Description"] ?? "",
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
                                          onTap:() {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return BrandsDialog(
                                                  title: "Edit brand",
                                                  blueButton: "Update",

                                                  initialData: brands[index], // Pass the current variation data
                                                  onSubmit: (data) {
                                                    setState(() {
                                                      brands[index] = data;
                                                    });
                                                  },
                                                );
                                              },
                                            );
                                          } ,
                                          child: Icon(Icons.edit,color: Constant.colorPurple,)),
                                      Gap(15),
                                      GestureDetector(
                                          onTap:() {
                                            setState(() {
                                              brands.removeAt(index);
                                            });
                                          } ,
                                          child: Icon(Icons.delete,color: Constant.colorRed,)),
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
                  return BrandsDialog(
                    title: "Add Unit",
                    blueButton: "Save",

                    onSubmit: (data) {
                      setState(() {
                        brands.add(  data);
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
