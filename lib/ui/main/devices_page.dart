import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/devices_cubit.dart';
import 'package:k3_sipp_mobile/logic/devices_logic.dart';
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
import 'package:k3_sipp_mobile/widget/apps_progress_dialog.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final DevicesLogic _logic = DevicesLogic();

  Future<void> _deleteDevice(Device device) async {
    var result = await DialogUtils.showAlertDialog(
      context,
      title: "Hapus Device",
      content: "Apakah Anda yakin akan menghapus ${device.name}?",
      neutralAction: "Tidak",
      onNeutral: () => navigatorKey.currentState?.pop(false),
      negativeAction: "Hapus",
      onNegative: () => navigatorKey.currentState?.pop(true),
    );

    if (result != null && !result) return;

    if (mounted) {
      final AppsProgressDialog progressDialog = AppsProgressDialog(context, "Loading", _logic.onDeleteDevice(device.id!));
      MasterMessage message = await progressDialog.show();
      switch (message.response) {
        case MasterResponseType.success:
          if (!TextUtils.isEmpty(message.content)) {
            if (mounted) {
              context.read<DevicesCubit>().deleteDevice(device.id!);
              await MessageUtils.showMessage(
                context: context,
                title: "Berhasil",
                content: "${device.name ?? ""} berhasil dihapus",
                dialog: true,
              );
            }
          }
          break;
        case MasterResponseType.notExist:
        case MasterResponseType.invalidCredential:
          if (mounted) DialogUtils.handleInvalidCredential(context, pinMode: false);
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
  }

  Future<void> _loadDevices({bool showDialog = true}) async {
    final AppsProgressDialog progressDialog = AppsProgressDialog(context, "Loading", _logic.onGetDevices());

    MasterMessage message = await progressDialog.show(showDialog: showDialog);
    print("message: ${message.response}");
    print("message content: ${message.content}");
    if(!TextUtils.isEmpty(message.token)) await DeviceRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          List<Device> devices = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Device device = Device.fromJson(element);
            devices.add(device);
          }

          if (mounted) context.read<DevicesCubit>().setDevices(devices);
        }
        break;
      case MasterResponseType.notExist:
      case MasterResponseType.invalidCredential:
        if (mounted) DialogUtils.handleInvalidCredential(context, pinMode: false);
        break;
      case MasterResponseType.invalidMessageFormat:
        if (mounted) DialogUtils.handleInvalidMessageFormat(context);
        break;
      case MasterResponseType.noConnection:
        if (mounted) DialogUtils.handleNoConnection(context);
        break;
      case MasterResponseType.invalidSession:
      case MasterResponseType.invalidToken:
        if (mounted) DialogUtils.handleInvalidSession(context);
        break;
      default:
        if (mounted) DialogUtils.handleException(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Tools", style: Theme.of(context).textTheme.headlineLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState!.pushNamed("/create_device"),
        shape: const CircleBorder(),
        backgroundColor: ColorResources.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<DevicesCubit, List<Device>>(
        builder: (BuildContext context, state) => RefreshIndicator(
          onRefresh: () => _loadDevices(showDialog: false),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
            child: ListView.separated(
              itemCount: state.length,
              itemBuilder: (context, index) {
                Device device = state.elementAt(index);
                return CustomCard(
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
                    focusColor: Colors.red,
                    leading: const Icon(Icons.devices, size: Dimens.iconSize),
                    title: Text(device.name!, style: Theme.of(context).textTheme.headlineSmall),
                    subtitle: Text(device.description!, style: Theme.of(context).textTheme.labelSmall),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Calibration: ${device.calibrationValue}", style: Theme.of(context).textTheme.labelSmall),
                        Text("CF: ${device.coverageFactor}", style: Theme.of(context).textTheme.labelSmall),
                        Text("U95: ${device.u95}", style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                    onTap: () => navigatorKey.currentState?.pushNamed("/update_device", arguments: device),
                    onLongPress: () => _deleteDevice(device),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingSmall),
            ),
          ),
        ),
      ),
    );
  }
}
