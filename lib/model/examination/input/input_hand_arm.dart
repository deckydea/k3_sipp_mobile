import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

enum Adaptor { lengan, tangan, mesin }

extension AdaptorExtension on Adaptor {
  String get label {
    switch (this) {
      case Adaptor.lengan:
        return "Lengan";
      case Adaptor.tangan:
        return "Tangan";
      case Adaptor.mesin:
        return "Mesin";
      default:
        return "-";
    }
  }
}

class DataHandArm {
  final int? id;
  final String location;
  final String nik;
  final String name;
  final String bagian;
  final DateTime time;
  final int jumlahTK;
  final double durasi;
  final String tindakan;
  final Adaptor adaptor;
  final String sumberGetaran;
  final double x1;
  final double x2;
  final double x3;
  final double y1;
  final double y2;
  final double y3;
  final double z1;
  final double z2;
  final double z3;
  final String? note;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataHandArm({
    this.id,
    required this.time,
    required this.location,
    required this.nik,
    required this.name,
    required this.bagian,
    required this.tindakan,
    required this.jumlahTK,
    required this.durasi,
    required this.adaptor,
    required this.sumberGetaran,
    required this.x1,
    required this.x2,
    required this.x3,
    required this.y1,
    required this.y2,
    required this.y3,
    required this.z1,
    required this.z2,
    required this.z3,
    this.note,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  DataHandArm copyWith({
    int? id,
    DateTime? time,
    String? location,
    String? nik,
    String? name,
    String? bagian,
    String? tindakan,
    int? jumlahTK,
    Adaptor? adaptor,
    String? sumberGetaran,
    double? x1,
    double? x2,
    double? x3,
    double? y1,
    double? y2,
    double? y3,
    double? z1,
    double? z2,
    double? z3,
    double? durasi,
    String? note,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataHandArm(
        id: id ?? this.id,
        location: location ?? this.location,
        nik: nik ?? this.nik,
        name: name ?? this.name,
        bagian: bagian ?? this.bagian,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        tindakan: tindakan ?? this.tindakan,
        adaptor: adaptor ?? this.adaptor,
        sumberGetaran: sumberGetaran ?? this.sumberGetaran,
        x1: x1 ?? this.x1,
        x2: x2 ?? this.x2,
        x3: x3 ?? this.x3,
        y1: y1 ?? this.y1,
        y2: y2 ?? this.y2,
        y3: y3 ?? this.y3,
        z1: z1 ?? this.z1,
        z2: z2 ?? this.z2,
        z3: z3 ?? this.z3,
        durasi: durasi ?? this.durasi,
        time: time ?? this.time,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
      );

  DataHandArm replica() {
    return DataHandArm(
      id: id,
      time: time,
      location: location,
      jumlahTK: jumlahTK,
      tindakan: tindakan,
      nik: nik,
      name: name,
      bagian: bagian,
      sumberGetaran: sumberGetaran,
      adaptor: adaptor,
      x1: x1,
      x2: x2,
      x3: x3,
      y1: y1,
      y2: y2,
      y3: y3,
      z1: z1,
      z2: z2,
      z3: z3,
      durasi: durasi,
      note: note,
      deviceCalibration: deviceCalibration,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': DateTimeUtils.format(time),
        'location': location,
        'jumlahTK': jumlahTK,
        'tindakan': tindakan,
        'nik': nik,
        'name': name,
        'bagian': bagian,
        'sumberGetaran': sumberGetaran,
        'adaptor': adaptor.name,
        'x1': x1,
        'x2': x2,
        'x3': x3,
        'y1': y1,
        'y2': y2,
        'y3': y3,
        'z1': z1,
        'z2': z2,
        'z3': z3,
        'durasi': durasi,
        'note': note,
        'isUpdate': isUpdate,
        'deviceCalibration': deviceCalibration,
      };

  factory DataHandArm.fromJson(Map<String, dynamic> json) {
    return DataHandArm(
      id: json['id'],
      time: DateTime.parse(json['time']).toLocal(),
      location: json['location'],
      jumlahTK: json['jumlahTK'],
      tindakan: json['tindakan'],
      nik: json['nik'],
      name: json['name'],
      bagian: json['bagian'],
      x1: double.parse(json['x1'].toString()),
      x2: double.parse(json['x2'].toString()),
      x3: double.parse(json['x3'].toString()),
      y1: double.parse(json['y1'].toString()),
      y2: double.parse(json['y2'].toString()),
      y3: double.parse(json['y3'].toString()),
      z1: double.parse(json['z1'].toString()),
      z2: double.parse(json['z2'].toString()),
      z3: double.parse(json['z3'].toString()),
      durasi: double.parse(json['durasi'].toString()),
      sumberGetaran: json['sumberGetaran'],
      adaptor: Adaptor.values.firstWhere((element) => element.name == json['adaptor']),
      note: json['note'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}


class InputDataHandArm {
  int examinationId;
  List<DataHandArm> dataHandArm;

  InputDataHandArm({required this.examinationId, required this.dataHandArm});

  InputDataHandArm replica() {
    List<DataHandArm> dataHandArmReplica = [];
    for (var element in dataHandArm) {
      dataHandArmReplica.add(element.replica());
    }

    return InputDataHandArm(
      examinationId: examinationId,
      dataHandArm: dataHandArmReplica,
    );
  }

  Map<String, dynamic> toJson() => {
    'examinationId': examinationId,
    'dataHandArm': dataHandArm.toList(),
  };

  factory InputDataHandArm.fromJson(Map<String, dynamic> json) {
    List<DataHandArm> dataHandArm = [];
    if (json["dataHandArm"] != null) {
      Iterable iterable = json["dataHandArm"];
      for (var data in iterable) {
        dataHandArm.add(DataHandArm.fromJson(data));
      }
    }
    return InputDataHandArm(
      examinationId: json['examinationId'],
      dataHandArm: dataHandArm,
    );
  }
}
