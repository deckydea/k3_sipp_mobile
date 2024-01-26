import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<File> getFile(String fileName, {String fileExtension = "png"}) async {
    final Directory output = await getTemporaryDirectory();

    String path = "${output.path}/$fileName.$fileExtension";
    File file = File(path);
    if (!await file.exists()) {
      file = await file.create(recursive: true);
    }

    return file;
  }
}
