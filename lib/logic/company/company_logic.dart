import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/company_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class CompanyLogic {
  final GlobalKey<FormState> formKey = GlobalKey();
  final List<DataInput> inputs = [];
  late bool isUpdate;
  Company? company;

  TextInput textInputCompanyName = TextInput(
    label: "Nama Perusahaan",
    required: true,
    icon: const Icon(Icons.apartment),
  );

  TextAreaInput textInputCompanyAddress = TextAreaInput(
    label: "Alamat Perusahaan",
    required: true,
    icon: const Icon(Icons.map_outlined),
  );


  void initRegisterUpdate({Company? company}) {
    this.company = company;
    isUpdate = company != null;

    if(isUpdate){
      textInputCompanyName.setValue(company!.companyName);
      textInputCompanyAddress.setValue(company.companyAddress);
    }

    inputs.clear();
    inputs.add(textInputCompanyName);
    inputs.add(textInputCompanyAddress);
  }

  void setCompany(Company? company)=> this.company = company;

  Future<MasterMessage> onCreateCompany() async {
    if (formKey.currentState!.validate()) {
      Company company = Company(companyName: textInputCompanyName.value, companyAddress: textInputCompanyAddress.value);

      String? token = await AppRepository().getToken();
      MasterMessage message = CreateCompanyRequest(company: company, token: token);
      return await ConnectionUtils.sendRequest(message);
    }

    return MasterMessage(response: MasterResponseType.invalidInput);
  }

  Future<MasterMessage> onUpdateCompany() async {
    if (formKey.currentState!.validate()) {
      print("textInputCompanyName.value: ${textInputCompanyName.value}");
      Company company = this.company!.replica();
      company.companyName = textInputCompanyName.value;
      company.companyAddress = textInputCompanyAddress.value;

      print("companycompany");
      print(jsonEncode(company));

      String? token = await AppRepository().getToken();
      MasterMessage message = UpdateCompanyRequest(company: company, token: token);
      return await ConnectionUtils.sendRequest(message);
    }

    return MasterMessage(response: MasterResponseType.invalidInput);
  }

}
