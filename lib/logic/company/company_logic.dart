import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/company_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class CompanyLogic {
  final GlobalKey<CustomFormInputState> formKey = GlobalKey();
  final List<DataInput> inputs = [];
  late bool isUpdate;
  Company? company;

  final TextInput textInputCompanyName = TextInput(
    label: "Nama Perusahaan",
    required: true,
    icon: const Icon(Icons.apartment),
  );

  final TextInput textInputContactName = TextInput(
    label: "Nama Contact Person",
    required: true,
    icon: const Icon(Icons.person_sharp),
  );

  final TextInput textInputContactNumber = TextInput(
    label: "Nomor Contact Person",
    required: true,
    icon: const Icon(Icons.phone),
  );

  final TextInput textInputPICName = TextInput(
    label: "Pengurus/Penanggungjawab",
    required: true,
    icon: const Icon(Icons.person),
  );

  final TextAreaInput textInputCompanyAddress = TextAreaInput(
    label: "Alamat Perusahaan",
    required: true,
    icon: const Icon(Icons.map_outlined),
  );

  void initRegisterUpdate({Company? company}) {
    this.company = company;
    isUpdate = company != null;

    if (isUpdate) {
      textInputCompanyName.setValue(company!.companyName);
      textInputCompanyAddress.setValue(company.companyAddress!);
      textInputContactName.setValue(company.contactName!);
      textInputContactNumber.setValue(company.contactNumber!);
      textInputPICName.setValue(company.picName!);
    }

    inputs.clear();
    inputs.add(textInputCompanyName);
    inputs.add(textInputCompanyAddress);
    inputs.add(textInputContactName);
    inputs.add(textInputContactNumber);
    inputs.add(textInputPICName);
  }

  void setCompany(Company? company) => this.company = company;

  Future<MasterMessage> onCreateCompany() async {
    if (formKey.currentState!.validate()) {
      Company company = Company(
        companyName: textInputCompanyName.value,
        companyAddress: textInputCompanyAddress.value,
        contactName: textInputContactName.value,
        contactNumber: textInputContactNumber.value,
        picName: textInputPICName.value,
      );

      String? token = await AppRepository().getToken();
      MasterMessage message = CreateCompanyRequest(company: company, token: token);
      return await ConnectionUtils.sendRequest(message);
    }

    return MasterMessage(response: MasterResponseType.invalidInput);
  }

  Future<MasterMessage> onUpdateCompany() async {
    if (formKey.currentState!.validate()) {
      Company company = this.company!.replica();
      company.companyName = textInputCompanyName.value;
      company.companyAddress = textInputCompanyAddress.value;
      company.contactName = textInputContactName.value;
      company.contactNumber = textInputContactNumber.value;
      company.picName = textInputPICName.value;

      String? token = await AppRepository().getToken();
      MasterMessage message = UpdateCompanyRequest(company: company, token: token);
      return await ConnectionUtils.sendRequest(message);
    }

    return MasterMessage(response: MasterResponseType.invalidInput);
  }
}
