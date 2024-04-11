import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_lk.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ResultKebisinganLK {
  final int id;
  final String location;
  final double average;
  final double standardDeviation;
  final double upresisi;
  final double ukalibrasi;
  final double ubias;
  final double ugabungan;
  final double u95;
  final double ketidakpastian;
  final double rsu;
  final double resolusiKebisingan;
  final double toleransiKebisingan;
  final double batasKeterimaan;
  final DateTime time;
  final int? pemaparan;
  final String? pengendalian;
  final int? jumlahTK;

  final DeviceCalibration? deviceCalibration;

  ResultKebisinganLK({
    required this.id,
    required this.location,
    required this.average,
    required this.standardDeviation,
    required this.upresisi,
    required this.ukalibrasi,
    required this.ubias,
    required this.ugabungan,
    required this.u95,
    required this.ketidakpastian,
    required this.rsu,
    required this.resolusiKebisingan,
    required this.toleransiKebisingan,
    required this.batasKeterimaan,
    required this.time,
    this.pemaparan,
    this.pengendalian,
    this.jumlahTK,
    this.deviceCalibration,
  });

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'location': location,
        'average': average,
        'standardDeviation': standardDeviation,
        'upresisi': upresisi,
        'ukalibrasi': ukalibrasi,
        'ubias': ubias,
        'ugabungan': ugabungan,
        'u95': u95,
        'ketidakpastian': ketidakpastian,
        'rsu': rsu,
        'resolusiKebisingan': resolusiKebisingan,
        'toleransiKebisingan': toleransiKebisingan,
        'batasKeterimaan': batasKeterimaan,
        'time': DateTimeUtils.format(time),
        'pemaparan': pemaparan,
        'pengendalian': pengendalian,
        'jumlahTK': jumlahTK,
        'deviceCalibration': deviceCalibration,
      };

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

  static ResultKebisinganLK fromJson(Map<String, dynamic> json) {
    return ResultKebisinganLK(
      id: json['id'],
      location: json['location'],
      average: double.parse(json['average'].toString()),
      standardDeviation: double.parse(json['standarDeviasi'].toString()),
      upresisi: double.parse(json['Upresisi'].toString()),
      ukalibrasi: double.parse(json['Ukalibrasi'].toString()),
      ubias: double.parse(json['Ubias'].toString()),
      ugabungan: double.parse(json['Ugabungan'].toString()),
      u95: double.parse(json['U95'].toString()),
      ketidakpastian: double.parse(json['ketidakpastian'].toString()),
      rsu: double.parse(json['RSU'].toString()),
      resolusiKebisingan: double.parse(json['resolusiKebisingan'].toString()),
      toleransiKebisingan: double.parse(json['toleransiKebisingan'].toString()),
      batasKeterimaan: double.parse(json['batasKeterimaan'].toString()),
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
      pemaparan: json['pemaparan'],
      pengendalian: json['pengendalian'],
      jumlahTK: json['jumlahTK'],
      time: DateTime.parse(json['time']).toLocal(),
    );
  }
}
