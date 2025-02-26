import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_elektromagnetic_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_hand_arm_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_iklim_kerja_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_kebisingan_frekuensi_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_kebisingan_lk_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_kebisingan_noise_dose_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_penerangan_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_uv_page.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_whole_body_page.dart';
import 'package:k3_sipp_mobile/ui/user/select_user.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/enum_translation_utils.dart';
import 'package:k3_sipp_mobile/util/file_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditas_hand_arm_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditas_iklim_kerja_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_elektromagnetic_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_kebisingan_frekuensi_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_noise_dose_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_uv_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_whole_body_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_elektromagnetic_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_hand_arm_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_iklim_kerja_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_kebisingan_lk_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_kebisingan_lk_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/akreditasi_penerangan_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_penerangan_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_uv_pdf.dart';
import 'package:k3_sipp_mobile/util/pdf/examination_result/lhp_whole_body_pdf.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_circular_progress_indicator.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

enum InputView { listView, tableView }

class InputFormArgument {
  final Examination examination;
  final List<User> users;

  InputFormArgument({required this.examination, required this.users});
}

class InputFormPage extends StatefulWidget {
  final InputFormArgument arguments;

  const InputFormPage({super.key, required this.arguments});

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final InputFormLogic _logic = InputFormLogic();

  Future<void> _generatePdfAkreditasi() async {
    bool permission = await FileUtils.requestStoragePermission();
    if (permission) {
      String fileName =
          "${EnumTranslationUtils.examinationType(_logic.examination.typeOfExaminationName)} - ${_logic.examination.company!.companyName} -${DateTimeUtils.formatToDateTime(DateTime.now())}";
      Uint8List? pdfBytes;

      switch (_logic.examination.typeOfExaminationName) {
        case ExaminationTypeName.kebisingan:
          pdfBytes = await AkreditasiKebisinganLKPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.penerangan:
          pdfBytes = await AkreditasiPeneranganResultPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.kebisinganFrekuensi:
          pdfBytes = await KebisinganFrekuensiPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.gelombangElektroMagnet:
          pdfBytes = await AkreditasiElektromagneticPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.kebisinganNoiseDose:
          pdfBytes = await AkreditasiNoiseDosePdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.iklimKerja:
          pdfBytes = await AkreditasiIklimKerjaPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.sinarUV:
          pdfBytes = await AkreditasiUVPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.getaranLengan:
          pdfBytes = await AkreditasiHandArmPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.getaranWholeBody:
          pdfBytes = await AkreditasiWholeBodyPdf.generatePrint(examination: _logic.examination);
          break;
        default:
          if (mounted) MessageUtils.showMessage(context: context, content: "Document tidak tersedia.");
          break;
      }

      if (pdfBytes != null && mounted) {
        FileUtils.openPdfFiles(context: context, pdfBytes: pdfBytes, fileName: fileName);
      }
    } else {
      if (mounted) MessageUtils.handlePermissionDenied(context: context);
    }
  }

  Future<void> _generatePdfLHP() async {
    bool permission = await FileUtils.requestStoragePermission();
    if (permission) {
      String fileName =
          "${EnumTranslationUtils.examinationType(_logic.examination.typeOfExaminationName)} - ${_logic.examination.company!.companyName} -${DateTimeUtils.formatToDateTime(DateTime.now())}";
      Uint8List? pdfBytes;

      switch (_logic.examination.typeOfExaminationName) {
        case ExaminationTypeName.kebisingan:
          pdfBytes = await LHPKebisinganLKPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.penerangan:
          pdfBytes = await LHPPeneranganPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.gelombangElektroMagnet:
          pdfBytes = await LHPElektromagnetikPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.sinarUV:
          pdfBytes = await LHPUVPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.getaranLengan:
          pdfBytes = await LHPHandArmPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.getaranWholeBody:
          pdfBytes = await LHPWholeBodyPdf.generatePrint(examination: _logic.examination);
          break;
        case ExaminationTypeName.iklimKerja:
          pdfBytes = await LHPIklimKerjaPdf.generatePrint(examination: _logic.examination);
          break;
        default:
          if (mounted) MessageUtils.showMessage(context: context, content: "Document tidak tersedia.");
          break;
      }

      if (pdfBytes != null && mounted) {
        FileUtils.openPdfFiles(context: context, pdfBytes: pdfBytes, fileName: fileName);
      }
    } else {
      if (mounted) MessageUtils.handlePermissionDenied(context: context);
    }
  }

  Future<void> _navigateSelectUser() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectUserPage(users: widget.arguments.users, selectedUser: _logic.selectedUserPJ)));

    if (result != null && result is User) {
      _logic.selectedUserPJ = result;
      _logic.pjInput.setValue(result.name);
    }
  }

  Future<void> _loadExamination() async {
    ProgressDialog progressDialog = ProgressDialog("Loading", _logic.loadExamination(widget.arguments.examination.id!));
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
    ProgressDialog progressDialog = ProgressDialog("Loading", _logic.approvalExamination(approved: approved));
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
    ProgressDialog progressDialog = ProgressDialog("Loading", _logic.submitInputExamination());
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
    ProgressDialog progressDialog = ProgressDialog("Loading", _logic.submitRevisionExamination());
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
    ProgressDialog progressDialog = ProgressDialog("Loading", _logic.saveInputExamination());
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

  Future<void> _actionSaveInformationDialog() async {
    var result = await DialogUtils.showAlertDialog(
      context,
      title: "Simpan Pengujian",
      content: "Apakah Anda yakin akan menyimpan Informasi ini?",
      onPositive: () => Navigator.of(context).pop(true),
      positiveAction: "Oke",
      onNeutral: () => Navigator.of(context).pop(false),
      neutralAction: "Batal",
    );

    if (result == null && !result) return;

    ProgressDialog progressDialog = ProgressDialog("Loading", _logic.assignExamination());
    MasterMessage message = await progressDialog.show();

    switch (message.response) {
      case MasterResponseType.success:
        setState(() => _logic.activeStep = InputStep.input);
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
    Widget widget;
    switch (_logic.examination.typeOfExaminationName) {
      case ExaminationTypeName.kebisingan:
        widget = InputKebisinganLKPage(logic: _logic);
        break;
      case ExaminationTypeName.penerangan:
        widget = InputPeneranganPage(logic: _logic);
        break;
      case ExaminationTypeName.kebisinganAmbient:
        widget = Container();
        break;
      case ExaminationTypeName.kebisinganFrekuensi:
        widget = InputKebisinganFrekuensiPage(logic: _logic);
        break;
      case ExaminationTypeName.iklimKerja:
        widget = InputIklimKerjaPage(logic: _logic);
        break;
      case ExaminationTypeName.kebisinganNoiseDose:
        widget = InputKebisinganNoiseDosePage(logic: _logic);
        break;
      case ExaminationTypeName.gelombangElektroMagnet:
        widget = InputElektromagneticPage(logic: _logic);
        break;
      case ExaminationTypeName.sinarUV:
        widget = InputUVPage(logic: _logic);
        break;
      case ExaminationTypeName.getaranWholeBody:
        widget = InputWholeBodyPage(logic: _logic);
        break;
      case ExaminationTypeName.getaranLengan:
        widget = InputHandArmPage(logic: _logic);
      default:
        widget = Container();
    }

    return Column(
      children: [
        Expanded(
          child: CustomCard(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
              child: widget,
            ),
          ),
        ),
        const SizedBox(height: Dimens.paddingMedium),
        CustomButton(
          minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
          label: Text("Simpan", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
          backgroundColor: ColorResources.primaryDark,
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
        ),
        const SizedBox(height: Dimens.paddingMedium),
      ],
    );
  }

  Widget _buildInformation() {
    _logic.initInformation(() => _navigateSelectUser());
    return Column(
      children: [
        CustomCard(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingPage),
            child: CustomFormInput(
              key: _logic.formKey,
              dataInputs: _logic.inputs,
              title: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.paddingWidget),
                child: Text(
                  "Data Pengujian",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox(height: Dimens.paddingMedium)),
        CustomButton(
          minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
          label: Text("Simpan", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
          backgroundColor: ColorResources.primaryDark,
          onPressed: _actionSaveInformationDialog,
        ),
        const SizedBox(height: Dimens.paddingMedium)
      ],
    );
  }

  Widget _buildDocuments() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: Dimens.paddingMedium),
          Image.asset(
            'assets/drawable/document.jpg',
            height: Dimens.iconBigSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Dimens.paddingMedium),
          _logic.initialized && _logic.examination.status == ExaminationStatus.PENDING_SIGNED ||
                  _logic.examination.status == ExaminationStatus.SIGNED
              ? Text(
                  _logic.initialized && _logic.examination.status == ExaminationStatus.PENDING_SIGNED
                      ? "Sedang menunggu ditandatangani."
                      : "Document sudah ditandatangani.",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _logic.initialized && _logic.examination.status == ExaminationStatus.PENDING_SIGNED
                            ? Colors.deepOrange
                            : Colors.green,
                      ),
                )
              : Text(
                  "Berikut document terlampir.",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: Dimens.paddingLarge),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
            child: CustomButton(
              minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
              icon: const Icon(Icons.file_download_outlined),
              label: Text("Laporan Akreditasi", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              backgroundColor: ColorResources.buttonBackground,
              onPressed: () => _generatePdfAkreditasi(),
            ),
          ),
          const SizedBox(height: Dimens.paddingSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMedium),
            child: CustomButton(
              minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
              icon: const Icon(Icons.file_download_outlined),
              label:
                  Text("Laporan Hasil Pengujian", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              backgroundColor: ColorResources.primary,
              onPressed: () => _generatePdfLHP(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: ColorResources.background,
          child: EasyStepper(
            fitWidth: true,
            activeStep: _logic.activeStep.index,
            direction: Axis.horizontal,
            enableStepTapping: true,
            stepShape: StepShape.circle,
            internalPadding: Dimens.paddingSmall,
            padding: const EdgeInsets.only(top: Dimens.paddingMedium),
            stepRadius: Dimens.cardStepRadius,
            showLoadingAnimation: false,
            activeStepIconColor: Colors.white,
            activeStepBorderColor: ColorResources.primary,
            activeStepBackgroundColor: ColorResources.primary,
            activeStepBorderType: BorderType.normal,
            unreachedStepBorderColor: Colors.blueGrey,
            unreachedStepIconColor: Colors.white,
            unreachedStepBackgroundColor: ColorResources.primaryDark,
            unreachedStepBorderType: BorderType.normal,
            finishedStepIconColor: Colors.white,
            finishedStepBackgroundColor: ColorResources.primaryDark,
            borderThickness: 2,
            lineStyle: const LineStyle(
              lineType: LineType.dotted,
              lineLength: Dimens.stepWidth,
              defaultLineColor: ColorResources.primaryDark,
            ),
            onStepReached: (index) {
              if (InputStep.values[index] == InputStep.documents) {
                if (_logic.examination.status == ExaminationStatus.SIGNED ||
                    _logic.examination.status == ExaminationStatus.PENDING_SIGNED ||
                    _logic.examination.status == ExaminationStatus.COMPLETED) {
                  setState(() => _logic.activeStep = InputStep.values[index]);
                } else {
                  MessageUtils.showMessage(
                    context: context,
                    content: "Document belum tersedia, silahkan lanjutkan selesaikan pengujian.",
                    title: "Document Belum Tersedia",
                  );
                }
              } else {
                setState(() => _logic.activeStep = InputStep.values[index]);
              }

              setState(() => _logic.activeStep = InputStep.values[index]);
            },
            steps: [
              EasyStep(
                icon: const Icon(Icons.insert_chart),
                // finishIcon: const Icon(Icons.check),
                customTitle: Text(
                  "Informasi",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              EasyStep(
                icon: const Icon(Icons.add_chart_outlined),
                // finishIcon: const Icon(Icons.check),
                customTitle: Text(
                  "Pengujian",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              EasyStep(
                icon: const Icon(Icons.file_copy_sharp),
                customTitle: Text(
                  "Documents",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap),
            child: _logic.activeStep == InputStep.information
                ? _buildInformation()
                : _logic.activeStep == InputStep.input
                    ? _buildInputForm()
                    : _buildDocuments(),
          ),
        ),
      ],
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
        centerTitle: true,
        backgroundColor: ColorResources.background,
        title: Text(EnumTranslationUtils.examinationType(widget.arguments.examination.typeOfExaminationName),
            style: Theme.of(context).textTheme.headlineLarge),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
        //     child: _logic.initialized && _logic.examination.status == ExaminationStatus.SIGNED
        //         ? IconButton(
        //             onPressed: _generatePdfAkreditasi,
        //             icon: const Icon(
        //               Icons.file_download_outlined,
        //               color: ColorResources.primaryDark,
        //               weight: Dimens.iconWeightAppbar,
        //               size: Dimens.iconSizeAppbar,
        //             ),
        //           )
        //         : IconButton(
        //             onPressed: !_logic.initialized
        //                 ? null
        //                 : _logic.examination.status == ExaminationStatus.PENDING
        //                     ? _actionSubmitOrSaveDialog
        //                     : _logic.examination.status == ExaminationStatus.REVISION_QC1 ||
        //                             _logic.examination.status == ExaminationStatus.REVISION_QC2 ||
        //                             _logic.examination.status == ExaminationStatus.REVISION_INPUT_LAB ||
        //                             _logic.examination.status == ExaminationStatus.REJECT_SIGNED
        //                         ? _actionSaveOrSubmitRevision
        //                         : _actionApprovalDialog,
        //             icon: const Icon(
        //               Symbols.check,
        //               color: ColorResources.primary,
        //               weight: Dimens.iconWeightAppbar,
        //               size: Dimens.iconSizeAppbar,
        //             ),
        //           ),
        //   ),
        // ],
      ),
      body: !_logic.initialized ? const CustomCircularProgressIndicator() : _buildBody(),
    );
  }
}
