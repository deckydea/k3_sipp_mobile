import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class Examination {
  int? id;
  int? templateId;
  int typeOfExaminationId;
  String typeOfExaminationName;
  String typeOfExaminationDescription;
  MasterExaminationType typeOfExaminationType;
  DateTime? implementationDate;
  int petugasId;
  String petugasName;
  int? analisId;
  String? analisName;
  String metode;
  int? qc1By;
  String? qc1ByName;
  DateTime? qc1Datetime;
  int? qc2By;
  String? qc2ByName;
  DateTime? qc2Datetime;
  int? signedBy;
  String? signedByName;
  DateTime? signedDatetime;
  ExaminationStatus? status;
  List<DeviceCalibration> deviceCalibrations;

  //Implement only for request approval to server
  bool? isUpdate;

  Examination({
    this.id,
    this.templateId,
    required this.typeOfExaminationId,
    required this.typeOfExaminationName,
    required this.typeOfExaminationDescription,
    required this.typeOfExaminationType,
    this.implementationDate,
    required this.petugasId,
    required this.petugasName,
    this.analisId,
    this.analisName,
    required this.metode,
    this.qc1By,
    this.qc1ByName,
    this.qc1Datetime,
    this.qc2By,
    this.qc2ByName,
    this.qc2Datetime,
    this.signedBy,
    this.signedByName,
    this.signedDatetime,
    this.status,
    required this.deviceCalibrations,
  });

  Color get color {
    switch (typeOfExaminationName) {
      case MasterExaminationTypeName.kebisingan:
        return Colors.brown;
      case MasterExaminationTypeName.penerangan:
        return Colors.amber;
    }

    return ColorResources.primaryDark;
  }

  Icon get icon {
    switch (typeOfExaminationName) {
      case MasterExaminationTypeName.kebisingan:
        return const Icon(Icons.noise_aware_outlined, color: Colors.white, size: Dimens.iconSize);
      case MasterExaminationTypeName.penerangan:
        return const Icon(Icons.light_mode_outlined, color: Colors.white, size: Dimens.iconSize);
    }

    return const Icon(Icons.unarchive_outlined, color: Colors.white, size: Dimens.iconSize);
  }

  Examination replica() {
    List<DeviceCalibration> deviceCalibrationsReplica = [];
    for (var element in deviceCalibrations) {
      deviceCalibrationsReplica.add(element.replica());
    }

    return Examination(
      id: id,
      templateId: templateId,
      typeOfExaminationId: typeOfExaminationId,
      typeOfExaminationName: typeOfExaminationName,
      typeOfExaminationDescription: typeOfExaminationDescription,
      typeOfExaminationType: typeOfExaminationType,
      implementationDate: implementationDate,
      petugasId: petugasId,
      petugasName: petugasName,
      analisId: analisId,
      analisName: analisName,
      metode: metode,
      qc1By: qc1By,
      qc1ByName: qc1ByName,
      qc1Datetime: qc1Datetime,
      qc2By: qc2By,
      qc2ByName: qc2ByName,
      qc2Datetime: qc2Datetime,
      signedBy: signedBy,
      signedByName: signedByName,
      signedDatetime: signedDatetime,
      status: status,
      deviceCalibrations: deviceCalibrationsReplica,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (templateId != null) 'templateId': templateId,
      'typeOfExaminationId': typeOfExaminationId,
      'typeOfExaminationName': typeOfExaminationName,
      'typeOfExaminationDescription': typeOfExaminationDescription,
      'typeOfExaminationType': EnumToString.convertToString(typeOfExaminationType),
      if (implementationDate != null) 'implementationDate': DateTimeUtils.format(implementationDate!),
      'petugasId': petugasId,
      'petugasName': petugasName,
      if (analisId != null) 'analisId': analisId,
      if (analisName != null) 'analisName': analisName,
      'metode': metode,
      if (qc1By != null) 'qc1_by': qc1By,
      if (qc1ByName != null) 'qc1Name': qc1ByName,
      if (qc1Datetime != null) "qc1_datetime": DateTimeUtils.format(qc1Datetime!),
      if (qc2By != null) 'qc2_by': qc2By,
      if (qc2ByName != null) 'qc2Name': qc2ByName,
      if (qc2Datetime != null) "qc2_datetime": DateTimeUtils.format(qc2Datetime!),
      if (signedBy != null) 'signed_by': signedBy,
      if (signedByName != null) 'signedByName': signedByName,
      if (signedDatetime != null) "signed_datetime": DateTimeUtils.format(signedDatetime!),
      if (status != null) 'status': EnumToString.convertToString(status),
      'deviceCalibration': deviceCalibrations.toList(),
    };
  }

  factory Examination.fromJson(Map<String, dynamic> json) {
    List<DeviceCalibration> deviceCalibrations = [];
    if (json["devicecalibrations"] != null) {
      Iterable iterable = json["devicecalibrations"];
      for (var deviceCalibration in iterable) {
        deviceCalibrations.add(DeviceCalibration.fromJson(deviceCalibration));
      }
    }

    return Examination(
      id: json['id'],
      templateId: json['templateId'],
      typeOfExaminationId: json['typeOfExaminationId'],
      typeOfExaminationName: json['typeOfExaminationName'],
      typeOfExaminationDescription: json['typeOfExaminationDescription'],
      typeOfExaminationType: MasterExaminationType.values.firstWhere((element) => element.name == json['type']),
      implementationDate: json['implementationDate'] == null ? null : DateTime.parse(json['implementationDate']).toLocal(),
      petugasId: json['petugasId'],
      petugasName: json['petugasName'],
      analisName: json['analisName'],
      metode: json['metode'],
      qc1By: json['qc1_by'],
      qc1ByName: json['qc1ByName'],
      qc1Datetime: json['qc1_datetime'] == null ? null : DateTime.parse(json['qc1_datetime']).toLocal(),
      qc2By: json['qc2_by'],
      qc2ByName: json['qc2ByName'],
      qc2Datetime: json['qc2_datetime'] == null ? null : DateTime.parse(json['qc2_datetime']).toLocal(),
      signedBy: json['signed_by'],
      signedByName: json['signedByName'],
      signedDatetime: json['signed_datetime'] == null ? null : DateTime.parse(json['signed_datetime']).toLocal(),
      status: ExaminationStatus.values.firstWhere((element) => element.name == json['status']),
      deviceCalibrations: deviceCalibrations,
    );
  }
}
