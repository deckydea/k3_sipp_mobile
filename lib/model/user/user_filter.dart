import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class UserFilter extends ReportFilter {
  String? query;
  int? userGroupId;

  UserFilter({
    this.query = "",
    this.userGroupId,
    super.startDate,
    super.endDate,
    super.upperBoundEpoch, //the last queried epoch
    super.resultSize,
  });

  @override
  Map<String, dynamic> toJson() => {
        'query': query,
        if (userGroupId != null) 'userGroupId': userGroupId,

        //Parent
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        'upperBoundEpoch': upperBoundEpoch,
        'resultSize': resultSize,
      };

  factory UserFilter.fromJson(Map<String, dynamic> json) {
    return UserFilter(
      query: json['query'],
      userGroupId: json['userGroupId'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBoundEpoch: json['upperBoundEpoch'],
      resultSize: json['resultSize'],
    );
  }
}
