import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> createPdf(
      {required String fileName, required Document doc}) async {
    final bytes = await doc.save();
    final save = await getApplicationDocumentsDirectory();
    final file = File('${save.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
