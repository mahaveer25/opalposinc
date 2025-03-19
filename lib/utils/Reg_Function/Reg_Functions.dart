class RegFunctions {
  static String? getCardNumber({required String card_Data}) {
    RegExp regExp = RegExp(r"%B(\d+)\^");
    RegExpMatch? match = regExp.firstMatch(card_Data.toUpperCase());

    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  static String? extractAndRearrangeName(String trackData) {
    RegExp regExpName = RegExp(r"\^(d+)\^");
    RegExp regExpName2 = RegExp(r'\^/?([^\^]+)');

    RegExpMatch? matchName = regExpName.firstMatch(trackData);
    RegExpMatch? matchName2 = regExpName2.firstMatch(trackData);

    if (matchName != null) {
      return '$matchName';
    } else {
      String? fullName = matchName2?.group(1);
      String cardholderName = fullName?.trim() ?? '';

      // log('from card 2');

      return cardholderName;
    }

// or handle accordingly if no match is found or if the format is unexpected
  }

  static Map<String, String>? extractInfo(String trackData) {
    RegExp regExpInfo = RegExp(r"=(\d{2})(\d{2})");
    RegExpMatch? matchInfo = regExpInfo.firstMatch(trackData);

    if (matchInfo != null) {
      String? info1 = matchInfo.group(1);
      String? info2 = matchInfo.group(2);

      return {
        'info1': info1.toString(),
        'info2': info2.toString(),
      };
    }

    return null; // or handle accordingly if no match is found or if the format is unexpected
  }
}
