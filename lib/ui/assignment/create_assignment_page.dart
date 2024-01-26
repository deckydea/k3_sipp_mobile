import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/assignment/examination_cubit.dart';
import 'package:k3_sipp_mobile/logic/examination/create_assignment_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
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

class CreateAssignmentPage extends StatefulWidget {
  const CreateAssignmentPage({super.key});

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final CreateAssignmentLogic _logic = CreateAssignmentLogic();

  Future<void> _selectCompany() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_company");
    if (result != null && result is Company) {
      _logic.selectedCompany = result;
      _logic.companyController.text = result.companyName ?? "";
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
      print("result: ${result.id}");
      if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(result);
    }
  }

  Future<void> _deleteExamination(Examination examination) async{
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
                onTap: () => _updateExamination(examination),
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
              label: "Name",
              controller: _logic.templateNameController,
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              width: double.infinity,
              label: "Company",
              onTap: _selectCompany,
              readOnly: true,
              cursorVisible: false,
              controller: _logic.companyController,
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.name,
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

  @override
  void deactivate() {
    context.read<ExaminationsCubit>().clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Register Pengujian", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}
