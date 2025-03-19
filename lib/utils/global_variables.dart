import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/loggedInUser.dart';

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
