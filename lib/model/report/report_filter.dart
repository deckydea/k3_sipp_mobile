import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ReportFilter {
  DateTime? startDate;
  DateTime? endDate;
  DateTime? upperBound; //the last queried epoch
  int? resultSize;

  ReportFilter({
    this.startDate,
    this.endDate,
    this.upperBound,
    this.resultSize,
  });

  Map<String, dynamic> toJson() => {
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        if (upperBound != null) 'upperBound': DateTimeUtils.format(upperBound!),
        if (resultSize != null) 'resultSize': resultSize,
      };

  factory ReportFilter.fromJson(Map<String, dynamic> json) {
    return ReportFilter(
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBound: json['upperBound'] == null ? null : DateTime.parse(json['upperBound']).toLocal(),
      resultSize: json['resultSize'],
    );
  }
}
