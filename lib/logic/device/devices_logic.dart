import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/devices_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

class DevicesLogic {
  final GlobalKey<CustomSearchFieldState> searchKey = GlobalKey();
  String searchKeywords = "";

  Future<MasterMessage> queryDevices({String? query}) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(
        QueryDevicesRequest(token: token, filter: DeviceFilter(upperBoundEpoch: null, resultSize: null, name: query)));
  }

  Future<MasterMessage> onDeleteDevice(int deviceId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(DeleteDeviceRequest(deviceRequest: DeviceRequest(deviceId: deviceId), token: token));
  }
}
