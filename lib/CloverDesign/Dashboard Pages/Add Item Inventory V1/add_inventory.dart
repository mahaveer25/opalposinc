import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_drop_down_field.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';
import 'package:opalposinc/widgets/CustomWidgets/flutter_quil.dart';
import 'package:opalposinc/widgets/common/Right%20Section/brand_dropdown.dart';
import 'package:opalposinc/widgets/common/Top%20Section/location.dart';
import 'package:opalposinc/widgets/common/left%20Section/customer_group.dart';
import 'package:gap/gap.dart';

//
//   class AddInventoryNewDesign extends StatefulWidget {
//
//
//      AddInventoryNewDesign({super.key});
//
//   @override
//   State<AddInventoryNewDesign> createState() => _AddInventoryNewDesignState();
// }
//
// class _AddInventoryNewDesignState extends State<AddInventoryNewDesign> {
//     final TextEditingController productNameController = TextEditingController();
//
//     final TextEditingController barCodeController = TextEditingController();
//
//     final TextEditingController skuController = TextEditingController();
//
//     final TextEditingController relatedSubUnitController = TextEditingController();
//
//     final TextEditingController customField1Controller = TextEditingController();
//
//     final TextEditingController customField2Controller = TextEditingController();
//
//     final TextEditingController customField3Controller = TextEditingController();
//     final TextEditingController excTaxController = TextEditingController();
//
//     final TextEditingController descriptionController = TextEditingController();
//
//      double gapBetweenRows=27;
//
//      bool value1=false;
//      bool value2=false;
//      bool value3=false;
//
//      QuillController _controller = QuillController.basic();
//
//      @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: [
//                 Container(
//
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Gap(20),
//
//
//
//                     Container(
//                       padding:EdgeInsets.symmetric(horizontal: 12,vertical: 10),
//
//                       // decoration: BoxDecoration(
//                       //   borderRadius: BorderRadius.circular(10),
//                       //   color: Colors.white,
//                       //   boxShadow: <BoxShadow>[
//                       //     BoxShadow(
//                       //       offset: Offset(0, 3),
//                       //       blurRadius: 5,
//                       //     ),
//                       //   ],
//                       // ),
//
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             child: const Center(
//                               child: Text(
//                                 'Add New Inventory',
//                                 style: TextStyle(
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           Gap(10),
//                           Row(
//                             children: [
//                               Expanded(child: ReusableTextPlusFieldWidget(fieldText: "Product Name", isStaricValue: true, upperText: "Product Name:", productNameController: productNameController)),
//                               const Gap(10),
//                               Expanded(child: ReusableTextPlusFieldWidget(fieldText: "SKU", upperText: "SKU:",isStaricValue: true, productNameController: skuController,isIcon: true,)),
//                               const Gap(10),
//
//                               Expanded(child: ReusableTextPlusFieldWidget(fieldText: "UPC-A", upperText: "Barcode Type", productNameController: barCodeController)),
//                               Gap( 10),
//
//                               Expanded(child: ReusableDropdownNoTextfield(items: ["sss"],upperText: "Unit:*",selectedValue:"sss" ,hinText: "",)),
//
//
//
//
//                             ],
//                           ),
//                           Gap( gapBetweenRows),
//
//                           Row(
//                             children: [
//                               Expanded(child: ReusableDropdownNoTextfield(items: ["sss"],upperText: "Unit:*",selectedValue:"sss" ,hinText: "",)),
//                               const Gap(10),
//                               Expanded(child: ReusableTextPlusFieldWidget(fieldText: "", upperText: "Related Sub Units:", productNameController: relatedSubUnitController,isIcon: true,)),
//                               const Gap(10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CustomText(text: "Brands",
//                                       fontWeight: FontWeight.bold,
//
//                                     ),
//                                     const Gap(10),
//                                     Container(
//                                       height: 54,
//                                       decoration: BoxDecoration(
//                                         color: Constant.colorWhite,
//                                         border: Border.all(color: Constant.colorGrey, width: 1.0),
//                                         borderRadius: BorderRadius.circular(5.0),),
//                                       width: context.width,
//
//
//                                       child: BrandsDropdown(onBrandChange: (brand) {
//
//                                       },),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Gap(10),
//                               Expanded(child: ReusableDropdownNoTextfield(items: ["sss"],upperText: "Unit:*",selectedValue:"sss" ,hinText: "",)),
//
//
//
//
//                             ],
//                           ),
//                           Gap( gapBetweenRows),
//
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//
//                             children: [
//                               Expanded(child: ReusableDropdownWidget(items: ["Category"],upperText: "Category:",hinText:"Please Select" ,)),
//                               const Gap(10),
//
//                               Expanded(child: ReusableDropdownWidget(items: ["Sub Category"],upperText: "Sub Category:",hinText:"Please Select" ,)),
//                               const Gap(10),
//                               Expanded(child: ReusableTextPlusFieldWidget(fieldText: "0", upperText: "ALert Quantity:", productNameController: relatedSubUnitController,)),
//
//                               const Gap(10),
//                               Expanded(child: ReusableDropdownNoTextfield(upperText:"Selling Price Tax Type:" ,
//                                 isStaricValue: true,
//                                 items: ["Exclusive"],hinText: "None",selectedValue: "Exclusive",)),
//
//
//
//                             ],
//                           ),
//                           Gap( gapBetweenRows),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                                     children: [
//                                       CustomText(text: "Business Locations:",
//                                         fontWeight: FontWeight.bold,
//
//                                       ),
//                                       const Gap(10),
//                                       Container(height: 54,
//                                           decoration: BoxDecoration(
//                                             color: Constant.colorWhite,
//                                             border: Border.all(color: Constant.colorGrey, width: 1.0),
//                                             borderRadius: BorderRadius.circular(5.0),),
//                                           child: LocationDropdown()),
//                                     ],
//                                   )),
//                               const Gap(10),
//                               Expanded(child: ReusableTextPlusFieldWidget(fieldText: "Weight", upperText: "Weight:", productNameController: relatedSubUnitController,isIcon: true,)),
//                               const Gap(10),
//
//                               Expanded(child: ReusableDropdownNoTextfield(upperText:"Applicable Tax:" ,items: ["sdd"],hinText: "None",selectedValue: "sdd",)),
//
//                             ],
//                           ),
//                           Gap( gapBetweenRows),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ReusableTextPlusFieldWidget(
//                                     maxLines: 3,
//                                     fieldText: "",
//                                     upperText: "Product Description:",
//                                     productNameController: descriptionController
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Gap( gapBetweenRows),
//
//                           ///Custom Field
//                           // Row(
//                           //   children: [
//                           //     Expanded(child: ReusableTextPlusFieldWidget(fieldText: "Custom Field1", upperText: "Custom Field1:", productNameController: customField1Controller)),
//                           //     const Gap(10),
//                           //
//                           //     Expanded(child: ReusableTextPlusFieldWidget(fieldText: "Custom Field2", upperText: "Custom Field2:", productNameController: customField1Controller)),
//                           //     const Gap(10),
//                           //
//                           //     Expanded(child: ReusableTextPlusFieldWidget(fieldText: "Custom Field3", upperText: "Custom Field3:", productNameController: customField1Controller)),
//                           //
//                           //   ],
//                           // ),
//
//
//                           Gap( gapBetweenRows-20),
//
//                           Row(
//                             children: [
//                               Expanded(child: TextWithTwoIcons(
//                                 title: "Enable stock management at product level",
//                                 lowerText: "",
//                                 value:value1 ,
//                                 onChange: (bool? newValue) {
//                                   setState(() {
//                                     value1=newValue??false;
//                                   });
//
//                               },)),
//                               const Gap(10),
//
//                               Expanded(child: TextWithTwoIcons(
//                                 value: value2,
//                                 title: "Enable Product description, IMEI or Serial Number",onChange: (bool? newValue) {
//                                 setState(() {
//                                   value2=newValue??false;
//                                 });
//                               },)),
//                               const Gap(10),
//
//                               Expanded(child: TextWithTwoIcons(
//                                 value: value3,
//                                 title: "Not for selling",onChange: (bool? newValue) {
//
//                                 setState(() {
//                                   value3=newValue??false;
//                                 });
//                               },)),
//
//
//
//
//                             ],
//                           ),
//                           Gap(gapBetweenRows-20),
//
//                           Align(
//                             alignment: Alignment.center,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: BlueContainerWidget(
//                                     excTaxController: excTaxController,
//                                     greenText: 'Purchase Price	',
//                                     hinText:"Exc. tax" ,
//                                     isIcon: false,
//                                     fieldUpperText: "Exc. tax:",),
//                                 ),
//                                 Expanded(
//                                   child: BlueContainerWidget(
//                                     excTaxController: excTaxController,
//                                     greenText: 'x Margin(%)',
//                                     hinText:"0.0" ,
//                                     isIcon: true,
//                                     fieldUpperText: "",),
//                                 ),
//                                 Expanded(
//                                   child: BlueContainerWidget(
//                                     excTaxController: excTaxController,
//                                     greenText: 'Selling Price',
//                                     hinText:"Exc. tax" ,
//                                     isIcon: false,
//                                     fieldUpperText: "Exc. tax:*",),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//
//
//
//
//                           Gap(gapBetweenRows),
//
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CustomText(text: "Add Opening Stock",fontSize: 25,fontWeight: FontWeight.bold,),
//                               Gap(gapBetweenRows-10),
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Constant.colorPurple,
//
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//
//                                     CustomText(text: "Location",color: Colors.white,fontWeight: FontWeight.bold,),
//                                     CustomText(text: "Quantity",color: Colors.white,fontWeight: FontWeight.bold,),
//                                     CustomText(text: "Unit Cost (Before Tax)",color: Colors.white,fontWeight: FontWeight.bold,),
//                                     CustomText(text: "Subtotal (Before Tax)",color: Colors.white,fontWeight: FontWeight.bold,),
//
//                                   ],
//                                 ),
//                               ),
//                               ListView.separated(
//                                 shrinkWrap: true,
//                                 itemCount: 2,
//                                 separatorBuilder: (context, index) {
//                                   return Divider();
//
//                                 },
//                                 itemBuilder: (context, index) {
//                                   return   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         CustomText(text: "Euless Vapor & Smoke (BL0002)",),
//                                         Gap(10),
//                                         Expanded(
//                                           child: CustomInputField(
//                                             controller:productNameController,
//                                             labelText: "",
//                                             hintText: "0",
//                                             toHide: false,
//                                           ),
//                                         ),
//                                         Gap(10),
//                                         Expanded(
//                                           child: CustomInputField(
//                                             controller:productNameController,
//                                             labelText: "",
//                                             hintText: "0",
//                                             toHide: false,
//                                           ),
//                                         ),
//                                         Gap(10),
//                                         Expanded(
//                                             child:Container(
//                                               height: 55,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white38,
//                                                   border: Border.all(
//                                                       width: 0.5
//                                                   ),
//                                                   borderRadius: BorderRadius.circular(5)
//                                               ),
//                                               child: Center(
//                                                 child: CustomText(text: "0",fontWeight: FontWeight.bold,),
//                                               ),
//                                             )
//                                         ),
//
//
//
//
//                                       ],
//                                     ),
//                                   );
//                                 },)
//
//
//
//
//
//                             ],
//                           ),
//                           Gap(gapBetweenRows),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               SizedBox(
//                                 width:200,
//                                 child: ElevatedButton(
//
//                                   onPressed: () {
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     foregroundColor: Colors.white,
//                                     backgroundColor: Constant.colorPurple,
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     "Save",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Gap(12),
//                               SizedBox(
//                                 width:200,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     foregroundColor: Colors.white,
//                                     backgroundColor: Constant.colorWhite,
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Go Back',
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Constant.colorGrey
//
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//
//
//
//
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//
//
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       );
//     }
// }
//
class BlueContainerWidget extends StatelessWidget {
  final String greenText;
  final String fieldUpperText;
  final String hinText;
  final bool? isIcon;
  const BlueContainerWidget({
    super.key,
    required this.excTaxController,
    required this.greenText,
    required this.fieldUpperText,
    required this.hinText,
    this.isIcon,
  });

  final TextEditingController excTaxController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      height: context.height * 0.26,
      width: context.width * 0.3,
      child: Column(
        children: [
          Container(
            height: 35,
            width: context.width,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Constant.colorPurple,
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    CustomText(
                      text: greenText,
                      color: Constant.colorWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Gap(10),
                if (isIcon ?? false)
                  Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          ReusableTextPlusFieldWidget(
              padding: 10,
              fieldText: hinText,
              upperText: fieldUpperText,
              productNameController: excTaxController),
        ],
      ),
    );
  }
}

class TextWithTwoIcons extends StatelessWidget {
  final String title;
  final String? lowerText;
  final bool value;
  final void Function(bool?) onChange;
  const TextWithTwoIcons(
      {super.key,
      required this.title,
      this.lowerText,
      required this.onChange,
      this.value = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                activeColor: Constant.colorPurple,
                value: value,
                tristate: false,
                onChanged: onChange),
            Expanded(
              // Ensures Row content doesn't overflow
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomText(
          text: lowerText ?? "",
          fontWeight: FontWeight.bold,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
          color: Constant.colorGrey,
        ),
      ],
    );
  }
}

class ReusableDropdownNoTextfield extends StatelessWidget {
  final List<String> items;
  final String? hinText;
  final String upperText;
  final String selectedValue;
  final bool isStaricValue;

  const ReusableDropdownNoTextfield(
      {super.key,
      required this.items,
      this.hinText,
      required this.upperText,
      required this.selectedValue,
      this.isStaricValue = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              upperText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isStaricValue)
              CustomText(
                text: "*",
                color: Constant.colorRed,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
        Gap(10),
        DropDownNoTextField(
          items: items,
          displayText: (item) => item,
          onChanged: (value) {},
          selectedValue: selectedValue,
        ),
      ],
    );
  }
}

class ReusableDropdownWidget extends StatelessWidget {
  final List<String> items;
  final String? hinText;
  final String upperText;

  const ReusableDropdownWidget({
    super.key,
    required this.items,
    this.hinText,
    required this.upperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          upperText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Gap(10),
        CustomDropdownWithField(
          items: items,
          onChanged: (value) {},
          hintText: hinText ?? "",
        ),
      ],
    );
  }
}

class ReusableTextPlusFieldWidget extends StatelessWidget {
  const ReusableTextPlusFieldWidget(
      {super.key,
      required this.productNameController,
      required this.upperText,
      required this.fieldText,
      this.padding = 0.0,
      this.contentPadding,
      this.isIcon,
      this.maxLines = 1,
      this.isStaricValue = false});

  final TextEditingController productNameController;
  final String upperText;
  final String fieldText;
  final bool? isIcon;
  final double? padding;
  final int? maxLines;
  final bool isStaricValue;
  final double? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: upperText,
                fontWeight: FontWeight.bold,
              ),
              if (isStaricValue)
                CustomText(
                  text: "*",
                  color: Constant.colorRed,
                  fontWeight: FontWeight.bold,
                ),
              const Gap(5),
              if (isIcon ?? false)
                Icon(
                  Icons.info,
                  color: Constant.colorPurple,
                  size: 15,
                ),
            ],
          ),
          Gap(10),
          CustomInputField(
            contentPadding: contentPadding,
            controller: productNameController,
            labelText: "",
            hintText: fieldText,
            toHide: false,
            maxLines: maxLines ?? 1,
          ),
        ],
      ),
    );
  }
}
