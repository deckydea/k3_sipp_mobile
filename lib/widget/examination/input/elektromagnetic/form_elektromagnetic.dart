import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_elektromagnetic.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_elektromagnetic.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class FormElektromagneticPage extends StatefulWidget {
  final Function(DataElektromagnetik)? onUpdate;
  final Function(DataElektromagnetik)? onAdd;
  final Function(DataElektromagnetik)? onDelete;
  final DataElektromagnetik? data;

  const FormElektromagneticPage({super.key, this.data, this.onUpdate, this.onAdd, this.onDelete});

  @override
  State<FormElektromagneticPage> createState() => _FormElektromagneticPageState();
}

class _FormElektromagneticPageState extends State<FormElektromagneticPage> {
  final GlobalKey<CustomFormInputState> _formKey = GlobalKey();
  final List<DataInput> _inputs = [];

  final TimeInput _time = TimeInput(label: "Waktu", required: true);
  final TextInput _location = TextInput(label: "Lokasi", required: true);
  final NumericInput _dl = NumericInput(label: "DL", required: true);
  final NumericInput _jumlahTK = NumericInput(label: "Jumlah Tenaga Kerja yang Terpapar ", required: true);
  final TextInput _note = TextInput(label: "Note", required: false);
  final List<DropdownMenuItem<BagianTubuh>> _dropdownBagianTubuh = [];
  DropdownInput? _bagianTubuh;
  BagianTubuh? _selectedBagianTubuh;

  late TextInput _deviceCalibration;
  Device? _selectedDevice;

  DataElektromagnetik? _data;

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
      DataElektromagnetik input = _data!.copyWith(
        location: _location.value,
        time: _time.selectedTime == null
            ? null
            : DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        bagianTubuh: _bagianTubuh!.selected!,
        dl: double.parse(_dl.value),
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
      );

      DateTime now = DateTime.now();
      DataElektromagnetik input = DataElektromagnetik(
        location: _location.value,
        time: DateTime(now.year, now.month, now.day, _time.selectedTime!.hour, _time.selectedTime!.minute),
        jumlahTK: int.parse(_jumlahTK.value),
        bagianTubuh: _bagianTubuh!.selected!,
        dl: double.parse(_dl.value),
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
      _time.setSelectedTime(TimeOfDay.fromDateTime(_data!.time));
      _location.setValue(_data!.location);
      _dl.setValue("${_data!.dl}");
      _jumlahTK.setValue("${_data!.jumlahTK}");
      _note.setValue(_data!.note ?? "");
      _selectedBagianTubuh = _data!.bagianTubuh;
    }

    for (BagianTubuh bagianTubuh in BagianTubuh.values) {
      _dropdownBagianTubuh.add(DropdownMenuItem(
        value: bagianTubuh,
        child: Text(bagianTubuh.label),
      ));
    }
    _selectedBagianTubuh = _selectedBagianTubuh ?? BagianTubuh.anggotaGerak;
    _bagianTubuh = DropdownInput(selected: _selectedBagianTubuh, dropdown: _dropdownBagianTubuh, label: "Bagian Tubuh");

    _inputs.add(_deviceCalibration);
    _inputs.add(_location);
    _inputs.add(_time);
    _inputs.add(_jumlahTK);
    _inputs.add(_dl);
    _inputs.add(_bagianTubuh!);
    _inputs.add(_note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.background,
        title: Text("Form Elektromagnetic", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
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
    );
  }
}
