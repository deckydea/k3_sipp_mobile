import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/other/date_picker.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dialog.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dropdown_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

enum InputType { text, number, numeric, password, phone, email, currency, textArea, date, time, groupInput, dropdown }

class CustomFormInput extends StatefulWidget {
  final Widget? title;
  final List<DataInput> dataInputs;

  const CustomFormInput({super.key, required this.dataInputs, this.title});

  @override
  State<CustomFormInput> createState() => CustomFormInputState();
}

class CustomFormInputState extends State<CustomFormInput> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void unFocusNode() => FocusScope.of(context).unfocus();

  bool validate() {
    unFocusNode();
    return _formKey.currentState!.validate();
  }

  Future<void> _selectDate(DateInput dateInput) async {
    final DateTime now = DateTime.now().toLocal();
    final DateTime maxDate = dateInput.maxDate ?? now.add(const Duration(days: 200 * 365));
    final DateTime minDate = dateInput.minDate ?? now;

    DatePickerArgument argument = DatePickerArgument(
      mode: DateRangePickerSelectionMode.single,
      selectedDate: dateInput.selectedDate,
      minDate: minDate,
      maxDate: maxDate,
    );

    var result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          CustomDialog(
            width: Dimens.dialogWidthSmall,
            height: Dimens.dialogWidthSmall,
            child: DatePickerPage(argument: argument),
          ),
    );

    if (result != null && result is DateTime) {
      setState(() {
        dateInput.selectedDate = result;
        dateInput.controller.text = DateTimeUtils.formatToDate(result);
      });
    }
  }

  Future<void> _selectTime(TimeInput timeInput) async {
    timeInput.selectedTime = await showTimePicker(
      context: context,
      initialTime: timeInput.selectedTime != null
          ? TimeOfDay(hour: timeInput.selectedTime!.hour, minute: timeInput.selectedTime!.minute)
          : const TimeOfDay(hour: 8, minute: 0),
    );

    if (timeInput.selectedTime != null) {
      setState(() =>
      timeInput.controller.text =
          DateTimeUtils.formatToTime(DateTime(1999, 01, 01, timeInput.selectedTime!.hour, timeInput.selectedTime!.minute)));
    }
  }

  Widget _buildTimeInput(TimeInput timeInput) {
    return CustomEditText(
      width: double.infinity,
      label: timeInput.label,
      controller: timeInput.controller,
      readOnly: true,
      cursorVisible: false,
      icon: Icon(TextUtils.isEmpty(timeInput.controller.text) ? Icons.watch_later : Icons.cancel_outlined),
      onIconTap: !TextUtils.isEmpty(timeInput.controller.text) ? () => timeInput.controller.text = "" : null,
      onTap: () => _selectTime(timeInput),
      textInputType: TextInputType.text,
      validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
    );
  }

  Widget _buildDateInput(DateInput dateInput) {
    return CustomEditText(
      label: dateInput.label,
      width: double.infinity,
      controller: dateInput.controller,
      readOnly: true,
      cursorVisible: false,
      icon: Icon(TextUtils.isEmpty(dateInput.controller.text) ? Icons.calendar_month : Icons.cancel_outlined),
      onIconTap: !TextUtils.isEmpty(dateInput.controller.text) ? () => dateInput.controller.text = "" : null,
      onTap: () => _selectDate(dateInput),
      textInputType: TextInputType.text,
    );
  }

  Widget _buildTextAreaInput(TextAreaInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      maxLines: dataInput.maxLines,
      icon: dataInput.icon,
      enabled: dataInput.enable,
      validator: (value) =>
          ValidatorUtils.validateInputLength(context, value, dataInput.minLength, dataInput.maxLength,
              required: dataInput.required),
      textInputType: TextInputType.text,
    );
  }

  Widget _buildCurrencyInput(CurrencyInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      isCurrencyInput: true,
      enabled: dataInput.enable,
      onChanged: dataInput.onChanged,
      validator: (value) => ValidatorUtils.validatePositive(context, value, required: dataInput.required),
      textInputType: TextInputType.number,
    );
  }

  Widget _buildEmailInput(EmailInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      enabled: dataInput.enable,
      onChanged: dataInput.onChanged,
      validator: (value) => ValidatorUtils.validateEmail(context, value, required: dataInput.required),
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneInput(PhoneInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      enabled: dataInput.enable,
      onChanged: dataInput.onChanged,
      validator: (value) => ValidatorUtils.validatePhone(context, value, required: dataInput.required),
      textInputType: TextInputType.phone,
    );
  }

  Widget _buildNumberInput(NumberInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      enabled: dataInput.enable,
      onChanged: dataInput.onChanged,
      validator: (value) =>
          ValidatorUtils.validateIntegerValue(context, int.parse(value!), dataInput.lowerBound, dataInput.upperBound),
      textInputType: TextInputType.number,
    );
  }

  Widget _buildNumericInput(NumericInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      enabled: dataInput.enable,
      onChanged: dataInput.onChanged,
      validator: (value) =>
          ValidatorUtils.validateNumericValue(context, double.parse(value!), dataInput.lowerBound, dataInput.upperBound),
      textInputType: TextInputType.number,
    );
  }

  Widget _buildTextInput(TextInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      onTap: dataInput.onTap,
      controller: dataInput.controller,
      icon: dataInput.icon,
      enabled: dataInput.enable,
      onChanged: dataInput.onChanged,
      validator: (value) =>
          ValidatorUtils.validateInputLength(context, value, dataInput.minLength, dataInput.maxLength,
              required: dataInput.required),
      textInputType: TextInputType.text,
    );
  }

  Widget _buildPassword(PasswordInput dataInput) {
    bool obscure = true;
    return StatefulBuilder(
      builder: (BuildContext context, insideState) {
        return CustomEditText(
          width: double.infinity,
          obscure: obscure,
          label: dataInput.label,
          controller: dataInput.controller,
          onChanged: dataInput.onChanged,
          enabled: dataInput.enable,
          icon: dataInput.icon ?? const Icon(Icons.lock, color: Colors.black45),
          onIconTap: () => insideState(() => obscure = !obscure),
          validator: (value) => ValidatorUtils.validatePassword(context, value),
          textInputType: TextInputType.text,
        );
      },
    );
  }

  Widget _buildRepeatPassword(PasswordInput dataInput) {
    bool obscure = true;
    return StatefulBuilder(builder: (BuildContext context, insideState) {
      return CustomEditText(
        width: double.infinity,
        obscure: true,
        label: "Konfirmasi ${dataInput.label}",
        controller: dataInput.repeatPasswordController,
        onChanged: dataInput.onChanged,
        enabled: dataInput.enable,
        icon: dataInput.icon ?? const Icon(Icons.lock, color: Colors.black45),
        onIconTap: () => insideState(() => obscure = !obscure),
        validator: (value) => ValidatorUtils.validateRepeatPassword(context, dataInput.value, dataInput.valueRepeat),
        textInputType: TextInputType.text,
      );
    });
  }

  Widget _buildDropdownInput(DropdownInput dataInput) {
    return StatefulBuilder(
      builder: (BuildContext context, insideState) {
        return CustomDropdownButton(
          items: dataInput.dropdown,
          value: dataInput.selected,
          width: double.infinity,
          onChanged: (value) => value != null ? insideState(() => dataInput.selected = value) : null,
        );
      },
    );
  }

  List<Widget> _getInputs(List<DataInput> dataInputs) {
    List<Widget> inputs = [];
    for (DataInput dataInput in dataInputs) {
      switch (dataInput.inputType) {
        case InputType.text:
          inputs.add(_buildTextInput(dataInput as TextInput));
          break;
        case InputType.password:
          inputs.add(_buildPassword(dataInput as PasswordInput));
          if (dataInput.repeatPassword) inputs.add(_buildRepeatPassword(dataInput));
          break;
        case InputType.phone:
          inputs.add(_buildPhoneInput(dataInput as PhoneInput));
          break;
        case InputType.number:
          inputs.add(_buildNumberInput(dataInput as NumberInput));
          break;
        case InputType.email:
          inputs.add(_buildEmailInput(dataInput as EmailInput));
          break;
        case InputType.currency:
          inputs.add(_buildCurrencyInput(dataInput as CurrencyInput));
          break;
        case InputType.textArea:
          inputs.add(_buildTextAreaInput(dataInput as TextAreaInput));
          break;
        case InputType.date:
          inputs.add(_buildDateInput(dataInput as DateInput));
          break;
        case InputType.numeric:
          inputs.add(_buildNumericInput(dataInput as NumericInput));
          break;
        case InputType.time:
          inputs.add(_buildTimeInput(dataInput as TimeInput));
          break;
        case InputType.dropdown:
          inputs.add(_buildDropdownInput(dataInput as DropdownInput));
          break;
        case InputType.groupInput:
          GroupInput input = dataInput as GroupInput;
          if (input.title != null) {
            inputs.add(input.title!);
          }
          List<Widget> widgets = _getInputs(input.dataInputs);

          inputs.add(
            Row(
              children: widgets
                  .map(
                    (e) =>
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap),
                        child: e,
                      ),
                    ),
              )
                  .toList(),
            ),
          );
          break;
      }
    }

    return inputs;
  }

  Widget _buildInputs(List<DataInput> dataInputs) {
    List<Widget> inputs = [];

    if (widget.title != null) {
      inputs.add(widget.title!);
    }

    inputs.addAll(_getInputs(dataInputs));

    return Column(
      children: inputs
          .map(
            (input) =>
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.paddingWidget),
              child: input,
            ),
      )
          .toList(),
    );
  }

  @override
  void dispose() {
    for (DataInput input in widget.dataInputs) {
      input.controller.dispose();
      if (input is PasswordInput) input.repeatPasswordController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _buildInputs(widget.dataInputs),
    );
  }
}
