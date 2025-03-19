import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opalsystem/utils/assets.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_text_widgets.dart';

class CommonAppBarV1 extends StatelessWidget {
  final String title;
  final String?  imagePath;
  final List<Widget>? actionList;
  const CommonAppBarV1({super.key,required   this.title, this.imagePath,this.actionList});

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: Constant.colorWhite,
      surfaceTintColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CustomText(
              text: title,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          const  Gap(12),
            if(imagePath!=null)
              Image.asset(
              imagePath??"",
              height: 32,
              width: 32,
            ),
          ],
        ),
      ),
      actions: actionList,
    );
  }
}
