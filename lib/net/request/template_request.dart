import 'dart:convert';

import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/template/template_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class TemplateRequest {
  final int id;

  TemplateRequest({required this.id});

  Map<String, dynamic> toJson() => {'id': id};

  factory TemplateRequest.fromJson(Map<String, dynamic> json) {
    return TemplateRequest(id: json['id']);
  }
}

class ManagementTemplateRequest extends MasterMessage {
  ManagementTemplateRequest({required super.token, required Template template})
      : super(request: MasterRequestType.managementTemplate, content: jsonEncode(template), path: "templates/create-template");
}

class QueryTemplatesRequest extends MasterMessage {
  QueryTemplatesRequest({required super.token, required TemplateFilter filter})
: super(request: MasterRequestType.queryTemplates, content: jsonEncode(filter), path: "templates/query-templates");
}

class QueryTemplateRequest extends MasterMessage {
  QueryTemplateRequest({required super.token, required int templateId})
      : super(request: MasterRequestType.queryTemplate, content: jsonEncode(TemplateRequest(id: templateId)), path: "templates/query-template");
}
