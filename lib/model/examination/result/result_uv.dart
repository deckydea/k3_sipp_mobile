import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ResultUV {
  final int? id;
  final DateTime time;
  final String location;
  final Posisi posisi;
  final int jumlahTK;
  final double value1;
  final double value2;
  final double value3;
  final double durasi;
  final double average;
  final double standarDeviasi;
  final double u95;
  final double cakupan;
  final double ketidakpastian;
  final double hasilAkhir;
  final double ieff;
  final double percentage;
  final String? note;
  final String? pengendalian;
  final DeviceCalibration? deviceCalibration;

  //For request update purpose only
  final bool isUpdate;

  const ResultUV({
    this.id,
    required this.time,
    required this.location,
    required this.posisi,
    required this.jumlahTK,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.durasi,
    required this.average,
    required this.standarDeviasi,
    required this.u95,
    required this.cakupan,
    required this.ketidakpastian,
    required this.hasilAkhir,
    required this.ieff,
    required this.percentage,
    this.note,
    this.pengendalian,
    this.deviceCalibration,
    this.isUpdate = false,
  });

  double get nab {
    switch (durasi) {
      case 28800: // 8 jam
        return 0.1;
      case 14400: // 4 jam
        return 0.2;
      case 7200: // 2 jam
        return 0.4;
      case 3600: // 1 jam
        return 0.8;
      case 1800: // 30 menit
        return 1.7;
      case 900: // 15 menit
        return 3.3;
      case 600: // 10 menit
        return 5;
      case 300: // 5 menit
        return 10;
      case 60: // 1 menit
        return 50;
      case 30: // 30 detik
        return 100;
      case 10: // 10 detik
        return 300;
      case 1: // 1 detik
        return 3000;
      case 0.5: // 0.5 detik
        return 6000;
      case 0.1: // 0.1 detik
        return 30000;
      default:
        return 0;
    }
  }

  ResultUV copyWith({
    int? id,
    DateTime? time,
    String? location,
    Posisi? posisi,
    int? jumlahTK,
    double? value1,
    double? value2,
    double? value3,
    double? durasi,
    double? average,
    double? standarDeviasi,
    double? u95,
    double? cakupan,
    double? ketidakpastian,
    double? hasilAkhir,
    double? ieff,
    double? percentage,
    String? note,
    String? pengendalian,
    DeviceCalibration? deviceCalibration,
    bool isUpdate = false,
  }) =>
      ResultUV(
        id: id ?? this.id,
        location: location ?? this.location,
        jumlahTK: jumlahTK ?? this.jumlahTK,
        posisi: posisi ?? this.posisi,
        value1: value1 ?? this.value1,
        value2: value2 ?? this.value2,
        value3: value3 ?? this.value3,
        durasi: durasi ?? this.durasi,
        average: average ?? this.average,
        standarDeviasi: standarDeviasi ?? this.standarDeviasi,
        u95: u95 ?? this.u95,
        cakupan: cakupan ?? this.cakupan,
        ketidakpastian: ketidakpastian ?? this.ketidakpastian,
        hasilAkhir: hasilAkhir ?? this.hasilAkhir,
        ieff: ieff ?? this.ieff,
        percentage: percentage ?? this.percentage,
        time: time ?? this.time,
        deviceCalibration: deviceCalibration ?? this.deviceCalibration,
        isUpdate: isUpdate,
        note: note ?? this.note,
        pengendalian: pengendalian ?? this.pengendalian,
      );

  ResultUV replica() {
    return ResultUV(
      id: id,
      time: time,
      location: location,
      jumlahTK: jumlahTK,
      posisi: posisi,
      value1: value1,
      value2: value2,
      value3: value3,
      durasi: durasi,
      average: average,
      standarDeviasi: standarDeviasi,
      u95: u95,
      cakupan: cakupan,
      ketidakpastian: ketidakpastian,
      hasilAkhir: hasilAkhir,
      ieff: ieff,
      percentage: percentage,
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
        'average': average,
        'standarDeviasi': standarDeviasi,
        'u95': u95,
        'cakupan': cakupan,
        'ketidakpastian': ketidakpastian,
        'hasilAkhir': hasilAkhir,
        'ieff': ieff,
        'percentage': percentage,
        'note': note,
        'pengendalian': pengendalian,
        'isUpdate': isUpdate,
        'deviceCalibration': deviceCalibration,
      };

  factory ResultUV.fromJson(Map<String, dynamic> json) {
    return ResultUV(
      id: json['id'],
      time: DateTime.parse(json['time']).toLocal(),
      location: json['location'],
      jumlahTK: json['jumlahTK'],
      posisi: Posisi.values.firstWhere((element) => element.name == json['posisi']),
      value1: double.parse(json['value1'].toString()),
      value2: double.parse(json['value2'].toString()),
      value3: double.parse(json['value3'].toString()),
      durasi: double.parse(json['durasi'].toString()),
      average: double.parse(json['average'].toString()),
      standarDeviasi: double.parse(json['standarDeviasi'].toString()),
      u95: double.parse(json['u95'].toString()),
      cakupan: double.parse(json['cakupan'].toString()),
      ketidakpastian: double.parse(json['ketidakpastian'].toString()),
      hasilAkhir: double.parse(json['hasilAkhir'].toString()),
      ieff: double.parse(json['ieff'].toString()),
      percentage: double.parse(json['percentage'].toString()),
      note: json['note'],
      pengendalian: json['pengendalian'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}
