import 'package:equatable/equatable.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class DataKebisinganFrekuensi extends Equatable {
  final int? id;
  final String location;
  final DateTime? time;
  final double value1;
  final double value2;
  final double value3;
  final double value4;
  final double value5;
  final double value6;
  final double value7;
  final double value8;
  final double value9;
  final double value10;
  final String? note;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataKebisinganFrekuensi({
    this.id,
    required this.location,
    this.time,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.value6,
    required this.value7,
    required this.value8,
    required this.value9,
    required this.value10,
    this.note,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  DataKebisinganFrekuensi copyWith({
    int? id,
    String? location,
    DateTime? time,
    double? value1,
    double? value2,
    double? value3,
    double? value4,
    double? value5,
    double? value6,
    double? value7,
    double? value8,
    double? value9,
    double? value10,
    String? note,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataKebisinganFrekuensi(
        id: id ?? this.id,
        location: location ?? this.location,
        time: time ?? this.time,
        value1: value1 ?? this.value1,
        value2: value2 ?? this.value2,
        value3: value3 ?? this.value3,
        value4: value3 ?? this.value4,
        value5: value3 ?? this.value5,
        value6: value3 ?? this.value6,
        value7: value3 ?? this.value7,
        value8: value3 ?? this.value8,
        value9: value3 ?? this.value9,
        value10: value3 ?? this.value10,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
      );

  DataKebisinganFrekuensi replica() {
    return DataKebisinganFrekuensi(
      id: id,
      location: location,
      time: time,
      value1: value1,
      value2: value2,
      value3: value3,
      value4: value4,
      value5: value5,
      value6: value6,
      value7: value7,
      value8: value8,
      value9: value9,
      value10: value10,
      note: note,
      deviceCalibration: deviceCalibration,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        if (time != null) 'time': DateTimeUtils.format(time!),
        'value1': value1,
        'value2': value2,
        'value3': value3,
        'value4': value4,
        'value5': value5,
        'value6': value6,
        'value7': value7,
        'value8': value8,
        'value9': value9,
        'value10': value10,
        'note': note,
        'isUpdate': isUpdate,
        'deviceCalibration': deviceCalibration,
      };

  factory DataKebisinganFrekuensi.fromJson(Map<String, dynamic> json) {
    return DataKebisinganFrekuensi(
      id: json['id'],
      location: json['location'],
      time: json['time'] == null ? null : DateTime.parse(json['time']).toLocal(),
      value1: double.parse(json['value1'].toString()),
      value2: double.parse(json['value2'].toString()),
      value3: double.parse(json['value3'].toString()),
      value4: double.parse(json['value4'].toString()),
      value5: double.parse(json['value5'].toString()),
      value6: double.parse(json['value6'].toString()),
      value7: double.parse(json['value7'].toString()),
      value8: double.parse(json['value8'].toString()),
      value9: double.parse(json['value9'].toString()),
      value10: double.parse(json['value10'].toString()),
      note: json['note'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [id, location, time, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, note, isUpdate];
}

class InputKebisinganFrekuensi {
  int examinationId;
  List<DataKebisinganFrekuensi> dataKebisinganFrekuensi;

  InputKebisinganFrekuensi({required this.examinationId, required this.dataKebisinganFrekuensi});

  InputKebisinganFrekuensi replica() {
    List<DataKebisinganFrekuensi> dataKebisinganReplica = [];
    for (var element in dataKebisinganFrekuensi) {
      dataKebisinganReplica.add(element.replica());
    }

    return InputKebisinganFrekuensi(
      examinationId: examinationId,
      dataKebisinganFrekuensi: dataKebisinganReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        'examinationId': examinationId,
        'dataKebisinganFrekuensi': dataKebisinganFrekuensi.toList(),
      };

  factory InputKebisinganFrekuensi.fromJson(Map<String, dynamic> json) {
    List<DataKebisinganFrekuensi> dataKebisinganLK = [];
    if (json["dataKebisinganFrekuensi"] != null) {
      Iterable iterable = json["dataKebisinganFrekuensi"];
      for (var data in iterable) {
        dataKebisinganLK.add(DataKebisinganFrekuensi.fromJson(data));
      }
    }
    return InputKebisinganFrekuensi(
      examinationId: json['examinationId'],
      dataKebisinganFrekuensi: dataKebisinganLK,
    );
  }
}
