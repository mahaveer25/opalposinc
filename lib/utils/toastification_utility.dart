import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationUtility {
  static void showToast({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      pauseOnHover: true,
      dragToClose: true,
      animationDuration: duration,
      showIcon: true,

      context: context,
      style: ToastificationStyle.minimal,
      


      title: Text( _getTitle(type),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
      description: Text(message),
      type: _getToastificationType(type),
      autoCloseDuration: duration,
    );
  }

  static String _getTitle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return "Success";
      case ToastType.error:
        return "Error";
      case ToastType.warning:
        return "Warning";
      case ToastType.info:
        return "Info";
      default:
        return "Notification";
    }
  }

  static ToastificationType _getToastificationType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
     default:
        return ToastificationType.info;

    }
  }
}

enum ToastType { success, error, warning, info }
