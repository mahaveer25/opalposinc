import 'package:opalsystem/model/TaxModel.dart';
import 'package:opalsystem/model/loggedInUser.dart';

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  static String storeUrl = '';
  LoggedInUser loggedInUser = LoggedInUser();
  TaxModel taxModel = TaxModel();
}
