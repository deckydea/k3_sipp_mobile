import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/template_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class TemplateDetailLogic{
  late Template template;

  bool initialized = false;

  Future<MasterMessage> onQueryTemplate(int templateId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(QueryTemplateRequest(token: token, templateId: templateId));
  }
}