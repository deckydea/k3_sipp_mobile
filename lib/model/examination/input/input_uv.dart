import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

enum Posisi { mata, siku, betis }

class DataUltraviolet {
  final int? id;
  final DateTime time;
  final String location;
  final Posisi posisi;
  final int jumlahTK;
  final double value1;
  final double value2;
  final double value3;
  final double durasi;
  final String? note;
  final String? pengendalian;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataUltraviolet({
    this.id,
    required this.time,
    required this.location,
    required this.posisi,
    required this.jumlahTK,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.durasi,
    this.note,
    this.pengendalian,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  DataUltraviolet copyWith({
    int? id,
    DateTime? time,
    String? location,
    Posisi? posisi,
    int? jumlahTK,
    double? value1,
    double? value2,
    double? value3,
    double? durasi,
    String? note,
    String? pengendalian,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataUltraviolet(
        id: id ?? this.id,
        location: location ?? this.location,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        posisi: posisi ?? this.posisi,
        value1: value1 ?? this.value1,
        value2: value2 ?? this.value2,
        value3: value3 ?? this.value3,
        durasi: durasi ?? this.durasi,
        time: time ?? this.time,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
        pengendalian: pengendalian ?? this.pengendalian,
      );

  DataUltraviolet replica() {
    return DataUltraviolet(
      id: id,
      time: time,
      location: location,
      jumlahTK: jumlahTK,
      posisi: posisi,
      value1: value1,
      value2: value2,
      value3: value3,
      durasi: durasi,
      note: note,
      pengendalian: pengendalian,
      deviceCalibration: deviceCalibration,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': DateTimeUtils.format(time),
        'location': location,
        'jumlahTK': jumlahTK,
        'posisi': posisi.name,
        'value1': value1,
        'value2': value2,
        'value3': value3,
        'durasi': durasi,
        'note': note,
        'pengendalian': pengendalian,
        'isUpdate': isUpdate,
        'deviceCalibration': deviceCalibration,
      };

  factory DataUltraviolet.fromJson(Map<String, dynamic> json) {
    return DataUltraviolet(
      id: json['id'],
      time: DateTime.parse(json['time']).toLocal(),
      location: json['location'],
      jumlahTK: json['jumlahTK'],
      posisi: Posisi.values.firstWhere((element) => element.name == json['posisi']),
      value1: double.parse(json['value1'].toString()),
      value2: double.parse(json['value2'].toString()),
      value3: double.parse(json['value3'].toString()),
      durasi: double.parse(json['durasi'].toString()),
      note: json['note'],
      pengendalian: json['pengendalian'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}

class InputDataUltraviolet {
  int examinationId;
  List<DataUltraviolet> dataUltraviolet;

  InputDataUltraviolet({required this.examinationId, required this.dataUltraviolet});

  InputDataUltraviolet replica() {
    List<DataUltraviolet> dataUltravioletReplica = [];
    for (var element in dataUltraviolet) {
      dataUltravioletReplica.add(element.replica());
    }

    return InputDataUltraviolet(
      examinationId: examinationId,
      dataUltraviolet: dataUltravioletReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        'examinationId': examinationId,
        'dataUltraviolet': dataUltraviolet.toList(),
      };

  factory InputDataUltraviolet.fromJson(Map<String, dynamic> json) {
    List<DataUltraviolet> dataUltraviolet = [];
    if (json["dataUltraviolet"] != null) {
      Iterable iterable = json["dataUltraviolet"];
      for (var data in iterable) {
        dataUltraviolet.add(DataUltraviolet.fromJson(data));
      }
    }
    return InputDataUltraviolet(
      examinationId: json['examinationId'],
      dataUltraviolet: dataUltraviolet,
    );
  }
}
