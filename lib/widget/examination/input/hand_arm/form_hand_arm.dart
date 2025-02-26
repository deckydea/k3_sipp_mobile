import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_hand_arm.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class FormHandArmPage extends StatefulWidget {
  final Function(DataHandArm)? onUpdate;
  final Function(DataHandArm)? onAdd;
  final Function(DataHandArm)? onDelete;
  final DataHandArm? data;

  const FormHandArmPage({super.key, this.onUpdate, this.onAdd, this.onDelete, this.data});

  @override
  State<FormHandArmPage> createState() => _FormHandArmPageState();
}

class _FormHandArmPageState extends State<FormHandArmPage> {
  final GlobalKey<CustomFormInputState> _formKey = GlobalKey();
  final List<DataInput> _inputs = [];

  final TextInput _location = TextInput(label: "Lokasi", required: true);
  final TimeInput _time = TimeInput(label: "Waktu", required: true);
  final TextInput _nik = TextInput(label: "NIK", required: true);
  final TextInput _name = TextInput(label: "Name", required: true);
  final TextInput _bagian = TextInput(label: "Bagian", required: true);
  final NumericInput _jumlahTK = NumericInput(label: "Jumlah Tenaga Kerja yang Terpapar ", required: true);
  final TextInput _sumberGetaran = TextInput(label: "Sumber Getaran", required: false);
  final TextInput _tindakan = TextInput(label: "Tindakan", required: false);
  final NumericInput _durasi = NumericInput(label: "Jumlah Waktu Pajanan Per Hari Kerja (Jam)", required: true);
  final TextInput _note = TextInput(label: "Note", required: false);

  final NumericInput _x1 = NumericInput(label: "x1", required: true);
  final NumericInput _x2 = NumericInput(label: "x2", required: true);
  final NumericInput _x3 = NumericInput(label: "x3", required: true);
  final NumericInput _y1 = NumericInput(label: "y1", required: true);
  final NumericInput _y2 = NumericInput(label: "y2", required: true);
  final NumericInput _y3 = NumericInput(label: "y3", required: true);
  final NumericInput _z1 = NumericInput(label: "z1", required: true);
  final NumericInput _z2 = NumericInput(label: "z2", required: true);
  final NumericInput _z3 = NumericInput(label: "z3", required: true);

  final List<DropdownMenuItem<Adaptor>> _dropdownAdaptor = [];
  DropdownInput? _adaptor;
  Adaptor? _selectedAdaptor;

  final NumericInput _internalCalibration = NumericInput(label: "Kalibrasi Internal", required: true);
  late TextInput _deviceCalibration;
  Device? _selectedDevice;

  DataHandArm? _data;

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
        internalCalibration: double.parse(_internalCalibration.value),
      );
      DataHandArm input = _data!.copyWith(
        location: _location.value,
        time: _time.selectedTime == null
            ? null
            : DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        bagian: _bagian.value,
        nik: _nik.value,
        name: _name.value,
        adaptor: _selectedAdaptor,
        sumberGetaran: _sumberGetaran.value,
        tindakan: _tindakan.value,
        x1: double.parse(_x1.value),
        x2: double.parse(_x2.value),
        x3: double.parse(_x3.value),
        y1: double.parse(_y1.value),
        y2: double.parse(_y2.value),
        y3: double.parse(_y3.value),
        z1: double.parse(_z1.value),
        z2: double.parse(_z2.value),
        z3: double.parse(_z3.value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
        isUpdate: true,
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
        internalCalibration: double.parse(_internalCalibration.value),
      );

      DateTime now = DateTime.now();
      DataHandArm input = DataHandArm(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        durasi: double.parse(_durasi.value),
        bagian: _bagian.value,
        nik: _nik.value,
        name: _name.value,
        adaptor: _selectedAdaptor!,
        sumberGetaran: _sumberGetaran.value,
        tindakan: _tindakan.value,
        x1: double.parse(_x1.value),
        x2: double.parse(_x2.value),
        x3: double.parse(_x3.value),
        y1: double.parse(_y1.value),
        y2: double.parse(_y2.value),
        y3: double.parse(_y3.value),
        z1: double.parse(_z1.value),
        z2: double.parse(_z2.value),
        z3: double.parse(_z3.value),
        note: _note.value,
        deviceCalibration: deviceCalibration,
      );
      if (widget.onAdd != null) widget.onAdd!(input);
      Navigator.of(context).pop();
    }
  }

  void _initData() {
    _deviceCalibration = TextInput(
      label: "Alat",
      required: true,
      onTap: () => _navigateSelectDevice(),
    );

    _data = widget.data;
    if (_data != null) {
      _location.setValue(_data!.location);
      _time.setSelectedTime(TimeOfDay(hour: _data!.time.hour, minute: _data!.time.minute));
      _nik.setValue(_data!.nik);
      _name.setValue(_data!.name);
      _bagian.setValue(_data!.bagian);
      _jumlahTK.setValue("${_data!.jumlahTK}");
      _selectedAdaptor = _data!.adaptor;
      _sumberGetaran.setValue(_data!.sumberGetaran);
      _tindakan.setValue(_data!.tindakan);
      _durasi.setValue("${_data!.durasi}");
      _x1.setValue("${_data!.x1}");
      _x2.setValue("${_data!.x2}");
      _x3.setValue("${_data!.x3}");
      _y1.setValue("${_data!.y1}");
      _y2.setValue("${_data!.y2}");
      _y3.setValue("${_data!.y3}");
      _z1.setValue("${_data!.z1}");
      _z2.setValue("${_data!.z2}");
      _z3.setValue("${_data!.z3}");
      _note.setValue("${_data!.note}");

      _deviceCalibration.setValue("${_data!.deviceCalibration!.internalCalibration}");
      _selectedDevice = _data!.deviceCalibration!.device;
    }

    for (Adaptor adaptor in Adaptor.values) {
      _dropdownAdaptor.add(DropdownMenuItem(
        value: adaptor,
        child: Text(adaptor.label),
      ));
    }
    _selectedAdaptor = _selectedAdaptor ?? Adaptor.mesin;
    _adaptor = DropdownInput(selected: _selectedAdaptor, dropdown: _dropdownAdaptor, label: "Adaptor");

    _inputs.add(_deviceCalibration);
    _inputs.add(_internalCalibration);
    _inputs.add(_location);
    _inputs.add(_time);
    _inputs.add(_nik);
    _inputs.add(_name);
    _inputs.add(_bagian);
    _inputs.add(_jumlahTK);
    _inputs.add(_adaptor!);
    _inputs.add(_sumberGetaran);
    _inputs.add(_tindakan);
    _inputs.add(_durasi);

    _inputs.add(GroupInput(
        dataInputs: [],
        title: Text("Perhitungan", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))));
    _inputs.add(GroupInput(dataInputs: [_x1, _x2, _x3]));
    _inputs.add(GroupInput(dataInputs: [_y1, _y2, _y3]));
    _inputs.add(GroupInput(dataInputs: [_z1, _z2, _z3]));

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
        title: Text("Form Hand Arm", style: Theme.of(context).textTheme.headlineLarge),
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
