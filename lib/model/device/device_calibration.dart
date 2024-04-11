import 'package:k3_sipp_mobile/model/device/device.dart';

class DeviceCalibration {
  int? id;
  int? examinationId;
  int deviceId;
  String? deviceName;
  String? name;
  double? internalCalibration;
  Device? device;

  //Device
  double? calibrationValue;
  double? u95;
  double? coverageFactor;

  DeviceCalibration({
    this.id,
    this.examinationId,
    required this.deviceId,
    this.deviceName,
    this.name = "",
    this.internalCalibration,
    this.device,
    this.calibrationValue,
    this.u95,
    this.coverageFactor,
  });

  DeviceCalibration replica({
    int? id,
    int? examinationId,
    int? deviceId,
    String? deviceName,
    String? name,
    Device? device,
    double? internalCalibration,
    double? calibrationValue,
    double? u95,
    double? coverageFactor,
  }) =>
      DeviceCalibration(
        id: id ?? this.id,
        examinationId: examinationId ?? this.examinationId,
        deviceId: deviceId ?? this.deviceId,
        name: name ?? this.name,
        internalCalibration: internalCalibration ?? this.internalCalibration,
        deviceName: deviceName ?? this.deviceName,
        device: device ?? this.device,
        calibrationValue: calibrationValue ?? this.calibrationValue,
        u95: u95 ?? this.u95,
        coverageFactor: coverageFactor ?? this.coverageFactor,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'examinationId': examinationId,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'name': name,
        'internalCalibration': internalCalibration,
        'device': device,
        'calibrationValue': calibrationValue,
        'u95': u95,
        'coverageFactor': coverageFactor,
      };

  factory DeviceCalibration.fromJson(Map<String, dynamic> json) {

    return DeviceCalibration(
      id: json['id'],
      examinationId: json['examinationId'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      name: json['name'],
      internalCalibration: json['internalCalibration']?.toDouble(),
      device: json['device'] == null ? null : Device.fromJson(json['device']),
      calibrationValue: json['calibrationValue']?.toDouble(),
      u95: json['u95']?.toDouble(),
      coverageFactor: json['coverageFactor']?.toDouble(),
    );
  }
}
