import 'package:flutter/material.dart';

class CustomMaterialWidget extends StatelessWidget {
  final IconData? icon;
  final Function()? onPressed;
  final Color? backgroundColor, iconColor;
  final double? padding;
  final Widget? child;
  const CustomMaterialWidget(
      {super.key,
      this.icon,
      required this.onPressed,
      this.backgroundColor,
      this.iconColor,
      this.padding,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.hardEdge,
      color: backgroundColor ?? Colors.white,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
            padding: EdgeInsets.all(padding ?? 15.0),
            child: child ??
                Icon(
                  icon,
                  color: iconColor ?? Colors.black,
                )),
      ),
    );
  }
}
