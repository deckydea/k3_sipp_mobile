import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/devices_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class DeviceLogic {
  final GlobalKey<CustomFormInputState> formKey = GlobalKey();
  final List<DataInput> inputs = [];

  final TextInput textInputName = TextInput(
    label: "Nama Alat",
    required: true,
    icon: const Icon(Icons.monitor),
  );

  final NumericInput textInputCalibrationValue = NumericInput(
    label: "Value Kalibrasi",
    required: true,
    icon: const Icon(Icons.confirmation_number_outlined),
  );

  final NumericInput textInputU95 = NumericInput(
    label: "U95",
    required: true,
    icon: const Icon(Icons.numbers_outlined),
  );

  final NumericInput textInputCoverageFactor = NumericInput(
    label: "K (Coverage Factor)",
    required: true,
    icon: const Icon(Icons.landscape_outlined),
  );

  final TextInput textInputNomorSeriAlat = TextInput(
    label: "Nomor Seri",
    required: true,
    icon: const Icon(Icons.keyboard),
  );

  final TextInput textInputNegaraPembuat = TextInput(
    label: "Negara Pembuat",
    required: true,
    icon: const Icon(Icons.flag_circle),
  );

  final TextInput textInputInstansiPengkalibrasi = TextInput(
    label: "Instansi Pengkalibrasi",
    required: true,
    icon: const Icon(Icons.account_balance_sharp),
  );

  final DateInput dateInputTanggalKalibrasiEksternalTerakhir = DateInput(
    label: "Tanggal Kalibrasi External Terakhir",
    required: false,
    maxDate: DateTime.now().add(const Duration(days: 200 * 365)),
    minDate: DateTime.now().subtract(const Duration(days: 200 * 365)),
    icon: const Icon(Icons.calendar_month),
  );

  final TextAreaInput textInputDescription = TextAreaInput(
    label: "Deskripsi",
    required: false,
    icon: const Icon(Icons.sticky_note_2_rounded),
  );

  Device? _device;
  bool isUpdate = false;

  void initRegisterUpdate({Device? device}) {
    _device = device;
    isUpdate = _device != null;
    if (isUpdate) {
      textInputName.setValue(device!.name ?? "");
      textInputCalibrationValue.setValue(device.calibrationValue.toString());
      textInputU95.setValue(device.u95.toString());
      textInputCoverageFactor.setValue(device.coverageFactor.toString());
      textInputNomorSeriAlat.setValue(device.nomorSeriAlat ?? "");
      textInputNegaraPembuat.setValue(device.negaraPembuat ?? "");
      textInputInstansiPengkalibrasi.setValue(device.instansiPengkalibrasi ?? "");

      dateInputTanggalKalibrasiEksternalTerakhir.setSelectedDate(device.tanggalKalibrasiEksternalTerakhir);
      textInputDescription.setValue(device.description ?? "");
    }

    inputs.clear();
    inputs.add(textInputName);
    inputs.add(textInputCalibrationValue);
    inputs.add(textInputU95);
    inputs.add(textInputCoverageFactor);
    inputs.add(textInputNomorSeriAlat);
    inputs.add(textInputNegaraPembuat);
    inputs.add(textInputInstansiPengkalibrasi);
    inputs.add(dateInputTanggalKalibrasiEksternalTerakhir);
    inputs.add(textInputDescription);
  }

  void setDevice(Device? device) => _device = device;

  Device? get device => _device;

  Future<MasterMessage> onCreateDevice() async {
    if (formKey.currentState!.validate()) {
      String name = textInputName.value;
      String description = textInputDescription.value;
      double? calibrationValue = double.tryParse(textInputCalibrationValue.value);
      double? u95 = double.tryParse(textInputU95.value);
      double? coverageFactor = double.tryParse(textInputCoverageFactor.value);
      String nomorSeriAlat = textInputNomorSeriAlat.value;
      String negaraPembuat = textInputNegaraPembuat.value;
      String instansiPengkalibrasi = textInputInstansiPengkalibrasi.value;
      DateTime tanggalKalibrasiEksternalTerakhir = dateInputTanggalKalibrasiEksternalTerakhir.selectedDate!;

      Device device = Device(
        name: name,
        description: description,
        calibrationValue: calibrationValue,
        u95: u95,
        coverageFactor: coverageFactor,
        nomorSeriAlat: nomorSeriAlat,
        negaraPembuat: negaraPembuat,
        instansiPengkalibrasi: instansiPengkalibrasi,
        tanggalKalibrasiEksternalTerakhir: tanggalKalibrasiEksternalTerakhir,
      );

      String? token = await AppRepository().getToken();
      return await ConnectionUtils.sendRequest(CreateDeviceRequest(device: device, token: token));
    }

    return MasterMessage(response: MasterResponseType.failed);
  }

  Future<MasterMessage> onGetDevice(int deviceId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(GetDeviceRequest(deviceRequest: DeviceRequest(deviceId: deviceId), token: token));
  }

  Future<MasterMessage> onUpdateDevice() async {
    if (formKey.currentState!.validate() && _device != null) {
      String name = textInputName.value;
      String description = textInputDescription.value;
      double? calibrationValue = double.tryParse(textInputCalibrationValue.value);
      double? u95 = double.tryParse(textInputU95.value);
      double? coverageFactor = double.tryParse(textInputCoverageFactor.value);
      String nomorSeriAlat = textInputNomorSeriAlat.value;
      String negaraPembuat = textInputNegaraPembuat.value;
      String instansiPengkalibrasi = textInputInstansiPengkalibrasi.value;
      DateTime tanggalKalibrasiEksternalTerakhir = dateInputTanggalKalibrasiEksternalTerakhir.selectedDate!;

      Device replica = _device!.replica;
      replica.name = name;
      replica.description = description;
      replica.calibrationValue = calibrationValue;
      replica.u95 = u95;
      replica.coverageFactor = coverageFactor;
      replica.nomorSeriAlat = nomorSeriAlat;
      replica.negaraPembuat = negaraPembuat;
      replica.instansiPengkalibrasi = instansiPengkalibrasi;
      replica.tanggalKalibrasiEksternalTerakhir = tanggalKalibrasiEksternalTerakhir;


      String? token = await AppRepository().getToken();
      return await ConnectionUtils.sendRequest(UpdateDeviceRequest(device: replica, token: token));
    }

    return MasterMessage(response: MasterResponseType.failed);
  }

  Future<MasterMessage> onDeleteDevice(int deviceId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(DeleteDeviceRequest(deviceRequest: DeviceRequest(deviceId: deviceId), token: token));
  }
}
