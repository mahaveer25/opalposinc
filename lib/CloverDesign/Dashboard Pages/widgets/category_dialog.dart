import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';

class CategoryDialog extends StatefulWidget {
  final String title;
  final String blueButton;
  final Map<String, String>? initialData;
  final Function(Map<String, String>) onSubmit;

  const CategoryDialog({
    Key? key,
    required this.title,
    this.initialData,
    required this.onSubmit,
    required this.blueButton,
  }) : super(key: key);

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      "Category":
          TextEditingController(text: widget.initialData?["Category"] ?? ""),
      "Category code": TextEditingController(
          text: widget.initialData?["Category code"] ?? ""),
      "Description":
          TextEditingController(text: widget.initialData?["Description"] ?? ""),
    };
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: controllers["Category"]!,
                upperText: "Category name:",
                fieldText: "Category name",
              ),
              const Gap(10),
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: controllers["Category code"]!,
                upperText: "Category code:",
                fieldText: "Category code",
              ),
              const Gap(10),
              const CustomText(text: "Category code is same as HSN code"),
              const Gap(10),
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: controllers["Description"]!,
                upperText: "Description:",
                maxLines: 2,
                fieldText: "Description",
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog without saving
                    },
                    child: const Text("Close"),
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomElevatedButton(
                      padding: const EdgeInsets.all(6),
                      fontSize: 12,
                      text: widget.blueButton,
                      onPressed: () {
                        // Gather data and pass it to the callback
                        widget.onSubmit({
                          "Category": controllers["Category"]!.text,
                          "Category code": controllers["Category code"]!.text,
                          "Description": controllers["Description"]!.text,
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: Constant.colorPurple,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
