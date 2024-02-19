import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/examination/examination_cubit.dart';
import 'package:k3_sipp_mobile/logic/examination/create_assignment_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:k3_sipp_mobile/widget/examination/examination_row.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

class CreateOrUpdateAssignmentPage extends StatefulWidget {
  final Template? template;

  const CreateOrUpdateAssignmentPage({super.key, this.template});

  @override
  State<CreateOrUpdateAssignmentPage> createState() => _CreateOrUpdateAssignmentPageState();
}

class _CreateOrUpdateAssignmentPageState extends State<CreateOrUpdateAssignmentPage> {
  final CreateAssignmentLogic _logic = CreateAssignmentLogic();

  Future<void> _selectCompany() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_company");
    if (result != null && result is Company) {
      _logic.selectedCompany = result;
      _logic.companyController.text = result.companyName ?? "";
    }
  }

  Future<void> _queryTemplate() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.onQueryTemplate(widget.template!.id!));

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Template template = Template.fromJson(jsonDecode(message.content!));
          List<Examination> examinations = template.examinations ?? [];
          for (Examination examination in examinations) {
            if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(examination);
          }
        }
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
    final ProgressDialog progressDialog = ProgressDialog(
        context, "Mendaftarkan...", _logic.onCreate(examinations: context.read<ExaminationsCubit>().state.examinations));

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          //TODO: Handle Success

          if (mounted) {
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "berhasil ditambahkan",
            );
          }
          navigatorKey.currentState?.pop();
        }
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

  Future<void> _addExamination() async {
    var result = await navigatorKey.currentState?.pushNamed("/add_examination_page");
    if (result != null && result is Examination) {
      if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(result);
    }
  }

  Future<void> _updateExamination(Examination examination) async {
    var result = await navigatorKey.currentState?.pushNamed("/update_examination_page", arguments: examination);
    if (result != null && result is Examination) {
      if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(result);
    }
  }

  Future<void> _navigateExaminationDetail(Examination examination) async {
    var result = await navigatorKey.currentState?.pushNamed("/input_form", arguments: examination);
  }

  Future<void> _deleteExamination(Examination examination) async {
    var result = await DialogUtils.showAlertDialog(
      context,
      dismissible: false,
      title: "Hapus Device",
      content: "Apakah Anda yakin akan menghapus ${examination.typeOfExaminationName}?",
      neutralAction: "Tidak",
      onNeutral: () => navigatorKey.currentState?.pop(false),
      negativeAction: "Hapus",
      onNegative: () => navigatorKey.currentState?.pop(true),
    );

    if (result == null || !result) return;

    if (mounted) context.read<ExaminationsCubit>().deleteExamination(examination);
  }

  Widget _buildExaminations() {
    return BlocBuilder<ExaminationsCubit, ExaminationsState>(
      builder: (context, state) {
        List<Examination> examinations = state.examinations;
        if (examinations.isNotEmpty) {
          return ListView.builder(
            itemCount: examinations.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Examination examination = examinations.elementAt(index);
              return ExaminationRow(
                examination: examination,
                onTap: () => examination.status != null && examination.status != ExaminationStatus.PENDING
                    ? _navigateExaminationDetail(examination)
                    : _updateExamination(examination),
                onLongPress: () => _deleteExamination(examination),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "Tidak pengujian, silahkan tambah pengujian.",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.deepOrange),
            ),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: Form(
        key: _logic.formKey,
        child: Column(
          children: [
            CustomEditText(
              width: double.infinity,
              label: "Perusahaan",
              onTap: _selectCompany,
              readOnly: true,
              cursorVisible: false,
              controller: _logic.companyController,
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              width: double.infinity,
              label: "Catatan",
              controller: _logic.templateNameController,
              maxLines: 3,
              validator: (value) => ValidatorUtils.validateInputLength(context, value, 0, 100),
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: Dimens.paddingLarge, child: Divider()),
            Row(
              children: [
                Expanded(
                    child: Text("Pengujian",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorResources.primaryDark))),
                CustomCard(
                  color: ColorResources.primary,
                  borderRadius: Dimens.cardRadiusXLarge,
                  onTap: _addExamination,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimens.paddingWidget, horizontal: Dimens.paddingPage),
                    child: Row(
                      children: [
                        Text("Tambah", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                        const SizedBox(width: Dimens.paddingGap),
                        GestureDetector(child: const Icon(Icons.add, size: Dimens.iconSizeSmall, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.paddingSmall),
            Expanded(child: _buildExaminations()),
            const SizedBox(height: Dimens.paddingMedium),
            CustomButton(
              minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
              label: Text("Daftar", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              backgroundColor: ColorResources.primaryDark,
              onPressed: _actionCreate,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    if (widget.template != null) {
      _logic.isUpdate = true;
      _logic.templateNameController.text = widget.template!.templateName ?? "";
      _logic.companyController.text = widget.template!.company!.companyName ?? "";
      _logic.selectedCompany = widget.template!.company;

      await _queryTemplate();
      _logic.initialized = true;
      setState(() {});
    }
  }

  @override
  void deactivate() {
    context.read<ExaminationsCubit>().clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (!_logic.initialized) _init();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text(
          _logic.isUpdate ? "Update Pengujian" : "Register Pengujian",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: _buildBody(),
    );
  }
}
