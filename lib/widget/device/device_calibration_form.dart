import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';

class DeviceCalibrationForm extends StatefulWidget {
  final DeviceCalibration? deviceCalibration;
  final Function(DeviceCalibration)? onSave;
  final Function(DeviceCalibration)? onUpdate;
  final bool needCalibrationInternal;
  final VoidCallback? onCancel;
  final bool? hide;

  const DeviceCalibrationForm({
    super.key,
    this.deviceCalibration,
    this.onSave,
    this.onCancel,
    this.hide,
    this.onUpdate,
    this.needCalibrationInternal = true,
  });

  @override
  State<DeviceCalibrationForm> createState() => DeviceCalibrationFormState();
}

class DeviceCalibrationFormState extends State<DeviceCalibrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _internalCalibrationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  Device? _selectedDevice;
  int? _selectedDeviceId;

  bool _hideForm = true;

  Future<void> _navigateSelectDevice() async {
    var result = await navigatorKey.currentState?.pushNamed("/select_device");
    if (result != null && result is Device) {
      _selectedDevice = result;
      _selectedDeviceId = result.id;
      _deviceController.text = result.name ?? "";
    }
  }

  void _onUpdateOrSave() {
    DeviceCalibration? calibration = widget.deviceCalibration;
    if (calibration != null) {
      calibration.deviceId = _selectedDeviceId!;
      calibration.deviceName = _deviceController.text;
      calibration.name = _noteController.text;
      calibration.internalCalibration = double.tryParse(_internalCalibrationController.text);
      calibration.device = _selectedDevice;
      calibration.calibrationValue = _selectedDevice!.calibrationValue;
      calibration.coverageFactor = _selectedDevice!.coverageFactor;
      calibration.u95 = _selectedDevice!.u95;
      if (widget.onUpdate != null) widget.onUpdate!(calibration);
    } else {
      calibration = DeviceCalibration(
        deviceId: _selectedDeviceId!,
        deviceName: _deviceController.text,
        name: _noteController.text,
        internalCalibration: double.tryParse(_internalCalibrationController.text),
        device: _selectedDevice,
        calibrationValue: _selectedDevice!.calibrationValue,
        coverageFactor: _selectedDevice!.coverageFactor,
        u95:  _selectedDevice!.u95,
      );
      if (widget.onSave != null) widget.onSave!(calibration);
    }
  }

  void hide(bool isHide) {
    if (_hideForm) _clear();
    setState(() => _hideForm = isHide);
  }

  void _clear() {
    _deviceController.text = "";
    _internalCalibrationController.text = "";
    _noteController.text = "";
  }

  @override
  void initState() {
    super.initState();
    if (widget.hide != null) _hideForm = widget.hide!;
    if (widget.deviceCalibration != null) {
      _selectedDevice = widget.deviceCalibration!.device!;
      _selectedDeviceId = widget.deviceCalibration!.deviceId;
      _deviceController.text = widget.deviceCalibration!.deviceName ?? "";
      _internalCalibrationController.text = "${widget.deviceCalibration!.internalCalibration}";
      _noteController.text = widget.deviceCalibration!.name ?? "";
    }
  }

  @override
  void dispose() {
    _deviceController.dispose();
    _internalCalibrationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hideForm
        ? Container()
        : CustomCard(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: Dimens.paddingMedium),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: CustomEditText(
                            label: "Alat",
                            controller: _deviceController,
                            width: double.infinity,
                            validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                            textInputType: TextInputType.text,
                            readOnly: true,
                            cursorVisible: false,
                            onTap: _navigateSelectDevice,
                          ),
                        ),
                        const SizedBox(width: Dimens.paddingGap),
                        widget.needCalibrationInternal
                            ? Expanded(
                                flex: 2,
                                child: CustomEditText(
                                  label: "Kalibrasi Internal",
                                  controller: _internalCalibrationController,
                                  width: double.infinity,
                                  validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                                  textInputType: TextInputType.number,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: Dimens.paddingGap),
                    CustomEditText(
                      label: "Note",
                      controller: _noteController,
                      width: double.infinity,
                      validator: (value) => ValidatorUtils.validateInputLength(context, value, 0, 100),
                      textInputType: TextInputType.text,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: widget.onCancel,
                            child: Text("Cancel",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepOrange)),
                          ),
                        ),
                        const SizedBox(width: Dimens.paddingGap),
                        Expanded(
                          child: TextButton(
                            onPressed: _onUpdateOrSave,
                            child:
                                Text("Simpan", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
