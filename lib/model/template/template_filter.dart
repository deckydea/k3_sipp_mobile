import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class TemplateFilter extends ReportFilter {
  String? query;
  int? companyId;
  int? petugasId;
  int? analisId;
  String? typeOfExaminationName;
  Set<ExaminationStatus>? statuses;

  TemplateFilter({
    this.query,
    this.companyId,
    this.petugasId,
    this.analisId,
    this.typeOfExaminationName,
    this.statuses,
    super.startDate,
    super.endDate,
    super.resultSize,
    super.upperBoundEpoch,
  });

  @override
  Map<String, dynamic> toJson() => {
        if (query != null) 'query': query,
        if (companyId != null) 'companyId': companyId,
        if (petugasId != null) 'petugasId': petugasId,
        if (analisId != null) 'analisId': analisId,
        if (typeOfExaminationName != null) 'typeOfExaminationName': typeOfExaminationName,
        if (statuses != null) "statuses": statuses!.map((element) => EnumToString.convertToString(element)).toList(),

        //Parent
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        if (upperBoundEpoch != null) 'upperBoundEpoch': upperBoundEpoch,
        if (resultSize != null) 'resultSize': resultSize,
      };

  factory TemplateFilter.fromJson(Map<String, dynamic> json) {
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
    return TemplateFilter(
      query: json['query'],
      companyId: json['companyId'],
      petugasId: json['petugasId'],
      analisId: json['analisId'],
      typeOfExaminationName: json['typeOfExaminationName'],
      statuses: statuses,

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      resultSize: json['resultSize'],
      upperBoundEpoch: json['upperBoundEpoch'],
    );
  }
}
