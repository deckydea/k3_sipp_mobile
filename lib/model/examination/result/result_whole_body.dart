import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_whole_body.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ResultWholeBody {
  final int id;
  final String location;
  final DateTime time;
  final double resultanMM1;
  final double resultanMM2;
  final double resultanMM3;
  final double average;
  final double averageX;
  final double averageY;
  final double averageZ;
  final double averageResultan;
  final double standarDeviasi;
  final double upresisi;
  final double ukalibrasi;
  final double ugabungan;
  final double u95;
  final double laporanMSrerata;
  final double laporanMSU95;
  final double rsu;
  final String toleransi;
  final String batasKeterimaan;
  final int jumlahTK;
  final String name;
  final String nik;
  final String bagian;
  final PosisiPengukuran posisiPengukuran;
  final String sumberGetaran;
  final String tindakan;
  final double durasi;
  final double durasiPaparanStart;
  final double durasiPaparanEnd;
  final DeviceCalibration deviceCalibration;

  ResultWholeBody({
    required this.id,
    required this.location,
    required this.time,
    required this.resultanMM1,
    required this.resultanMM2,
    required this.resultanMM3,
    required this.average,
    required this.averageX,
    required this.averageY,
    required this.averageZ,
    required this.averageResultan,
    required this.standarDeviasi,
    required this.upresisi,
    required this.ukalibrasi,
    required this.ugabungan,
    required this.u95,
    required this.laporanMSrerata,
    required this.laporanMSU95,
    required this.rsu,
    required this.toleransi,
    required this.batasKeterimaan,
    required this.jumlahTK,
    required this.name,
    required this.nik,
    required this.bagian,
    required this.posisiPengukuran,
    required this.sumberGetaran,
    required this.tindakan,
    required this.durasi,
    required this.durasiPaparanStart,
    required this.durasiPaparanEnd,
    required this.deviceCalibration,
  });

  double get nab {
    switch (durasi) {
      case 0.5:
        return 3.4644;
      case 1:
        return 2.4497;
      case 2:
        return 1.7322;
      case 4:
        return 1.2249;
      case 8:
        return 0.8661;
    }
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        'time': DateTimeUtils.format(time),
        'resultanMM1': resultanMM1,
        'resultanMM2': resultanMM2,
        'resultanMM3': resultanMM3,
        'average': average,
        'averageX': averageX,
        'averageY': averageY,
        'averageZ': averageZ,
        'averageResultan': averageResultan,
        'standarDeviasi': standarDeviasi,
        'Upresisi': upresisi,
        'Ukalibrasi': ukalibrasi,
        'Ugabungan': ugabungan,
        'U95': u95,
        'laporanMSrerata': laporanMSrerata,
        'laporanMSU95': laporanMSU95,
        'RSU': rsu,
        'toleransi': toleransi,
        'batasKeterimaan': batasKeterimaan,
        'jumlahTK': jumlahTK,
        'name': name,
        'NIK': nik,
        'bagian': bagian,
        'posisiPengukuran': posisiPengukuran,
        'sumberGetaran': sumberGetaran,
        'tindakan': tindakan,
        'durasi': durasi,
        'durasiPaparanStart': durasiPaparanStart,
        'durasiPaparanEnd': durasiPaparanEnd,
        'deviceCalibration': deviceCalibration,
      };

  factory ResultWholeBody.fromJson(Map<String, dynamic> json) {
    return ResultWholeBody(
      id: json['id'],
      location: json['location'],
      time: DateTime.parse(json['time']).toLocal(),
      resultanMM1: double.parse(json['resultanMM1'].toString()),
      resultanMM2: double.parse(json['resultanMM2'].toString()),
      resultanMM3: double.parse(json['resultanMM3'].toString()),
      average: double.parse(json['average'].toString()),
      averageX: double.parse(json['averageX'].toString()),
      averageY: double.parse(json['averageY'].toString()),
      averageZ: double.parse(json['averageZ'].toString()),
      averageResultan: double.parse(json['averageResultanMM'].toString()),
      standarDeviasi: double.parse(json['standarDeviasi'].toString()),
      upresisi: double.parse(json['Upresisi'].toString()),
      ukalibrasi: double.parse(json['Ukalibrasi'].toString()),
      ugabungan: double.parse(json['Ugabungan'].toString()),
      u95: double.parse(json['U95'].toString()),
      laporanMSrerata: double.parse(json['laporanMSrerata'].toString()),
      laporanMSU95: double.parse(json['laporanMSU95'].toString()),
      rsu: double.parse(json['RSU'].toString()),
      toleransi: json['toleransi'],
      batasKeterimaan: json['batasKeterimaan'],
      jumlahTK: json['jumlahTK'],
      name: json['name'],
      nik: json['nik'],
      bagian: json['bagian'],
      posisiPengukuran: PosisiPengukuran.values.firstWhere((element) => element.name == json['posisiPengukuran']),
      sumberGetaran: json['sumberGetaran'],
      tindakan: json['tindakan'],
      durasi: double.parse(json['durasi'].toString()),
      durasiPaparanStart: double.parse(json['durasiPaparanStart'].toString()),
      durasiPaparanEnd: double.parse(json['durasiPaparanEnd'].toString()),
      deviceCalibration: DeviceCalibration.fromJson(json['deviceCalibration']),
    );
  }
}
