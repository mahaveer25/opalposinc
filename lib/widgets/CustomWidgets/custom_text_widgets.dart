import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final double? wordSpacing;
  final String? fontFamily;
  final TextStyle? customStyle;

  const CustomText(
  {
        Key? key,
        this.fontSize,
        required  this.text,
        this.color,
        this.fontWeight,
        this.textAlign,
        this.decoration,
        this.overflow,
        this.maxLines,
        this.letterSpacing,
        this.wordSpacing,
        this.fontFamily,
        this.customStyle,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: customStyle ??
          TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            decoration: decoration,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            fontFamily: fontFamily,
          ),
    );
  }
}
