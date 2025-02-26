
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class DataNoiseDose {
  final int? id;
  final DateTime timeStart;
  final DateTime timeEnd;
  final String name;
  final String nik;
  final String bagian;
  final double twa;
  final double dose;
  final double leq;
  final String? note;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataNoiseDose({
    this.id,
    required this.timeStart,
    required this.timeEnd,
    required this.name,
    required this.nik,
    required this.bagian,
    required this.twa,
    required this.dose,
    required this.leq,
    this.note,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  DataNoiseDose copyWith({
    int? id,
    DateTime? timeStart,
    DateTime? timeEnd,
    String? name,
    String? nik,
    String? bagian,
    double? twa,
    double? dose,
    double? leq,
    String? note,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataNoiseDose(
        id: id ?? this.id,
        timeStart: timeStart ?? this.timeStart,
        timeEnd: timeEnd ?? this.timeEnd,
        name: name ?? this.name,
        nik: nik ?? this.nik,
        bagian: bagian ?? this.bagian,
        twa: twa ?? this.twa,
        dose: dose ?? this.dose,
        leq: leq ?? this.leq,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
      );

  DataNoiseDose replica() {
    return DataNoiseDose(
      id: id,
      timeStart: timeStart,
      timeEnd: timeEnd,
      name: name,
      nik: nik,
      bagian: bagian,
      twa: twa,
      dose: dose,
      leq: leq,
      note: note,
      deviceCalibration: deviceCalibration,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'timeStart': DateTimeUtils.format(timeStart),
    'timeEnd': DateTimeUtils.format(timeEnd),
    'name': name,
    'nik': nik,
    'bagian': bagian,
    'twa': twa,
    'dose': dose,
    'leq': leq,
    'note': note,
    'isUpdate': isUpdate,
    'deviceCalibration': deviceCalibration,
  };

  factory DataNoiseDose.fromJson(Map<String, dynamic> json) {
    return DataNoiseDose(
      id: json['id'],
      timeStart: DateTime.parse(json['timeStart']).toLocal(),
      timeEnd: DateTime.parse(json['timeEnd']).toLocal(),
      name: json['name'],
      nik: json['nik'],
      bagian: json['bagian'],
      twa: double.parse(json['twa'].toString()),
      dose: double.parse(json['dose'].toString()),
      leq: double.parse(json['leq'].toString()),
      note: json['note'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}

class InputKebisinganNoiseDose {
  int examinationId;
  List<DataNoiseDose> dataNoiseDose;

  InputKebisinganNoiseDose({required this.examinationId, required this.dataNoiseDose});

  InputKebisinganNoiseDose replica() {
    List<DataNoiseDose> dataNoiseDoseReplica = [];
    for (var element in dataNoiseDose) {
      dataNoiseDoseReplica.add(element.replica());
    }

    return InputKebisinganNoiseDose(
      examinationId: examinationId,
      dataNoiseDose: dataNoiseDoseReplica,
    );
  }

  Map<String, dynamic> toJson() => {
    'examinationId': examinationId,
    'dataNoiseDose': dataNoiseDose.toList(),
  };

  factory InputKebisinganNoiseDose.fromJson(Map<String, dynamic> json) {
    List<DataNoiseDose> dataNoiseDose = [];
    if (json["dataNoiseDose"] != null) {
      Iterable iterable = json["dataNoiseDose"];
      for (var data in iterable) {
        dataNoiseDose.add(DataNoiseDose.fromJson(data));
      }
    }
    return InputKebisinganNoiseDose(
      examinationId: json['examinationId'],
      dataNoiseDose: dataNoiseDose,
    );
  }
}