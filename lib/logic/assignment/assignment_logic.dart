import 'package:k3_sipp_mobile/model/assignment/assignment_filter.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/examination_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class AssignmentLogic {
  Future<MasterMessage> queryExaminations({required DateTime date}) async {
    String? token = await AppRepository().getToken();
    User? user = await AppRepository().getUser();
    Set<ExaminationStatus> statuses = AppRepository().getStatusesAccess();
    return await ConnectionUtils.sendRequest(
      QueryExaminationsRequest(
        token: token,
        filter: AssignmentFilter(
          date: date,
          petugasId: user!.id,
          statuses: statuses,
        ),
      ),
    );
  }
}
