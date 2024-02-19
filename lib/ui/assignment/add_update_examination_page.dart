import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/examination/device_calibration_cubit.dart';
import 'package:k3_sipp_mobile/logic/examination/add_examination_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/repository/examination_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/other/date_picker.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dialog.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dropdown_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:k3_sipp_mobile/widget/device/device_calibration_form.dart';
import 'package:k3_sipp_mobile/widget/device/device_calibration_row.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddOrUpdateExaminationPage extends StatefulWidget {
  final Examination? examination;

  const AddOrUpdateExaminationPage({super.key, this.examination});

  @override
  State<AddOrUpdateExaminationPage> createState() => _AddOrUpdateExaminationPageState();
}

class _AddOrUpdateExaminationPageState extends State<AddOrUpdateExaminationPage> {
  final GlobalKey<DeviceCalibrationFormState> _addCalibrationFormKey = GlobalKey();
  final AddExaminationLogic _logic = AddExaminationLogic();

  void _actionAdd() {
    List<DeviceCalibration> deviceCalibrations = context.read<DeviceCalibrationCubit>().state.deviceCalibrationMap != null
        ? context.read<DeviceCalibrationCubit>().state.deviceCalibrationMap!.values.toList()
        : [];

    if (deviceCalibrations.isEmpty) {
      MessageUtils.showMessage(
          context: context, content: "Tidak ada alat. Silahkan tambahkan alat terlebih dahulu", title: "Warning", dialog: true);
      return;
    }

    if (_logic.formKey.currentState!.validate()) {
      Examination examination;
      if (widget.examination != null) {
        examination = widget.examination!.replica();
        examination.petugasId = _logic.selectedPetugas!.id!;
        examination.petugasName = _logic.selectedPetugas!.name;
        examination.metode = _logic.metodeController.text;
        examination.deviceCalibrations = deviceCalibrations;
        examination.typeOfExaminationName = _logic.selectedExaminationType!.name;
        examination.deadlineDate = _logic.selectedDeadline;
      } else {
        examination = Examination(
          petugasId: _logic.selectedPetugas!.id!,
          petugasName: _logic.selectedPetugas!.name,
          metode: _logic.metodeController.text,
          deviceCalibrations: deviceCalibrations,
          typeOfExaminationName: _logic.selectedExaminationType!.name,
          deadlineDate: _logic.selectedDeadline,
        );
      }

      context.read<DeviceCalibrationCubit>().clear();

      navigatorKey.currentState?.pop(examination);
    }
  }

  Future<void> _navigateToSelectUser() async {
    var result = await navigatorKey.currentState
        ?.pushNamed("/select_user", arguments: UserFilter(userAccessMenu: _logic.selectedExaminationType?.accessMenu));
    if (result != null && result is User) {
      _logic.selectedPetugas = result;
      _logic.petugasController.text = result.name;
    }
  }

  Future<void> _loadExaminationTypes() async {
    List<ExaminationType> types = await ExaminationRepository().getExaminationTypes();
    if (mounted) {
      _logic.dropdownExaminationTypes.clear();

      for (ExaminationType type in types) {
        _logic.dropdownExaminationTypes.add(
          DropdownMenuItem(
            value: type,
            enabled: type.name == ExaminationTypeName.kebisingan || type.name == ExaminationTypeName.penerangan,
            child: Text(type.examinationTypeName, style: Theme.of(context).textTheme.titleSmall),
          ),
        );

        if (widget.examination != null && widget.examination!.typeOfExaminationName == type.name ) {
          _logic.selectedExaminationType = type;
        }
      }

      _logic.selectedExaminationType ??= types.firstWhere((element) => element.name == ExaminationTypeName.kebisingan);
      _logic.initialized = true;
    }

    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now().toLocal();
    final DateTime maxDate = now.add(const Duration(days: 200 * 365));
    final DateTime minDate = now;

    DatePickerArgument argument = DatePickerArgument(
      mode: DateRangePickerSelectionMode.single,
      selectedDate: _logic.selectedDeadline,
      minDate: minDate,
      maxDate: maxDate,
    );

    var result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CustomDialog(
        width: Dimens.dialogWidthSmall,
        height: Dimens.dialogWidthSmall,
        child: DatePickerPage(argument: argument),
      ),
    );

    if (result != null && result is DateTime) {
      setState(() {
        _logic.selectedDeadline = result;
        _logic.deadlineController.text = DateTimeUtils.formatToDate(result);
      });
    }
  }

  Widget _buildDeviceCalibrations() {
    return BlocBuilder<DeviceCalibrationCubit, DeviceCalibrationState>(
      builder: (context, state) {
        Iterable<DeviceCalibration>? deviceCalibrations = state.deviceCalibrationMap?.values.toList().reversed;
        if (deviceCalibrations == null || deviceCalibrations.isEmpty) {
          return Center(
            child: Text(
              "Tidak ada alat, silahkan tambahkan alat.",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.deepOrange),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: deviceCalibrations.length,
            itemBuilder: (context, index) {
              DeviceCalibration deviceCalibration = deviceCalibrations.elementAt(index);
              bool isUpdate = false;
              return StatefulBuilder(
                builder: (BuildContext context, insideState) {
                  if (!isUpdate) {
                    return GestureDetector(
                      onTap: () => insideState(() => isUpdate = true),
                      child: DeviceCalibrationRow(
                        deviceCalibration: deviceCalibration,
                        onDelete: (deviceCalibration) =>
                            context.read<DeviceCalibrationCubit>().deleteDeviceCalibration(deviceCalibration),
                      ),
                    );
                  } else {
                    return DeviceCalibrationForm(
                      deviceCalibration: deviceCalibration,
                      needCalibrationInternal: _logic.selectedExaminationType!.name != ExaminationTypeName.penerangan,
                      onCancel: () => insideState(() => isUpdate = false),
                      onSave: (calibration) {
                        context.read<DeviceCalibrationCubit>().addOrUpdateDeviceCalibration(calibration);
                        insideState(() => isUpdate = false);
                      },
                      onUpdate: (calibration) {
                        context.read<DeviceCalibrationCubit>().addOrUpdateDeviceCalibration(calibration);
                        insideState(() => isUpdate = false);
                      },
                      hide: false,
                    );
                  }
                },
              );
            },
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomEditText(
              label: "Metode",
              controller: _logic.metodeController,
              width: double.infinity,
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomDropdownButton(
              items: _logic.dropdownExaminationTypes,
              value: _logic.selectedExaminationType,
              width: double.infinity,
              onChanged: (value) => value != null ? setState(() => _logic.selectedExaminationType = value) : null,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              label: "Petugas",
              controller: _logic.petugasController,
              width: double.infinity,
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.text,
              onTap: _navigateToSelectUser,
              readOnly: true,
              cursorVisible: false,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              label: "Deadline Pengujian",
              width: double.infinity,
              controller: _logic.deadlineController,
              readOnly: true,
              cursorVisible: false,
              icon: Icon(TextUtils.isEmpty(_logic.deadlineController.text) ? Icons.calendar_month : Icons.cancel_outlined),
              onIconTap: !TextUtils.isEmpty(_logic.deadlineController.text) ? () => _logic.deadlineController.text = "" : null,
              onTap: () => _selectDate(context),
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: Dimens.paddingLarge, child: Divider()),
            Row(
              children: [
                Expanded(
                    child: Text("Kalibrasi Alat",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorResources.primaryDark))),
                CustomCard(
                  color: ColorResources.primary,
                  borderRadius: Dimens.cardRadiusXLarge,
                  onTap: () => _addCalibrationFormKey.currentState?.hide(false),
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
            const SizedBox(height: Dimens.paddingMedium),
            DeviceCalibrationForm(
              key: _addCalibrationFormKey,
              needCalibrationInternal: _logic.selectedExaminationType!.name != ExaminationTypeName.penerangan,
              onCancel: () => _addCalibrationFormKey.currentState?.hide(true),
              onSave: (calibration) {
                context.read<DeviceCalibrationCubit>().addOrUpdateDeviceCalibration(calibration);
                _addCalibrationFormKey.currentState?.hide(true);
              },
            ),
            const SizedBox(height: Dimens.paddingSmall),
            Expanded(child: _buildDeviceCalibrations()),
            const SizedBox(height: Dimens.paddingMedium),
            CustomButton(
              minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
              label: Text(widget.examination != null ? "Update" : "Tambahkan",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              backgroundColor: ColorResources.primaryDark,
              onPressed: _actionAdd,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.examination != null) {
      _logic.metodeController.text = widget.examination!.metode;
      _logic.petugasController.text = widget.examination!.petugasName;
      _logic.selectedPetugas =
          User(id: widget.examination!.petugasId, name: widget.examination!.petugasName, username: '', nip: '');
      if (widget.examination!.analisId != null) {
        _logic.selectedAnalis =
            User(id: widget.examination!.analisId, name: widget.examination!.analisName!, username: '', nip: '');
      }
      if(widget.examination!.deadlineDate != null) {
        _logic.selectedDeadline = widget.examination!.deadlineDate;
        _logic.deadlineController.text = DateTimeUtils.formatToDate(widget.examination!.deadlineDate!);

      }
      context.read<DeviceCalibrationCubit>().setDeviceCalibration(widget.examination!.deviceCalibrations);
    }
  }

  @override
  void deactivate() {
    context.read<DeviceCalibrationCubit>().clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (!_logic.initialized) _loadExaminationTypes();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Tambah Jenis Pengujian", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}
