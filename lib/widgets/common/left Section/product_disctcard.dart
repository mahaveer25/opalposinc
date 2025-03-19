import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/Functions/FunctionsProduct.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

import '../../../model/product.dart';
import '../../CustomWidgets/CustomIniputField.dart';
import '../../major/left_section.dart';

class ProductDiscCard extends StatefulWidget {
  final Product product;
  final void Function(double) updateProductPriceCallback;
  const ProductDiscCard({
    super.key,
    required this.product,
    required this.updateProductPriceCallback,
  });

  @override
  State<ProductDiscCard> createState() => _ProductDiscCardState();
}

class _ProductDiscCardState extends State<ProductDiscCard> {
  TextEditingController textEditingController = TextEditingController();
  List<String> items = ['Fixed', 'Percentage'];
  String selectedValue = 'Fixed';
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDiscount = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      log("BEfore Product Unit_price${widget.product.unit_price}");
      productPrice.text =
          double.parse(widget.product.unit_price.toString()).toStringAsFixed(2);
      // double.parse(widget.product.calculate.toString())
      //     .toStringAsFixed(2) ??
      alreadyDiscount();
    });
  }

  void alreadyDiscount() {
    setState(() {
      // Check if the lineDiscountType is valid and exists in the items
      if (widget.product.lineDiscountType != null &&
          widget.product.lineDiscountType!.isNotEmpty &&
          items.contains(widget.product.lineDiscountType)) {
        selectedValue = widget.product.lineDiscountType!;
      } else {
        selectedValue = items.first; // Default to the first item if not valid
      }
      productDiscount.text = (widget.product.lineDiscountAmount == '0.0'
          ? ""
          : widget.product.lineDiscountAmount)!;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    double price =
        productPrice.text.isNotEmpty ? double.parse(productPrice.text) : 0.0;
    double? discount = productDiscount.text.isNotEmpty
        ? double.parse(productDiscount.text)
        : 0.0;
    double discountPrice = FunctionProduct.applyDiscount(
        selectedValue: selectedValue, discount: discount, amount: price);
    log("Product Price $price");
    log("Product Discount $discount");
    log("Product DiscountType $selectedValue");

    widget.product.lineDiscountAmount = discount.toString();
    widget.product.calculate = discountPrice.toString();
    widget.product.unit_price = price.toString();
    widget.product.lineDiscountType = selectedValue;

    widget.updateProductPriceCallback(double.parse(widget.product.calculate!));

    await displayManager.transferDataToPresentation(
        {'type': 'update', 'product': widget.product.toJson()});

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: BlocBuilder<IsMobile, bool>(
                builder: (context, isMobile) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          widget.product.name!,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                              labelText: 'Price',
                              hintText: 'Price',
                              controller: productPrice,
                              onChanged: (value) => setState(() {
                                widget.product.unit_price = value;
                              }),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Constant.colorGrey, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  items: items
                                      .map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    height: 40,
                                    width: 150,
                                  ),
                                  dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 200,
                                  ),
                                  menuItemStyleData:
                                      const MenuItemStyleData(height: 40),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: textEditingController,
                                    searchInnerWidgetHeight: 50,
                                    searchInnerWidget: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 4,
                                        right: 8,
                                        left: 8,
                                      ),
                                      child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        controller: textEditingController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'Search for an item...',
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return item.value
                                          .toString()
                                          .contains(searchValue);
                                    },
                                  ),
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (!isMobile)
                            const SizedBox(
                              width: 2,
                            ),
                          if (!isMobile)
                            Expanded(
                              child: CustomInputField(
                                hintText: 'Discount Amount',
                                labelText: 'DiscountAmount',
                                controller: productDiscount,
                                onChanged: (value) {
                                  if (productDiscount.text.isNotEmpty) {
                                    if (selectedValue == 'Fixed') {
                                      if (double.parse(productDiscount.text) >
                                          double.parse(productPrice.text)) {
                                        setState(() {
                                          productDiscount.text =
                                              productPrice.text;
                                        });
                                      }
                                    } else {
                                      if (int.parse(productDiscount.text) >
                                          100.0) {
                                        setState(() {
                                          productDiscount.text =
                                              100.0.toStringAsFixed(2);
                                        });
                                      }
                                    }
                                  }
                                },
                              ),
                            )
                        ],
                      ),
                      if (isMobile)
                        const SizedBox(
                          height: 10,
                        ),
                      if (isMobile)
                        CustomInputField(
                          hintText: 'Discount Amount',
                          labelText: 'DiscountAmount',
                          controller: productDiscount,
                          onChanged: (value) {
                            if (productDiscount.text.isNotEmpty) {
                              if (selectedValue == 'Fixed') {
                                if (double.parse(productDiscount.text) >
                                    double.parse(productPrice.text)) {
                                  setState(() {
                                    productDiscount.text = productPrice.text;
                                  });
                                }
                              } else {
                                if (int.parse(productDiscount.text) > 100.0) {
                                  setState(() {
                                    productDiscount.text =
                                        100.0.toStringAsFixed(2);
                                  });
                                }
                              }
                            }
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                              labelText: "Description",
                              hintText: "Description",
                              maxLines: 5,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Constant.colorPurple,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: submitForm,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Constant.colorPurple,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
