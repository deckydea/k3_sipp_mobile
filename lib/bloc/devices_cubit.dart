import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';

class DevicesCubit extends Cubit<List<Device>> {
  final Map<int, Device> _deviceMap = {};
  DevicesCubit() : super([]);

  // Define methods to update the state
  void setDevices(List<Device> devices) {
    for (var device in devices) {
      _deviceMap[device.id!] = device;
    }

    emit(devices);
  }

  void addDevice(Device device){
    _deviceMap[device.id!] = device;
    _notify();
  }

  void deleteDevice(int id){
    _deviceMap.remove(id);
    _notify();
  }

  void updateDevice(Device updatedDevice){
    _deviceMap[updatedDevice.id!] = updatedDevice;
    _notify();
  }


  void _notify(){
    emit(_deviceMap.values.toList());
  }
}