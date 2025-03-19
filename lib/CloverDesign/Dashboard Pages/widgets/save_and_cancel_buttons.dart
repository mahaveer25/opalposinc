import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:opalsystem/CloverDesign/Bloc/inventory_bloc.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/utils.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_elevated_button.dart';


class BlueAndWhiteButtons extends StatelessWidget {
  final  VoidCallback onPressedBlue;
  final VoidCallback onPressedWhite;
  final String blueButtonTitle;
  final String whiteButtonTitle;
  final bool? isLoadingCheckBlue;
  final bool? isLoadingCheckWhite;
  // final Widget? textWidgetBlue;
  // final Widget? textWidgetWhite;

  const BlueAndWhiteButtons({
    super.key,
    required this.onPressedBlue,
    required this.onPressedWhite,
    required this.blueButtonTitle,
    required this.whiteButtonTitle,this.isLoadingCheckBlue, this.isLoadingCheckWhite,
    // this.textWidgetBlue, this.textWidgetWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SaveAndCancelButtons(
          isLoadingCheckBlue: isLoadingCheckBlue,
          isLoadingCheckWhite:isLoadingCheckWhite ,
          // textWidgetBlue: textWidgetBlue,
          // textWidgetWhite: textWidgetWhite,
          onPressedCancel: onPressedWhite,
              whiteButtonTitle: whiteButtonTitle,
          blueButtonTitle: blueButtonTitle,
          onPressedSave: onPressedBlue,

        ),
      ),
    );
  }
}




class SaveAndCancelButtons extends StatelessWidget {
  final  VoidCallback onPressedSave;
  final VoidCallback onPressedCancel;
  final String blueButtonTitle;
  final String whiteButtonTitle;
  final bool? isLoadingCheckBlue;
  final bool? isLoadingCheckWhite;
  // final Widget? textWidgetBlue;
  // final Widget? textWidgetWhite;


  const SaveAndCancelButtons({
    super.key,  required this.onPressedSave, required this.onPressedCancel,
    required this.blueButtonTitle, required this.whiteButtonTitle,
    // this.textWidgetBlue,
    this.isLoadingCheckBlue,
    this.isLoadingCheckWhite,
    // this.textWidgetWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 80,
          width: 170,
          child: CustomElevatedButton(
            // textWidget: textWidgetBlue,
            isLoadingCheck: isLoadingCheckBlue,

            text: blueButtonTitle, onPressed: onPressedSave,backgroundColor: Constant.colorPurple,),
        ),
        Gap(20),
        SizedBox(
            height: 80,
            width: 170,
            child: CustomElevatedButton(
              // textWidget: textWidgetWhite,
              isLoadingCheck: isLoadingCheckWhite,

              text: whiteButtonTitle, onPressed: onPressedCancel,backgroundColor: Constant.colorWhite,textColor: Colors.black,)),
      ],
    );
  }
}
