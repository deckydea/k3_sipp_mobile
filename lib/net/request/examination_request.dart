import 'dart:convert';

import 'package:k3_sipp_mobile/model/assignment/assignment_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class QueryExaminationsTypeRequest extends MasterMessage {
  QueryExaminationsTypeRequest({required super.token})
      : super(request: MasterRequestType.queryTypeExaminations, content: null, path: "examinations/query-examinationtype");
}

class QueryExaminationsRequest extends MasterMessage {
  QueryExaminationsRequest({required super.token, required AssignmentFilter filter})
      : super(request: MasterRequestType.queryExaminations, content: jsonEncode(filter), path: "examinations/query-examinations");
}

