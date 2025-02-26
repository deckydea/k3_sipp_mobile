import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dropdown_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';

class FormPenerangan extends StatefulWidget {
  final Function(DataPenerangan)? onUpdate;
  final Function(DataPenerangan)? onAdd;
  final Function(DataPenerangan)? onDelete;
  final DataPenerangan? data;

  const FormPenerangan({super.key, this.data, this.onUpdate, this.onAdd, this.onDelete});

  @override
  State<FormPenerangan> createState() => _FormPeneranganState();
}

class _FormPeneranganState extends State<FormPenerangan> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _localLightingData = TextEditingController();
  final TextEditingController _value1Controller = TextEditingController();
  final TextEditingController _value2Controller = TextEditingController();
  final TextEditingController _value3Controller = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _jumlahTKController = TextEditingController();
  final List<DropdownMenuItem<SumberCahaya>> _dropdownSumberCahaya = [];
  final List<DropdownMenuItem<JenisPengukuran>> _dropdownJenisPengukuran = [];

  SumberCahaya? _selectedSumberCahaya;
  JenisPengukuran? _selectedJenisPengukuran;
  Device? _selectedDevice;
  TimeOfDay? _selectedTime;
  DataPenerangan? _data;

  bool _initialized = false;

  Future<void> _onDelete() async {
    if (widget.onDelete != null) {
      var result = await DialogUtils.showAlertDialog(
        context,
        dismissible: false,
        title: "Hapus Lokasi",
        content: "Apakah Anda yakin akan menghapus lokasi ${_data!.localLightingData} ini?",
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

      DeviceCalibration deviceCalibration = DeviceCalibration(deviceId: _selectedDevice!.id!, name: "");

      DataPenerangan input = _data!.copyWith(
        location: _locationController.text,
        localLightingData: _localLightingData.text,
        value1: double.parse(_value1Controller.text),
        value2: double.parse(_value2Controller.text),
        value3: double.parse(_value3Controller.text),
        time: _selectedTime == null ? null : DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute),
        note: _noteController.text,
        jumlahTK: int.tryParse(_jumlahTKController.text),
        deviceCalibration: deviceCalibration,
        sumberCahaya: _selectedSumberCahaya,
        jenisPengukuran: _selectedJenisPengukuran,
      );

      if (widget.onUpdate != null) widget.onUpdate!(input);
      Navigator.of(context).pop();
    }
  }

  void _onAdd() {
    if (_formKey.currentState!.validate()) {
      DateTime now = DateTime.now();
      DeviceCalibration deviceCalibration = DeviceCalibration(deviceId: _selectedDevice!.id!);

      DataPenerangan input = DataPenerangan(
        location: _locationController.text,
        localLightingData: _localLightingData.text,
        value1: double.parse(_value1Controller.text),
        value2: double.parse(_value2Controller.text),
        value3: double.parse(_value3Controller.text),
        time: _selectedTime == null ? null : DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute),
        note: _noteController.text,
        jumlahTK: int.parse(_jumlahTKController.text),
        deviceCalibration: deviceCalibration,
        sumberCahaya: _selectedSumberCahaya,
        jenisPengukuran: _selectedJenisPengukuran,
      );
      if (widget.onAdd != null) widget.onAdd!(input);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime != null
          ? TimeOfDay(hour: _selectedTime!.hour, minute: _selectedTime!.minute)
          : const TimeOfDay(hour: 8, minute: 0),
    );

    if (_selectedTime != null) {
      setState(() => _timeController.text = _selectedTime!.format(context));
    }
  }

  Future<void> _navigateSelectDevice() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_device");
    if (result != null && result is Device) {
      _selectedDevice = result;
      _deviceController.text = _selectedDevice!.name ?? "";
    }
  }

  void _init() {
    if (widget.data != null) {
      _data = widget.data!;
      _locationController.text = _data!.location;
      _localLightingData.text = _data!.localLightingData;
      _value1Controller.text = "${_data!.value1}";
      _value2Controller.text = "${_data!.value2}";
      _value3Controller.text = "${_data!.value3}";
      _jumlahTKController.text = "${_data!.jumlahTK}";
      _deviceController.text = _data!.deviceCalibration != null ? "${_data!.deviceCalibration!.deviceName}" : "";
      if (!TextUtils.isEmpty(_data!.note)) _noteController.text = _data!.note!;
      if (_data!.time != null) {
        _selectedTime = TimeOfDay.fromDateTime(_data!.time!);
        _timeController.text = _selectedTime!.format(context);
      }

      _selectedJenisPengukuran = _data!.jenisPengukuran;
      _selectedSumberCahaya = _data!.sumberCahaya;
    }

    for (SumberCahaya sumberCahaya in SumberCahaya.values) {
      _dropdownSumberCahaya.add(DropdownMenuItem(
        value: sumberCahaya,
        child: Text(sumberCahaya.label),
      ));
    }
    _selectedSumberCahaya = _selectedSumberCahaya ?? SumberCahaya.alami;

    for (JenisPengukuran jenisPengukuran in JenisPengukuran.values) {
      _dropdownJenisPengukuran.add(DropdownMenuItem(
        value: jenisPengukuran,
        child: Text(jenisPengukuran.label),
      ));
    }
    _selectedJenisPengukuran = _selectedJenisPengukuran ?? JenisPengukuran.lokal;

    _initialized = true;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _localLightingData.dispose();
    _value1Controller.dispose();
    _value2Controller.dispose();
    _value3Controller.dispose();
    _timeController.dispose();
    _noteController.dispose();
    _jumlahTKController.dispose();
    _deviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) _init();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.background,
        title: Text("Form Penerangan", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingPage),
          child: Column(
            children: [
              CustomEditText(
                label: "Alat",
                controller: _deviceController,
                width: double.infinity,
                validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                textInputType: TextInputType.text,
                readOnly: true,
                cursorVisible: false,
                onTap: _navigateSelectDevice,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              const Divider(color: Colors.grey),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                label: "Lokasi",
                controller: _locationController,
                width: double.infinity,
                validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                label: "Data Penerangan Lokal",
                controller: _localLightingData,
                width: double.infinity,
                validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomEditText(
                      label: "Value 1",
                      controller: _value1Controller,
                      width: double.infinity,
                      validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                      textInputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: Dimens.paddingWidget),
                  Expanded(
                    child: CustomEditText(
                      label: "Value 2",
                      controller: _value2Controller,
                      width: double.infinity,
                      validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                      textInputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: Dimens.paddingWidget),
                  Expanded(
                    child: CustomEditText(
                      label: "Value 3",
                      controller: _value3Controller,
                      width: double.infinity,
                      validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                      textInputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                width: double.infinity,
                label: "Waktu",
                controller: _timeController,
                readOnly: true,
                cursorVisible: false,
                icon: Icon(TextUtils.isEmpty(_timeController.text) ? Icons.calendar_month : Icons.cancel_outlined),
                onIconTap: !TextUtils.isEmpty(_timeController.text) ? () => _timeController.text = "" : null,
                onTap: () => _selectTime(context),
                textInputType: TextInputType.text,
                validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
              ),
              const SizedBox(height: Dimens.paddingSmall),
              StatefulBuilder(
                builder: (BuildContext context, insideState) {
                  return CustomDropdownButton(
                    items: _dropdownJenisPengukuran,
                    value: _selectedJenisPengukuran,
                    width: double.infinity,
                    onChanged: (value) => value != null ? insideState(() => _selectedJenisPengukuran = value) : null,
                  );
                },
              ),
              const SizedBox(height: Dimens.paddingSmall),
              StatefulBuilder(
                builder: (BuildContext context, insideState) {
                  return CustomDropdownButton(
                    items: _dropdownSumberCahaya,
                    value: _selectedSumberCahaya,
                    width: double.infinity,
                    onChanged: (value) => value != null ? insideState(() => _selectedSumberCahaya = value) : null,
                  );
                },
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                label: "Jumlah Tenaga Kerja yang terpapar",
                controller: _jumlahTKController,
                width: double.infinity,
                validator: (value) => ValidatorUtils.validateInputLength(context, value, 0, 200),
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                label: "Catatan",
                controller: _noteController,
                width: double.infinity,
                validator: (value) => ValidatorUtils.validateInputLength(context, value, 0, 200),
                textInputType: TextInputType.text,
              ),
              const Expanded(child: SizedBox(height: Dimens.paddingMedium)),
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