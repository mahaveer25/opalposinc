import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Secondaryapp extends StatelessWidget {
  static const platform = MethodChannel('com.org.kotlin_specifics/print');

  const Secondaryapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Secondary Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                await platform.invokeMethod('showSecondaryScreen');
              } on PlatformException catch (e) {
                log("Failed to show secondary screen: '${e.message}'.");
              }
            },
            child: const Text('Show on Secondary Screen'),
          ),
        ),
      ),
    );
  }
}
