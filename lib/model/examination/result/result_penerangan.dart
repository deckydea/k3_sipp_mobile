import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ResultPenerangan {
  final int id;
  final String location;
  final String localLightingData;
  final double average;
  final double standardDeviation;
  final double standar;
  final double upresisi;
  final double ukalibrasi;
  final double ugabungan;
  final double u95;
  final double ketidakpastian;
  final double rsu;
  final double toleransi;
  final double batasKeterimaan;
  final DateTime time;
  final int jumlahTK;
  final SumberCahaya sumberCahaya;
  final JenisPengukuran jenisPengukuran;
  final DeviceCalibration? deviceCalibration;

  ResultPenerangan({
    required this.id,
    required this.location,
    required this.localLightingData,
    required this.average,
    required this.standardDeviation,
    required this.standar,
    required this.upresisi,
    required this.ukalibrasi,
    required this.ugabungan,
    required this.u95,
    required this.ketidakpastian,
    required this.rsu,
    required this.toleransi,
    required this.batasKeterimaan,
    required this.time,
    required this.jumlahTK,
    required this.sumberCahaya,
    required this.jenisPengukuran,
    this.deviceCalibration,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'location': location,
    'localLightingData': localLightingData,
    'average': average,
    'standardDeviation': standardDeviation,
    'standard': standar,
    'upresisi': upresisi,
    'ukalibrasi': ukalibrasi,
    'ugabungan': ugabungan,
    'u95': u95,
    'ketidakpastian': ketidakpastian,
    'rsu': rsu,
    'toleransi': toleransi,
    'batasKeterimaan': batasKeterimaan,
    'time': DateTimeUtils.format(time),
    'jumlahTK': jumlahTK,
    'sumberCahaya': sumberCahaya.label,
    'jenisPengukuran': jenisPengukuran.label,
    'deviceCalibration': deviceCalibration,
  };

  static ResultPenerangan fromJson(Map<String, dynamic> json) {
    return ResultPenerangan(
      id: json['id'],
      location: json['location'],
      localLightingData: json['localLightingData'],
      average: double.parse(json['average'].toString()),
      standardDeviation: double.parse(json['standarDeviasi'].toString()),
      standar: json['standard'] == null ? 0 : double.parse(json['standard'].toString()),
      upresisi: double.parse(json['Upresisi'].toString()),
      ukalibrasi: double.parse(json['Ukalibrasi'].toString()),
      ugabungan: double.parse(json['Ugabungan'].toString()),
      u95: double.parse(json['U95'].toString()),
      ketidakpastian: double.parse(json['ketidakpastian'].toString()),
      rsu: double.parse(json['RSU'].toString()),
      toleransi: double.parse(json['toleransi'].toString()),
      batasKeterimaan: double.parse(json['batasKeterimaan'].toString()),
      time: DateTime.parse(json['time']).toLocal(),
      jumlahTK: json['jumlahTK'],
      sumberCahaya: SumberCahaya.values.firstWhere((element) => element.label == json['sumberCahaya']),
      jenisPengukuran: JenisPengukuran.values.firstWhere((element) => element.label == json['jenisPengukuran']),
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
    );
  }
}