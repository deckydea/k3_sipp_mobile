import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/user/petugas.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/template_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class CreateAssignmentLogic {
  final GlobalKey<CustomFormInputState> formKey = GlobalKey();
  final List<DataInput> inputs = [];

  late final TextInput companyInput;
  late final TextAreaInput templateNameInput;
  late final DateInput deadlineInput;

  List<User> selectedUsers = [];
  User? userPJ;

  Company? selectedCompany;
  bool isUpdate = false;
  bool initialized = false;

  void initInput(Function() onSelectCompany) {
    companyInput = TextInput(
      label: "Perusahaan",
      required: true,
      onTap: onSelectCompany,
    );

    deadlineInput = DateInput(
      label: "Tanggal Pengujian",
      required: true,
      maxDate: DateTime.now().add(const Duration(days: 200 * 365)),
      minDate: DateTime.now(),
    );

    templateNameInput = TextAreaInput(
      label: "Catatan",
      required: false,
    );

    initTemplate(null);
  }

  void initTemplate(Template? template) {
    if (template != null) {
      isUpdate = true;
      selectedCompany = template.company;

      companyInput.setValue(template.company.companyName);
      deadlineInput.setSelectedDate(template.deadlineDate);
      templateNameInput.setValue(template.templateName ?? "");
      for (Petugas petugas in template.petugas) {
        if (petugas.penanggungJawab) {
          userPJ = petugas.user;
        }
        if (petugas.user != null) selectedUsers.add(petugas.user!);
      }
    }

    inputs.clear();
    inputs.add(companyInput);
    inputs.add(deadlineInput);
    inputs.add(templateNameInput);
  }

  Future<MasterMessage> onUpdate({required List<Examination> examinations}) async {
    if (formKey.currentState!.validate()) {
      List<Petugas> petugas = [];
      for (User user in selectedUsers) {
        petugas.add(Petugas(petugasId: user.id!, penanggungJawab: userPJ != null && user.id == userPJ!.id));
      }

      Template template = Template(
        examinations: examinations,
        templateName: templateNameInput.value,
        company: selectedCompany!,
        petugas: petugas,
        deadlineDate: deadlineInput.selectedDate,
      );

      String? token = await AppRepository().getToken();
      return await ConnectionUtils.sendRequest(ManagementTemplateRequest(template: template, token: token));
    }
    return MasterMessage(response: MasterResponseType.failed);
  }

  Future<MasterMessage> onCreate({required List<Examination> examinations}) async {
    if (formKey.currentState!.validate()) {
      List<Petugas> petugas = [];
      for (User user in selectedUsers) {
        petugas.add(Petugas(petugasId: user.id!, penanggungJawab: userPJ != null && user.id == userPJ!.id));
      }

      Template template = Template(
        examinations: examinations,
        templateName: templateNameInput.value,
        company: selectedCompany!,
        petugas: petugas,
        deadlineDate: deadlineInput.selectedDate,
      );

      String? token = await AppRepository().getToken();
      return await ConnectionUtils.sendRequest(ManagementTemplateRequest(template: template, token: token));
    }
    return MasterMessage(response: MasterResponseType.failed);
  }

  Future<MasterMessage> onQueryTemplate(int templateId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(QueryTemplateRequest(token: token, templateId: templateId));
  }
}
