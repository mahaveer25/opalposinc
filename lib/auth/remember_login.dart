import 'package:shared_preferences/shared_preferences.dart';

class RememberLogin {
  static late SharedPreferences preferences;

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> toHiveStorage({required String storeUrl}) async {
    await preferences.setString('storeUrl', storeUrl);
  }

  static Future<String?> getUrlFromHive() async {
    final storeUrl = preferences.getString('storeUrl');
    return storeUrl;
  }

  static Future<void> savePaxId({required String paxId}) async {
    await preferences.setString('paxId', paxId);
  }

  static Future<String?> getPaxId() async {
    final paxId = preferences.getString('paxId');
    return paxId;
  }

  static Future<void> saveLocationId({required String savedLocationID}) async {
    await preferences.setString('savedLocationID', savedLocationID);
  }

  static Future<String?> getLocationId() async {
    final savedLocationID = preferences.getString('savedLocationID');
    return savedLocationID;
  }
}
