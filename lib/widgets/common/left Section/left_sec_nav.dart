import 'package:flutter/material.dart';
import 'package:opalposinc/utils/constants.dart';

class LeftSecNav extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color? color;
  const LeftSecNav({
    super.key,
    this.onTap,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / 8.5;
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 57,
          width: buttonWidth,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin: const EdgeInsets.only(left: 3, right: 3),
          decoration: BoxDecoration(
            color: color ?? Constant.colorPurple,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
