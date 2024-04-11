import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_iklim_kerja.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

enum CalibrationCategory { tw, tg, isbb }

class FormIklimKerja extends StatefulWidget {
  final Function(DataIklimKerja)? onUpdate;
  final Function(DataIklimKerja)? onAdd;
  final Function(DataIklimKerja)? onDelete;
  final DataIklimKerja? data;

  const FormIklimKerja({super.key, this.onUpdate, this.onAdd, this.onDelete, this.data});

  @override
  State<FormIklimKerja> createState() => _FormIklimKerjaState();
}

class _FormIklimKerjaState extends State<FormIklimKerja> {
  final GlobalKey<CustomFormInputState> _formKey = GlobalKey();
  final List<DataInput> _inputs = [];

  final TextInput _location = TextInput(label: "Lokasi", required: true);
  final TimeInput _time = TimeInput(label: "Waktu", required: true);
  final NumericInput _jumlahTK = NumericInput(label: "Jumlah Tenaga Kerja yang terpapar", required: true);
  final NumericInput _durasi = NumericInput(label: "Durasi Paparan Terhadap Pekerja Per Jam", required: true);
  final TextInput _pengendalian = TextInput(label: "Pengendalian", required: false);
  final TextInput _note = TextInput(label: "Note", required: false);

  final NumericInput _tw1 = NumericInput(label: "TW 1", required: true);
  final NumericInput _tw2 = NumericInput(label: "TW 2", required: true);
  final NumericInput _tw3 = NumericInput(label: "TW 3", required: true);
  final NumericInput _tw4 = NumericInput(label: "TW 4", required: true);
  final NumericInput _tw5 = NumericInput(label: "TW 5", required: true);
  final NumericInput _tw6 = NumericInput(label: "TW 6", required: true);

  final NumericInput _tg1 = NumericInput(label: "TG 1", required: true);
  final NumericInput _tg2 = NumericInput(label: "TG 2", required: true);
  final NumericInput _tg3 = NumericInput(label: "TG 3", required: true);
  final NumericInput _tg4 = NumericInput(label: "TG 4", required: true);
  final NumericInput _tg5 = NumericInput(label: "TG 5", required: true);
  final NumericInput _tg6 = NumericInput(label: "TG 6", required: true);

  final NumericInput _rh1 = NumericInput(label: "RH 1", required: true);
  final NumericInput _rh2 = NumericInput(label: "RH 2", required: true);
  final NumericInput _rh3 = NumericInput(label: "RH 3", required: true);
  final NumericInput _rh4 = NumericInput(label: "RH 4", required: true);
  final NumericInput _rh5 = NumericInput(label: "RH 5", required: true);
  final NumericInput _rh6 = NumericInput(label: "RH 6", required: true);

  late TextInput _deviceCalibrationTW;
  late TextInput _deviceCalibrationTG;
  late TextInput _deviceCalibrationISBB;

  final NumericInput _internalCalibrationTW = NumericInput(label: "Kalibrasi Internal (TW)", required: true);
  final NumericInput _internalCalibrationTG = NumericInput(label: "Kalibrasi Internal (TG)", required: true);
  final NumericInput _internalCalibrationISBB = NumericInput(label: "Kalibrasi Internal (ISBB)", required: true, enable: false);

  Device? _selectedDeviceTW;
  Device? _selectedDeviceTG;
  Device? _selectedDeviceISBB;
  DataIklimKerja? _data;

  Future<void> _navigateSelectDevice(CalibrationCategory category) async {
    var result = await navigatorKey.currentState?.pushNamed("/select_device");
    if (result != null && result is Device) {
      switch (category) {
        case CalibrationCategory.tw:
          _selectedDeviceTW = result;
          _deviceCalibrationTW.setValue(_selectedDeviceTW!.name ?? "");
          break;
        case CalibrationCategory.tg:
          _selectedDeviceTG = result;
          _deviceCalibrationTG.setValue(_selectedDeviceTG!.name ?? "");
          break;
        case CalibrationCategory.isbb:
          _selectedDeviceISBB = result;
          _deviceCalibrationISBB.setValue(_selectedDeviceISBB!.name ?? "");

          if (TextUtils.isEmpty(_internalCalibrationTW.value) || TextUtils.isEmpty(_internalCalibrationTG.value)) {
            _internalCalibrationISBB.setValue("0");
          } else {
            _internalCalibrationISBB.setValue(
                "${(0.7 * double.parse(_internalCalibrationTW.value)) + (0.3 * double.parse(_internalCalibrationTG.value))}");
          }
          break;
      }
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
    if (_formKey.currentState!.validate()) {
      DateTime now = DateTime.now();

      DeviceCalibration deviceCalibrationTG = DeviceCalibration(
        deviceId: _selectedDeviceTG!.id!,
        name: "",
        device: _selectedDeviceTG,
      );

      DeviceCalibration deviceCalibrationTW = DeviceCalibration(
        deviceId: _selectedDeviceTW!.id!,
        name: "",
        device: _selectedDeviceTW,
      );

      DeviceCalibration deviceCalibrationISBB = DeviceCalibration(
        deviceId: _selectedDeviceISBB!.id!,
        name: "",
        device: _selectedDeviceISBB,
      );

      DataIklimKerja input = _data!.copyWith(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: int.parse(_durasi.value),
        pengendalian: _pengendalian.value,
        note: _note.value,
        deviceCalibrationTG: deviceCalibrationTG,
        deviceCalibrationTW: deviceCalibrationTW,
        deviceCalibrationISBB: deviceCalibrationISBB,
        rh1: double.parse(_rh1.value),
        rh2: double.parse(_rh2.value),
        rh3: double.parse(_rh3.value),
        rh4: double.parse(_rh4.value),
        rh5: double.parse(_rh5.value),
        rh6: double.parse(_rh6.value),
        tg1: double.parse(_tg1.value),
        tg2: double.parse(_tg2.value),
        tg3: double.parse(_tg3.value),
        tg4: double.parse(_tg4.value),
        tg5: double.parse(_tg5.value),
        tg6: double.parse(_tg6.value),
        tw1: double.parse(_tw1.value),
        tw2: double.parse(_tw2.value),
        tw3: double.parse(_tw3.value),
        tw4: double.parse(_tw4.value),
        tw5: double.parse(_tw5.value),
        tw6: double.parse(_tw6.value),
      );

      if (widget.onUpdate != null) widget.onUpdate!(input);
      Navigator.of(context).pop();
    }
  }

  void _onAdd() {
    if (_formKey.currentState!.validate()) {
      DeviceCalibration deviceCalibrationTG = DeviceCalibration(
        deviceId: _selectedDeviceTG!.id!,
        name: "",
        device: _selectedDeviceTG,
      );

      DeviceCalibration deviceCalibrationTW = DeviceCalibration(
        deviceId: _selectedDeviceTW!.id!,
        name: "",
        device: _selectedDeviceTW,
      );

      DeviceCalibration deviceCalibrationISBB = DeviceCalibration(
        deviceId: _selectedDeviceISBB!.id!,
        name: "",
        device: _selectedDeviceISBB,
      );


      DateTime now = DateTime.now();
      DataIklimKerja input = DataIklimKerja(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: int.parse(_durasi.value),
        pengendalian: _pengendalian.value,
        note: _note.value,
        deviceCalibrationTG: deviceCalibrationTG,
        deviceCalibrationTW: deviceCalibrationTW,
        deviceCalibrationISBB: deviceCalibrationISBB,
        rh1: double.parse(_rh1.value),
        rh2: double.parse(_rh2.value),
        rh3: double.parse(_rh3.value),
        rh4: double.parse(_rh4.value),
        rh5: double.parse(_rh5.value),
        rh6: double.parse(_rh6.value),
        tg1: double.parse(_tg1.value),
        tg2: double.parse(_tg2.value),
        tg3: double.parse(_tg3.value),
        tg4: double.parse(_tg4.value),
        tg5: double.parse(_tg5.value),
        tg6: double.parse(_tg6.value),
        tw1: double.parse(_tw1.value),
        tw2: double.parse(_tw2.value),
        tw3: double.parse(_tw3.value),
        tw4: double.parse(_tw4.value),
        tw5: double.parse(_tw5.value),
        tw6: double.parse(_tw6.value),
      );
      if (widget.onAdd != null) widget.onAdd!(input);
      Navigator.of(context).pop();
    }
  }

  void _initData() {
    _deviceCalibrationTW = TextInput(
      label: "Alat TW",
      required: true,
      onTap: () => _navigateSelectDevice(CalibrationCategory.tw),
    );
    _deviceCalibrationTG = TextInput(
      label: "Alat TG",
      required: true,
      onTap: () => _navigateSelectDevice(CalibrationCategory.tg),
    );
    _deviceCalibrationISBB = TextInput(
      label: "Alat ISBB",
      required: true,
      onTap: () => _navigateSelectDevice(CalibrationCategory.isbb),
    );

    _data = widget.data;
    if (_data != null) {
      _location.setValue(_data!.location);
      _time.setSelectedTime(TimeOfDay(hour: _data!.time.hour, minute: _data!.time.minute));
      _jumlahTK.setValue("${_data!.jumlahTK}");
      _durasi.setValue("${_data!.durasi}");
      _pengendalian.setValue(_data!.pengendalian);
      _note.setValue(_data!.note ?? "");

      _tw1.setValue("${_data!.tw1}");
      _tw2.setValue("${_data!.tw2}");
      _tw3.setValue("${_data!.tw3}");
      _tw4.setValue("${_data!.tw4}");
      _tw5.setValue("${_data!.tw5}");
      _tw6.setValue("${_data!.tw6}");

      _tg1.setValue("${_data!.tg1}");
      _tg2.setValue("${_data!.tg2}");
      _tg3.setValue("${_data!.tg3}");
      _tg4.setValue("${_data!.tg4}");
      _tg5.setValue("${_data!.tg5}");
      _tg6.setValue("${_data!.tg6}");

      _rh1.setValue("${_data!.rh1}");
      _rh2.setValue("${_data!.rh2}");
      _rh3.setValue("${_data!.rh3}");
      _rh4.setValue("${_data!.rh4}");
      _rh5.setValue("${_data!.rh5}");
      _rh6.setValue("${_data!.rh6}");

      _deviceCalibrationTW.setValue("${_data!.deviceCalibrationTW!.internalCalibration}");
      _deviceCalibrationTG.setValue("${_data!.deviceCalibrationTG!.internalCalibration}");
      _deviceCalibrationISBB.setValue("${_data!.deviceCalibrationTG!.internalCalibration}");

      _selectedDeviceTW = _data!.deviceCalibrationTW!.device;
      _selectedDeviceTG = _data!.deviceCalibrationTG!.device;
      _selectedDeviceISBB = _data!.deviceCalibrationISBB!.device;
    }

    _inputs.add(InputGroup(
        dataInputs: [],
        title: Text("Kalibrasi Alat", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))));
    _inputs.add(_deviceCalibrationTW);
    _inputs.add(_internalCalibrationTW);
    _inputs.add(_deviceCalibrationTG);
    _inputs.add(_internalCalibrationTG);
    _inputs.add(_deviceCalibrationISBB);
    _inputs.add(_internalCalibrationISBB);

    _inputs.add(InputGroup(
        dataInputs: [],
        title: Text("Informasi", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))));
    _inputs.add(_location);
    _inputs.add(_time);
    _inputs.add(_jumlahTK);
    _inputs.add(_durasi);
    _inputs.add(_pengendalian);
    _inputs.add(_note);

    _inputs.add(InputGroup(
        dataInputs: [], title: Text("TW", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))));
    _inputs.add(InputGroup(dataInputs: [_tw1, _tw2, _tw3]));
    _inputs.add(InputGroup(dataInputs: [_tw4, _tw5, _tw6]));

    _inputs.add(InputGroup(
        dataInputs: [], title: Text("TG", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))));
    _inputs.add(InputGroup(dataInputs: [_tg1, _tg2, _tg3]));
    _inputs.add(InputGroup(dataInputs: [_tg4, _tg5, _tg6]));

    _inputs.add(InputGroup(
        dataInputs: [], title: Text("RH", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))));
    _inputs.add(InputGroup(dataInputs: [_rh1, _rh2, _rh3]));
    _inputs.add(InputGroup(dataInputs: [_rh4, _rh5, _rh6]));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async => _initData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.background,
        title: Text("Form Iklim Kerja", style: Theme.of(context).textTheme.headlineLarge),
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