import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class AssignmentFilter extends ReportFilter{
  Set<ExaminationStatus>? statuses;
  DateTime? date;
  int? petugasId;
  int? analisId;

  AssignmentFilter({
    this.statuses,
    this.date,
    this.petugasId,
    this.analisId,
    super.startDate,
    super.endDate,
    super.resultSize,
    super.upperBound,
  });

  @override
  Map<String, dynamic> toJson() => {
    if (statuses != null) "statuses": statuses!.map((element) => EnumToString.convertToString(element)).toList(),
    if (date != null) 'date': DateTimeUtils.formatToISODate(date!),
    if (petugasId != null) 'petugasId': petugasId,
    if (analisId != null) 'analisId': analisId,

    //Parent
    if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
    if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
    if (upperBound != null) 'upperBound': upperBound,
    if (resultSize != null) 'resultSize': resultSize,
  };

  factory AssignmentFilter.fromJson(Map<String, dynamic> json) {
    Set<ExaminationStatus>? statuses;
    if (json["statuses"] != null) {
      statuses = {};
      Iterable iterable = json["statuses"];
      for (var element in iterable) {
        for (ExaminationStatus status in ExaminationStatus.values) {
          if (status.name == element) {
            statuses.add(status);
            break;
          }
        }
      }
    }
    return AssignmentFilter(
      statuses: statuses,
      date: json['date'] == null ? null : DateTime.parse(json['date']).toLocal(),
      petugasId: json['petugasId'],
      analisId: json['analisId'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      resultSize: json['resultSize'],
      upperBound: json['upperBound'],
    );
  }
}