import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/template_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class CreateAssignmentLogic {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController templateNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  Company? selectedCompany;

  Future<MasterMessage> onCreate({required List<Examination> examinations}) async {
    if (formKey.currentState!.validate()) {
      Template template =
          Template(examinations: examinations, templateName: templateNameController.text, company: selectedCompany);

      String? token = await AppRepository().getToken();
      MasterMessage message = ManagementTemplateRequest(template: template, token: token);
      return await ConnectionUtils.sendRequest(message);
    }
    return MasterMessage(response: MasterResponseType.failed);
  }
}
