import 'dart:convert';

import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class DeviceRequest {
  final int deviceId;

  DeviceRequest({required this.deviceId});

  Map<String, dynamic> toJson() => {'deviceId': deviceId};

  factory DeviceRequest.fromJson(Map<String, dynamic> json) {
    return DeviceRequest(deviceId: json['deviceId']);
  }
}

class CreateDeviceRequest extends MasterMessage {
  CreateDeviceRequest({
    required Device device,
    required super.token,
  }) : super(request: MasterRequestType.createDevice, content: jsonEncode(device), path: "devices/create-device");
}

class QueryDevicesRequest extends MasterMessage {
  QueryDevicesRequest({
    required DeviceFilter filter,
    required super.token,
  }) : super(
          request: MasterRequestType.queryDevices,
          content: jsonEncode(filter),
          path: "devices/query-devices",
        );
}

class GetDeviceRequest extends MasterMessage {
  GetDeviceRequest({
    required DeviceRequest deviceRequest,
    required super.token,
  }) : super(
          request: MasterRequestType.queryDevice,
          content: jsonEncode(deviceRequest),
          path: "devices/device",
        );
}

class UpdateDeviceRequest extends MasterMessage {
  UpdateDeviceRequest({
    required Device device,
    required super.token,
  }) : super(
          request: MasterRequestType.updateDevice,
          content: jsonEncode(device),
          path: "devices/update-device",
        );
}

class DeleteDeviceRequest extends MasterMessage {
  DeleteDeviceRequest({
    required DeviceRequest deviceRequest,
    required super.token,
  }) : super(
          request: MasterRequestType.deleteDevice,
          content: jsonEncode(deviceRequest),
          path: "devices/delete-device",
        );
}
