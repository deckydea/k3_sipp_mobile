import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/device/devices_bloc.dart';
import 'package:k3_sipp_mobile/logic/device/device_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

class DevicePage extends StatefulWidget {
  final Device? device;

  const DevicePage({super.key, required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final DeviceLogic _logic = DeviceLogic();

  Future<void> _actionUpdate() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Memperbarui...", _logic.onUpdateDevice());

    MasterMessage message = await progressDialog.show();
    if(!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Device device = Device.fromJson(jsonDecode(message.content!));
          _logic.setDevice(null);
          if (mounted) {
            context.read<DevicesBloc>().add(UpdateDeviceEvent(device));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${device.name ?? ""} berhasil diperbarui",
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

  Future<void> _actionCreate() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Mendaftarkan...", _logic.onCreateDevice());

    MasterMessage message = await progressDialog.show();
    if(!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          Device device = Device.fromJson(jsonDecode(message.content!));
          _logic.setDevice(null);
          if (mounted) {
            context.read<DevicesBloc>().add(AddDeviceEvent(device));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${device.name ?? ""} berhasil ditambahkan",
            );
          }
          navigatorKey.currentState?.pop(device);
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: Form(
        key: _logic.formKey,
        child: Column(
          children: [
            CustomEditText(
              width: double.infinity,
              label: "Nama Alat",
              controller: _logic.nameController,
              icon: const Icon(Icons.monitor, color: Colors.black, size: Dimens.iconSize),
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              width: double.infinity,
              label: "Deskripsi",
              controller: _logic.descriptionController,
              icon: const Icon(Icons.description, color: Colors.black, size: Dimens.iconSize),
              validator: (value) => ValidatorUtils.validateInputLength(context, value, 0, 200),
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              width: double.infinity,
              label: "Value Kalibrasi",
              controller: _logic.calibrationValueController,
              icon: const Icon(Icons.confirmation_number_outlined, color: Colors.black, size: Dimens.iconSize),
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              width: double.infinity,
              label: "U95",
              icon: const Icon(Icons.numbers_outlined, color: Colors.black, size: Dimens.iconSize),
              controller: _logic.u95Controller,
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            CustomEditText(
              width: double.infinity,
              label: "K (Coverage Factor)",
              controller: _logic.coverageFactorController,
              icon: const Icon(Icons.landscape_outlined, color: Colors.black, size: Dimens.iconSize),
              validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: Dimens.paddingMedium),
            CustomButton(
              minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
              label: Text(_logic.isUpdate ? "Update" : "Daftar",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              backgroundColor: ColorResources.primary,
              onPressed: _logic.isUpdate ? _actionUpdate : _actionCreate,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _logic.initRegisterUpdate(device: widget.device);
    if (_logic.isUpdate) {
      _logic.nameController.text = widget.device!.name!;
      _logic.descriptionController.text = widget.device!.description!;
      _logic.calibrationValueController.text = widget.device!.calibrationValue!.toString();
      _logic.u95Controller.text = widget.device!.u95!.toString();
      _logic.coverageFactorController.text = widget.device!.coverageFactor!.toString();
    }
  }

  @override
  void dispose() {
    _logic.nameController.dispose();
    _logic.coverageFactorController.dispose();
    _logic.calibrationValueController.dispose();
    _logic.u95Controller.dispose();
    _logic.descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text(_logic.isUpdate ? "${_logic.device!.name}" : "Create Device",
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}
