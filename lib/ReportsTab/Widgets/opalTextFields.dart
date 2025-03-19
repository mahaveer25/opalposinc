import 'package:flutter/material.dart';

class OpalTextFields extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onFieldChanged;

  const OpalTextFields(
      {super.key, required this.textController, required this.onFieldChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      onChanged: onFieldChanged,
    );
  }
}



