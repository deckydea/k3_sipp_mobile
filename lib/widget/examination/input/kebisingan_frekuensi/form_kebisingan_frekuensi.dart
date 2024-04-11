import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_frekuensi.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class FormKebisinganFrekuensi extends StatefulWidget {
  final Function(DataKebisinganFrekuensi)? onUpdate;
  final Function(DataKebisinganFrekuensi)? onAdd;
  final Function(DataKebisinganFrekuensi)? onDelete;
  final DataKebisinganFrekuensi? data;

  const FormKebisinganFrekuensi({super.key, this.onUpdate, this.onAdd, this.onDelete, this.data});

  @override
  State<FormKebisinganFrekuensi> createState() => _FormKebisinganFrekuensiState();
}

class _FormKebisinganFrekuensiState extends State<FormKebisinganFrekuensi> {
  final GlobalKey<CustomFormInputState> _formKey = GlobalKey();
  final List<DataInput> _inputs = [];

  final TextInput _location = TextInput(label: "Lokasi", required: true);
  final TimeInput _time = TimeInput(label: "Waktu", required: true);
  final NumericInput _value1 = NumericInput(label: "31,5 Hz", required: true);
  final NumericInput _value2 = NumericInput(label: "63,0 Hz", required: true);
  final NumericInput _value3 = NumericInput(label: "125 Hz", required: true);
  final NumericInput _value4 = NumericInput(label: "250 Hz", required: true);
  final NumericInput _value5 = NumericInput(label: "500 Hz", required: true);
  final NumericInput _value6 = NumericInput(label: "1 KHz", required: true);
  final NumericInput _value7 = NumericInput(label: "2 KHz", required: true);
  final NumericInput _value8 = NumericInput(label: "4 KHz", required: true);
  final NumericInput _value9 = NumericInput(label: "8 KHz", required: true);
  final NumericInput _value10 = NumericInput(label: "16 KHz", required: true);
  final TextInput _note = TextInput(label: "Note");
  late TextInput _deviceCalibration;
  Device? _selectedDevice;
  DataKebisinganFrekuensi? _data;

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
        content: "Apakah Anda yakin akan menghapus lokasi ${_data!.location} ini?",
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
      DataKebisinganFrekuensi input = _data!.copyWith(
        location: _location.value,
        value1: double.parse(_value1.value),
        value2: double.parse(_value2.value),
        value3: double.parse(_value3.value),
        value4: double.parse(_value4.value),
        value5: double.parse(_value5.value),
        value6: double.parse(_value6.value),
        value7: double.parse(_value7.value),
        value8: double.parse(_value8.value),
        value9: double.parse(_value9.value),
        value10: double.parse(_value10.value),
        time: _time.selectedTime == null
            ? null
            : DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
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
      DataKebisinganFrekuensi input = DataKebisinganFrekuensi(
        location: _location.value,
        value1: double.parse(_value1.value),
        value2: double.parse(_value2.value),
        value3: double.parse(_value3.value),
        value4: double.parse(_value4.value),
        value5: double.parse(_value5.value),
        value6: double.parse(_value6.value),
        value7: double.parse(_value7.value),
        value8: double.parse(_value8.value),
        value9: double.parse(_value9.value),
        value10: double.parse(_value10.value),
        time: _time.selectedTime == null
            ? null
            : DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
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

      _location.setValue(_data!.location);
      _time.setSelectedTime(TimeOfDay(hour: _data!.time!.hour, minute: _data!.time!.minute));
      _value1.setValue("${_data!.value1}");
      _value2.setValue("${_data!.value2}");
      _value3.setValue("${_data!.value3}");
      _value4.setValue("${_data!.value4}");
      _value5.setValue("${_data!.value5}");
      _value6.setValue("${_data!.value6}");
      _value7.setValue("${_data!.value7}");
      _value8.setValue("${_data!.value8}");
      _value9.setValue("${_data!.value9}");
      _value10.setValue("${_data!.value10}");
    }

    _inputs.add(_deviceCalibration);
    _inputs.add(_location);
    _inputs.add(_time);
    _inputs.add(_value1);
    _inputs.add(_value2);
    _inputs.add(_value3);
    _inputs.add(_value4);
    _inputs.add(_value5);
    _inputs.add(_value6);
    _inputs.add(_value7);
    _inputs.add(_value8);
    _inputs.add(_value9);
    _inputs.add(_value10);
    _inputs.add(_note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.background,
        title: Text("Form Kebisingan Frekuensi", style: Theme.of(context).textTheme.headlineLarge),
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
              const SizedBox(height: Dimens.paddingMedium),
            ],
          ),
        ),
      ),
    );
  }
}
