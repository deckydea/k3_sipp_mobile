import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

enum PosisiPengukuran { berdiri, bersandar, duduk, berbaring }

extension PosisiPengukuranExtension on PosisiPengukuran {
  String get label {
    switch (this) {
      case PosisiPengukuran.berdiri:
        return "Berdiri";
      case PosisiPengukuran.bersandar:
        return "Bersandar";
      case PosisiPengukuran.duduk:
        return "Duduk";
      case PosisiPengukuran.berbaring:
        return "Berbaring";
      default:
        return "-";
    }
  }
}

class DataWholeBody {
  final int? id;
  final DateTime time;
  final String location;
  final String nik;
  final String name;
  final String bagian;
  final int jumlahTK;
  final PosisiPengukuran posisiPengukuran;
  final String sumberGetaran;
  final String tindakan;
  final double durasi;
  final double durasiPaparanStart;
  final double durasiPaparanEnd;
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

  const DataWholeBody({
    this.id,
    required this.time,
    required this.location,
    required this.nik,
    required this.name,
    required this.bagian,
    required this.jumlahTK,
    required this.posisiPengukuran,
    required this.sumberGetaran,
    required this.tindakan,
    required this.durasi,
    required this.durasiPaparanStart,
    required this.durasiPaparanEnd,
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

  DataWholeBody copyWith({
    int? id,
    DateTime? time,
    String? location,
    String? nik,
    String? name,
    String? bagian,
    int? jumlahTK,
    PosisiPengukuran? posisiPengukuran,
    String? sumberGetaran,
    String? tindakan,
    double? durasi,
    double? durasiPaparanStart,
    double? durasiPaparanEnd,
    double? x1,
    double? x2,
    double? x3,
    double? y1,
    double? y2,
    double? y3,
    double? z1,
    double? z2,
    double? z3,
    String? note,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataWholeBody(
        id: id ?? this.id,
        time: time ?? this.time,
        location: location ?? this.location,
        nik: nik ?? this.nik,
        name: name ?? this.name,
        bagian: bagian ?? this.bagian,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        posisiPengukuran: posisiPengukuran ?? this.posisiPengukuran,
        sumberGetaran: sumberGetaran ?? this.sumberGetaran,
        tindakan: tindakan ?? this.tindakan,
        durasi: durasi ?? this.durasi,
        durasiPaparanStart: durasiPaparanStart ?? this.durasiPaparanStart,
        durasiPaparanEnd: durasiPaparanEnd ?? this.durasiPaparanEnd,
        x1: x1 ?? this.x1,
        x2: x2 ?? this.x2,
        x3: x3 ?? this.x3,
        y1: y1 ?? this.y1,
        y2: y2 ?? this.y2,
        y3: y3 ?? this.y3,
        z1: z1 ?? this.z1,
        z2: z2 ?? this.z2,
        z3: z3 ?? this.z3,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
      );

  DataWholeBody replica() {
    return DataWholeBody(
      id: id,
      time: time,
      location: location,
      nik: nik,
      name: name,
      bagian: bagian,
      jumlahTK: jumlahTK,
      posisiPengukuran: posisiPengukuran,
      sumberGetaran: sumberGetaran,
      tindakan: tindakan,
      durasi: durasi,
      durasiPaparanStart: durasiPaparanStart,
      durasiPaparanEnd: durasiPaparanEnd,
      x1: x1,
      x2: x2,
      x3: x3,
      y1: y1,
      y2: y2,
      y3: y3,
      z1: z1,
      z2: z2,
      z3: z3,
      deviceCalibration: deviceCalibration ?? deviceCalibration,
      isUpdate: isUpdate,
      note: note ?? note,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': DateTimeUtils.format(time),
        'location': location,
        'nik': nik,
        'name': name,
        'bagian': bagian,
        'jumlahTK': jumlahTK,
        'posisiPengukuran': posisiPengukuran.name,
        'sumberGetaran': sumberGetaran,
        'tindakan': tindakan,
        'durasi': durasi,
        'durasiPaparanStart': durasiPaparanStart,
        'durasiPaparanEnd': durasiPaparanEnd,
        'x1': x1,
        'x2': x2,
        'x3': x3,
        'y1': y1,
        'y2': y2,
        'y3': y3,
        'z1': z1,
        'z2': z2,
        'z3': z3,
        'note': note,
        'isUpdate': isUpdate,
        'deviceCalibration': deviceCalibration,
      };

  factory DataWholeBody.fromJson(Map<String, dynamic> json) {
    return DataWholeBody(
      id: json['id'],
      time: DateTime.parse(json['time']).toLocal(),
      location: json['location'],
      nik: json['nik'],
      name: json['name'],
      bagian: json['bagian'],
      jumlahTK: json['jumlahTK'],
      posisiPengukuran: PosisiPengukuran.values.firstWhere((element) => element.name == json['posisiPengukuran']),
      sumberGetaran: json['sumberGetaran'],
      tindakan: json['tindakan'],
      durasi: double.parse(json['durasi'].toString()),
      durasiPaparanStart: double.parse(json['durasiPaparanStart'].toString()),
      durasiPaparanEnd: double.parse(json['durasiPaparanEnd'].toString()),
      x1: double.parse(json['x1'].toString()),
      x2: double.parse(json['x2'].toString()),
      x3: double.parse(json['x3'].toString()),
      y1: double.parse(json['y1'].toString()),
      y2: double.parse(json['y2'].toString()),
      y3: double.parse(json['y3'].toString()),
      z1: double.parse(json['z1'].toString()),
      z2: double.parse(json['z2'].toString()),
      z3: double.parse(json['z3'].toString()),
      note: json['note'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}

class InputDataWholeBody {
  int examinationId;
  List<DataWholeBody> dataWholeBody;

  InputDataWholeBody({required this.examinationId, required this.dataWholeBody});

  InputDataWholeBody replica() {
    List<DataWholeBody> dataWholeBodyReplica = [];
    for (var element in dataWholeBody) {
      dataWholeBodyReplica.add(element.replica());
    }

    return InputDataWholeBody(
      examinationId: examinationId,
      dataWholeBody: dataWholeBodyReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        'examinationId': examinationId,
        'dataWholeBody': dataWholeBody.toList(),
      };

  factory InputDataWholeBody.fromJson(Map<String, dynamic> json) {
    List<DataWholeBody> dataWholeBody = [];
    if (json["dataWholeBody"] != null) {
      Iterable iterable = json["dataWholeBody"];
      for (var data in iterable) {
        dataWholeBody.add(DataWholeBody.fromJson(data));
      }
    }
    return InputDataWholeBody(
      examinationId: json['examinationId'],
      dataWholeBody: dataWholeBody,
    );
  }
}
