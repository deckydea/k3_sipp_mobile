import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/repository/examination_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class Examination {
  int? id;
  int? templateId;
  String typeOfExaminationName;
  DateTime? implementationDate;
  DateTime? deadlineDate;
  Company? company;
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
    required this.typeOfExaminationName,
    this.implementationDate,
    this.deadlineDate,
    this.company,
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

  ExaminationType? get examinationType => ExaminationRepository().getExaminationTypeByName(typeOfExaminationName);

  //Styles
  Color get color {
    switch (typeOfExaminationName) {
      case ExaminationTypeName.kebisingan:
        return Colors.brown;
      case ExaminationTypeName.penerangan:
        return Colors.amber;
    }

    return ColorResources.primaryDark;
  }

  Color get backgroundColorStatus {
    switch (status) {
      case ExaminationStatus.PENDING:
        return ColorResources.backgroundPending;
      case ExaminationStatus.REVISION_QC1:
        return ColorResources.backgroundRevisionQc1;
      case ExaminationStatus.PENDING_APPROVE_QC1:
        return ColorResources.backgroundPendingApproveQc1;
      case ExaminationStatus.REVISION_QC2:
        return ColorResources.backgroundPendingApproveQc2;
      case ExaminationStatus.PENDING_INPUT_LAB:
        return ColorResources.backgroundInputLab;
      case ExaminationStatus.REVISION_INPUT_LAB:
        return ColorResources.backgroundRevisionInputLab;
      case ExaminationStatus.PENDING_APPROVE_QC2:
        return ColorResources.backgroundPendingApproveQc2;
      case ExaminationStatus.REJECT_SIGNED:
        return ColorResources.dangerBackground;
      case ExaminationStatus.PENDING_SIGNED:
        return ColorResources.backgroundPendingSigned;
      case ExaminationStatus.SIGNED:
        return ColorResources.backgroundSigned;
      case ExaminationStatus.COMPLETED:
        return ColorResources.backgroundComplete;
      default:
        return ColorResources.backgroundNoneStatus;
    }
  }

  Color get colorStatus {
    switch (status) {
      case ExaminationStatus.PENDING:
        return Colors.deepOrangeAccent;
      case ExaminationStatus.REVISION_QC1:
        return Colors.blueGrey;
      case ExaminationStatus.PENDING_APPROVE_QC1:
        return Colors.greenAccent;
      case ExaminationStatus.REVISION_QC2:
        return Colors.orangeAccent;
      case ExaminationStatus.PENDING_INPUT_LAB:
        return Colors.purpleAccent;
      case ExaminationStatus.REVISION_INPUT_LAB:
        return Colors.yellow;
      case ExaminationStatus.PENDING_APPROVE_QC2:
        return Colors.deepPurple;
      case ExaminationStatus.REJECT_SIGNED:
        return Colors.redAccent;
      case ExaminationStatus.PENDING_SIGNED:
        return Colors.tealAccent;
      case ExaminationStatus.SIGNED:
        return Colors.blueAccent;
      case ExaminationStatus.COMPLETED:
        return Colors.teal;
      default:
        return ColorResources.primaryDark;
    }
  }
  
  Icon get icon {
    switch (typeOfExaminationName) {
      case ExaminationTypeName.kebisingan:
        return const Icon(Icons.noise_aware_outlined, color: Colors.white, size: Dimens.iconSize);
      case ExaminationTypeName.penerangan:
        return const Icon(Icons.light_mode_outlined, color: Colors.white, size: Dimens.iconSize);
    }

    return const Icon(Icons.unarchive_outlined, color: Colors.white, size: Dimens.iconSize);
  }

  Widget get statusBadge {
    return Container(
      decoration: BoxDecoration(
        color: colorStatus,
        borderRadius: BorderRadius.circular(Dimens.cardRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingSmallGap, horizontal: Dimens.paddingGap),
        child: Text(status == null ? "NOT STARTED" : status!.name.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: Dimens.fontXSmall)),
      ),
    );
  }

  Examination replica() {
    List<DeviceCalibration> deviceCalibrationsReplica = [];
    for (var element in deviceCalibrations) {
      deviceCalibrationsReplica.add(element.replica());
    }

    return Examination(
      id: id,
      templateId: templateId,
      typeOfExaminationName: typeOfExaminationName,
      implementationDate: implementationDate,
      deadlineDate: deadlineDate,
      company: company?.replica(),
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
      'typeOfExaminationName': typeOfExaminationName,
      if (implementationDate != null) 'implementationDate': DateTimeUtils.format(implementationDate!),
      if (deadlineDate != null) 'deadlineDate': DateTimeUtils.format(deadlineDate!),
      if (company != null) 'company': company,
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
      typeOfExaminationName: json['typeOfExaminationName'],
      implementationDate: json['implementationDate'] == null ? null : DateTime.parse(json['implementationDate']).toLocal(),
      deadlineDate: json['deadlineDate'] == null ? null : DateTime.parse(json['deadlineDate']).toLocal(),
      company: Company.fromJson(json['company']),
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
