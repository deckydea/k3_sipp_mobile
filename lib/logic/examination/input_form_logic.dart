import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/assign_examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_elektromagnetic.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_hand_arm.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_iklim_kerja.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_frekuensi.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_lk.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_noise_dose.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_whole_body.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/examination_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_form_page.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

enum InputStep { information, input, documents }

class InputFormLogic {
  InputView view = InputView.tableView;

  late Examination examination;
  bool initialized = false;

  //Styles
  InputStep activeStep = InputStep.information;

  //Information Page
  final GlobalKey<CustomFormInputState> formKey = GlobalKey();
  final List<DataInput> inputs = [];
  late TextInput lokasiInput;
  late TextInput pjInput;
  late DateInput dateInput;
  late TimeInput timeStartInput;
  late TimeInput timeEndInput;
  User? selectedUserPJ;

  bool informationCompleted = false;

  void initInformation(Function() onTapPJ) {
    lokasiInput = TextInput(label: "Lokasi Pemeriksaan/Pengujian");
    pjInput = TextInput(label: "Penanggungjawab", onTap: onTapPJ);
    dateInput = DateInput(label: "Tanggal Pemeriksaan");
    timeStartInput = TimeInput(label: "Start Waktu Pemeriksaan");
    timeEndInput = TimeInput(label: "Akhir Waktu Pemeriksaan");

    lokasiInput.setValue(examination.lokasi ?? "");
    dateInput.setSelectedDate(examination.implementationTimeStart);
    if (examination.implementationTimeStart != null) {
      timeStartInput.setSelectedTime(TimeOfDay.fromDateTime(examination.implementationTimeStart!));
    }

    if (examination.implementationTimeEnd != null) {
      timeEndInput.setSelectedTime(TimeOfDay.fromDateTime(examination.implementationTimeEnd!));
    }

    if (examination.petugasExaminations != null) {
      pjInput.setValue(examination.petugasExaminations!.name);
    }

    informationCompleted = !TextUtils.isEmpty(lokasiInput.value) &&
        !TextUtils.isEmpty(pjInput.value) &&
        !TextUtils.isEmpty(dateInput.value) &&
        !TextUtils.isEmpty(timeStartInput.value) &&
        !TextUtils.isEmpty(timeEndInput.value);

    inputs.clear();
    inputs.add(lokasiInput);
    inputs.add(pjInput);
    inputs.add(dateInput);
    inputs.add(timeStartInput);
    inputs.add(timeEndInput);
  }

  Future<MasterMessage> loadExamination(int examinationId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(
      QueryExaminationRequest(
        token: token,
        filter: ExaminationRequest(examinationId: examinationId),
      ),
    );
  }

  Future<MasterMessage> assignExamination() async {
    String? token = await AppRepository().getToken();

    DateTime implementationTimeStart = DateTime.now();
    DateTime implementationTimeEnd = DateTime.now();
    if (dateInput.selectedDate != null) {
      implementationTimeStart =
          DateTime(dateInput.selectedDate!.year, dateInput.selectedDate!.month, dateInput.selectedDate!.day);
    }

    if (timeStartInput.selectedTime != null) {
      implementationTimeStart = DateTime(implementationTimeStart.year, implementationTimeStart.month, implementationTimeStart.day,
          timeStartInput.selectedTime!.hour, timeStartInput.selectedTime!.minute);
    }

    if (timeEndInput.selectedTime != null) {
      implementationTimeEnd = DateTime(implementationTimeStart.year, implementationTimeStart.month, implementationTimeStart.day,
          timeEndInput.selectedTime!.hour, timeEndInput.selectedTime!.minute);
    }

    MasterMessage message = AssignExaminationRequest(
      token: token,
      assignExamination: AssignExamination(
        examinationId: examination.id!,
        templateId: examination.templateId!,
        userId: selectedUserPJ?.id,
        lokasi: lokasiInput.value,
        implementationTimeStart: implementationTimeStart,
        implementationTimeEnd: implementationTimeEnd,
      ),
    );
    return await ConnectionUtils.sendRequest(message);
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
      case ExaminationTypeName.kebisinganFrekuensi:
        message = SaveExaminationKebisinganFrekuensiRequest(
          token: token,
          inputKebisingan:
              InputKebisinganFrekuensi(examinationId: examination.id!, dataKebisinganFrekuensi: examination.userInput),
        );
        break;
      case ExaminationTypeName.iklimKerja:
        message = SaveExaminationIklimKerjaRequest(
            token: token, input: InputIklimKerja(examinationId: examination.id!, dataIklimKerja: examination.userInput));
        break;
      case ExaminationTypeName.kebisinganNoiseDose:
        message = SaveExaminationNoiseDoseRequest(
            token: token, input: InputKebisinganNoiseDose(examinationId: examination.id!, dataNoiseDose: examination.userInput));
        break;
      case ExaminationTypeName.gelombangElektroMagnet:
        message = SaveExaminationGelombangElektromagnetikRequest(
            token: token,
            input: InputDataElektromagnetic(examinationId: examination.id!, dataElektromagnetik: examination.userInput));
        break;
      case ExaminationTypeName.sinarUV:
        message = SaveExaminationUVRequest(
            token: token, input: InputDataUltraviolet(examinationId: examination.id!, dataUltraviolet: examination.userInput));
        break;
      case ExaminationTypeName.getaranWholeBody:
        message = SaveExaminationWholeBodyRequest(
            token: token, input: InputDataWholeBody(examinationId: examination.id!, dataWholeBody: examination.userInput));
        break;
      case ExaminationTypeName.getaranLengan:
        message = SaveExaminationHandArmRequest(
            token: token, input: InputDataHandArm(examinationId: examination.id!, dataHandArm: examination.userInput));
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
      case ExaminationTypeName.kebisinganFrekuensi:
        message = SubmitExaminationKebisinganFrekuensiRequest(
          token: token,
          inputKebisingan:
              InputKebisinganFrekuensi(examinationId: examination.id!, dataKebisinganFrekuensi: examination.userInput),
        );
        break;
      case ExaminationTypeName.iklimKerja:
        message = SubmitExaminationIklimKerjaRequest(
            token: token, input: InputIklimKerja(examinationId: examination.id!, dataIklimKerja: examination.userInput));
        break;
      case ExaminationTypeName.kebisinganNoiseDose:
        message = SubmitExaminationNoiseDoseRequest(
            token: token, input: InputKebisinganNoiseDose(examinationId: examination.id!, dataNoiseDose: examination.userInput));
        break;
      case ExaminationTypeName.gelombangElektroMagnet:
        message = SubmitExaminationGelombangElektromagnetikRequest(
            token: token,
            input: InputDataElektromagnetic(examinationId: examination.id!, dataElektromagnetik: examination.userInput));
        break;
      case ExaminationTypeName.sinarUV:
        message = SubmitExaminationUVRequest(
            token: token, input: InputDataUltraviolet(examinationId: examination.id!, dataUltraviolet: examination.userInput));
        break;
      case ExaminationTypeName.getaranWholeBody:
        message = SubmitExaminationWholeBodyRequest(
            token: token, input: InputDataWholeBody(examinationId: examination.id!, dataWholeBody: examination.userInput));
        break;
      case ExaminationTypeName.getaranLengan:
        message = SubmitExaminationHandArmRequest(
            token: token, input: InputDataHandArm(examinationId: examination.id!, dataHandArm: examination.userInput));
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
