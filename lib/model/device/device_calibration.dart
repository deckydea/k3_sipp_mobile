class DeviceCalibration {
  int id;
  int examinationId;
  int deviceId;
  String name;
  double internalCalibration;

  DeviceCalibration({
    required this.id,
    required this.examinationId,
    required this.deviceId,
    required this.name,
    required this.internalCalibration,
  });

  DeviceCalibration replica({
    int? id,
    int? examinationId,
    int? deviceId,
    String? name,
    double? internalCalibration,
  }) => DeviceCalibration(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      internalCalibration: internalCalibration ?? this.internalCalibration,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'examinationId': examinationId,
      'deviceId': deviceId,
      'name': name,
      'internalCalibration': internalCalibration,
    };

  factory DeviceCalibration.fromJson(Map<String, dynamic> json) {
    return DeviceCalibration(
      id: json['id'],
      examinationId: json['examinationId'],
      deviceId: json['deviceId'],
      name: json['name'],
      internalCalibration: json['internalCalibration'],
    );
  }
}
