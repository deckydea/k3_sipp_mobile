import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class DeviceCalibrationState extends Equatable {
  final Map<int, DeviceCalibration>? deviceCalibrationMap;

  const DeviceCalibrationState({this.deviceCalibrationMap});

  DeviceCalibrationState copyWith({Map<int, DeviceCalibration>? deviceCalibrationMap}) =>
      DeviceCalibrationState(deviceCalibrationMap: deviceCalibrationMap ?? this.deviceCalibrationMap);

  @override
  List<Object?> get props => [deviceCalibrationMap];
}

class DeviceCalibrationCubit extends Cubit<DeviceCalibrationState> {
  DeviceCalibrationCubit() : super(const DeviceCalibrationState(deviceCalibrationMap: {}));

  void addOrUpdateDeviceCalibration(DeviceCalibration deviceCalibration) {
    final updatedMap = Map<int, DeviceCalibration>.from(state.deviceCalibrationMap ?? {});
    deviceCalibration.id ??= TextUtils.generateRandomInt();
    updatedMap[deviceCalibration.id!] = deviceCalibration;
    emit(state.copyWith(deviceCalibrationMap: updatedMap));
  }

  void deleteDeviceCalibration(DeviceCalibration deviceCalibration) {
    final updatedMap = Map<int, DeviceCalibration>.from(state.deviceCalibrationMap ?? {});
    updatedMap.remove(deviceCalibration.id);
    emit(state.copyWith(deviceCalibrationMap: updatedMap));
  }

  void setDeviceCalibration(List<DeviceCalibration> deviceCalibrations) {
    Map<int, DeviceCalibration>? deviceCalibrationMap = {};
    for (DeviceCalibration calibration in deviceCalibrations) {
      deviceCalibrationMap[calibration.id ?? TextUtils.generateRandomInt()] = calibration;
    }
    emit(state.copyWith(deviceCalibrationMap: deviceCalibrationMap));
  }

  void clear() {
    emit(const DeviceCalibrationState(deviceCalibrationMap: {}));
  }
}
