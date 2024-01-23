import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/assignment/device_calibration_cubit.dart';
import 'package:k3_sipp_mobile/logic/examination/add_examination_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dropdown_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:k3_sipp_mobile/widget/device/device_calibration_form.dart';
import 'package:k3_sipp_mobile/widget/device/device_calibration_row.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

class AddExaminationPage extends StatefulWidget {
  final Examination? examination;

  const AddExaminationPage({super.key, this.examination});

  @override
  State<AddExaminationPage> createState() => _AddExaminationPageState();
}

class _AddExaminationPageState extends State<AddExaminationPage> {
  final GlobalKey<DeviceCalibrationFormState> _addCalibrationFormKey = GlobalKey();
  final AddExaminationLogic _logic = AddExaminationLogic();

  void _actionAdd() {
    List<DeviceCalibration> deviceCalibrations = context.read<DeviceCalibrationCubit>().state.deviceCalibrationMap != null
        ? context.read<DeviceCalibrationCubit>().state.deviceCalibrationMap!.values.toList()
        : [];

    if (deviceCalibrations.isEmpty) {
      //TODO: Handle this
      MessageUtils.showMessage(
          context: context, content: "Tidak ada alat. Silahkan tambahkan alat terlebih dahulu", title: "Warning", dialog: true);
      return;
    }

    if (_logic.formKey.currentState!.validate()) {
      Examination examination = Examination(
        petugasId: _logic.petugasId!,
        metode: _logic.metodeController.text,
        deviceCalibrations: deviceCalibrations,
        typeOfExaminationId: _logic.selectedExaminationType!.id,
      );

      navigatorKey.currentState?.pop(examination);
    }
  }

  Future<void> _navigateToSelectUser() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_user");
    if (result != null && result is User) {
      _logic.petugasController.text = result.name;
      _logic.petugasId = result.id;
    }
  }

  void _loadDropDown(List<ExaminationType> types) {
    _logic.dropdownExaminationTypes.clear();

    for (ExaminationType type in types) {
      _logic.dropdownExaminationTypes.add(
        DropdownMenuItem(
          value: type,
          child: Text(type.name.toCapitalize(), style: Theme.of(context).textTheme.titleSmall),
        ),
      );
    }

    _logic.selectedExaminationType = types.first;
  }

  Future<void> _loadExaminationTypes() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Loading...", _logic.loadExaminationTypes());

    MasterMessage message = await progressDialog.show();
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          List<ExaminationType> types = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            ExaminationType type = ExaminationType.fromJson(element);
            types.add(type);
          }
          _loadDropDown(types);
          _logic.initialized = true;
          setState(() {});
        }
        break;
      case MasterResponseType.notExist:
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

  Widget _buildDeviceCalibrations() {
    return BlocBuilder<DeviceCalibrationCubit, DeviceCalibrationState>(
      builder: (context, state) {
        Iterable<DeviceCalibration>? deviceCalibrations = state.deviceCalibrationMap?.values.toList().reversed;
        if (deviceCalibrations == null || deviceCalibrations.isEmpty) {
          return const Center(child: Text("Tidak ada alat, silahkan tambahkan alat."));
        } else {
          return Expanded(
            child: ListView.builder(
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
                        onCancel: () => insideState(() => isUpdate = false),
                        onSave: (calibration) {
                          context.read<DeviceCalibrationCubit>().setDeviceCalibration(calibration);
                          insideState(() => isUpdate = false);
                        },
                        onUpdate: (calibration) {
                          context.read<DeviceCalibrationCubit>().setDeviceCalibration(calibration);
                          insideState(() => isUpdate = false);
                        },
                        hide: false,
                      );
                    }
                  },
                );
              },
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
              onCancel: () => _addCalibrationFormKey.currentState?.hide(true),
              onSave: (calibration) {
                context.read<DeviceCalibrationCubit>().setDeviceCalibration(calibration);
                _addCalibrationFormKey.currentState?.hide(true);
              },
            ),
            const SizedBox(height: Dimens.paddingSmall),
            _buildDeviceCalibrations(),
            const SizedBox(height: Dimens.paddingMedium),
            CustomButton(
              minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
              label: Text("Tambahkan", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
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
