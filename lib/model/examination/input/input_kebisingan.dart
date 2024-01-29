import 'package:equatable/equatable.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class DataKebisinganLK extends Equatable {
  final int? id;
  final String location;
  final DateTime? time;
  final String value1;
  final String value2;
  final String value3;
  final String? note;

  //For request update purpose only
  final bool isUpdate;

  const DataKebisinganLK({
    this.id,
    required this.location,
    this.time,
    required this.value1,
    required this.value2,
    required this.value3,
    this.note,
    this.isUpdate = false,
  });

  DataKebisinganLK copyWith({
    int? id,
    String? location,
    DateTime? time,
    String? value1,
    String? value2,
    String? value3,
    String? note,
  }) =>
      DataKebisinganLK(
        id: id ?? this.id,
        location: location ?? this.location,
        time: time ?? this.time,
        value1: value1 ?? this.value1,
        value2: value2 ?? this.value2,
        value3: value3 ?? this.value3,
      );

  DataKebisinganLK replica() {
    return DataKebisinganLK(
      id: id,
      location: location,
      time: time,
      value1: value1,
      value2: value2,
      value3: value3,
      note: note,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        if (time != null) 'time': DateTimeUtils.format(time!),
        'value1': value1,
        'value2': value2,
        'value3': value3,
        'note': note,
        'isUpdate': isUpdate,
      };

  factory DataKebisinganLK.fromJson(Map<String, dynamic> json) {
    return DataKebisinganLK(
      id: json['id'],
      location: json['location'],
      time: json['time'] == null ? null : DateTime.parse(json['time']).toLocal(),
      value1: json['value1'],
      value2: json['value2'],
      value3: json['value3'],
      note: json['note'],
      isUpdate: json['isUpdate'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, location, time, value1, value2, value3, note, isUpdate];
}

class InputKebisinganLK {
  int examinationId;
  List<DataKebisinganLK> dataKebisinganLK;

  InputKebisinganLK({required this.examinationId, required this.dataKebisinganLK});

  InputKebisinganLK replica() {
    List<DataKebisinganLK> dataKebisinganReplica = [];
    for (var element in dataKebisinganLK) {
      dataKebisinganReplica.add(element.replica());
    }

    return InputKebisinganLK(
      examinationId: examinationId,
      dataKebisinganLK: dataKebisinganReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        'examinationId': examinationId,
        'dataKebisinganLK': dataKebisinganLK.toList(),
      };

  factory InputKebisinganLK.fromJson(Map<String, dynamic> json) {
    List<DataKebisinganLK> dataKebisinganLK = [];
    if (json["dataKebisinganLK"] != null) {
      Iterable iterable = json["dataKebisinganLK"];
      for (var data in iterable) {
        dataKebisinganLK.add(DataKebisinganLK.fromJson(data));
      }
    }
    return InputKebisinganLK(
      examinationId: json['examinationId'],
      dataKebisinganLK: dataKebisinganLK,
    );
  }
}
