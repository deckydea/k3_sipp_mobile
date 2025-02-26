
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_hand_arm.dart';

class ResultHandArm {
  final int id;
  final String location;
  final String time;
  final double dominan1;
  final double dominan2;
  final double dominan3;
  final double average;
  final double standarDeviasi;
  final double upresisi;
  final double ukalibrasi;
  final double ugabungan;
  final double u95;
  final double laporanMSrerata;
  final double laporanMSU95;
  final double rsu;
  final double averageX;
  final double averageY;
  final double averageZ;
  final double averageDominan;
  final String toleransi;
  final String batasKeterimaan;
  final int jumlahTK;
  final String name;
  final String nik;
  final String bagian;
  final Adaptor adaptor;
  final String sumberGetaran;
  final String tindakan;
  final double durasi;
  final String note;
  final DeviceCalibration deviceCalibration;

  ResultHandArm({
    required this.id,
    required this.location,
    required this.time,
    required this.dominan1,
    required this.dominan2,
    required this.dominan3,
    required this.average,
    required this.standarDeviasi,
    required this.upresisi,
    required this.ukalibrasi,
    required this.ugabungan,
    required this.u95,
    required this.laporanMSrerata,
    required this.laporanMSU95,
    required this.rsu,
    required this.averageX,
    required this.averageY,
    required this.averageZ,
    required this.averageDominan,
    required this.toleransi,
    required this.batasKeterimaan,
    required this.jumlahTK,
    required this.name,
    required this.nik,
    required this.bagian,
    required this.adaptor,
    required this.sumberGetaran,
    required this.tindakan,
    required this.durasi,
    required this.note,
    required this.deviceCalibration,
});

  double get nab {
    if(durasi >= 6 && durasi <= 8){
      return 5;
    }else if(durasi >= 4 && durasi <= 6){
      return 6;
    }else if(durasi >= 2 && durasi <= 4){
      return 7;
    }else if(durasi >= 1 && durasi <= 2){
      return 10;
    }else if(durasi >= 0.5 && durasi <= 1){
      return 14;
    }else if(durasi < 0.5){
      return 20;
    }

    return 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'location': location,
    'time': time,
    'dominan1': dominan1,
    'dominan2': dominan2,
    'dominan3': dominan3,
    'average': average,
    'standarDeviasi': standarDeviasi,
    'Upresisi': upresisi,
    'Ukalibrasi': ukalibrasi,
    'Ugabungan': ugabungan,
    'U95': u95,
    'laporanMSrerata': laporanMSrerata,
    'laporanMSU95': laporanMSU95,
    'RSU': rsu,
    'averageX': averageX,
    'averageY': averageY,
    'averageZ': averageZ,
    'averageDominan': averageDominan,
    'toleransi': toleransi,
    'batasKeterimaan': batasKeterimaan,
    'jumlahTK': jumlahTK,
    'name': name,
    'NIK': nik,
    'bagian': bagian,
    'adaptor': adaptor,
    'sumberGetaran': sumberGetaran,
    'tindakan': tindakan,
    'durasi': durasi,
    'note': note,
    'deviceCalibration': deviceCalibration,
  };

  factory ResultHandArm.fromJson(Map<String, dynamic> json) {
    return ResultHandArm(
      id: json['id'],
      location: json['location'],
      time: json['time'],
      dominan1: double.parse(json['dominan1'].toString()),
      dominan2: double.parse(json['dominan2'].toString()),
      dominan3: double.parse(json['dominan3'].toString()),
      average: double.parse(json['average'].toString()),
      standarDeviasi: double.parse(json['standarDeviasi'].toString()),
      upresisi: double.parse(json['Upresisi'].toString()),
      ukalibrasi: double.parse(json['Ukalibrasi'].toString()),
      ugabungan: double.parse(json['Ugabungan'].toString()),
      u95: double.parse(json['U95'].toString()),
      laporanMSrerata: double.parse(json['laporanMSrerata'].toString()),
      laporanMSU95: double.parse(json['laporanMSU95'].toString()),
      rsu: double.parse(json['RSU'].toString()),
      averageX: double.parse(json['averageX'].toString()),
      averageY: double.parse(json['averageY'].toString()),
      averageZ: double.parse(json['averageZ'].toString()),
      averageDominan: double.parse(json['averageDominan'].toString()),
      toleransi: json['toleransi'],
      batasKeterimaan: json['batasKeterimaan'],
      jumlahTK: json['jumlahTK'],
      name: json['name'],
      nik: json['nik'],
      bagian: json['bagian'],
      adaptor: Adaptor.values.firstWhere((element) => element.name == json['adaptor']),
      sumberGetaran: json['sumberGetaran'],
      tindakan: json['tindakan'],
      durasi: double.parse(json['durasi'].toString()),
      note: json['note'],
      deviceCalibration: DeviceCalibration.fromJson(json['deviceCalibration']),
    );
  }
}