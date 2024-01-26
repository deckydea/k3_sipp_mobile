import 'dart:convert';
import 'dart:typed_data';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:image/image.dart' as image;

class ImageUtils {
  static String? encodeImage(Uint8List image) => base64Encode(image);

  static Uint8List? decodeImage(String? encodedImage) =>
      TextUtils.isEmpty(encodedImage) ? null : base64.decode(base64.normalize(encodedImage!.replaceAll(RegExp(r"\s+"), '')));

  static image.Image resizeImage({required Uint8List data, required double width, required double height}) {
    image.Image? img = image.decodeImage(data);
    return image.copyResize(img!, width: width.toInt(), height: height.toInt());
  }
}
