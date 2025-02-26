import 'package:equatable/equatable.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

enum SumberCahaya { alami, buatan, alamiBuatan }

extension SumberCahayaExtension on SumberCahaya {
  String get label {
    switch (this) {
      case SumberCahaya.alami:
        return "Alami";
      case SumberCahaya.buatan:
        return "Buatan";
      case SumberCahaya.alamiBuatan:
        return "Alami dan Buatan";
      default:
        return "-";
    }
  }
}

enum JenisPengukuran { lokal, umum }

extension JenisPengukuranExtension on JenisPengukuran {
  String get label {
    switch (this) {
      case JenisPengukuran.lokal:
        return "Lokal";
      case JenisPengukuran.umum:
        return "Umum";
      default:
        return "-";
    }
  }
}

class DataPenerangan extends Equatable {
  final int? id;
  final String location;
  final String localLightingData;
  final DateTime? time;
  final double value1;
  final double value2;
  final double value3;
  final String? note;
  final int jumlahTK;
  final SumberCahaya? sumberCahaya;
  final JenisPengukuran? jenisPengukuran;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataPenerangan({
    this.id,
    required this.location,
    required this.localLightingData,
    this.time,
    required this.value1,
    required this.value2,
    required this.value3,
    this.note,
    this.jumlahTK = 0,
    this.sumberCahaya,
    this.jenisPengukuran,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  DataPenerangan copyWith({
    int? id,
    String? location,
    String? localLightingData,
    DateTime? time,
    double? value1,
    double? value2,
    double? value3,
    String? note,
    int? jumlahTK,
    SumberCahaya? sumberCahaya,
    JenisPengukuran? jenisPengukuran,
    DeviceCalibration? deviceCalibration,
  }) =>
      DataPenerangan(
        id: id ?? this.id,
        location: location ?? this.location,
        localLightingData: localLightingData ?? this.localLightingData,
        time: time ?? this.time,
        value1: value1 ?? this.value1,
        value2: value2 ?? this.value2,
        value3: value3 ?? this.value3,
        note: note ?? this.note,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        sumberCahaya: sumberCahaya ?? this.sumberCahaya,
        jenisPengukuran: jenisPengukuran ?? this.jenisPengukuran,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
      );

  DataPenerangan replica() {
    return DataPenerangan(
      id: id,
      location: location,
      localLightingData: localLightingData,
      time: time,
      value1: value1,
      value2: value2,
      value3: value3,
      note: note,
      jumlahTK: jumlahTK,
      sumberCahaya: sumberCahaya,
      jenisPengukuran: jenisPengukuran,
      deviceCalibration: deviceCalibration,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        'localLightingData': localLightingData,
        if (time != null) 'time': DateTimeUtils.format(time!),
        'value1': value1,
        'value2': value2,
        'value3': value3,
        'note': note,
        'jumlahTK': jumlahTK,
        'sumberCahaya': sumberCahaya?.label,
        'jenisPengukuran': jenisPengukuran?.label,
        'deviceCalibration': deviceCalibration,
        'isUpdate': isUpdate,
      };

  factory DataPenerangan.fromJson(Map<String, dynamic> json) {
    return DataPenerangan(
      id: json['id'],
      location: json['location'],
      localLightingData: json['localLightingData'],
      time: json['time'] == null ? null : DateTime.parse(json['time']).toLocal(),
      value1: double.parse(json['value1'].toString()),
      value2: double.parse(json['value2'].toString()),
      value3: double.parse(json['value3'].toString()),
      note: json['note'],
      jumlahTK: json['jumlahTK'],
      sumberCahaya: json['sumberCahaya'] == null ? null : SumberCahaya.values.firstWhere((element) => element.label == json['sumberCahaya']),
      jenisPengukuran: json['jenisPengukuran'] == null ? null : JenisPengukuran.values.firstWhere((element) => element.label == json['jenisPengukuran']),
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, localLightingData, time, value1, value2, value3, note, isUpdate];
}

class InputPenerangan {
  int examinationId;
  List<DataPenerangan> dataPenerangan;

  InputPenerangan({required this.examinationId, required this.dataPenerangan});

  InputPenerangan replica() {
    List<DataPenerangan> dataPeneranganReplica = [];
    for (var element in dataPenerangan) {
      dataPeneranganReplica.add(element.replica());
    }

    return InputPenerangan(
      examinationId: examinationId,
      dataPenerangan: dataPeneranganReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        'examinationId': examinationId,
        'dataPenerangan': dataPenerangan.toList(),
      };

  factory InputPenerangan.fromJson(Map<String, dynamic> json) {
    List<DataPenerangan> dataPenerangan = [];
    if (json["dataPenerangan"] != null) {
      Iterable iterable = json["dataPenerangan"];
      for (var data in iterable) {
        dataPenerangan.add(DataPenerangan.fromJson(data));
      }
    }
    return InputPenerangan(
      examinationId: json['examinationId'],
      dataPenerangan: dataPenerangan,
    );
  }
}
