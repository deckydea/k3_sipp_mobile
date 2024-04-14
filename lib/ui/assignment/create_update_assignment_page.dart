import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/examination/examination_cubit.dart';
import 'package:k3_sipp_mobile/logic/examination/create_assignment_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';
import 'package:k3_sipp_mobile/widget/examination/examination_row.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';
import 'package:k3_sipp_mobile/widget/user/user_row.dart';

class CreateOrUpdateAssignmentPage extends StatefulWidget {
  final Template? template;

  const CreateOrUpdateAssignmentPage({super.key, this.template});

  @override
  State<CreateOrUpdateAssignmentPage> createState() => _CreateOrUpdateAssignmentPageState();
}

class _CreateOrUpdateAssignmentPageState extends State<CreateOrUpdateAssignmentPage> with SingleTickerProviderStateMixin {
  final CreateAssignmentLogic _logic = CreateAssignmentLogic();

  late TabController _tabController;

  Future<void> _navigateToSelectUser() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_user", arguments: UserFilter());
    if (result != null && result is User) {
      _logic.selectedUsers.add(result);
      setState(() {});
    }
  }

  Future<void> _selectCompany() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_company");
    if (result != null && result is Company) {
      _logic.selectedCompany = result;
      _logic.companyInput.setValue(result.companyName);
    }
  }

  Future<void> _queryTemplate() async {
    final ProgressDialog progressDialog = ProgressDialog("Loading", _logic.onQueryTemplate(widget.template!.id!));

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Template template = Template.fromJson(jsonDecode(message.content!));
          List<Examination> examinations = template.examinations;
          if(mounted) context.read<ExaminationsCubit>().clear();
          for (Examination examination in examinations) {
            if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(examination);
          }

          _logic.initTemplate(template);
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
    final ProgressDialog progressDialog =
        ProgressDialog("Mendaftarkan...", _logic.onCreate(examinations: context.read<ExaminationsCubit>().state.examinations));

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

  Future<void> _actionAdd() async {
    if (_tabController.index == 0) {
      _navigateToSelectUser();
    } else if (_tabController.index == 1) {
      var result = await navigatorKey.currentState?.pushNamed("/select_examination");
      if (result != null && result is List<Examination>) {
        for(Examination examination in result){
          if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(examination);
        }
      }
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
      title: "Hapus",
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
          return Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingSmall, right: Dimens.paddingPage, left: Dimens.paddingPage),
            child: ListView.builder(
              itemCount: examinations.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Examination examination = examinations.elementAt(index);
                return ExaminationRow(
                  examination: examination,
                  onTap: () => _deleteExamination(examination),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text(
              "Tidak ada pengujian, silahkan tambah pengujian.",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.deepOrange),
            ),
          );
        }
      },
    );
  }

  Widget _buildPetugas() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingSmall, right: Dimens.paddingPage, left: Dimens.paddingPage),
      child: _logic.selectedUsers.isNotEmpty
          ? ListView.builder(
              itemCount: _logic.selectedUsers.length,
              itemBuilder: (context, index) {
                User user = _logic.selectedUsers[index];
                bool isSelected = _logic.userPJ == null ? false : user.id == _logic.userPJ!.id;
                return UserRow(
                  user: user,
                  onTap: () => setState(() => _logic.userPJ = user),
                  hideGroup: true,
                  isSelected: isSelected,
                  description: isSelected
                      ? Text(
                          "Penanggungjawab",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.primaryLight),
                        )
                      : null,
                );
              },
            )
          : Center(
              child: Text(
                "Tidak ada petugas, silahkan tambah petugas.",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.deepOrange),
              ),
            ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimens.paddingPage),
          child: CustomFormInput(key: _logic.formKey, dataInputs: _logic.inputs),
        ),
        const SizedBox(height: Dimens.paddingLarge),
        Padding(
          padding: const EdgeInsets.all(Dimens.paddingPage),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(
                    child: Text("Petugas", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child:
                        Text("Pengujian", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              CustomCard(
                color: ColorResources.primary,
                borderRadius: Dimens.cardRadiusXLarge,
                onTap: _actionAdd,
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
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPetugas(),
              _buildExaminations(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.paddingPage),
          child: CustomButton(
            minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
            label: Text("Daftar", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
            backgroundColor: ColorResources.primaryDark,
            onPressed: _actionCreate,
          ),
        ),
      ],
    );
  }

  Future<void> _init() async {
    _logic.initInput(() => _selectCompany());

    if(mounted) context.read<ExaminationsCubit>().clear();

    if (widget.template != null) {
      await _queryTemplate();
    }

    _logic.initialized = true;
    setState(() {});
  }

  @override
  void deactivate() {
    context.read<ExaminationsCubit>().clear();
    super.deactivate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
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
