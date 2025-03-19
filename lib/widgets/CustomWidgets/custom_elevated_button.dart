import 'package:flutter/material.dart';
import 'package:opalsystem/utils/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final  Color? backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color textColor;
  final bool? isLoadingCheck;
  // final Widget? textWidget;


  // Constructor with all customizable properties
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor=Colors.white,
    this.backgroundColor ,
    this.foregroundColor = Colors.white, // Default text color if not provided
    this.elevation = 5.0, // Default elevation
    this.borderRadius = 6.0, // Default border radius
    this.fontSize = 16.0, // Default font size
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    this.borderColor,
    this.isLoadingCheck=false,
    // this.textWidget, // Default padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor, // Text color
        backgroundColor: backgroundColor??Constant.colorPurple, // Button color
        elevation: elevation,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor??Colors.transparent,
            width: 0.3
          ),
          borderRadius: BorderRadius.circular(borderRadius), // Border radius
        ),
        padding: padding, // Custom padding
      ),
      child: (isLoadingCheck??false)?const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white),
        ),
      ):Text(
        text,
        style: TextStyle(
          color:textColor ,
          fontSize: fontSize, // Custom font size
        ),
      )
    );
  }
}
