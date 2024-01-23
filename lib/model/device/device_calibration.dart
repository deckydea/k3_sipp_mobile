class DeviceCalibration {
  int? id;
  int? examinationId;
  int deviceId;
  String deviceName;
  String name;
  double internalCalibration;

  DeviceCalibration({
    this.id,
    this.examinationId,
    required this.deviceId,
    required this.deviceName,
    required this.name,
    required this.internalCalibration,
  });

  DeviceCalibration replica({
    int? id,
    int? examinationId,
    int? deviceId,
    String? deviceName,
    String? name,
    double? internalCalibration,
  }) =>
      DeviceCalibration(
        id: id ?? this.id,
        examinationId: examinationId ?? this.examinationId,
        deviceId: deviceId ?? this.deviceId,
        name: name ?? this.name,
        internalCalibration: internalCalibration ?? this.internalCalibration,
        deviceName: deviceName ?? this.deviceName,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'examinationId': examinationId,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'name': name,
        'internalCalibration': internalCalibration,
      };

  factory DeviceCalibration.fromJson(Map<String, dynamic> json) {
    return DeviceCalibration(
      id: json['id'],
      examinationId: json['examinationId'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      name: json['name'],
      internalCalibration: json['internalCalibration'],
    );
  }
}
