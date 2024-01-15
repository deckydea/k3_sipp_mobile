import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/report/report_filter.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class TemplateFilter extends ReportFilter {
  String? templateName;
  int? companyId;
  String? companyName;
  String? companyAddress;
  int? petugasId;
  int? analisId;
  String? metode;
  int? typeOfExaminationId;
  ExaminationStatus? status;

  // Constructor
  TemplateFilter({
    this.templateName,
    this.companyId,
    this.companyName,
    this.companyAddress,
    this.petugasId,
    this.analisId,
    this.metode,
    this.typeOfExaminationId,
    this.status,
    super.startDate,
    super.endDate,
    super.resultSize,
    super.upperBoundEpoch,
  });

  // toJson method
  @override
  Map<String, dynamic> toJson() => {
        if (templateName != null) 'templateName': templateName,
        if (companyId != null) 'companyId': companyId,
        if (companyName != null) 'companyName': companyName,
        if (companyAddress != null) 'companyAddress': companyAddress,
        if (petugasId != null) 'petugasId': petugasId,
        if (analisId != null) 'analisId': analisId,
        if (metode != null) 'metode': metode,
        if (typeOfExaminationId != null) 'typeOfExaminationId': typeOfExaminationId,
        if (status != null) 'status': EnumToString.convertToString(status),

        //Parent
        if (startDate != null) 'startDate': DateTimeUtils.format(startDate!),
        if (endDate != null) 'endDate': DateTimeUtils.format(endDate!),
        if (upperBoundEpoch != null) 'upperBoundEpoch': upperBoundEpoch,
        if (resultSize != null) 'resultSize': resultSize,
      };

  // fromJson method
  factory TemplateFilter.fromJson(Map<String, dynamic> json) {
    return TemplateFilter(
      templateName: json['templateName'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyAddress: json['companyAddress'],
      petugasId: json['petugasId'],
      analisId: json['analisId'],
      metode: json['metode'],
      typeOfExaminationId: json['typeOfExaminationId'],
      status: ExaminationStatus.values.firstWhere((element) => element.name == json['status']),

      //Parent
      startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']).toLocal(),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']).toLocal(),
      resultSize: json['resultSize'],
      upperBoundEpoch: json['upperBoundEpoch'],
    );
  }
}
