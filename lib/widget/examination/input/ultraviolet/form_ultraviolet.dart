import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class FormUltravioletPage extends StatefulWidget {
  final Function(Map<Posisi, DataUltraviolet>)? onUpdate;
  final Function(Map<Posisi, DataUltraviolet>)? onAdd;
  final Function(Map<Posisi, DataUltraviolet>)? onDelete;
  final Map<Posisi, DataUltraviolet>? data;

  const FormUltravioletPage({super.key, this.onUpdate, this.onAdd, this.onDelete, this.data});

  @override
  State<FormUltravioletPage> createState() => _FormUltravioletPageState();
}

class _FormUltravioletPageState extends State<FormUltravioletPage> {
  final GlobalKey<CustomFormInputState> _formKey = GlobalKey();
  final List<DataInput> _inputs = [];

  final TimeInput _time = TimeInput(label: "Waktu", required: true);
  final TextInput _location = TextInput(label: "Lokasi", required: true);
  final NumericInput _jumlahTK = NumericInput(label: "Jumlah Tenaga Kerja yang Terpapar ", required: true);
  final NumericInput _durasi = NumericInput(label: "Jumlah Jam Pemaparan Per hari", required: true);
  final TextInput _note = TextInput(label: "Note", required: false);

  final List<NumericInput> _mataValues = [
    NumericInput(label: "1", required: true),
    NumericInput(label: "2", required: true),
    NumericInput(label: "3", required: true),
  ];

  final List<NumericInput> _sikuValues = [
    NumericInput(label: "1", required: true),
    NumericInput(label: "2", required: true),
    NumericInput(label: "3", required: true),
  ];

  final List<NumericInput> _betisValues = [
    NumericInput(label: "1", required: true),
    NumericInput(label: "2", required: true),
    NumericInput(label: "3", required: true),
  ];

  late TextInput _deviceCalibration;
  Device? _selectedDevice;

  Map<Posisi, DataUltraviolet>? _data;

  Future<void> _navigateSelectDevice() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_device");
    if (result != null && result is Device) {
      _selectedDevice = result;
      _deviceCalibration.setValue(_selectedDevice!.name ?? "");
    }
  }

  Future<void> _onDelete() async {
    if (widget.onDelete != null) {
      var result = await DialogUtils.showAlertDialog(
        context,
        dismissible: false,
        title: "Hapus Lokasi",
        content: "Apakah Anda yakin akan menghapus lokasi ${_data!.values.first.location} ini?",
        neutralAction: "Tidak",
        onNeutral: () => navigatorKey.currentState?.pop(false),
        negativeAction: "Hapus",
        onNegative: () => navigatorKey.currentState?.pop(true),
      );

      if (result == null || !result) return;

      widget.onDelete!(widget.data!);
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _onUpdate() {
    if (_formKey.currentState!.validate() && _selectedDevice != null) {
      DateTime now = DateTime.now();

      DeviceCalibration deviceCalibration = DeviceCalibration(
        deviceId: _selectedDevice!.id!,
        name: "",
        device: _selectedDevice,
      );

      DataUltraviolet inputMata = _data![Posisi.mata]!.copyWith(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        posisi: Posisi.mata,
        value1: double.parse(_mataValues[0].value),
        value2: double.parse(_mataValues[1].value),
        value3: double.parse(_mataValues[2].value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
        isUpdate: true,
      );

      DataUltraviolet inputSiku = _data![Posisi.siku]!.copyWith(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        posisi: Posisi.siku,
        value1: double.parse(_sikuValues[0].value),
        value2: double.parse(_sikuValues[1].value),
        value3: double.parse(_sikuValues[2].value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
        isUpdate: true,
      );

      DataUltraviolet inputBetis = _data![Posisi.siku]!.copyWith(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        posisi: Posisi.siku,
        value1: double.parse(_sikuValues[0].value),
        value2: double.parse(_sikuValues[1].value),
        value3: double.parse(_sikuValues[2].value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
        isUpdate: true,
      );

      if (widget.onUpdate != null) widget.onUpdate!({Posisi.mata: inputMata, Posisi.siku: inputSiku, Posisi.betis: inputBetis});
      Navigator.of(context).pop();
    }
  }

  void _onAdd() {
    if (_formKey.currentState!.validate() && _selectedDevice != null) {
      DeviceCalibration deviceCalibration = DeviceCalibration(
        deviceId: _selectedDevice!.id!,
        name: "",
        device: _selectedDevice,
      );

      DateTime now = DateTime.now();
      DataUltraviolet inputMata = DataUltraviolet(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        posisi: Posisi.mata,
        value1: double.parse(_mataValues[0].value),
        value2: double.parse(_mataValues[1].value),
        value3: double.parse(_mataValues[2].value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
      );

      DataUltraviolet inputSiku = DataUltraviolet(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        posisi: Posisi.siku,
        value1: double.parse(_sikuValues[0].value),
        value2: double.parse(_sikuValues[1].value),
        value3: double.parse(_sikuValues[2].value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
      );

      DataUltraviolet inputBetis = DataUltraviolet(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        posisi: Posisi.betis,
        value1: double.parse(_betisValues[0].value),
        value2: double.parse(_betisValues[1].value),
        value3: double.parse(_betisValues[2].value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
      );

      if (widget.onAdd != null) widget.onAdd!({Posisi.mata: inputMata, Posisi.siku: inputSiku, Posisi.betis: inputBetis});
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    _deviceCalibration = TextInput(label: "Alat", required: true, onTap: _navigateSelectDevice);
    _data = widget.data;
    if (_data != null) {
      DataUltraviolet dataMata = widget.data![Posisi.mata]!;
      DataUltraviolet dataBetis = widget.data![Posisi.betis]!;
      DataUltraviolet dataSiku = widget.data![Posisi.siku]!;

      _mataValues[0].setValue("${dataMata.value1}");
      _mataValues[1].setValue("${dataMata.value2}");
      _mataValues[2].setValue("${dataMata.value3}");

      _betisValues[0].setValue("${dataBetis.value1}");
      _betisValues[1].setValue("${dataBetis.value2}");
      _betisValues[2].setValue("${dataBetis.value3}");

      _sikuValues[0].setValue("${dataSiku.value1}");
      _sikuValues[1].setValue("${dataSiku.value2}");
      _sikuValues[2].setValue("${dataSiku.value3}");

      _selectedDevice = dataMata.deviceCalibration!.device!;
      _time.setSelectedTime(TimeOfDay.fromDateTime(dataMata.time));
      _location.setValue(dataMata.location);
      _durasi.setValue("${dataMata.durasi}");
      _jumlahTK.setValue("${dataMata.jumlahTK}");
      _note.setValue(dataMata.note ?? "");
    }

    _inputs.add(_deviceCalibration);
    _inputs.add(_location);
    _inputs.add(_time);
    _inputs.add(_jumlahTK);
    _inputs.add(_durasi);
    _inputs.add(_note);
    _inputs.add(
      GroupInput(
        dataInputs: _mataValues,
        title: const Text(
          "Mata",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.fontSmall),
        ),
      ),
    );

    _inputs.add(
      GroupInput(
        dataInputs: _betisValues,
        title: const Text(
          "Betis",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.fontSmall),
        ),
      ),
    );

    _inputs.add(
      GroupInput(
        dataInputs: _sikuValues,
        title: const Text(
          "Siku",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.fontSmall),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.background,
        title: Text("Form Ultraviolet", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomFormInput(key: _formKey, dataInputs: _inputs),
              const SizedBox(height: Dimens.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.data != null,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
                        child: CustomButton(
                          minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
                          label: Text("Hapus", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                          backgroundColor: Colors.redAccent,
                          onPressed: _onDelete,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
                      child: CustomButton(
                        minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
                        label: Text("Simpan", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                        backgroundColor: ColorResources.primary,
                        onPressed: () => _data != null ? _onUpdate() : _onAdd(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.paddingSmall),
            ],
          ),
        ),
      ),
    );
  }
}
