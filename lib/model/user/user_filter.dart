import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class UserFilter extends ReportFilter {
  String? query;
  String? userAccessMenu;

  UserFilter({
    this.query = "",
    this.userAccessMenu,
    super.startDate,
    super.endDate,
    super.upperBoundEpoch, //the last queried epoch
    super.resultSize,
  });

  @override
  Map<String, dynamic> toJson() => {
        'query': query,
        'userAccessMenu': userAccessMenu,

        //Parent
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        'upperBoundEpoch': upperBoundEpoch,
        'resultSize': resultSize,
      };

  factory UserFilter.fromJson(Map<String, dynamic> json) {
    return UserFilter(
      query: json['query'],
      userAccessMenu: json['userAccessMenu'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBoundEpoch: json['upperBoundEpoch'],
      resultSize: json['resultSize'],
    );
  }
}
