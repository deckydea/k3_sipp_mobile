import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

enum BagianTubuh { seluruhTubuhUmum, seluruhTubuhKhusus, anggotaGerak, peralatanMedis }

extension BagianTubuhExtension on BagianTubuh {
  String get label {
    switch (this) {
      case BagianTubuh.seluruhTubuhUmum:
        return "Seluruh tubuh (tempat kerja umum)";
      case BagianTubuh.seluruhTubuhKhusus:
        return "Seluruh tubuh (pekerja khusus dan lingkungan kerja yang terkendali)";
      case BagianTubuh.anggotaGerak:
        return "Anggota gerak (Limbs)";
      case BagianTubuh.peralatanMedis:
        return "Pengguna peralatan medis elektronik ";
      default:
        return "-";
    }
  }

  double get nab {
    switch (this) {
      case BagianTubuh.seluruhTubuhUmum:
        return 2;
      case BagianTubuh.seluruhTubuhKhusus:
        return 8;
      case BagianTubuh.anggotaGerak:
        return 20;
      case BagianTubuh.peralatanMedis:
        return 0.5;
      default:
        return 0;
    }
  }
}

class ResultElektromagnetic {
  final int? id;
  final DateTime time;
  final String location;
  final double dl;
  final double mikro;
  final double mili;
  final int jumlahTK;
  final BagianTubuh bagianTubuh;
  final String? note;
  final DeviceCalibration? deviceCalibration;

  ResultElektromagnetic({
    this.id,
    required this.time,
    required this.location,
    required this.dl,
    required this.mikro,
    required this.mili,
    required this.jumlahTK,
    required this.bagianTubuh,
    this.note,
    this.deviceCalibration,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': DateTimeUtils.format(time),
        'location': location,
        'dl': dl,
        'mikro': mikro,
        'mili': mili,
        'jumlahTK': jumlahTK,
        'bagianTubuh': bagianTubuh.name,
        'note': note,
        'deviceCalibrations': deviceCalibration,
      };

  factory ResultElektromagnetic.fromJson(Map<String, dynamic> json) {
    return ResultElektromagnetic(
      id: json['id'],
      time: DateTime.parse(json['time']).toLocal(),
      location: json['location'],
      dl: double.parse(json['dl'].toString()),
      mikro: double.parse(json['mikro'].toString()),
      mili: double.parse(json['mili'].toString()),
      jumlahTK: json['jumlahTK'],
      bagianTubuh: BagianTubuh.values.firstWhere((element) => element.name == json['bagianTubuh']),
      note: json['note'],
      deviceCalibration: json['deviceCalibration'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibration']),
    );
  }
}