import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_noise_dose.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class FormKebisinganNoiseDose extends StatefulWidget {
  final Function(DataNoiseDose)? onUpdate;
  final Function(DataNoiseDose)? onAdd;
  final Function(DataNoiseDose)? onDelete;
  final DataNoiseDose? data;

  const FormKebisinganNoiseDose({super.key, this.onUpdate, this.onAdd, this.onDelete, this.data});

  @override
  State<FormKebisinganNoiseDose> createState() => _FormKebisinganNoiseDoseState();
}

class _FormKebisinganNoiseDoseState extends State<FormKebisinganNoiseDose> {
  final GlobalKey<CustomFormInputState> _formKey = GlobalKey();
  final List<DataInput> _inputs = [];

  final TimeInput _timeStart = TimeInput(label: "Waktu Awal Pengukuran", required: true);
  final TimeInput _timeEnd = TimeInput(label: "Waktu Akhir Pengukuran", required: true);
  final TextInput _name = TextInput(label: "Nama", required: true);
  final TextInput _bagian = TextInput(label: "Bagian", required: true);
  final TextInput _nik = TextInput(label: "NIK", required: true);
  final TextAreaInput _note = TextAreaInput(label: "Note", required: false);
  final NumericInput _twa = NumericInput(label: "TWA(dBA)", required: true);
  final NumericInput _dose = NumericInput(label: "Dose (%)", required: true);
  final NumericInput _leq = NumericInput(label: "Leq (dBA)", required: true);
  late TextInput _deviceCalibration;

  Device? _selectedDevice;
  DataNoiseDose? _data;

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
        content: "Apakah Anda yakin akan menghapus ${_data!.name} - ${_data!.nik} ini?",
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
      DataNoiseDose input = _data!.copyWith(
        timeStart: _timeStart.selectedTime == null
            ? null
            : DateTime(now.year, now.month, now.day, _timeStart.selectedTime!.hour, _timeStart.selectedTime!.minute),
        timeEnd: _timeEnd.selectedTime == null
            ? null
            : DateTime(now.year, now.month, now.day, _timeEnd.selectedTime!.hour, _timeEnd.selectedTime!.minute),
        name: _name.value,
        nik: _nik.value,
        bagian: _bagian.value,
        twa: double.parse(_twa.value),
        dose: double.parse(_dose.value),
        leq: double.parse(_leq.value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
      );

      if (widget.onUpdate != null) widget.onUpdate!(input);
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
      DataNoiseDose input = DataNoiseDose(
        timeStart: DateTime(now.year, now.month, now.day, _timeStart.selectedTime!.hour, _timeStart.selectedTime!.minute),
        timeEnd: DateTime(now.year, now.month, now.day, _timeEnd.selectedTime!.hour, _timeEnd.selectedTime!.minute),
        name: _name.value,
        nik: _nik.value,
        bagian: _bagian.value,
        twa: double.parse(_twa.value),
        dose: double.parse(_dose.value),
        leq: double.parse(_leq.value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
      );
      if (widget.onAdd != null) widget.onAdd!(input);
      Navigator.of(context).pop();
    }
  }


  @override
  void initState() {
    super.initState();
    _deviceCalibration = TextInput(label: "Alat", required: true, onTap: _navigateSelectDevice);

    _data = widget.data;

    if (_data != null) {
      _selectedDevice = _data!.deviceCalibration!.device!;
      _deviceCalibration.setValue(_selectedDevice!.name ?? "");

      _timeStart.setSelectedTime(TimeOfDay(hour: _data!.timeStart.hour, minute: _data!.timeStart.minute));
      _timeEnd.setSelectedTime(TimeOfDay(hour: _data!.timeEnd.hour, minute: _data!.timeEnd.minute));
      _name.setValue(_data!.name);
      _bagian.setValue(_data!.bagian);
      _nik.setValue(_data!.nik);
      _note.setValue(_data!.note ?? "");
      _twa.setValue("${_data!.twa}");
      _dose.setValue("${_data!.dose}");
      _leq.setValue("${_data!.leq}");
    }

    _inputs.add(_deviceCalibration);
    _inputs.add(_timeStart);
    _inputs.add(_timeEnd);
    _inputs.add(_name);
    _inputs.add(_bagian);
    _inputs.add(_nik);
    _inputs.add(_note);
    _inputs.add(_twa);
    _inputs.add(_dose);
    _inputs.add(_leq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.background,
        title: Text("Form Kebisingan Noise Dose", style: Theme.of(context).textTheme.headlineLarge),
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
