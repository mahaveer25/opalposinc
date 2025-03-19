import 'dart:developer';

import 'package:flutter/services.dart';

class MyPlatformFunctions {
  static MethodChannel platform =
      const MethodChannel('com.example.app/drawerChannel');

  static Future<void> cashDrawerOpen() async {
    try {
      final String result = await platform.invokeMethod('cashDrawerOpen');
      log('Result from Java: $result');
    } on PlatformException catch (e) {
      log("Failed to Invoke: '${e.message}'.");
    }
  }
}
