import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

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

  static Future<bool> requestStoragePermission() async {
    if (kIsWeb || Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      PermissionStatus permission = await Permission.storage.status;
      if (!permission.isGranted) permission = await Permission.storage.request();
      return permission == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  static Future<bool> openPdfFiles({required BuildContext context, required Uint8List pdfBytes, required String fileName}) async {
    bool result = false;
    if (kIsWeb) {
      FileUtils.downloadFiles(pdfBytes, fileName, 'pdf');
    } else {
      File file = await FileUtils.getFile(fileName, fileExtension: 'pdf');
      await file.writeAsBytes(pdfBytes);
      if (!TextUtils.isEmpty(file.path)) {
        if (context.mounted) {
          OpenResult openResult = await FileUtils.openFile(context, file.path);
          if (openResult.type == ResultType.done) return true;
        }
      } else {
        if (context.mounted) MessageUtils.handlePermissionDenied(context: context);
      }
    }

    return result;
  }

  static Future<OpenResult> openFile(BuildContext context, String fileName) async {
    OpenResult result;
    if (TextUtils.isEmpty(fileName)) {
      result = OpenResult(type: ResultType.fileNotFound);
    } else {
      result = await OpenFile.open(fileName);
    }

    if (result.type != ResultType.done) {
      switch (result.type) {
        case ResultType.fileNotFound:
          if (context.mounted) MessageUtils.showMessage(context: context, content: "File tidak ditemukan.");
          break;
        case ResultType.error:
          if (context.mounted) MessageUtils.showMessage(context: context, content: "Terjadi kesalahan saat membuka file.");
          break;
        case ResultType.noAppToOpen:
          if (context.mounted) MessageUtils.showMessage(context: context, content: "Tidak ada aplikasi yang tersedia untuk membuka file.");
          break;
        case ResultType.permissionDenied:
          if (context.mounted) MessageUtils.showMessage(context: context, content: "Tidak memiliki izin untuk membuka file.");
          break;
        default:
      }
    }
    return result;
  }

  static void downloadFiles(Uint8List file, String fileName, String fileType) {
    final blob = html.Blob([file], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$fileName.$fileType';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
