import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
final  List<String> headings;
  const NavBar({
    super.key,
    required this.fixedWidth,
    required this.headings,

  });

  final double fixedWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 5),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(headings.length, (index) =>SizedBox(
            width:fixedWidth,
            child: Text(headings[index], style: const TextStyle(fontWeight: FontWeight.bold))), ),
      )

    );
  }
}
