import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/examination_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_form_page.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class InputFormLogic {
  InputView view = InputView.tableView;

  late Examination examination;
  bool initialized = false;

  Future<MasterMessage> loadExamination(int examinationId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(
      QueryExaminationRequest(
        token: token,
        filter: ExaminationRequest(examinationId: examinationId),
      ),
    );
  }

  Future<MasterMessage> saveInputExamination() async {
    String? token = await AppRepository().getToken();

    MasterMessage message;
    switch (examination.typeOfExaminationName) {
      case ExaminationTypeName.kebisingan:
        message = SaveExaminationKebisinganLKRequest(
          token: token,
          inputKebisinganLK: InputKebisinganLK(examinationId: examination.id!, dataKebisinganLK: examination.userInput),
        );
        break;
      case ExaminationTypeName.penerangan:
        message = SaveExaminationPeneranganRequest(
          token: token,
          inputPenerangan: InputPenerangan(examinationId: examination.id!, dataPenerangan: examination.userInput),
        );
        break;
      default:
        message = MasterMessage(response: MasterResponseType.invalidRequest);
    }
    return await ConnectionUtils.sendRequest(message);
  }

  Future<MasterMessage> submitInputExamination() async {
    String? token = await AppRepository().getToken();

    MasterMessage message;
    switch (examination.typeOfExaminationName) {
      case ExaminationTypeName.kebisingan:
        message = SubmitExaminationKebisinganLKRequest(
          token: token,
          inputKebisinganLK: InputKebisinganLK(examinationId: examination.id!, dataKebisinganLK: examination.userInput),
        );
        break;
      case ExaminationTypeName.penerangan:
        message = SubmitExaminationPeneranganRequest(
          token: token,
          inputPenerangan: InputPenerangan(examinationId: examination.id!, dataPenerangan: examination.userInput),
        );
        break;
      default:
        message = MasterMessage(response: MasterResponseType.invalidRequest);
    }
    return await ConnectionUtils.sendRequest(message);
  }

  Future<MasterMessage> approvalExamination({required bool approved}) async {
    String? token = await AppRepository().getToken();

    MasterMessage? message;
    if (examination.status == ExaminationStatus.PENDING_APPROVE_QC1) {
      message = ApprovalQC1ExaminationRequest(
        token: token,
        approvalExaminationRequest: ApprovalExaminationRequest(
          examinationId: examination.id!,
          isUpdate: false,
          approved: approved,
          status: examination.status!,
        ),
      );
    } else if (examination.status == ExaminationStatus.PENDING_APPROVE_QC2 ||
        examination.status == ExaminationStatus.REJECT_SIGNED) {
      message = ApprovalQC2ExaminationRequest(
        token: token,
        approvalExaminationRequest: ApprovalExaminationRequest(
          examinationId: examination.id!,
          isUpdate: false,
          approved: approved,
          status: examination.status!,
        ),
      );
    } else if (examination.status == ExaminationStatus.PENDING_SIGNED) {
      message = ApprovalSignedExaminationRequest(
        token: token,
        approvalExaminationRequest: ApprovalExaminationRequest(
          examinationId: examination.id!,
          isUpdate: false,
          approved: approved,
          status: examination.status!,
        ),
      );
    }

    if (message == null) return MasterMessage(response: MasterResponseType.invalidFormat);

    return await ConnectionUtils.sendRequest(message);
  }

  Future<MasterMessage> submitRevisionExamination() async {
    String? token = await AppRepository().getToken();

    MasterMessage message = SubmitRevisionExaminationRequest(token: token, examination: examination);
    return await ConnectionUtils.sendRequest(message);
  }
}
