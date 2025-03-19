import 'package:opalposinc/localDatabase/Transaction/Pages/LocalDraftdb.dart';
import 'package:opalposinc/localDatabase/Transaction/localTransaction.dart';

class LocalDatabaseInit {
  static Future<void> initialize() async {
    await LocalTransaction().initialize();
    await LocalDraft().initialize();
    // await LocalTransaction().close();
    // await LocalTransaction().deleteDatabase();
  }
}
