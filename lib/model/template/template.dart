import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class Template {
  int? id;
  String? templateName;
  Company? company;
  List<Examination>? examinations;

  //Not implemented
  int? createdById;
  String? createdByName;
  int? updateById;
  String? updateByName;
  DateTime? createdAt;
  DateTime? updateAt;

  Template({
    this.id,
    this.templateName,
    this.company,
    this.examinations,
    this.createdById,
    this.createdByName,
    this.updateById,
    this.updateByName,
    this.createdAt,
    this.updateAt,
  });

  // Create a replica of the template
  Template replica() {
    List<Examination> examinationsReplica = [];
    if (examinations != null) {
      examinations?.forEach((element) => examinationsReplica.add(element.replica()));
    }

    return Template(
      id: id,
      templateName: templateName,
      company: company?.replica(),
      examinations: examinationsReplica,
      createdById: createdById,
      createdByName: createdByName,
      updateById: updateById,
      updateByName: updateByName,
      createdAt: createdAt,
      updateAt: updateAt,
    );
  }

  // Convert the template to a JSON map
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (templateName != null) 'templateName': templateName,
        if (company != null) 'company': company,
        if (examinations != null) 'examinations': examinations!.toList(),
        if (createdById != null) 'createdById': createdById,
        if (createdByName != null) 'createdByName': createdByName,
        if (updateById != null) 'updateById': updateById,
        if (updateByName != null) 'updateByName': updateByName,
        if (createdAt != null) 'createdAt': DateTimeUtils.format(createdAt!),
        if (updateAt != null) 'updatedAt': DateTimeUtils.format(updateAt!),
      };

  // Create a template from a JSON map
  factory Template.fromJson(Map<String, dynamic> json) {
    List<Examination> examinations = [];
    if (json["examinations"] != null) {
      Iterable iterable = json["examinations"];
      for (var examination in iterable) {
        examinations.add(Examination.fromJson(examination));
      }
    }

    return Template(
      id: json['id'],
      templateName: json['templateName'],
      company: Company.fromJson(json['company']),
      examinations: examinations,
      createdById: json['createdById'],
      createdByName: json['createdByName'],
      updateById: json['updateById'],
      updateByName: json['updateByName'],
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']).toLocal(),
      updateAt: json['updateAt'] == null ? null : DateTime.parse(json['updateAt']).toLocal(),
    );
  }
}
