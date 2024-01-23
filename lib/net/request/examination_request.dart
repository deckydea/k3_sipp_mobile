import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class QueryExaminationsTypeRequest extends MasterMessage {
  QueryExaminationsTypeRequest({required super.token})
      : super(request: MasterRequestType.queryTypeExaminations, content: null, path: "examinations/query-examinationtype");
}
