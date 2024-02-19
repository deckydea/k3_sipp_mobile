// ignore_for_file: constant_identifier_names

import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';
import 'package:k3_sipp_mobile/util/enum_translation_utils.dart';

enum MasterExaminationType { PHYSICS, CHEMICAL, HEALTH }

class ExaminationTypeName {
  static const kebisingan = "KEBISINGAN";
  static const penerangan = "PENERANGAN";
  static const iklimKerja = "IKLIM_KERJA";
  static const getaranLengan = "GETARAN_LENGAN";
  static const getaranWholeBody = "GETARAN_WHOLE_BODY";
  static const sinarUV = "SINAR_UV";
  static const gelombangElektroMagnet = "GELOMBANG_ELEKTROMAGNET";
  static const kebisinganAmbient = "KEBISINGAN_AMBIENT";
}

class ExaminationType {
  final String name;
  final String description;
  final MasterExaminationType type;

  ExaminationType({required this.name, required this.description, required this.type});

  String get examinationTypeName {
    return EnumTranslationUtils.examinationType(name);
  }

  String get accessMenu {
    switch (name) {
      case ExaminationTypeName.kebisingan:
        return MasterRequestType.submitExaminationKebisinganLK;
      case ExaminationTypeName.penerangan:
        return MasterRequestType.submitExaminationPenerangan;
    }
    return "";
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': EnumToString.convertToString(type),
    };
  }

  factory ExaminationType.fromJson(Map<String, dynamic> json) {
    return ExaminationType(
      name: json['name'],
      description: json['description'],
      type: MasterExaminationType.values.firstWhere((element) => element.name == json['type']),
    );
  }
}
