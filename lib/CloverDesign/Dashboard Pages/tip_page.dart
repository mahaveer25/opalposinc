import 'package:flutter/material.dart';
import 'package:opalposinc/widgets/CustomWidgets/custom_text_widgets.dart';

class Tip extends StatelessWidget {
  const Tip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [CustomText(text: "Tip Page")],
    );
  }
}
