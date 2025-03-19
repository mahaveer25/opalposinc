import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opalposinc/utils/constants.dart';

class ToastUtility {
  static void showToast({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Constant.colorGrey,
    Color textColor = Constant.colorWhite,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      webShowClose: true,
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
