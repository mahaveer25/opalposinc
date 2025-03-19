import 'package:flutter/material.dart';
import 'package:opalposinc/utils/constants.dart';

import '../../CustomWidgets/CustomIniputField.dart';

class CustomeDailoge extends StatefulWidget {
  const CustomeDailoge({
    super.key,
  });

  @override
  State<CustomeDailoge> createState() => _CustomeDailogeState();
}

class _CustomeDailogeState extends State<CustomeDailoge> {
  TextEditingController cardData = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardExpireMM = TextEditingController();
  TextEditingController cardExpireYY = TextEditingController();
  String? getCardNumber({required String card_Data}) {
    RegExp regExp = RegExp(r"%B(\d+)\^");
    RegExpMatch? match = regExp.firstMatch(card_Data);

    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  String? extractAndRearrangeName(String trackData) {
    RegExp regExpName = RegExp(r"\^([^^]+/[^^]+)\^");
    RegExpMatch? matchName = regExpName.firstMatch(trackData);

    if (matchName != null) {
      String? fullName = matchName.group(1);
      List<String> nameParts = fullName!.split('/');

      if (nameParts.length == 2) {
        String firstName = nameParts[1].trim();
        String lastName = nameParts[0].trim();
        return '$firstName $lastName';
      }
    }

    return null; // or handle accordingly if no match is found or if the format is unexpected
  }

  Map<String, String>? extractInfo(String trackData) {
    RegExp regExpInfo = RegExp(r"\^([^^]+/[^^]+)\^(\d{2})(\d{2})");
    RegExpMatch? matchInfo = regExpInfo.firstMatch(trackData);

    if (matchInfo != null) {
      String? info1 = matchInfo.group(2);
      String? info2 = matchInfo.group(3);

      return {
        'info1': info1.toString(),
        'info2': info2.toString(),
      };
    }

    return null; // or handle accordingly if no match is found or if the format is unexpected
  }

  @override
  Widget build(BuildContext context) {
    if (cardData.text.isNotEmpty) {
      cardNumber.text = getCardNumber(card_Data: cardData.text).toString();
      cardHolderName.text = extractAndRearrangeName(cardData.text).toString();
      cardExpireMM.text = extractInfo(cardData.text)!['info2'].toString();
      cardExpireYY.text = extractInfo(cardData.text)!['info1'].toString();
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text(
                      "Card Payment",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomInputField(
                      labelText: 'Card Data',
                      hintText: 'Card Data',
                      controller: cardData,
                      toHide: false,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomInputField(
                      labelText: 'Card Number',
                      hintText: 'Card Number',
                      controller: cardNumber,
                      toHide: false,
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: CustomInputField(
                      labelText: 'Card Holder Name',
                      hintText: 'Card Holder Name',
                      controller: cardHolderName,
                      toHide: false,
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: CustomInputField(
                      labelText: 'MM',
                      hintText: 'MM',
                      controller: cardExpireMM,
                      toHide: false,
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: CustomInputField(
                      labelText: 'YY',
                      hintText: 'YY',
                      controller: cardExpireYY,
                      toHide: false,
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Constant.colorGreen,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Constant.colorGreen,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
