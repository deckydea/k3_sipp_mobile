import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/device/devices_bloc.dart';
import 'package:k3_sipp_mobile/logic/device/device_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
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

class DevicePage extends StatefulWidget {
  final Device? device;

  const DevicePage({super.key, this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final DeviceLogic _logic = DeviceLogic();

  Future<void> _actionUpdate() async {
    final ProgressDialog progressDialog = ProgressDialog("Memperbarui...", _logic.onUpdateDevice());

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
    final ProgressDialog progressDialog = ProgressDialog("Mendaftarkan...", _logic.onCreateDevice());

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
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _logic.initRegisterUpdate(device: widget.device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text(_logic.isUpdate ? "${_logic.device!.name}" : "Register Device",
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}