
import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class CompanyFilter extends ReportFilter{
  String? query;

  CompanyFilter({
    this.query,
    super.startDate,
    super.endDate,
    super.upperBound, //the last queried epoch
    super.resultSize,
  });

  @override
  Map<String, dynamic> toJson() => {
    if (query != null) 'query': query,

    //Parent
    if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
    if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
    'upperBound': upperBound,
    'resultSize': resultSize,
  };

  factory CompanyFilter.fromJson(Map<String, dynamic> json) {
    return CompanyFilter(
      query: json['query'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBound: json['upperBound'],
      resultSize: json['resultSize'],
    );
  }
}