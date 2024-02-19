import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class TemplateFilter extends ReportFilter {
  String? query;
  int? companyId;

  TemplateFilter({
    this.query,
    this.companyId,
    super.startDate,
    super.endDate,
    super.resultSize,
    super.upperBound,
  });

  @override
  Map<String, dynamic> toJson() => {
        'query': query,
        'companyId': companyId,

        //Parent
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        if (upperBound != null) 'upperBound': DateTimeUtils.format(upperBound!),
        'resultSize': resultSize,
      };

  factory TemplateFilter.fromJson(Map<String, dynamic> json) {
    return TemplateFilter(
      query: json['query'],
      companyId: json['companyId'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      resultSize: json['resultSize'],
      upperBound: json['upperBound'] == null ? null : DateTime.parse(json['upperBound']).toLocal(),
    );
  }
}
