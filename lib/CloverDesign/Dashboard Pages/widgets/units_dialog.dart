import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalsystem/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_elevated_button.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_text_widgets.dart';
import 'package:opalsystem/utils/constants.dart';

class UnitsDialog extends StatefulWidget {
  final String title;
  final String blueButton;
  final Map<String, String>? initialData;
  final Function(Map<String, String>) onSubmit;

  const UnitsDialog({
    Key? key,
    required this.title,
    required this.blueButton,
    this.initialData,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _UnitsDialogState createState() => _UnitsDialogState();
}

class _UnitsDialogState extends State<UnitsDialog> {
  late TextEditingController nameController;
  late TextEditingController selectedShortName;
  String allowDecimal="Yes";

  final List<String> allowDecimalOptions = ["Yes", "No"];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData?['Name'] ?? "");
    selectedShortName = TextEditingController(text: widget.initialData?['Short name'] ?? "");
    allowDecimal = widget.initialData?['Allow decimal'] ?? allowDecimalOptions.first;
  }

  @override
  void dispose() {
    nameController.dispose();
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
                productNameController: nameController,
                upperText: "Name:",
                fieldText: "Enter name",
              ),
              const Gap(10),
              ReusableTextPlusFieldWidget(
                contentPadding: 7,
                productNameController: selectedShortName,
                upperText: "Short name:",
                fieldText: "Enter short name",
              ),
              const Gap(10),
              const CustomText(text: "Allow Decimal:"),
              const Gap(5),
              DropdownButtonFormField<String>(
                value: allowDecimal,
                onChanged: (value) {
                  setState(() {
                    allowDecimal = value??"No";
                  });
                },
                items: allowDecimalOptions
                    .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
                    .toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
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
                "Name": nameController.text,
                "Short name": selectedShortName.text ?? "",
                "Allow decimal": allowDecimal ?? "",
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
