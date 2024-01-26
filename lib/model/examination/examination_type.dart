// ignore_for_file: constant_identifier_names

import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

enum MasterExaminationType{PHYSICS, CHEMICAL, HEALTH}

class MasterExaminationTypeName{
  static const kebisingan = "KEBISINGAN";
  static const penerangan = "PENERANGAN";
}

class ExaminationType {
  final int id;
  final String name;
  final String description;
  final MasterExaminationType type;

  ExaminationType({required this.id, required this.name, required this.description, required this.type});

  String get accessMenu{
    switch(name){
      case MasterExaminationTypeName.kebisingan:
        return MasterRequestType.inputExaminationKebisinganLK;
      case MasterExaminationTypeName.penerangan:
        return MasterRequestType.inputExaminationPencahayaan;
    }
    return "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': EnumToString.convertToString(type),
    };
  }

  factory ExaminationType.fromJson(Map<String, dynamic> json) {
    return ExaminationType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: MasterExaminationType.values.firstWhere((element) => element.name == json['type']),
    );
  }
}
