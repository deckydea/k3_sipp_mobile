import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/examination/examination_cubit.dart';
import 'package:k3_sipp_mobile/logic/template/template_detail_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_form_page.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_circular_progress_indicator.dart';
import 'package:k3_sipp_mobile/widget/examination/examination_row.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

class TemplateDetailPage extends StatefulWidget {
  final Template template;

  const TemplateDetailPage({super.key, required this.template});

  @override
  State<TemplateDetailPage> createState() => _TemplateDetailPageState();
}

class _TemplateDetailPageState extends State<TemplateDetailPage> {
  final TemplateDetailLogic _logic = TemplateDetailLogic();

  Future<void> _queryTemplate() async {
    final ProgressDialog progressDialog = ProgressDialog("Loading", _logic.onQueryTemplate(widget.template.id!));

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Template template = Template.fromJson(jsonDecode(message.content!));
          if (mounted) context.read<ExaminationsCubit>().clear();
          for (Examination examination in template.examinations) {
            if (mounted) context.read<ExaminationsCubit>().addOrUpdateExamination(examination);
          }
          _logic.template = template;
        }

        _logic.initialized = true;

        setState(() {});
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

  Future<void> _navigateExaminationDetail(Examination examination) async {
    var result = await navigatorKey.currentState?.pushNamed("/input_form",
        arguments: InputFormArgument(examination: examination, users: _logic.template.getPetugasUsers));
    if (result != null && result is bool && result) {
      _queryTemplate();
    }
  }

  Widget _titleRow({
    IconData? icon,
    required String title,
    String? value,
    Widget? valueWidget,
    VoidCallback? onTapValue,
  }) {
    if (value == null && valueWidget == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: Dimens.paddingWidget),
          icon == null ? Container() : Icon(icon, color: ColorResources.primaryDark, size: Dimens.iconSizeTitle),
          const SizedBox(width: Dimens.paddingGap),
          Expanded(
              flex: 2,
              child: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.primaryDark))),
          const SizedBox(width: Dimens.paddingGap),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: onTapValue,
              child: valueWidget ??
                  Text(
                    value ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: onTapValue != null ? ColorResources.primaryLight : Colors.black),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExaminations() {
    return BlocBuilder<ExaminationsCubit, ExaminationsState>(
      builder: (context, state) {
        List<Examination> examinations = state.examinations;
        if (examinations.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingSmall),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: examinations.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Examination examination = examinations.elementAt(index);
                return ExaminationRow(examination: examination, onTap: () => _navigateExaminationDetail(examination));
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMedium),
            child: Center(
              child: Text(
                "Tidak ada pengujian, silahkan tambah pengujian.",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.deepOrange),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_logic.initialized) _queryTemplate();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.background,
        title: Text("Pengujian", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: !_logic.initialized
          ? const CustomCircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.paddingPage),
                child: Column(
                  children: [
                    CustomCard(
                      borderRadius: Dimens.cardRadius,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingPage, horizontal: Dimens.paddingWidget),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _titleRow(
                                icon: Icons.home_work_rounded, title: "Perusahaan", value: _logic.template.company.companyName),
                            _titleRow(icon: Icons.map, title: "Alamat", value: _logic.template.company.companyAddress),
                            _titleRow(icon: Icons.person, title: "Penanggungjawab", value: _logic.template.company.picName),
                            _titleRow(
                                icon: Icons.contacts,
                                title: "Contact Person",
                                value: "${_logic.template.company.contactName} (${_logic.template.company.contactNumber})"),
                            _titleRow(
                              icon: Icons.calendar_month,
                              title: "Tanggal Pengujian",
                              value: DateTimeUtils.formatToDayDate(_logic.template.deadlineDate!),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimens.paddingSmall),
                    _buildExaminations(),
                  ],
                ),
              ),
            ),
    );
  }
}
