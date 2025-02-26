import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_iklim_kerja.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ResultIklimKerja {
  final int id;
  final String location;
  final double average;
  final double standarDeviasi;
  final double upresisi;
  final double ukalibrasi;
  final double ubias;
  final double ugabungan;
  final double u95;
  final DateTime time;
  final int jumlahTK;
  final String pengendalian;
  final int durasi;
  final double ta1;
  final double ta2;
  final double ta3;
  final double ta4;
  final double ta5;
  final double ta6;
  final double tw1;
  final double tw2;
  final double tw3;
  final double tw4;
  final double tw5;
  final double tw6;
  final double tg1;
  final double tg2;
  final double tg3;
  final double tg4;
  final double tg5;
  final double tg6;
  final double rh1;
  final double rh2;
  final double rh3;
  final double rh4;
  final double rh5;
  final double rh6;
  final double isbb1;
  final double isbb2;
  final double isbb3;
  final double isbb4;
  final double isbb5;
  final double isbb6;
  final LajuMetabolit lajuMetabolit;
  final SiklusKerja siklusKerja;
  final DeviceCalibration? deviceCalibrationTW;
  final DeviceCalibration? deviceCalibrationTG;
  final DeviceCalibration? deviceCalibrationISBB;

  //For request update purpose only
  final bool isUpdate;

  ResultIklimKerja({
    required this.id,
    required this.location,
    required this.average,
    required this.standarDeviasi,
    required this.upresisi,
    required this.ukalibrasi,
    required this.ubias,
    required this.ugabungan,
    required this.u95,
    required this.time,
    required this.jumlahTK,
    required this.pengendalian,
    required this.durasi,
    required this.ta1,
    required this.ta2,
    required this.ta3,
    required this.ta4,
    required this.ta5,
    required this.ta6,
    required this.tw1,
    required this.tw2,
    required this.tw3,
    required this.tw4,
    required this.tw5,
    required this.tw6,
    required this.tg1,
    required this.tg2,
    required this.tg3,
    required this.tg4,
    required this.tg5,
    required this.tg6,
    required this.rh1,
    required this.rh2,
    required this.rh3,
    required this.rh4,
    required this.rh5,
    required this.rh6,
    required this.isbb1,
    required this.isbb2,
    required this.isbb3,
    required this.isbb4,
    required this.isbb5,
    required this.isbb6,
    required this.lajuMetabolit,
    required this.siklusKerja,
    this.deviceCalibrationTW,
    this.deviceCalibrationTG,
    this.deviceCalibrationISBB,
    this.isUpdate = false,
  });

  double get averageTA => (ta1 + ta2 + ta3 + ta4 + ta5 + ta6) / 6;

  double get averageTG => (tg1 + tg2 + tg3 + tg4 + tg5 + tg6) / 6;

  double get averageTW => (tw1 + tw2 + tw3 + tw4 + tw5 + tw6) / 6;

  double get averageRH => (rh1 + rh2 + rh3 + rh4 + rh5 + rh6) / 6;

  double get averageISBB => (isbb1 + isbb2 + isbb3 + isbb4 + isbb5 + isbb6) / 6;

  double get nab {
    switch (siklusKerja) {
      case SiklusKerja.siklus_75_100:
        switch (lajuMetabolit) {
          case LajuMetabolit.rendah:
            return 31.0;
          case LajuMetabolit.sedang:
            return 28.0;
          case LajuMetabolit.berat:
            return 0;
          case LajuMetabolit.sangatBerat:
            return 0;
        }
      case SiklusKerja.siklus_50_75:
        switch (lajuMetabolit) {
          case LajuMetabolit.rendah:
            return 31.0;
          case LajuMetabolit.sedang:
            return 29.0;
          case LajuMetabolit.berat:
            return 27.5;
          case LajuMetabolit.sangatBerat:
            return 0;
        }
      case SiklusKerja.siklus_25_50:
        switch (lajuMetabolit) {
          case LajuMetabolit.rendah:
            return 32.0;
          case LajuMetabolit.sedang:
            return 30.0;
          case LajuMetabolit.berat:
            return 29.0;
          case LajuMetabolit.sangatBerat:
            return 28.0;
        }
      case SiklusKerja.siklus_0_25:
        switch (lajuMetabolit) {
          case LajuMetabolit.rendah:
            return 32.5;
          case LajuMetabolit.sedang:
            return 31.5;
          case LajuMetabolit.berat:
            return 30.5;
          case LajuMetabolit.sangatBerat:
            return 30.0;
        }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        'average': average,
        'standarDeviasi': standarDeviasi,
        'Upresisi': upresisi,
        'Ubias': ubias,
        'Ukalibrasi': ukalibrasi,
        'Ugabungan': ugabungan,
        'U95': u95,
        'time': DateTimeUtils.format(time),
        'jumlahTK': jumlahTK,
        'pengendalian': pengendalian,
        'durasi': durasi,
        'ta1': ta1,
        'ta2': ta2,
        'ta3': ta3,
        'ta4': ta4,
        'ta5': ta5,
        'ta6': ta6,
        'tw1': tw1,
        'tw2': tw2,
        'tw3': tw3,
        'tw4': tw4,
        'tw5': tw5,
        'tw6': tw6,
        'tg1': tg1,
        'tg2': tg2,
        'tg3': tg3,
        'tg4': tg4,
        'tg5': tg5,
        'tg6': tg6,
        'rh1': rh1,
        'rh2': rh2,
        'rh3': rh3,
        'rh4': rh4,
        'rh5': rh5,
        'rh6': rh6,
        'isbb1': isbb1,
        'isbb2': isbb2,
        'isbb3': isbb3,
        'isbb4': isbb4,
        'isbb5': isbb5,
        'isbb6': isbb6,
        'lajuMetabolit': lajuMetabolit.name,
        'siklusKerja': siklusKerja.name,
        'deviceCalibrationTW': deviceCalibrationTW,
        'deviceCalibrationTG': deviceCalibrationTG,
        'deviceCalibrationISBB': deviceCalibrationISBB,
        'isUpdate': isUpdate,
      };

  static ResultIklimKerja fromJson(Map<String, dynamic> json) {
    return ResultIklimKerja(
      id: json['id'],
      location: json['location'],
      average: double.parse(json['average'].toString()),
      standarDeviasi: double.parse(json['standarDeviasi'].toString()),
      upresisi: double.parse(json['Upresisi'].toString()),
      ukalibrasi: double.parse(json['Ukalibrasi'].toString()),
      ubias: double.parse(json['Ubias'].toString()),
      ugabungan: double.parse(json['Ugabungan'].toString()),
      u95: double.parse(json['U95'].toString()),
      time: DateTime.parse(json['time']).toLocal(),
      jumlahTK: json['jumlahTK'],
      pengendalian: json['pengendalian'],
      durasi: json['durasi'],
      ta1: double.parse(json['ta1'].toString()),
      ta2: double.parse(json['ta2'].toString()),
      ta3: double.parse(json['ta3'].toString()),
      ta4: double.parse(json['ta4'].toString()),
      ta5: double.parse(json['ta5'].toString()),
      ta6: double.parse(json['ta6'].toString()),
      tw1: double.parse(json['tw1'].toString()),
      tw2: double.parse(json['tw2'].toString()),
      tw3: double.parse(json['tw3'].toString()),
      tw4: double.parse(json['tw4'].toString()),
      tw5: double.parse(json['tw5'].toString()),
      tw6: double.parse(json['tw6'].toString()),
      tg1: double.parse(json['tg1'].toString()),
      tg2: double.parse(json['tg2'].toString()),
      tg3: double.parse(json['tg3'].toString()),
      tg4: double.parse(json['tg4'].toString()),
      tg5: double.parse(json['tg5'].toString()),
      tg6: double.parse(json['tg6'].toString()),
      rh1: double.parse(json['rh1'].toString()),
      rh2: double.parse(json['rh2'].toString()),
      rh3: double.parse(json['rh3'].toString()),
      rh4: double.parse(json['rh4'].toString()),
      rh5: double.parse(json['rh5'].toString()),
      rh6: double.parse(json['rh6'].toString()),
      isbb1: double.parse(json['isbb1'].toString()),
      isbb2: double.parse(json['isbb2'].toString()),
      isbb3: double.parse(json['isbb3'].toString()),
      isbb4: double.parse(json['isbb4'].toString()),
      isbb5: double.parse(json['isbb5'].toString()),
      isbb6: double.parse(json['isbb6'].toString()),
      lajuMetabolit: LajuMetabolit.values.firstWhere((element) => element.name == json['lajuMetabolit']),
      siklusKerja: SiklusKerja.values.firstWhere((element) => element.name == json['siklusKerja']),
      deviceCalibrationTW: json['deviceCalibrationTW'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibrationTW']),
      deviceCalibrationTG: json['deviceCalibrationTG'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibrationTG']),
      deviceCalibrationISBB:
          json['deviceCalibrationISBB'] == null ? null : DeviceCalibration.fromJson(json['deviceCalibrationISBB']),
      isUpdate: json['isUpdate'] ?? false,
    );
  }
}
