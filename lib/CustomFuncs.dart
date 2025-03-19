import 'package:flutter/material.dart';

import 'utils/constant_dialog.dart';
import 'views/Register_Screen.dart';

class ErrorFuncs {
  final BuildContext context;
  ErrorFuncs(this.context);

  void errRegisterClose({required Map<String, dynamic> errorInfo}) {
    if (errorInfo['type'] == 'cash_register_closed') {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const RegisterScreen())));
    } else {
      ConstDialog(context).showErrorDialog(error: errorInfo['info']);
    }
  }
}
