import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color color;
  final IconData? iconData;
  final Color? iconColor; // Optional icon color
  final double? iconSize; // Optional icon size

  const Button({
    super.key,
    this.onTap,
    required this.title,
    required this.color,
    this.iconData,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / 4.3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    iconData,
                    color: iconColor ?? Colors.white,
                    size: iconSize ?? 24.0,
                  ),
                ),
              const SizedBox(
                width: 2,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
