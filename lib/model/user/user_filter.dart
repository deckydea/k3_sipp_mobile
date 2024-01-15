import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class UserFilter extends ReportFilter {
  String? email;
  String? username;
  String? name;
  String? nip;
  DateTime? dateOfBirth;
  int? userGroup;

  // Constructor
  UserFilter({
    this.email,
    this.username,
    this.name,
    this.nip,
    this.dateOfBirth,
    this.userGroup,
    super.startDate,
    super.endDate,
    super.upperBoundEpoch, //the last queried epoch
    super.resultSize,
  });

  // toJson method
  @override
  Map<String, dynamic> toJson() => {
        if (email != null) 'email': email,
        if (username != null) 'username': username,
        if (name != null) 'name': name,
        if (nip != null) 'nip': nip,
        if (dateOfBirth != null) 'dateOfBirth': DateTimeUtils.format(dateOfBirth!),
        if (userGroup != null) 'userGroup': userGroup,

        //Parent
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        if (upperBoundEpoch != null) 'upperBoundEpoch': upperBoundEpoch,
        if (resultSize != null) 'resultSize': resultSize,
      };

  // fromJson method
  factory UserFilter.fromJson(Map<String, dynamic> json) {
    return UserFilter(
      email: json['email'],
      username: json['username'],
      name: json['name'],
      nip: json['nip'],
      dateOfBirth: json['dateOfBirth'] == null ? null : DateTime.parse(json['dateOfBirth']).toLocal(),
      userGroup: json['userGroup'],

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      upperBoundEpoch: json['upperBoundEpoch'],
      resultSize: json['resultSize'],
    );
  }
}
