import 'package:flutter/material.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/constants_string.dart';
import 'package:opalsystem/widgets/common/Top%20Section/nav_button.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    var isVisible = true;

    return Row(
      children: [
        Button(
          title: StringConstants.runningOrders,
          color: Constant.colorHead,
          onTap: () {},
        ),
        Button(
          title: StringConstants.cart,
          color: Constant.colorPurple,
          onTap: () {},
        ),
        Button(
          title: StringConstants.Product,
          color: Constant.colorBluish,
          onTap: () {
            setState(() {
              isVisible = !isVisible;
            });

            // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
          },
        ),
        Button(
          title: StringConstants.others,
          color: Constant.colorGreen,
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> RunningItems()));
          },
        )
      ],
    );
  }
}
