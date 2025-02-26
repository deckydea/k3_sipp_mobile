import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:k3_sipp_mobile/model/assignment/assignment_filter.dart';
import 'package:k3_sipp_mobile/model/examination/assign_examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_elektromagnetic.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_hand_arm.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_iklim_kerja.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_frekuensi.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_lk.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_noise_dose.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_whole_body.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class ExaminationRequest {
  final int examinationId;

  ExaminationRequest({required this.examinationId});

  Map<String, dynamic> toJson() => {'examinationId': examinationId};

  factory ExaminationRequest.fromJson(Map<String, dynamic> json) {
    return ExaminationRequest(examinationId: json['examinationId']);
  }
}

class ApprovalExaminationRequest {
  final int examinationId;
  final ExaminationStatus status;
  final bool isUpdate;
  final bool approved;

  ApprovalExaminationRequest({
    required this.examinationId,
    required this.status,
    required this.isUpdate,
    required this.approved,
  });

  Map<String, dynamic> toJson() => {
        'id': examinationId,
        'status': EnumToString.convertToString(status),
        'isUpdate': isUpdate,
        'approved': approved,
      };

  factory ApprovalExaminationRequest.fromJson(Map<String, dynamic> json) {
    return ApprovalExaminationRequest(
      examinationId: json['id'],
      status: ExaminationStatus.values.firstWhere((element) => element.name == json['status']),
      isUpdate: json['isUpdate'],
      approved: json['approved'],
    );
  }
}

class QueryExaminationsTypeRequest extends MasterMessage {
  QueryExaminationsTypeRequest({required super.token})
      : super(request: MasterRequestType.queryTypeExaminations, content: null, path: "examinations/query-examinationtype");
}

class QueryExaminationsRequest extends MasterMessage {
  QueryExaminationsRequest({required super.token, required AssignmentFilter filter})
      : super(request: MasterRequestType.queryExaminations, content: jsonEncode(filter), path: "examinations/query-examination");
}

class QueryExaminationRequest extends MasterMessage {
  QueryExaminationRequest({required super.token, required ExaminationRequest filter})
      : super(request: MasterRequestType.queryExamination, content: jsonEncode(filter), path: "examinations/get-pengujian");
}

//Assign
class AssignExaminationRequest extends MasterMessage {
  AssignExaminationRequest({required super.token, required AssignExamination assignExamination})
      : super(
            request: MasterRequestType.assignExamination,
            content: jsonEncode(assignExamination),
            path: "examinations/assign-examination");
}

//Kebisingan LK
class SaveExaminationKebisinganLKRequest extends MasterMessage {
  SaveExaminationKebisinganLKRequest({required super.token, required InputKebisinganLK inputKebisinganLK})
      : super(
            request: MasterRequestType.saveExaminationKebisinganLK,
            content: jsonEncode(inputKebisinganLK),
            path: "examinations/save-pengujian/kebisingan-lk");
}

class SubmitExaminationKebisinganLKRequest extends MasterMessage {
  SubmitExaminationKebisinganLKRequest({required super.token, required InputKebisinganLK inputKebisinganLK})
      : super(
            request: MasterRequestType.submitExaminationKebisinganLK,
            content: jsonEncode(inputKebisinganLK),
            path: "examinations/submit-pengujian/kebisingan-lk");
}

//Kebisingan Freqkuensi
class SaveExaminationKebisinganFrekuensiRequest extends MasterMessage {
  SaveExaminationKebisinganFrekuensiRequest({required super.token, required InputKebisinganFrekuensi inputKebisingan})
      : super(
            request: MasterRequestType.saveExaminationKebisinganFrekuensi,
            content: jsonEncode(inputKebisingan),
            path: "examinations/save-pengujian/kebisinganFrekuensi");
}

class SubmitExaminationKebisinganFrekuensiRequest extends MasterMessage {
  SubmitExaminationKebisinganFrekuensiRequest({required super.token, required InputKebisinganFrekuensi inputKebisingan})
      : super(
            request: MasterRequestType.submitExaminationKebisinganFrekuensi,
            content: jsonEncode(inputKebisingan),
            path: "examinations/submit-pengujian/kebisinganFrekuensi");
}

//Penerangan
class SaveExaminationPeneranganRequest extends MasterMessage {
  SaveExaminationPeneranganRequest({required super.token, required InputPenerangan inputPenerangan})
      : super(
            request: MasterRequestType.saveExaminationPenerangan,
            content: jsonEncode(inputPenerangan),
            path: "examinations/save-pengujian/penerangan");
}

class SubmitExaminationPeneranganRequest extends MasterMessage {
  SubmitExaminationPeneranganRequest({required super.token, required InputPenerangan inputPenerangan})
      : super(
            request: MasterRequestType.submitExaminationPenerangan,
            content: jsonEncode(inputPenerangan),
            path: "examinations/submit-pengujian/penerangan");
}

class ApprovalQC1ExaminationRequest extends MasterMessage {
  ApprovalQC1ExaminationRequest({required super.token, required ApprovalExaminationRequest approvalExaminationRequest})
      : super(
            request: MasterRequestType.approvalQC1,
            content: jsonEncode(approvalExaminationRequest),
            path: "examinations/approval-examination");
}

class ApprovalQC2ExaminationRequest extends MasterMessage {
  ApprovalQC2ExaminationRequest({required super.token, required ApprovalExaminationRequest approvalExaminationRequest})
      : super(
            request: MasterRequestType.approvalQC2,
            content: jsonEncode(approvalExaminationRequest),
            path: "examinations/approval-examination");
}

class ApprovalSignedExaminationRequest extends MasterMessage {
  ApprovalSignedExaminationRequest({required super.token, required ApprovalExaminationRequest approvalExaminationRequest})
      : super(
            request: MasterRequestType.approvalSigned,
            content: jsonEncode(approvalExaminationRequest),
            path: "examinations/approval-examination");
}

class SubmitRevisionExaminationRequest extends MasterMessage {
  SubmitRevisionExaminationRequest({required super.token, required Examination examination})
      : super(
            request: MasterRequestType.submitRevision,
            content: jsonEncode(examination),
            path: "examinations/revision-examination");
}

//Iklim Kerja
class SaveExaminationIklimKerjaRequest extends MasterMessage {
  SaveExaminationIklimKerjaRequest({required super.token, required InputIklimKerja input})
      : super(
      request: MasterRequestType.saveExaminationIklimKerja,
      content: jsonEncode(input),
      path: "examinations/save-pengujian/iklimKerja");
}

class SubmitExaminationIklimKerjaRequest extends MasterMessage {
  SubmitExaminationIklimKerjaRequest({required super.token, required InputIklimKerja input})
      : super(
      request: MasterRequestType.submitExaminationIklimKerja,
      content: jsonEncode(input),
      path: "examinations/submit-pengujian/iklimKerja");
}

//Noise Dose
class SaveExaminationNoiseDoseRequest extends MasterMessage {
  SaveExaminationNoiseDoseRequest({required super.token, required InputKebisinganNoiseDose input})
      : super(
      request: MasterRequestType.saveExaminationNoiseDose,
      content: jsonEncode(input),
      path: "examinations/save-pengujian/noiseDose");
}

class SubmitExaminationNoiseDoseRequest extends MasterMessage {
  SubmitExaminationNoiseDoseRequest({required super.token, required InputKebisinganNoiseDose input})
      : super(
      request: MasterRequestType.submitExaminationNoiseDose,
      content: jsonEncode(input),
      path: "examinations/submit-pengujian/noiseDose");
}

//Elektromagnetic
class SaveExaminationGelombangElektromagnetikRequest extends MasterMessage {
  SaveExaminationGelombangElektromagnetikRequest({required super.token, required InputDataElektromagnetic input})
      : super(
      request: MasterRequestType.saveExaminationGelombangelektromagnetik,
      content: jsonEncode(input),
      path: "examinations/save-pengujian/elektromagnetik");
}

class SubmitExaminationGelombangElektromagnetikRequest extends MasterMessage {
  SubmitExaminationGelombangElektromagnetikRequest({required super.token, required InputDataElektromagnetic input})
      : super(
      request: MasterRequestType.submitExaminationGelombangelektromagnetik,
      content: jsonEncode(input),
      path: "examinations/submit-pengujian/elektromagnetik");
}

//UV
class SaveExaminationUVRequest extends MasterMessage {
  SaveExaminationUVRequest({required super.token, required InputDataUltraviolet input})
      : super(
      request: MasterRequestType.saveExaminationUV,
      content: jsonEncode(input),
      path: "examinations/save-pengujian/ultraviolet");
}

class SubmitExaminationUVRequest extends MasterMessage {
  SubmitExaminationUVRequest({required super.token, required InputDataUltraviolet input})
      : super(
      request: MasterRequestType.submitExaminationUV,
      content: jsonEncode(input),
      path: "examinations/submit-pengujian/ultraviolet");
}

//Wholebody
class SaveExaminationWholeBodyRequest extends MasterMessage {
  SaveExaminationWholeBodyRequest({required super.token, required InputDataWholeBody input})
      : super(
      request: MasterRequestType.saveExaminationWholeBody,
      content: jsonEncode(input),
      path: "examinations/save-pengujian/wholeBody");
}

class SubmitExaminationWholeBodyRequest extends MasterMessage {
  SubmitExaminationWholeBodyRequest({required super.token, required InputDataWholeBody input})
      : super(
      request: MasterRequestType.submitExaminationWholeBody,
      content: jsonEncode(input),
      path: "examinations/submit-pengujian/wholeBody");
}

//Hand Arm
class SaveExaminationHandArmRequest extends MasterMessage {
  SaveExaminationHandArmRequest({required super.token, required InputDataHandArm input})
      : super(
      request: MasterRequestType.saveExaminationHandArm,
      content: jsonEncode(input),
      path: "examinations/save-pengujian/handArm");
}

class SubmitExaminationHandArmRequest extends MasterMessage {
  SubmitExaminationHandArmRequest({required super.token, required InputDataHandArm input})
      : super(
      request: MasterRequestType.submitExaminationHandArm,
      content: jsonEncode(input),
      path: "examinations/submit-pengujian/handArm");
}