import 'package:flutter/material.dart';
import 'package:opalposinc/utils/decorations.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double? fontSize;
  final double? elevation, radius;
  final Color? backgroundColor, textColor;
  final IconData? iconData;
  final FontWeight? fontWeight;
  final bool? isLoading, enabled;

  const CustomButton(
      {super.key,
      required this.text,
      this.onTap,
      this.elevation,
      this.backgroundColor,
      this.textColor,
      this.radius,
      this.iconData,
      this.isLoading,
      this.enabled,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: enabled ?? false ? 10.0 : elevation ?? 0.0,
      borderRadius: radius == null ? BorderRadius.circular(10.0) : null,
      color: enabled ?? true
          ? backgroundColor ?? Colors.white
          : Colors.grey.shade800,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: enabled ?? true ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading ?? false
                  ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : iconData != null
                      ? Icon(iconData)
                      : Container(),
              if (iconData != null) Decorations.width5,
              Center(
                  child: Text(
                text,
                style: TextStyle(
                    color: textColor ?? Colors.black,
                    fontSize: fontSize ?? 12.0,
                    fontWeight: fontWeight),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
