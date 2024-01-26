import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/device/devices_bloc.dart';
import 'package:k3_sipp_mobile/logic/device/devices_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';
import 'package:k3_sipp_mobile/widget/device/device_row.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

enum DevicesPageMode { selectDevice, deviceList }

class DevicesPage extends StatefulWidget {
  final DevicesPageMode pageMode;

  const DevicesPage({super.key, required this.pageMode});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final DevicesLogic _logic = DevicesLogic();

  void _navigateTo(Device device) {
    switch (widget.pageMode) {
      case DevicesPageMode.selectDevice:
        navigatorKey.currentState?.pop(device);
        return;
      case DevicesPageMode.deviceList:
        navigatorKey.currentState?.pushNamed("/update_device", arguments: device);
        return;
    }
  }

  void _updateSearchText(String query) {
    _logic.searchKeywords = query;
    context.read<DevicesBloc>().add(FetchDevicesEvent(query: _logic.searchKeywords));
  }

  Future<void> _deleteDevice(Device device) async {
    if (widget.pageMode != DevicesPageMode.deviceList) return;

    var result = await DialogUtils.showAlertDialog(
      context,
      dismissible: false,
      title: "Hapus Device",
      content: "Apakah Anda yakin akan menghapus ${device.name}?",
      neutralAction: "Tidak",
      onNeutral: () => navigatorKey.currentState?.pop(false),
      negativeAction: "Hapus",
      onNegative: () => navigatorKey.currentState?.pop(true),
    );

    if (result == null || !result) return;

    if (mounted) {
      final ProgressDialog progressDialog = ProgressDialog(context, "Loading", _logic.onDeleteDevice(device.id!));
      MasterMessage message = await progressDialog.show();
      switch (message.response) {
        case MasterResponseType.success:
          if (mounted) {
            context.read<DevicesBloc>().add(DeleteDeviceEvent(device.id!));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${device.name ?? ""} berhasil dihapus",
              dialog: false,
            );
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
  }

  Widget _buildDevices(List<Device> devices) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        Device device = devices.elementAt(index);
        return DeviceRow(
          device: device,
          onTap: () => _navigateTo(device),
          onLongPress: () => _deleteDevice(device),
        );
      },
    );
  }

  Widget _buildNoData() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Tidak ada alat.",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Our service is currently unavailable.",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => const CustomShimmer(),
      separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: RefreshIndicator(
        onRefresh: () async => context.read<DevicesBloc>().add(FetchDevicesEvent(query: _logic.searchKeywords)),
        child: Column(
          children: [
            CustomCard(
              child: CustomSearchField(
                key: _logic.searchKey,
                onFieldSubmitted: (value) async => _updateSearchText(value),
                onClearText: () {
                  _logic.searchKey.currentState?.clearText();
                  _updateSearchText("");
                },
              ),
            ),
            const SizedBox(height: Dimens.paddingWidget),
            Expanded(
              child: BlocBuilder<DevicesBloc, DevicesState>(
                builder: (context, state) {
                  if (state is DevicesLoadingState) {
                    return _buildShimmer();
                  } else if (state is DevicesLoadedState) {
                    if (state.devices.isNotEmpty) {
                      return _buildDevices(state.devices);
                    } else {
                      return _buildNoData();
                    }
                  } else {
                    return _buildError();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<DevicesBloc>().add(FetchDevicesEvent(query: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Alat", style: Theme.of(context).textTheme.headlineLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState?.pushNamed("/create_device"),
        backgroundColor: ColorResources.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildBody(),
    );
  }
}
