import 'package:flutter/material.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/views/paxDevice.dart';

class ConstDialog {
  final BuildContext context;
  ConstDialog(this.context);

  showErrorDialog({
    required String error,
    String? title,
    final IconData? iconData,
    Color? iconColor,
    double? iconSize,
    String? iconText,
    final Function()? ontap, // Make ontap optional
  }) {
    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                iconData ?? Icons.error, // Use default icon if iconData is null
                color: iconColor ?? Constant.colorPurple,
                size: iconSize ?? 20.0,
              ),
              const SizedBox(width: 8),
              Text(iconText ?? 'Alert'),
            ],
          ),
          content: Text(error),
          actions: [
            if (ontap != null)
              TextButton(onPressed: ontap, child: const Text("OK"))
            else
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
          ],
        );
      },
    );
  }

  showLoadingDialog({String? text}) {
    showDialog(
        context: context,
        builder: ((context) => Dialog(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(text ?? 'Loading Please wait...')
                  ],
                ),
              ),
            )));
  }
}

class ConstDialogNew {
  static showErrorDialogNew({
    required String error,
    String? title,
    IconData? iconData,
    Color? iconColor,
    double? iconSize,
    String? iconText,
    required BuildContext contextNew,
  }) {
    showDialog(
      barrierColor: Colors.black87,
      context: contextNew,
      builder: (BuildContext dialogContext) {
        // Use dialogContext here
        return Builder(
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  iconData ?? Icons.error, // Default icon if iconData is null
                  color:
                      iconColor ?? Colors.purple, // Replace with your constant
                  size: iconSize ?? 20.0,
                ),
                const SizedBox(width: 8),
                Text(iconText ?? 'Alert'),
              ],
            ),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Pop the specific dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const PaxDeviceRailWidget();
                    },
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }
}
