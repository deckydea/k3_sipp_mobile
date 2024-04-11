import 'package:k3_sipp_mobile/model/template/template_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/template_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class AssignmentService {
  static Future<MasterMessage> queryTemplates({required DateTime date}) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(
      QueryTemplatesRequest(
        token: token,
        filter: TemplateFilter(date: date),
      ),
    );
  }
}
