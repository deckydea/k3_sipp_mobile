import 'dart:convert';

import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/template/template_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class ManagementTemplateRequest extends MasterMessage {
  ManagementTemplateRequest({required super.token, required Template template})
      : super(request: MasterRequestType.managementTemplate, content: jsonEncode(template), path: "templates/create-template");
}

class QueryTemplatesRequest extends MasterMessage {
  QueryTemplatesRequest({required super.token, required TemplateFilter filter})
: super(request: MasterRequestType.queryTemplates, content: null, path: "templates/query-templates");
}
