import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ResultPenerangan {
  int id;
  String location;
  String localLightingData;
  double average;
  double standardDeviation;
  double upresisi;
  double ukalibrasi;
  double ugabungan;
  double u95;
  double ketidakpastian;
  double rsu;
  double toleransi;
  double batasKeterimaan;
  DateTime time;

  ResultPenerangan({
    required this.id,
    required this.location,
    required this.localLightingData,
    required this.average,
    required this.standardDeviation,
    required this.upresisi,
    required this.ukalibrasi,
    required this.ugabungan,
    required this.u95,
    required this.ketidakpastian,
    required this.rsu,
    required this.toleransi,
    required this.batasKeterimaan,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'location': location,
    'localLightingData': localLightingData,
    'average': average,
    'standardDeviation': standardDeviation,
    'upresisi': upresisi,
    'ukalibrasi': ukalibrasi,
    'ugabungan': ugabungan,
    'u95': u95,
    'ketidakpastian': ketidakpastian,
    'rsu': rsu,
    'toleransi': toleransi,
    'batasKeterimaan': batasKeterimaan,
    'time': DateTimeUtils.format(time),
  };

  static ResultPenerangan fromJson(Map<String, dynamic> json) {
    return ResultPenerangan(
      id: json['id'],
      location: json['location'],
      localLightingData: json['localLightingData'],
      average: double.parse(json['average'].toString()),
      standardDeviation: double.parse(json['standarDeviasi'].toString()),
      upresisi: double.parse(json['Upresisi'].toString()),
      ukalibrasi: double.parse(json['Ukalibrasi'].toString()),
      ugabungan: double.parse(json['Ugabungan'].toString()),
      u95: double.parse(json['U95'].toString()),
      ketidakpastian: double.parse(json['ketidakpastian'].toString()),
      rsu: double.parse(json['RSU'].toString()),
      toleransi: double.parse(json['toleransi'].toString()),
      batasKeterimaan: double.parse(json['batasKeterimaan'].toString()),
      time: DateTime.parse(json['time']).toLocal(),
    );
  }
}