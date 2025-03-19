import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:opalsystem/utils/constants.dart';

class CustomInputField extends StatelessWidget {
  final Widget? icon;
  final String labelText;
  final bool? toHide, enabled, noFill;
  final String hintText;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final int? maxLines;
  final TextInputType? inputType;
  final double? contentPadding;
  final TextStyle? labelStyle;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.toHide,
    this.onChanged,
    this.maxLines,
    this.inputType,
    this.enabled,
    this.noFill,
    this.labelStyle,
    this.icon, this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      controller: controller,
      obscureText: toHide ?? false,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      autofocus: false,
      onTapOutside: (event) =>  FocusManager.instance.primaryFocus?.unfocus(),
      keyboardType: inputType ?? TextInputType.text,
      decoration: InputDecoration(

        isDense: true,
        filled: true,
        fillColor: Colors.white, // Set background color to white
        suffixText: labelText,
        suffixIcon: icon,
        suffixStyle: labelStyle??TextStyle(color: Colors.grey.withOpacity(0.8)),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14,color: Constant.colorGrey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey), // Set border color
          borderRadius: BorderRadius.circular(5.0), // Border radius
        ),
        contentPadding:  EdgeInsets.all(contentPadding??16),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.blue), // Focused border color
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.grey), // Default border color
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
