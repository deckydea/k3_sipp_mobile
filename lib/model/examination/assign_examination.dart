import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class AssignExamination {
  final int templateId;
  final int examinationId;
  final int? userId;
  final DateTime? implementationTimeStart;
  final DateTime? implementationTimeEnd;
  final String? lokasi;

  AssignExamination({
    required this.templateId,
    required this.examinationId,
    this.userId,
    this.implementationTimeStart,
    this.implementationTimeEnd,
    this.lokasi,
  });

  Map<String, dynamic> toJson() => {
        'templateId': templateId,
        'examinationId': examinationId,
        'userId': userId,
        "implementationTimeStart": implementationTimeStart == null ? null : DateTimeUtils.format(implementationTimeStart!),
        "implementationTimeEnd": implementationTimeEnd == null ? null : DateTimeUtils.format(implementationTimeEnd!),
        'lokasi': lokasi,
      };

  static AssignExamination fromJson(Map<String, dynamic> json) {
    return AssignExamination(
      templateId: json['templateId'],
      examinationId: json['examinationId'],
      userId: json['userId'],
      implementationTimeStart:
          json['implementationTimeStart'] == null ? null : DateTime.parse(json['implementationTimeStart']).toLocal(),
      implementationTimeEnd:
          json['implementationTimeEnd'] == null ? null : DateTime.parse(json['implementationTimeEnd']).toLocal(),
      lokasi: json['lokasi'],
    );
  }
}
