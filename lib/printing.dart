import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

mixin PrintPDF {
  static const platform = MethodChannel('com.org.kotlin_specifics/print');
  static const cashDrawerPlatform =
      MethodChannel('com.your_package_name/cashDrawer');

  // Function to get a temporary PDF file path
  static Future<String> getTemporaryPdfFilePath(
      {required String fileName}) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$fileName.pdf';
      return filePath;
    } catch (e) {
      rethrow;
    }
  }

  // Function to print a PDF file
  Future<void> printPdf(
      {required String path, required BuildContext context}) async {
    try {
      // Validate file path
      final file = File(path);
      if (!await file.exists()) {
        throw Exception("File not found at the specified path.");
      }

      final String result = await platform.invokeMethod('printPdf', {'path': path});
      log("Print result: $result");
    } on PlatformException catch (e) {
      log("Failed to print PDF: '${e.message}'.");
      // Navigator.of(context).pop();
    } catch (e) {
      log("An error occurred: '${e.toString()}'.");
      Navigator.of(context).pop();
    }
  }

  Future<void> openCashDrawer(BuildContext context) async {
    try {
      final String result =
          await cashDrawerPlatform.invokeMethod('cashDrawerOpen');
      log("Cash drawer result: $result");
    } on PlatformException catch (e) {
      log("Failed to open cash drawer: '${e.message}'.");
      // Navigator.of(context).pop();
    } catch (e) {
      log("An error occurred while opening the cash drawer: '${e.toString()}'.");
      // Navigator.of(context).pop();
    }
  }
}
