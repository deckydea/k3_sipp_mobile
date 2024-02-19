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
  });

  Map<String, dynamic> toJson() => {
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
      };

  static ResultKebisinganLK fromJson(Map<String, dynamic> json) {
    print("json: $json");
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
      time: DateTime.parse(json['time']).toLocal(),
    );
  }
}
