import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:opalsystem/CloverDesign/Bloc/inventory_bloc.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/widgets/save_and_cancel_buttons.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/utils.dart';
import 'package:opalsystem/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_drop_down_field.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_text_widgets.dart';

class AddItemInventory extends StatefulWidget {
  const AddItemInventory({super.key});

  @override
  State<AddItemInventory> createState() => _AddItemInventoryState();
}

class _AddItemInventoryState extends State<AddItemInventory> {

  bool manageStocks=true;


  String applicableTaxVal="Tax";
  String sellingPriceVal="Exclusive";
  String productTypeVal="Variable";

  String  fileName="";
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12),
        height: context.height,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:"Add Item" ,
                          color: Constant.colorPurple,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,),
                       Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInputField(
                                labelText: '',
                                contentPadding: 10,
                                hintText: "Product Name",
                                toHide: false,
                              ),
                            ),
                            Gap(15),
                            Expanded(
                              child: CustomInputField(
                                contentPadding: 10,
                                hintText: "SKU",
                                toHide: false,
                                labelText: '',
                              ),
                            ),

                            Gap(15),
                            Expanded(
                              child: SizedBox(
                                height: 43,
                                child: CustomDropdownWithField(
                                  items: ["UPC-A", "Option 2", "Option 3"],
                                  onChanged: (value) {},
                                  selectedValue: "UPC-A",
                                  hintText: "Please Select Barcode Type",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(20),




                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: DropDownNoTextField(
                                  items: ["Pieces", "Pc(Cs)"],
                                  displayText: (item) => item,
                                  onChanged: (value) {},
                                  hintText: "Please select units",

                                  // selectedValue: "Pieces",
                                ),
                              ),
                            ),
                            Gap(10),
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: DropDownNoTextField(
                                  items: ["Pieces", "Pc(Cs)"],
                                  hintText: "Please select related sub-units",
                                  displayText: (item) => item,

                                  onChanged: (value) {},
                                  // selectedValue: "Pieces",
                                ),
                              ),
                            ),
                            Gap(10),

                            Expanded(
                              child: SizedBox(
                                height: 43,
                                child: CustomDropdownWithField(
                                  items: ["Elfbar", "Elite", "Looper XL"],
                                  onChanged: (value) {},
                                  // selectedValue: "UPC-A",
                                  hintText: "Please select brand",
                                ),
                              ),
                            ),

                          ],
                        ),

                        Gap(20),




                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 43,
                                child: CustomDropdownWithField(
                                  items: ["Beverages ", "Elite", "Looper XL"],
                                  onChanged: (value) {},
                                  // selectedValue: "UPC-A",
                                  hintText: "Please select sub-category",
                                ),
                              ),
                            ),
                            Gap(10),
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: DropDownNoTextField(
                                  items: ["Pieces", "Pc(Cs)"],
                                  hintText: "Please select sub-category",
                                  displayText: (item) => item,

                                  onChanged: (value) {},
                                  // selectedValue: "Pieces",
                                ),
                              ),
                            ),
                            Gap(10),
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: DropDownNoTextField(
                                  items: ["Pieces", "Pc(Cs)"],
                                  hintText: "Business Locations",
                                  displayText: (item) => item,

                                  onChanged: (value) {},
                                  // selectedValue: "Pieces",
                                ),
                              ),
                            ),


                          ],
                        ),
                        Gap(10),
                        Row(
                          children: [

                            Expanded(child: TextWithTwoIcons(title: "Manage Stocks",onChange:(value){
                              setState(() {
                                manageStocks=value??false;
                              });
                            } ,
                              value:manageStocks ,
                              lowerText: "Enable stock management at product level",
                              )),

                            manageStocks? Expanded(
                              child: CustomInputField(
                                  contentPadding: 10,
                                  labelText: "",
                                  hintText: "Alert Quantity",
                                  toHide: false,
                                  maxLines: 1
                              ),
                            ):SizedBox(),

                          ],
                        ),
                        Gap(10),
                        Row(
                          children: [
                            Expanded(
                              flex:4,
                              child: CustomInputField(
                                labelText: "",
                                  contentPadding: 10,

                                  hintText: "Product Description",
                                toHide: false,
                                maxLines: 2
                              ),
                            ),
                            Gap(10),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [



                                          Column(
                                            children: [
                                              if(result!=null)
                                                Container(

                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(50),


                                                  height: 100,
                                                  decoration:BoxDecoration(
                                                      image: DecorationImage(image: FileImage(File(result!.files.first.path!)))
                                                  ),
                                                ),
                                              Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                             fileName!=""?fileName: 'No file chosen',
                                                              style: TextStyle(color: Colors.grey,fontSize: 10,overflow: TextOverflow.ellipsis),
                                                            ),
                                                          ),
                                                        ),

                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                             result = await FilePicker.platform.pickFiles(
                                                                               type: FileType.custom,
                                                                               allowMultiple: true,
                                                                               allowedExtensions: ['jpg', 'jpeg', 'png', ],
                                                                             );
                                                                            if (result != null) {
                                                                              setState(() {
                                                                                fileName = result!.files.single.name;

                                                                              });
                                                                    
                                                                    
                                                                            }
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              result!=null?
                                                                              GestureDetector(
                                                                                onTap:(){
                                                                                  setState(() {
                                                                                    result=null;
                                                                                  });

                                                                        },
                                                                                child: Container(
                                                                                  height: 35,
                                                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Constant.colorRed,
                                                                                
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.delete,
                                                                                        size: 16,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                                  :Container(),

                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  result = await FilePicker.platform.pickFiles(
                                                                                    type: FileType.custom,
                                                                                    allowMultiple: true,
                                                                                    allowedExtensions: ['jpg', 'jpeg', 'png', ],
                                                                                  );
                                                                                  if (result != null) {
                                                                                    setState(() {
                                                                                      fileName = result!.files.single.name;

                                                                                    });


                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  height: 35,
                                                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Constant.colorPurple,

                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.folder_open,
                                                                                        size: 16,
                                                                                        color: Colors.white,
                                                                                      ),

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Max File size: 5MB\nAspect ratio should be 1:1',
                                            style: TextStyle(color: Colors.grey, fontSize: 8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                              ],),
                            )

                          ],
                        ),
                        Gap(20),

                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 42,
                                      child: DropDownNoTextField(
                                        selectedValue: applicableTaxVal,
                                        items: ["Tax", "None"],
                                        hintText: "Please select applicable tax",
                                        displayText: (item) => item,

                                        onChanged: (value) {
                                          setState(() {
                                            applicableTaxVal=value??"";
                                          });
                                        },
                                        // selectedValue: "Pieces",
                                      ),
                                    ),
                                  ),
                                  Gap(10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 42,
                                      child: DropDownNoTextField(
                                        selectedValue:sellingPriceVal,
                                        items: ["Exclusive", "Inclusive"],
                                        hintText: "Selling Price Tax Type",
                                        displayText: (item) => item,

                                        onChanged: (value) {
                                          setState(() {
                                            sellingPriceVal=value??"";
                                          });
                                        },                                        // selectedValue: "Pieces",
                                      ),
                                    ),
                                  ),
                                  Gap(10),

                                  Expanded(
                                    flex:1,
                                    child: SizedBox(
                                      height: 42,
                                      child: DropDownNoTextField(
                                        selectedValue: productTypeVal,
                                        items: ["Single", "Variable","Combo"],
                                        hintText: "Please select product type",
                                        displayText: (item) => item,

                                        onChanged: (value) {
                                          setState(() {
                                            productTypeVal=value??"";
                                          });
                                        },                                       
                                      ),
                                    ),
                                  ),




                                ],
                              ),
                          
                              Gap(20),
                         if(productTypeVal=="Single" )
                                  Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: BlueContainerWidget(
                                        excTaxController: TextEditingController(),
                                        greenText: 'Purchase Price	',
                                        hinText:"0.00" ,
                                        isIcon: false,
                                        fieldUpperText: "Exc. tax:"),
                                    ),
                                    Expanded(
                                      child: BlueContainerWidget(
                                        excTaxController: TextEditingController(),
                                        greenText: 'x Margin(%)',
                                        hinText:"0.0  0" ,
                                        isIcon: true,
                                        fieldUpperText: "",),
                                    ),
                                    Expanded(
                                      child: BlueContainerWidget(
                                        excTaxController: TextEditingController(),
                                        greenText: 'Selling Price',
                                        hinText:"0.00" ,
                                        isIcon: false,
                                        fieldUpperText:sellingPriceVal=="Exclusive"? "Exc. tax:*":"Inc.Tax",),
                                    ),

                                  ],
                                ),
                              )
                          else
                            Container(
                              height: 200,
                              width:context.width,
                              child:Column(

                                children: [
                                  Container(


                                    child:CustomText(text: "Variation values")

                                  )
                                ],
                              )
                            )
                                






                            ],
                          ),
                        )

                      ],
                    ),
                  )),
              VerticalDivider(
                endIndent: 0,
                indent: 0,
                color: Colors.black,
                thickness: 0.5,
              ),
              BlueAndWhiteButtons(
                onPressedBlue: () {
                  context.read<InventoryBloc>().add(MenuSelectionEvent(selectedMenu: MyUtility.items));
                }, whiteButtonTitle: "Cancel", blueButtonTitle: 'Save',


                onPressedWhite: () {
                context.read<InventoryBloc>().add(MenuSelectionEvent(selectedMenu: MyUtility.items));
              },),
            ],
          ),
        ));
  }
}


