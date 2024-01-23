import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/devices_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class DeviceLogic{

  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController calibrationValueController = TextEditingController();
  final TextEditingController u95Controller = TextEditingController();
  final TextEditingController coverageFactorController = TextEditingController();

  Device? _device;
  bool isUpdate = false;


  void initRegisterUpdate({Device? device}) {
    _device = device;
    isUpdate = _device != null;
  }

  void setDevice(Device? device)=> _device = device;

  Device? get device => _device;

  Future<MasterMessage> onCreateDevice() async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String description = descriptionController.text;
      double? calibrationValue = double.tryParse(calibrationValueController.text);
      double? u95 = double.tryParse(u95Controller.text);
      double? coverageFactor = double.tryParse(coverageFactorController.text);

      Device device = Device(
        name: name,
        description: description,
        calibrationValue: calibrationValue,
        u95: u95,
        coverageFactor: coverageFactor,
      );

      String? token = await AppRepository().getToken();
      MasterMessage message = CreateDeviceRequest(device: device, token: token);
      return await ConnectionUtils.sendRequest(message);
    }

    return MasterMessage(response: MasterResponseType.failed);
  }

  Future<MasterMessage> onGetDevice(int deviceId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(GetDeviceRequest(deviceRequest: DeviceRequest(deviceId: deviceId), token: token));
  }

  Future<MasterMessage> onUpdateDevice() async {
    if (formKey.currentState!.validate() && _device != null) {
      String name = nameController.text;
      String description = descriptionController.text;
      double? calibrationValue = double.tryParse(calibrationValueController.text);
      double? u95 = double.tryParse(u95Controller.text);
      double? coverageFactor = double.tryParse(coverageFactorController.text);

      Device replica = _device!.replica;
      replica.name = name;
      replica.description = description;
      replica.calibrationValue = calibrationValue;
      replica.u95 = u95;
      replica.coverageFactor = coverageFactor;

      String? token = await AppRepository().getToken();
      MasterMessage message = UpdateDeviceRequest(device: replica, token: token);
      return await ConnectionUtils.sendRequest(message);
    }

    return MasterMessage(response: MasterResponseType.failed);
  }

  Future<MasterMessage> onDeleteDevice(int deviceId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(DeleteDeviceRequest(deviceRequest: DeviceRequest(deviceId: deviceId), token: token));
  }
}