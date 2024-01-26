import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/image_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageSelectionUtils {
  static const String permissionDenied = "PERMISSION_DENIED";
  static const double maxWidth = 800;
  static const double maxHeight = 800;
  static const int minCompressHeight = 1024;
  static const int minCompressWidth = 768;
  static const int compressionThreshold = 131072; // 128KB

  static Future<String?> getImage(context, {List<CropAspectRatioPreset>? aspectRatioPresets}) async {
    var result = await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.cardRadius))),
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingPage),
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                      'Photo Library',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    onTap: () async {
                      String? encodedImage = await getImageFromGallery(aspectRatioPresets ??
                          [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ]);
                      navigatorKey.currentState?.pop(encodedImage);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text(
                      'Camera',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    onTap: () async => navigatorKey.currentState?.pop(await getImageFromCamera()),
                  ),
                ],
              ),
            ),
          );
        });

    return result;
  }

  Future<String?> getImagePath() async {
    bool approved = await checkAndRequestGalleryPermissions();
    if (!approved) {
      final PermissionStatus status = await Permission.photos.request();
      if (status.isPermanentlyDenied || status.isDenied) return permissionDenied;
    }
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);
    return pickedFile?.path;
  }

  static Future<String?> getImageFromGallery(List<CropAspectRatioPreset>? aspectRatioPresets) async {
    bool approved = await checkAndRequestGalleryPermissions();
    if (!approved) {
      final PermissionStatus status = await Permission.photos.request();
      if (status.isPermanentlyDenied || status.isDenied) return permissionDenied;
    }

    String? imagePath = await ImageSelectionUtils().getImagePath();
    if (imagePath == null) return null;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: aspectRatioPresets ??
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    Uint8List? image;
    if (croppedFile != null) {
      image = await croppedFile.readAsBytes();
      image = await compressImage(image);
    }
    return image != null ? ImageUtils.encodeImage(image) : null;
  }

  static Future<String?> getImageFromCamera({int imageQuality = 50}) async {
    bool approved = await checkAndRequestCameraPermissions();
    if (!approved) {
      final PermissionStatus status = await Permission.camera.request();
      if (status.isPermanentlyDenied || status.isDenied) return permissionDenied;
    }
    String? encodedImage;
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    if (pickedFile != null) {
      Uint8List imageSteam = await pickedFile.readAsBytes();
      imageSteam = await compressImage(imageSteam);
      encodedImage = ImageUtils.encodeImage(imageSteam);
    }
    return encodedImage;
  }

  static Future<bool> checkAndRequestGalleryPermissions() async {
    PermissionStatus permission = await Permission.photos.status;
    if (permission.isPermanentlyDenied) {
      return false;
    } else if (!permission.isGranted) {
      PermissionStatus? status;
      if (Platform.isIOS) {
        status = await Permission.photos.request();
      } else if (Platform.isAndroid) {
        status = await Permission.photos.request();
        if (!status.isGranted) status = await Permission.storage.request();
      }
      return status?.isGranted ?? false;
    } else {
      return true;
    }
  }

  static Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission.isPermanentlyDenied) {
      return false;
    } else if (!permission.isGranted) {
      PermissionStatus status = await Permission.camera.request();
      return status.isGranted;
    } else {
      return true;
    }
  }

  static Future<Uint8List> compressImage(Uint8List list, {int imageQuality = 50}) async {
    // Compress image if image size is greater than the threshold
    if (list.lengthInBytes <= compressionThreshold) return list;
    var result = await FlutterImageCompress.compressWithList(
      list,
      minWidth: minCompressWidth,
      minHeight: minCompressHeight,
      quality: imageQuality,
    );
    return result;
  }
}
