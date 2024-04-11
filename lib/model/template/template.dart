import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/user/petugas.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';

class Template {
  static Comparator<Template> get registerDateComparator => (a, b) {
        return b.createdAt!.compareTo(a.createdAt!);
      };

  int? id;
  String? templateName;
  DateTime? deadlineDate;
  Company company;
  List<Petugas> petugas;
  List<Examination> examinations;

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
    this.deadlineDate,
    required this.company,
    required this.petugas,
    required this.examinations,
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
    for (var element in examinations) {
      examinationsReplica.add(element.replica());
    }

    List<Petugas> petugasIdReplica = [];
    for (var element in petugas) {
      petugasIdReplica.add(element);
    }

    return Template(
      id: id,
      templateName: templateName,
      deadlineDate: deadlineDate,
      company: company.replica(),
      petugas: petugasIdReplica,
      examinations: examinationsReplica,
      createdById: createdById,
      createdByName: createdByName,
      updateById: updateById,
      updateByName: updateByName,
      createdAt: createdAt,
      updateAt: updateAt,
    );
  }

  List<User> get getPetugasUsers {
    List<User> users = [];
    for(Petugas petugas in petugas){
      if(petugas.user != null)users.add(petugas.user!);
    }

    return users;
  }

  // Convert the template to a JSON map
  Map<String, dynamic> toJson() => {
        'id': id,
        'templateName': templateName,
        'deadlineDate': deadlineDate == null ? null : DateTimeUtils.format(deadlineDate!),
        'company': company,
        'petugas': petugas.toList(),
        'examinations': examinations.toList(),
        'createdById': createdById,
        'createdByName': createdByName,
        'updateById': updateById,
        'updateByName': updateByName,
        'createdAt': createdAt == null ? null : DateTimeUtils.format(createdAt!),
        'updatedAt': updateAt == null ? null : DateTimeUtils.format(updateAt!),
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

    List<Petugas> petugas = [];
    if(json["petugasTemplates"] != null){
      Iterable iterable = json["petugasTemplates"];
      for (var element in iterable) {
        petugas.add(Petugas.fromJson(element));
      }
    }

    return Template(
      id: json['id'],
      templateName: json['templateName'],
      deadlineDate: json['deadlineDate'] == null ? null : DateTime.parse(json['deadlineDate']).toLocal(),
      company: Company.fromJson(json['company']),
      petugas: petugas,
      examinations: examinations,
      createdById: json['createdBy'],
      createdByName: json['createdByName'],
      updateById: json['updateBy'],
      updateByName: json['updateByName'],
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']).toLocal(),
      updateAt: json['updateAt'] == null ? null : DateTime.parse(json['updateAt']).toLocal(),
    );
  }

  @override
  String toString() {
    return 'Template{id: $id, templateName: $templateName, deadlineDate: $deadlineDate, company: $company, petugas: $petugas, examinations: $examinations, createdById: $createdById, createdByName: $createdByName, updateById: $updateById, updateByName: $updateByName, createdAt: $createdAt, updateAt: $updateAt}';
  }
}
