import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class ReportFilter {
  DateTime? startDate;
  DateTime? endDate;
  int? upperBoundEpoch; //the last queried epoch
  int? resultSize;

  ReportFilter({
    this.startDate,
    this.endDate,
    this.upperBoundEpoch,
    this.resultSize,
  });

  Map<String, dynamic> toJson() => {
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        if (upperBoundEpoch != null) 'upperBoundEpoch': upperBoundEpoch,
        if (resultSize != null) 'resultSize': resultSize,
      };

  factory ReportFilter.fromJson(Map<String, dynamic> json) {
    return ReportFilter(
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBoundEpoch: json['upperBoundEpoch'],
      resultSize: json['resultSize'],
    );
  }
}
