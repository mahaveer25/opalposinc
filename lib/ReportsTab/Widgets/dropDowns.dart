import 'package:flutter/material.dart';

import '../../utils/decorations.dart';

class OpalDropDown extends StatelessWidget {
  final List<Text> items;
  final String selectedWidget, headingText;
  void Function(String?)? onChanged;
   OpalDropDown(
      {super.key,
      required this.items,
      required this.selectedWidget,
      required this.headingText,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              headingText,
              style: Decorations.caption,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Material(
              borderRadius: BorderRadius.circular(10.0),
              clipBehavior: Clip.hardEdge,
              child: DropdownButtonFormField(
                  isDense: true,
                  borderRadius: BorderRadius.circular(10.0),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1)),
                  value: items[0].data,
                  items: items
                      .map((e) => DropdownMenuItem(
                            value: e.data,
                            child: e,
                          ))
                      .toList(),
                  onChanged: onChanged),
            ))
          ],
        )
      ],
    ));
  }
}
