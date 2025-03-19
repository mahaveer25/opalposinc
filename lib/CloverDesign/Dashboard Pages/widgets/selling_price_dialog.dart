import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_text_widgets.dart';

class SellingPriceDialog extends StatefulWidget {
  final String title;
  final String blueButton;
  final Map<String, String>? initialData;
  final Function(Map<String, String>) onSubmit;

  const SellingPriceDialog({
    Key? key,
    required this.title,
    this.initialData,
    required this.onSubmit,
    required this.blueButton,
  }) : super(key: key);

  @override
  _SellingPriceDialogState createState() => _SellingPriceDialogState();
}

class _SellingPriceDialogState extends State<SellingPriceDialog> {
  late TextEditingController variationNameController;
  late List<TextEditingController> valueControllers;

  @override
  void initState() {
    super.initState();
    variationNameController = TextEditingController(
        text: widget.initialData?["Variations"] ?? "");
    valueControllers = (widget.initialData?["Values"] ?? "")
        .split(", ")
        .where((value) => value.isNotEmpty)
        .map((value) => TextEditingController(text: value))
        .toList();

    if (valueControllers.isEmpty) {
      _addValueField();
    }
  }

  @override
  void dispose() {
    variationNameController.dispose();
    for (var controller in valueControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addValueField() {
    setState(() {
      valueControllers.add(TextEditingController());
    });
  }

  void _removeValueField(int index) {
    setState(() {
      valueControllers[index].dispose();
      valueControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: variationNameController,
                upperText: "Variation Name:",
                fieldText: "Enter variation name",
              ),
              const Gap(10),
              const CustomText(text: "Variation Values:"),
              const Gap(10),
              Column(
                children: List.generate(valueControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableTextPlusFieldWidget(
                            contentPadding: 7,
                            productNameController: valueControllers[index],
                            upperText: "Value ${index + 1}:",
                            fieldText: "Enter value",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.red),
                          onPressed: () {
                            _removeValueField(index);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const Gap(10),
              TextButton(
                onPressed: _addValueField,
                child: const Text("+ Add Value"),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                ],
              ),


            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 6),


      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        SizedBox(
          height: 40,
          child: CustomElevatedButton(
            padding: const EdgeInsets.all(6),
            fontSize: 12,
            text: widget.blueButton,
            onPressed: () {
              widget.onSubmit({
                "Variations": variationNameController.text,
                "Values": valueControllers
                    .map((controller) => controller.text)
                    .where((value) => value.isNotEmpty)
                    .join(","),
              });
              Navigator.pop(context);
            },
            backgroundColor: Constant.colorPurple,
            textColor: Colors.white,
          ),
        ),
      ],

    );
  }
}