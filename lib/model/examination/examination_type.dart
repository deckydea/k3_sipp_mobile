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
  static const gelombangElektroMagnet = "GELOMBANG_ELEKTROMAGNETIK";
  static const kebisinganAmbient = "KEBISINGAN_AMBIENT";
  static const kebisinganFrekuensi = "KEBISINGAN_FREKUENSI";
  static const kebisinganNoiseDose = "NOISE_DOSE";
}

class ExaminationType {
  final String name;
  final String description;
  final MasterExaminationType type;
  final String metode;

  ExaminationType({required this.name, required this.description, required this.type, required this.metode});

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
      'metode': metode,
      'type': EnumToString.convertToString(type),
    };
  }

  factory ExaminationType.fromJson(Map<String, dynamic> json) {
    return ExaminationType(
      name: json['name'],
      description: json['description'],
      metode: json['metode'],
      type: MasterExaminationType.values.firstWhere((element) => element.name == json['type']),
    );
  }
}
