import 'package:opalsystem/localDatabase/Transaction/Pages/LocalDraftdb.dart';
import 'package:opalsystem/localDatabase/Transaction/localTransaction.dart';

class LocalDatabaseInit {
  static Future<void> initialize() async {
    await LocalTransaction().initialize();
    await LocalDraft().initialize();
    // await LocalTransaction().close();
    // await LocalTransaction().deleteDatabase();
  }
}
