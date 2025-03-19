import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle? heading({required BuildContext context}) =>
      const TextStyle().copyWith(color: Colors.white);

  static TextStyle? bodyFontBig({required BuildContext context}) =>
      const TextStyle().copyWith(color: Colors.white, fontSize: 23.0);

  static TextStyle? body({required BuildContext context, Color? color}) =>
      const TextStyle().copyWith(color: color ?? Colors.black, fontSize: 14.0);
}

class InputBorders {
  static defaultInputDecor({required String hintText}) => InputDecoration(
    hintText: hintText,
    

  );
}
