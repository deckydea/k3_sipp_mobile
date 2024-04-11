import 'package:equatable/equatable.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

enum PemaparanKebisingan { jam8, jam4, jam2, jam1, menit30, menit15,menit75, menit375, menit188, menit094 }

extension PemaparanKebisinganExtension on PemaparanKebisingan {
  int get nab {
    switch (this) {
      case PemaparanKebisingan.jam8:
        return 85;
      case PemaparanKebisingan.jam4:
        return 88;
      case PemaparanKebisingan.jam2:
        return 91;
      case PemaparanKebisingan.jam1:
        return 94;
      case PemaparanKebisingan.menit30:
        return 97;
      case PemaparanKebisingan.menit15:
        return 100;
      case PemaparanKebisingan.menit75:
        return 103;
      case PemaparanKebisingan.menit375:
        return 106;
      case PemaparanKebisingan.menit188:
        return 109;
      case PemaparanKebisingan.menit094:
        return 112;
      default:
        return 0;
    }
  }

  double get value {
    switch (this) {
      case PemaparanKebisingan.jam8:
        return 8;
      case PemaparanKebisingan.jam4:
        return 4;
      case PemaparanKebisingan.jam2:
        return 2;
      case PemaparanKebisingan.jam1:
        return 1;
      case PemaparanKebisingan.menit30:
        return 30;
      case PemaparanKebisingan.menit15:
        return 15;
      case PemaparanKebisingan.menit75:
        return 7.5;
      case PemaparanKebisingan.menit375:
        return 3.75;
      case PemaparanKebisingan.menit188:
        return 1.88;
      case PemaparanKebisingan.menit094:
        return 0.94;
      default:
        return 0;
    }
  }

  String get label {
    switch (this) {
      case PemaparanKebisingan.jam8:
        return "8 Jam";
      case PemaparanKebisingan.jam4:
        return "4 Jam";
      case PemaparanKebisingan.jam2:
        return "2 Jam";
      case PemaparanKebisingan.jam1:
        return "1 Jam";
      case PemaparanKebisingan.menit30:
        return "30 Menit";
      case PemaparanKebisingan.menit15:
        return "15 Menit";
      case PemaparanKebisingan.menit75:
        return "7.5 Menit";
      case PemaparanKebisingan.menit375:
        return "3.75 Menit";
      case PemaparanKebisingan.menit188:
        return "1.88 Menit";
      case PemaparanKebisingan.menit094:
        return "0.94 Menit";
      default:
        return "-";
    }
  }
}

class DataKebisinganLK extends Equatable {
  final int? id;
  final String location;
  final DateTime? time;
  final double value1;
  final double value2;
  final double value3;
  final String? note;
  final double? pemaparan;
  final String? pengendalian;
  final int? jumlahTK;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataKebisinganLK({
    this.id,
    required this.location,
    this.time,
    required this.value1,
    required this.value2,
    required this.value3,
    this.note,
    this.pemaparan,
    this.pengendalian,
    this.deviceCalibration,
    this.jumlahTK,
    this.isUpdate = false,
  });

  DataKebisinganLK copyWith({
    int? id,
    String? location,
    DateTime? time,
    double? value1,
    double? value2,
    double? value3,
    String? note,
    double? pemaparan,
    String? pengendalian,
    int? jumlahTK,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataKebisinganLK(
        id: id ?? this.id,
        location: location ?? this.location,
        time: time ?? this.time,
        value1: value1 ?? this.value1,
        value2: value2 ?? this.value2,
        value3: value3 ?? this.value3,
        pemaparan: pemaparan ?? this.pemaparan,
        pengendalian: pengendalian ?? this.pengendalian,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note
      );

  DataKebisinganLK replica() {
    return DataKebisinganLK(
      id: id,
      location: location,
      time: time,
      value1: value1,
      value2: value2,
      value3: value3,
      note: note,
      pemaparan: pemaparan,
      pengendalian: pengendalian,
      deviceCalibration: deviceCalibration,
      jumlahTK: jumlahTK,
      isUpdate: isUpdate,
    );
  }

  PemaparanKebisingan pemaparanKebisingan() {
    switch (pemaparan) {
      case 8:
        return PemaparanKebisingan.jam8;
      case 4:
        return PemaparanKebisingan.jam4;
      case 2:
        return PemaparanKebisingan.jam2;
      case 1:
        return PemaparanKebisingan.jam1;
      case 30:
        return PemaparanKebisingan.menit30;
      case 15:
        return PemaparanKebisingan.menit15;
      default:
        return PemaparanKebisingan.jam8;
    }
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'location': location,
        if (time != null) 'time': DateTimeUtils.format(time!),
        'value1': value1,
        'value2': value2,
        'value3': value3,
        'note': note,
        'isUpdate': isUpdate,
        'pemaparan': pemaparan?.toDouble(),
        'pengendalian': pengendalian,
        'jumlahTK': jumlahTK,
        'deviceCalibration': deviceCalibration,
      };

  factory DataKebisinganLK.fromJson(Map<String, dynamic> json) {
    return DataKebisinganLK(
      id: json['id'],
      location: json['location'],
      time: json['time'] == null ? null : DateTime.parse(json['time']).toLocal(),
      value1: double.parse(json['value1'].toString()),
      value2: double.parse(json['value2'].toString()),
      value3: double.parse(json['value3'].toString()),
      note: json['note'],
      pemaparan: double.tryParse(json['pemaparan'].toString()),
      pengendalian: json['pengendalian'],
      jumlahTK: json['jumlahTK'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, location, time, value1, value2, value3, note, isUpdate];
}

class InputKebisinganLK {
  int examinationId;
  List<DataKebisinganLK> dataKebisinganLK;

  InputKebisinganLK({required this.examinationId, required this.dataKebisinganLK});

  InputKebisinganLK replica() {
    List<DataKebisinganLK> dataKebisinganReplica = [];
    for (var element in dataKebisinganLK) {
      dataKebisinganReplica.add(element.replica());
    }

    return InputKebisinganLK(
      examinationId: examinationId,
      dataKebisinganLK: dataKebisinganReplica,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'examinationId': examinationId,
        'dataKebisinganLK': dataKebisinganLK.toList(),
      };

  factory InputKebisinganLK.fromJson(Map<String, dynamic> json) {
    List<DataKebisinganLK> dataKebisinganLK = [];
    if (json["dataKebisinganLK"] != null) {
      Iterable iterable = json["dataKebisinganLK"];
      for (var data in iterable) {
        dataKebisinganLK.add(DataKebisinganLK.fromJson(data));
      }
    }
    return InputKebisinganLK(
      examinationId: json['examinationId'],
      dataKebisinganLK: dataKebisinganLK,
    );
  }
}
