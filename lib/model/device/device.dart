import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class Device {
  int? id;
  String? name;
  String? description;
  double? calibrationValue;
  double? u95;
  double? coverageFactor;
  String? note;
  String? nomorSeriAlat;
  String? negaraPembuat;
  String? instansiPengkalibrasi;
  DateTime? tanggalKalibrasiEksternalTerakhir;

  Device({
    this.id,
    this.name,
    this.description,
    this.calibrationValue,
    this.u95,
    this.coverageFactor,
    this.note,
    this.nomorSeriAlat,
    this.negaraPembuat,
    this.instansiPengkalibrasi,
    this.tanggalKalibrasiEksternalTerakhir,
  });

  // Create a replica (clone) of the Tool instance
  Device get replica => Device(
        id: id,
        name: name,
        description: description,
        calibrationValue: calibrationValue,
        u95: u95,
        coverageFactor: coverageFactor,
        note: note,
        nomorSeriAlat: nomorSeriAlat,
        negaraPembuat: negaraPembuat,
        instansiPengkalibrasi: instansiPengkalibrasi,
        tanggalKalibrasiEksternalTerakhir: tanggalKalibrasiEksternalTerakhir,
      );

  // Convert a Tool instance to a JSON object
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'calibrationValue': calibrationValue,
        'u95': u95,
        'coverageFactor': coverageFactor,
        'note': note,
        'nomorSeriAlat': nomorSeriAlat,
        'negaraPembuat': negaraPembuat,
        'instansiPengkalibrasi': instansiPengkalibrasi,
        'tanggalKalibrasiEksternalTerakhir':
            tanggalKalibrasiEksternalTerakhir == null ? null : DateTimeUtils.format(tanggalKalibrasiEksternalTerakhir!),
      };

  // Create a Tool instance from a JSON object
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      calibrationValue: json['calibrationValue']?.toDouble(),
      u95: json['u95']?.toDouble(),
      coverageFactor: json['coverageFactor']?.toDouble(),
      note: json['note'],
      nomorSeriAlat: json['nomorSeriAlat'],
      negaraPembuat: json['negaraPembuat'],
      instansiPengkalibrasi: json['instansiPengkalibrasi'],
      tanggalKalibrasiEksternalTerakhir: json['tanggalKalibrasiEksternalTerakhir'] == null
          ? null
          : DateTime.parse(json['tanggalKalibrasiEksternalTerakhir']).toLocal(),
    );
  }
}
