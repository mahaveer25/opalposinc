// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/utils/constant_dialog.dart';

class BridgePayService {
  static Future<Map<String, dynamic>?> postBridgePay({
    required PaxDevice paxDevice,
    required String amount,
    required String tenderType,
    required String transType,
    required String invNum,
    required String pnRefNum,
    required bool isPrefNumAllowed,
    required BuildContext context,
  }) async {
    if (paxDevice.id != null && paxDevice.id!.isNotEmpty) {
      try {
        final requestBody = json.encode(
          {
            "username": paxDevice.bridgePayDetails?.username ?? "",
            "password": paxDevice.bridgePayDetails?.password ?? "",
            "merchantAccountCode":
                paxDevice.bridgePayDetails?.merchantAccountCode ?? "",
            "merchantCode": paxDevice.bridgePayDetails?.merchantCode ?? "",
            "partialApproval":
                paxDevice.bridgePayDetails?.partialApproval ?? "",
            "allowPartialApproval": false,
            "mode": paxDevice.bridgePayDetails?.mode ?? "",
            "amount": amount,
            "tenderType": tenderType,
            "transType": transType,
            "terminalID": paxDevice.bridgePayDetails?.terminalID ?? "",
            "softwareVendor": paxDevice.bridgePayDetails?.softwareVendor ?? "",
            "invNum": invNum,
            if (isPrefNumAllowed) "pnRefNum": pnRefNum,
          },
        );

        log("POST Request Body: $requestBody");
        final response = await http
            .post(
              Uri.parse(paxDevice.bridgePayUrl.toString() ?? ""),
              headers: {
                "Content-Type": "application/json",
              },
              body: requestBody,
            )
            .timeout(
              const Duration(seconds: 90),
            );
        if (response.statusCode == 200) {
          log(response.body);
          return json.decode(response.body);
        } else if (response.statusCode == 415) {
          log("Unsupported Media Type error: status code 415");
          return null;
        } else {
          log("postBridgePay encountered an error with status code: ${response.statusCode}");
          throw Exception('Failed to post data');
        }
      } on http.ClientException catch (e) {
        log("ClientException occurred: $e");
        ConstDialog(context).showErrorDialog(error: "Network error: $e");
        return null;
      } on TimeoutException {
        log("Request timed out");
        ConstDialog(context)
            .showErrorDialog(error: "Request timed out. Please try again.");
        return null;
      } catch (e) {
        log("An unexpected error occurred: $e");
        ConstDialog(context)
            .showErrorDialog(error: "An unexpected error occurred: $e");
        return null;
      }
    } else {
      ConstDialog(context).showErrorDialog(error: "No device is selected");
      log("paxDevice.business is null or empty");
      return null;
    }
  }
}
