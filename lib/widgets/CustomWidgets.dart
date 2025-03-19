import 'package:flutter/material.dart';
import 'package:opalposinc/utils/decorations.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final bool? isHeading;
  const CustomTextWidget({super.key, required this.text, this.isHeading});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isHeading ?? false
          ? Decorations.heading
          : Decorations.body.copyWith(
              color: Colors.black54, fontStyle: FontStyle.normal, fontSize: 12),
    );
  }
}

class CustomRichText extends StatelessWidget {
  final String textBefore, textAfter;
  final TextStyle? beforeStyle, afterStyle;
  const CustomRichText(
      {super.key,
      required this.textBefore,
      required this.textAfter,
      this.beforeStyle,
      this.afterStyle});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: textBefore,
            style: beforeStyle ??
                Decorations.body.copyWith(
                    color: Colors.black54, fontStyle: FontStyle.italic),
            children: [
          TextSpan(
            text: textAfter,
            style: afterStyle ??
                Decorations.heading.copyWith(color: Colors.black, fontSize: 14),
          )
        ]));
  }
}
