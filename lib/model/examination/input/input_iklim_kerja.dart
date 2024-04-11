import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class DataIklimKerja {
  final int? id;
  final String location;
  final DateTime time;
  final int jumlahTK;
  final int durasi;
  final String pengendalian;
  final String? note;
  final double tw1;
  final double tw2;
  final double tw3;
  final double tw4;
  final double tw5;
  final double tw6;
  final double tg1;
  final double tg2;
  final double tg3;
  final double tg4;
  final double tg5;
  final double tg6;
  final double rh1;
  final double rh2;
  final double rh3;
  final double rh4;
  final double rh5;
  final double rh6;
  final DeviceCalibration? deviceCalibrationTW;
  final DeviceCalibration? deviceCalibrationTG;
  final DeviceCalibration? deviceCalibrationISBB;

  //For request update purpose only
  final bool isUpdate;

  const DataIklimKerja({
    this.id,
    required this.location,
    required this.time,
    required this.jumlahTK,
    required this.durasi,
    required this.pengendalian,
    required this.note,
    required this.tw1,
    required this.tw2,
    required this.tw3,
    required this.tw4,
    required this.tw5,
    required this.tw6,
    required this.tg1,
    required this.tg2,
    required this.tg3,
    required this.tg4,
    required this.tg5,
    required this.tg6,
    required this.rh1,
    required this.rh2,
    required this.rh3,
    required this.rh4,
    required this.rh5,
    required this.rh6,
    required this.deviceCalibrationTW,
    required this.deviceCalibrationTG,
    required this.deviceCalibrationISBB,
    this.isUpdate = false,
  });

  DataIklimKerja copyWith({
    int? id,
    String? location,
    DateTime? time,
    int? jumlahTK,
    int? durasi,
    String? pengendalian,
    String? note,
    double? tw1,
    double? tw2,
    double? tw3,
    double? tw4,
    double? tw5,
    double? tw6,
    double? tg1,
    double? tg2,
    double? tg3,
    double? tg4,
    double? tg5,
    double? tg6,
    double? rh1,
    double? rh2,
    double? rh3,
    double? rh4,
    double? rh5,
    double? rh6,
    DeviceCalibration? deviceCalibrationTW,
    DeviceCalibration? deviceCalibrationTG,
    DeviceCalibration? deviceCalibrationISBB,
    bool isUpdate = false,
  }) =>
      DataIklimKerja(
        id: id ?? this.id,
        location: location ?? this.location,
        time: time ?? this.time,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        durasi: durasi ?? this.durasi,
        pengendalian: pengendalian ?? this.pengendalian,
        note: note ?? this.note,
        tw1: tw1 ?? this.tw1,
        tw2: tw2 ?? this.tw2,
        tw3: tw3 ?? this.tw3,
        tw4: tw4 ?? this.tw4,
        tw5: tw5 ?? this.tw5,
        tw6: tw6 ?? this.tw6,
        tg1: tg1 ?? this.tg1,
        tg2: tg2 ?? this.tg2,
        tg3: tg3 ?? this.tg3,
        tg4: tg4 ?? this.tg4,
        tg5: tg5 ?? this.tg5,
        tg6: tg6 ?? this.tg6,
        rh1: rh1 ?? this.rh1,
        rh2: rh2 ?? this.rh2,
        rh3: rh3 ?? this.rh3,
        rh4: rh4 ?? this.rh4,
        rh5: rh5 ?? this.rh5,
        rh6: rh6 ?? this.rh6,
        deviceCalibrationTW: deviceCalibrationTW ?? this.deviceCalibrationTW,
        deviceCalibrationTG: deviceCalibrationTG ?? this.deviceCalibrationTG,
        deviceCalibrationISBB: deviceCalibrationISBB ?? this.deviceCalibrationISBB,
        isUpdate: isUpdate,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        'time': DateTimeUtils.format(time),
        'jumlahTK': jumlahTK,
        'durasi': durasi,
        'pengendalian': pengendalian,
        'note': note,
        'tw1': tw1,
        'tw2': tw2,
        'tw3': tw3,
        'tw4': tw4,
        'tw5': tw5,
        'tw6': tw6,
        'tg1': tg1,
        'tg2': tg2,
        'tg3': tg3,
        'tg4': tg4,
        'tg5': tg5,
        'tg6': tg6,
        'rh1': rh1,
        'rh2': rh2,
        'rh3': rh3,
        'rh4': rh4,
        'rh5': rh5,
        'rh6': rh6,
        'deviceCalibrationTW': deviceCalibrationTW,
        'deviceCalibrationTG': deviceCalibrationTG,
        'deviceCalibrationISBB': deviceCalibrationISBB,
        'isUpdate': isUpdate,
      };

  factory DataIklimKerja.fromJson(Map<String, dynamic> json) {
    return DataIklimKerja(
      id: json['id'],
      location: json['location'],
      time: DateTime.parse(json['time']).toLocal(),
      jumlahTK: json['jumlahTK'],
      durasi: json['durasi'],
      pengendalian: json['pengendalian'],
      note: json['note'],
      tw1: double.parse(json['tw1']),
      tw2: double.parse(json['tw2']),
      tw3: double.parse(json['tw3']),
      tw4: double.parse(json['tw4']),
      tw5: double.parse(json['tw5']),
      tw6: double.parse(json['tw6']),
      tg1: double.parse(json['tg1']),
      tg2: double.parse(json['tg2']),
      tg3: double.parse(json['tg3']),
      tg4: double.parse(json['tg4']),
      tg5: double.parse(json['tg5']),
      tg6: double.parse(json['tg6']),
      rh1: double.parse(json['rh1']),
      rh2: double.parse(json['rh2']),
      rh3: double.parse(json['rh3']),
      rh4: double.parse(json['rh4']),
      rh5: double.parse(json['rh5']),
      rh6: double.parse(json['rh6']),
      deviceCalibrationTW: json['deviceCalibrationTW'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibrationTW']),
      deviceCalibrationTG: json['deviceCalibrationTG'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibrationTG']),
      deviceCalibrationISBB:
          json['deviceCalibrationISBB'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibrationISBB']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}

class InputIklimKerja {
  int examinationId;
  List<DataIklimKerja> dataInputIklimKerja;

  InputIklimKerja({required this.examinationId, required this.dataInputIklimKerja});

  Map<String, dynamic> toJson() => {
        'examinationId': examinationId,
        'dataInputIklimKerja': dataInputIklimKerja.toList(),
      };

  factory InputIklimKerja.fromJson(Map<String, dynamic> json) {
    List<DataIklimKerja> dataInputIklimKerja = [];
    if (json["dataInputIklimKerja"] != null) {
      Iterable iterable = json["dataInputIklimKerja"];
      for (var data in iterable) {
        dataInputIklimKerja.add(DataIklimKerja.fromJson(data));
      }
    }
    return InputIklimKerja(
      examinationId: json['examinationId'],
      dataInputIklimKerja: dataInputIklimKerja,
    );
  }
}
