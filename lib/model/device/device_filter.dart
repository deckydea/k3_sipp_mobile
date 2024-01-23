
import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class DeviceFilter extends ReportFilter{
  String? name;

  DeviceFilter({
    this.name,
    super.startDate,
    super.endDate,
    super.upperBoundEpoch, //the last queried epoch
    super.resultSize,
  });

  @override
  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,

    //Parent
    if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
    if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
    'upperBoundEpoch': upperBoundEpoch,
    'resultSize': resultSize,
  };

  factory DeviceFilter.fromJson(Map<String, dynamic> json) {
    return DeviceFilter(
      name: json['name'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBoundEpoch: json['upperBoundEpoch'],
      resultSize: json['resultSize'],
    );
  }
}