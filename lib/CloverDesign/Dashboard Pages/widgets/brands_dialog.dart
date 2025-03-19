import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';
import 'package:opalposinc/utils/constants.dart';

class BrandsDialog extends StatefulWidget {
  final String title;
  final String blueButton;
  final Map<String, String>? initialData;
  final Function(Map<String, String>) onSubmit;

  const BrandsDialog({
    Key? key,
    required this.title,
    required this.blueButton,
    this.initialData,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _BrandsDialogState createState() => _BrandsDialogState();
}

class _BrandsDialogState extends State<BrandsDialog> {
  late TextEditingController brandNameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    brandNameController =
        TextEditingController(text: widget.initialData?['Brand'] ?? "");
    descriptionController =
        TextEditingController(text: widget.initialData?['Description'] ?? "");
  }

  @override
  void dispose() {
    brandNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: brandNameController,
                upperText: "Brand name:",
                fieldText: "Enter brand name",
              ),
              const Gap(10),
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: descriptionController,
                upperText: "Short description :",
                fieldText: "Enter description",
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
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
                "Brand": brandNameController.text,
                "Description": descriptionController.text ?? "",
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
