import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/logic/device/devices_logic.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

@immutable
abstract class DevicesEvent {}

class FetchDevicesEvent extends DevicesEvent {
  final String? query;

  FetchDevicesEvent({this.query});
}

class AddDeviceEvent extends DevicesEvent {
  final Device device;

  AddDeviceEvent(this.device);
}

class UpdateDeviceEvent extends DevicesEvent {
  final Device device;

  UpdateDeviceEvent(this.device);
}

class DeleteDeviceEvent extends DevicesEvent {
  final int id;

  DeleteDeviceEvent(this.id);
}

@immutable
abstract class DevicesState {}

class DevicesEmptyState extends DevicesState {}

class DevicesLoadingState extends DevicesState {}

class DevicesLoadedState extends DevicesState {
  final List<Device> devices;

  DevicesLoadedState(this.devices);
}

class DevicesErrorState extends DevicesState {}

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final DevicesLogic _logic = DevicesLogic();
  final Map<int, Device> _deviceMap = {};

  DevicesBloc() : super(DevicesEmptyState()) {
    on<FetchDevicesEvent>((event, emit) async {
      emit(DevicesLoadingState());
      try {
        MasterMessage message = await _logic.queryDevices(query: event.query);
        if (message.response == MasterResponseType.success) {
          _deviceMap.clear();
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Device device = Device.fromJson(element);
            _deviceMap[device.id!] = device;
          }
          emit(DevicesLoadedState(_reverse()));
        } else {
          emit(DevicesErrorState());
        }
      } catch (_) {
        emit(DevicesErrorState());
      }
    });

    on<AddDeviceEvent>((event, emit) {
      _deviceMap[event.device.id!] = event.device;
      emit(DevicesLoadedState(_reverse()));
    });

    on<UpdateDeviceEvent>((event, emit) {
      _deviceMap[event.device.id!] = event.device;
      emit(DevicesLoadedState(_reverse()));
    });

    on<DeleteDeviceEvent>((event, emit) {
      _deviceMap.remove(event.id);
      emit(DevicesLoadedState(_reverse()));
    });
  }

  List<Device> _reverse() {
    return _deviceMap.values.toList().reversed.toList();
  }
}
