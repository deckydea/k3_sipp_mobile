import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class Examination {
  int? id;
  int? templateId;
  int? typeOfExaminationId;
  int petugasId;
  int? analisId;
  String metode;
  int? qc1By;
  DateTime? qc1Datetime;
  int? qc2By;
  DateTime? qc2Datetime;
  int? signedBy;
  DateTime? signedDatetime;
  ExaminationStatus? status;
  List<DeviceCalibration> deviceCalibrations;

  Examination({
    this.id,
    this.templateId,
    this.typeOfExaminationId,
    required this.petugasId,
    this.analisId,
    required this.metode,
    this.qc1By,
    this.qc1Datetime,
    this.qc2By,
    this.qc2Datetime,
    this.signedBy,
    this.signedDatetime,
    this.status,
    required this.deviceCalibrations,
  });

  Examination replica() {
    List<DeviceCalibration> deviceCalibrationsReplica = [];
    for (var element in deviceCalibrations) {
      deviceCalibrationsReplica.add(element.replica());
    }

    return Examination(
      id: id,
      templateId: templateId,
      typeOfExaminationId: typeOfExaminationId,
      petugasId: petugasId,
      analisId: analisId,
      metode: metode,
      qc1By: qc1By,
      qc1Datetime: qc1Datetime,
      qc2By: qc2By,
      qc2Datetime: qc2Datetime,
      signedBy: signedBy,
      signedDatetime: signedDatetime,
      status: status,
      deviceCalibrations: deviceCalibrationsReplica,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (templateId != null) 'templateId': templateId,
      if (typeOfExaminationId != null) 'typeOfExaminationId': typeOfExaminationId,
      'petugasId': petugasId,
      if (analisId != null) 'analisId': analisId,
      'metode': metode,
      if (qc1By != null) 'qc1_by': qc1By,
      if (qc1Datetime != null) "qc1_datetime": DateTimeUtils.format(qc1Datetime!),
      if (qc2By != null) 'qc2_by': qc2By,
      if (qc2Datetime != null) "qc2_datetime": DateTimeUtils.format(qc2Datetime!),
      if (signedBy != null) 'signed_by': signedBy,
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
      petugasId: json['petugasId'],
      analisId: json['analisId'],
      metode: json['metode'],
      qc1By: json['qc1_by'],
      qc1Datetime: json['qc1_datetime'] == null ? null : DateTime.parse(json['qc1_datetime']).toLocal(),
      qc2By: json['qc2_by'],
      qc2Datetime: json['qc2_datetime'] == null ? null : DateTime.parse(json['qc2_datetime']).toLocal(),
      signedBy: json['signed_by'],
      signedDatetime: json['signed_datetime'] == null ? null : DateTime.parse(json['signed_datetime']).toLocal(),
      status: ExaminationStatus.values.firstWhere((element) => element.name == json['status']),
      deviceCalibrations: deviceCalibrations,
    );
  }
}
