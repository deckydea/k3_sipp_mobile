import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_kebisingan_lk_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_penerangan_page.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/file_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/kebisingan_lk_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/penerangan_pdf.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

enum InputView { listView, tableView }

class InputFormPage extends StatefulWidget {
  final Examination examination;

  const InputFormPage({super.key, required this.examination});

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final InputFormLogic _logic = InputFormLogic();

  Future<void> _generatePdf() async {
    bool permission = await FileUtils.requestStoragePermission();
    if (permission) {
      String fileName =
          "${_logic.examination.typeOfExaminationName} - ${_logic.examination.company!.companyName} -${DateTimeUtils.formatToDateTime(DateTime.now())}";
      Uint8List? pdfBytes;

      switch (_logic.examination.typeOfExaminationName) {
        case ExaminationTypeName.kebisingan:
          pdfBytes = await KebisinganLKResultPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.penerangan:
          pdfBytes = await PeneranganResultPdf.generatePrint(examination: _logic.examination);
          break;
      }

      if (pdfBytes != null && mounted) {
        FileUtils.openPdfFiles(context: context, pdfBytes: pdfBytes, fileName: fileName);
      }
    } else {
      if (mounted) MessageUtils.handlePermissionDenied(context: context);
    }
  }

  Future<void> _loadExamination() async {
    ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.loadExamination(widget.examination.id!));
    MasterMessage message = await progressDialog.show();

    switch (message.response) {
      case MasterResponseType.success:
        Examination examination = Examination.fromJson(jsonDecode(message.content!));
        _logic.examination = examination;
        _logic.initialized = true;
        setState(() {});
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

  Future<void> _actionApproval({required bool approved}) async {
    ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.approvalExamination(approved: approved));
    MasterMessage message = await progressDialog.show();

    switch (message.response) {
      case MasterResponseType.success:
        if (mounted) {
          await MessageUtils.showMessage(
            context: context,
            title: "Berhasil",
            content: "Pengujian berhasil disimpan",
            dialog: false,
          );
        }
        navigatorKey.currentState?.pop(true);
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

  Future<void> _actionSubmit() async {
    ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.submitInputExamination());
    MasterMessage message = await progressDialog.show();

    switch (message.response) {
      case MasterResponseType.success:
        if (mounted) {
          await MessageUtils.showMessage(
            context: context,
            title: "Berhasil",
            content: "Pengujian berhasil dilanjutkan ke approval",
            dialog: false,
          );
        }
        navigatorKey.currentState?.pop(true);
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

  Future<void> _actionSubmitRevision() async {
    ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.submitRevisionExamination());
    MasterMessage message = await progressDialog.show();

    switch (message.response) {
      case MasterResponseType.success:
        if (mounted) {
          await MessageUtils.showMessage(
            context: context,
            title: "Berhasil",
            content: "Pengujian berhasil di revisi",
            dialog: false,
          );
        }
        navigatorKey.currentState?.pop(true);
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

  Future<void> _actionSave() async {
    ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.saveInputExamination());
    MasterMessage message = await progressDialog.show();

    switch (message.response) {
      case MasterResponseType.success:
        if (mounted) {
          await MessageUtils.showMessage(
            context: context,
            title: "Berhasil",
            content: "Pengujian berhasil disimpan",
            dialog: false,
          );
        }
        navigatorKey.currentState?.pop();
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

  Future<void> _actionApprovalDialog() async {
    List<String> options = [];
    List<Icon> icons = [];
    List<Function()> callbacks = [];
    List<Color> colors = [];

    options.add("Revisi Pengujian");
    callbacks.add(() => Navigator.of(context).pop(false));
    icons.add(const Icon(Icons.edit_note_outlined, color: Colors.black));
    colors.add(Colors.black);

    if (_logic.examination.status == ExaminationStatus.PENDING_SIGNED) {
      options.add("Setujui dan Tandatangan");
    } else {
      options.add("Setujui dan Lanjutkan Approval");
    }

    callbacks.add(() => Navigator.of(context).pop(true));
    icons.add(const Icon(Icons.approval_outlined, color: Colors.black));
    colors.add(Colors.black);

    if (mounted) {
      var result = context.mounted
          ? await DialogUtils.showOptionDialog(
              context: context,
              title: "Pilih Opsi",
              options: options,
              onSelected: callbacks,
              icons: icons,
              color: colors,
              dismissible: true,
            )
          : null;

      if (result != null && result is bool) {
        _actionApproval(approved: result);
      }
    }
  }

  Future<void> _actionSaveOrSubmitRevision() async {
    List<String> options = [];
    List<Icon> icons = [];
    List<Function()> callbacks = [];
    List<Color> colors = [];

    options.add("Simpan Pengujian");
    callbacks.add(() => Navigator.of(context).pop(0));
    icons.add(const Icon(Icons.save, color: Colors.black));
    colors.add(Colors.black);

    options.add("Selesai Revisi dan Lanjutkan");
    callbacks.add(() => Navigator.of(context).pop(1));
    icons.add(const Icon(Symbols.order_approve_rounded, color: Colors.black));
    colors.add(Colors.black);

    if (mounted) {
      var result = context.mounted
          ? await DialogUtils.showOptionDialog(
              context: context,
              title: "Pilih Opsi",
              options: options,
              onSelected: callbacks,
              icons: icons,
              color: colors,
              dismissible: true,
            )
          : null;

      if (result != null && result is int) {
        switch (result) {
          case 0:
            _actionSave();
            break;
          case 1:
            _actionSubmitRevision();
            break;
          default:
        }
      }
    }
  }

  Future<void> _actionSubmitOrSaveDialog() async {
    List<String> options = [];
    List<Icon> icons = [];
    List<Function()> callbacks = [];
    List<Color> colors = [];

    options.add("Simpan Pengujian");
    callbacks.add(() => Navigator.of(context).pop(0));
    icons.add(const Icon(Icons.save, color: Colors.black));
    colors.add(Colors.black);

    options.add("Selesai dan Lanjutkan Approval");
    callbacks.add(() => Navigator.of(context).pop(1));
    icons.add(const Icon(Symbols.order_approve_rounded, color: Colors.black));
    colors.add(Colors.black);

    if (mounted) {
      var result = context.mounted
          ? await DialogUtils.showOptionDialog(
              context: context,
              title: "Pilih Opsi",
              options: options,
              onSelected: callbacks,
              icons: icons,
              color: colors,
              dismissible: true,
            )
          : null;

      if (result != null && result is int) {
        switch (result) {
          case 0:
            _actionSave();
            break;
          case 1:
            _actionSubmit();
            break;
          default:
        }
      }
    }
  }

  Future<void> _showDeviceDetailDialog(DeviceCalibration deviceCalibration) async {
    if (deviceCalibration.device == null) return;

    Widget row({
      IconData? icon,
      required String title,
      String? value,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon == null ? Container() : Icon(icon, color: ColorResources.primaryDark, size: Dimens.iconSizeTitle),
            const SizedBox(width: Dimens.paddingGap),
            Expanded(
                flex: 2,
                child:
                    Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark))),
            const SizedBox(width: Dimens.paddingGap),
            Text(
              value ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      );
    }

    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
        title: Text("Alat yang Digunakan",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row(
              icon: Icons.devices,
              title: deviceCalibration.device!.name!,
              value: deviceCalibration.device!.calibrationValue!.toStringAsFixed(2),
            ),
            row(
              icon: Icons.format_size,
              title: "U95",
              value: deviceCalibration.device!.u95!.toStringAsFixed(2),
            ),
            row(
              icon: Icons.map,
              title: "K (Coverage Factor)",
              value: deviceCalibration.device!.coverageFactor!.toStringAsFixed(2),
            ),
            deviceCalibration.internalCalibration != null
                ? row(
                    icon: Icons.compass_calibration,
                    title: "Kalibrasi Internal",
                    value: deviceCalibration.internalCalibration!.toStringAsFixed(2),
                  )
                : Container(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tutup", style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    switch (_logic.examination.typeOfExaminationName) {
      case ExaminationTypeName.kebisingan:
        return InputKebisinganLKPage(logic: _logic);
      case ExaminationTypeName.penerangan:
        return InputPeneranganPage(logic: _logic);
    }

    return Container();
  }

  Widget _deviceRow({
    required IconData icon,
    required String title,
    required List<DeviceCalibration> deviceCalibrations,
  }) {
    if (deviceCalibrations.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: Dimens.paddingWidget),
          Icon(icon, color: ColorResources.primaryDark, size: Dimens.iconSizeTitle),
          const SizedBox(width: Dimens.paddingGap),
          Expanded(
              flex: 2,
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark))),
          const SizedBox(width: Dimens.paddingGap),
          Expanded(
            flex: 3,
            child: deviceCalibrations.isEmpty
                ? const Text("-")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: deviceCalibrations
                        .map(
                          (deviceCalibration) => InkWell(
                            onTap: () => _showDeviceDetailDialog(deviceCalibration),
                            child: Text(
                              deviceCalibration.device == null ? "" : deviceCalibration.device!.name ?? "",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorResources.primaryLight),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
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
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark))),
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

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingPage),
        child: Column(
          children: [
            CustomCard(
              borderRadius: Dimens.cardRadius,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(Dimens.paddingPage),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(_logic.examination.typeOfExaminationName.toCapitalize(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text(_logic.examination.examinationType!.description, style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        InkWell(onTap: _generatePdf, child: const Icon(Icons.description, color: Colors.blueAccent)),
                      ],
                    ),
                    const SizedBox(height: Dimens.paddingSmall),
                    _titleRow(icon: Icons.home_work_rounded, title: "Perusahaan", value: _logic.examination.company!.companyName),
                    _titleRow(icon: Icons.map, title: "Alamat", value: _logic.examination.company!.companyAddress),
                    _deviceRow(
                      icon: Icons.devices,
                      title: "Alat yang digunakan",
                      deviceCalibrations: _logic.examination.deviceCalibrations,
                    ),
                    _titleRow(
                      icon: Icons.calendar_month,
                      title: "Deadline",
                      value: DateTimeUtils.formatToDayDate(_logic.examination.deadlineDate!),
                    ),
                    _titleRow(
                      icon: Icons.check_box,
                      title: "Status",
                      valueWidget: Align(
                        alignment: Alignment.centerLeft,
                        child: _logic.examination.statusBadge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimens.paddingSmall),
            _buildInputForm(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _loadExamination();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.background,
        title: Text("Pengujian", style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
            child: _logic.initialized && _logic.examination.status == ExaminationStatus.SIGNED
                ? IconButton(
                    onPressed: !_logic.initialized ? null : _generatePdf,
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: ColorResources.primaryDark,
                      weight: Dimens.iconWeightAppbar,
                      size: Dimens.iconSizeAppbar,
                    ),
                  )
                : IconButton(
                    onPressed: !_logic.initialized
                        ? null
                        : _logic.examination.status == ExaminationStatus.PENDING
                            ? _actionSubmitOrSaveDialog
                            : _logic.examination.status == ExaminationStatus.REVISION_QC1 ||
                                    _logic.examination.status == ExaminationStatus.REVISION_QC2 ||
                                    _logic.examination.status == ExaminationStatus.REVISION_INPUT_LAB ||
                                    _logic.examination.status == ExaminationStatus.REJECT_SIGNED
                                ? _actionSaveOrSubmitRevision
                                : _actionApprovalDialog,
                    icon: const Icon(
                      Symbols.check,
                      color: ColorResources.primary,
                      weight: Dimens.iconWeightAppbar,
                      size: Dimens.iconSizeAppbar,
                    ),
                  ),
          ),
        ],
      ),
      body: !_logic.initialized ? Container() : _buildBody(),
    );
  }
}
