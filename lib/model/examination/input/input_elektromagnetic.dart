import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_elektromagnetic.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class DataElektromagnetik {
  final int? id;
  final DateTime time;
  final String location;
  final double dl;
  final int jumlahTK;
  final BagianTubuh bagianTubuh;
  final String? note;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const DataElektromagnetik({
    this.id,
    required this.time,
    required this.location,
    required this.dl,
    required this.jumlahTK,
    required this.bagianTubuh,
    this.note,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  DataElektromagnetik copyWith({
    int? id,
    DateTime? time,
    String? location,
    double? dl,
    int? jumlahTK,
    BagianTubuh? bagianTubuh,
    String? note,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      DataElektromagnetik(
        id: id ?? this.id,
        location: location ?? this.location,
        dl: dl ?? this.dl,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        bagianTubuh: bagianTubuh ?? this.bagianTubuh,
        time: time ?? this.time,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
      );

  DataElektromagnetik replica() {
    return DataElektromagnetik(
      id: id,
      time: time,
      location: location,
      dl: dl,
      jumlahTK: jumlahTK,
      bagianTubuh: bagianTubuh,
      note: note,
      deviceCalibration: deviceCalibration,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': DateTimeUtils.format(time),
    'location': location,
    'dl': dl,
    'jumlahTK': jumlahTK,
    'bagianTubuh' : bagianTubuh.name,
    'note': note,
    'isUpdate': isUpdate,
    'deviceCalibration': deviceCalibration,
  };

  factory DataElektromagnetik.fromJson(Map<String, dynamic> json) {
    return DataElektromagnetik(
      id: json['id'],
      time: DateTime.parse(json['time']).toLocal(),
      location: json['location'],
      dl: double.parse(json['dl'].toString()),
      jumlahTK: json['jumlahTK'],
      bagianTubuh: BagianTubuh.values.firstWhere((element) => element.name == json['bagianTubuh']),
      note: json['note'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}

class InputDataElektromagnetic {
  int examinationId;
  List<DataElektromagnetik> dataElektromagnetik;

  InputDataElektromagnetic({required this.examinationId, required this.dataElektromagnetik});

  InputDataElektromagnetic replica() {
    List<DataElektromagnetik> dataElektromagneticReplica = [];
    for (var element in dataElektromagnetik) {
      dataElektromagneticReplica.add(element.replica());
    }

    return InputDataElektromagnetic(
      examinationId: examinationId,
      dataElektromagnetik: dataElektromagneticReplica,
    );
  }

  Map<String, dynamic> toJson() => {
    'examinationId': examinationId,
    'dataElektromagnetik': dataElektromagnetik.toList(),
  };

  factory InputDataElektromagnetic.fromJson(Map<String, dynamic> json) {
    List<DataElektromagnetik> dataElektromagnetik = [];
    if (json["dataElektromagnetik"] != null) {
      Iterable iterable = json["dataElektromagnetik"];
      for (var data in iterable) {
        dataElektromagnetik.add(DataElektromagnetik.fromJson(data));
      }
    }
    return InputDataElektromagnetic(
      examinationId: json['examinationId'],
      dataElektromagnetik: dataElektromagnetik,
    );
  }
}