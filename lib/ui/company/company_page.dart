import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/company/companies_bloc.dart';
import 'package:k3_sipp_mobile/logic/company/company_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

class CompanyPage extends StatefulWidget {
  final Company? company;

  const CompanyPage({super.key, this.company});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final CompanyLogic _logic = CompanyLogic();

  Future<void> _actionUpdate() async {
    final ProgressDialog progressDialog = ProgressDialog("Memperbarui...", _logic.onUpdateCompany());

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Company company = Company.fromJson(jsonDecode(message.content!));
          _logic.setCompany(null);
          if (mounted) {
            context.read<CompaniesBloc>().add(UpdateCompanyEvent(company));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${company.companyName} berhasil diperbarui",
            );
          }
          navigatorKey.currentState?.pop();
        }
        break;
      case MasterResponseType.invalidInput:
        //Input invalid
        break;
      case MasterResponseType.invalidAccess:
        if (mounted) DialogUtils.handleInvalidAccess(context);
        break;
      case MasterResponseType.notExist:
      case MasterResponseType.invalidCredential:
        if (mounted) DialogUtils.handleInvalidCredential(context);
        break;
      case MasterResponseType.invalidMessageFormat:
        if (mounted) DialogUtils.handleInvalidMessageFormat(context);
        break;
      case MasterResponseType.noConnection:
        if (mounted) DialogUtils.handleNoConnection(context);
        break;
      default:
        if (mounted) DialogUtils.handleException(context);
    }
  }

  Future<void> _actionCreate() async {
    final ProgressDialog progressDialog = ProgressDialog("Mendaftarkan...", _logic.onCreateCompany());

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Company company = Company.fromJson(jsonDecode(message.content!));
          if (mounted) {
            context.read<CompaniesBloc>().add(AddCompanyEvent(company));
            _logic.setCompany(null);
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${company.companyName} berhasil ditambahkan",
            );
          }
          navigatorKey.currentState?.pop(company);
        }
        break;
      case MasterResponseType.invalidInput:
        //Input invalid
        break;
      case MasterResponseType.invalidAccess:
        if (mounted) DialogUtils.handleInvalidAccess(context);
        break;
      case MasterResponseType.notExist:
      case MasterResponseType.invalidCredential:
        if (mounted) DialogUtils.handleInvalidCredential(context);
        break;
      case MasterResponseType.invalidMessageFormat:
        if (mounted) DialogUtils.handleInvalidMessageFormat(context);
        break;
      case MasterResponseType.noConnection:
        if (mounted) DialogUtils.handleNoConnection(context);
        break;
      default:
        if (mounted) DialogUtils.handleException(context);
    }
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: Column(
        children: [
          CustomFormInput(
            key: _logic.formKey,
            dataInputs: _logic.inputs,
          ),
          const SizedBox(height: Dimens.paddingMedium),
          CustomButton(
            minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
            label: Text(_logic.isUpdate ? "Update" : "Daftar",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
            backgroundColor: ColorResources.primary,
            onPressed: _logic.isUpdate ? _actionUpdate : _actionCreate,
          ),
          const SizedBox(height: Dimens.paddingMedium),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _logic.initRegisterUpdate(company: widget.company);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text(_logic.isUpdate ? _logic.company!.companyName : "Register Perusahaan",
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}
