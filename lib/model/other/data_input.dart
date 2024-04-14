import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_input.dart';

class DataInput {
  final InputType inputType;
  final String? label;
  final bool required;
  final bool enable;
  Function(String)? onChanged;

  final TextEditingController controller = TextEditingController();

  DataInput({
    required this.inputType,
    this.label,
    this.required = false,
    this.enable = true,
    this.onChanged,
  });

  void setOnChange(Function(String) onChanged) => this.onChanged = onChanged;

  String get value => controller.text;

  void setValue(String value) => controller.text = value;
}

class TextInput extends DataInput {
  final int minLength;
  final int maxLength;
  final Function()? onTap;

  //Style
  Icon? icon;

  TextInput({
    this.minLength = 0,
    this.maxLength = 999,
    this.icon,
    this.onTap,
    super.required,
    required super.label,
  }) : super(inputType: InputType.text);
}

class PasswordInput extends DataInput {
  final int minLength;
  final int maxLength;

  final bool repeatPassword;

  final TextEditingController repeatPasswordController = TextEditingController();

  //Style
  Icon? icon;

  PasswordInput({
    this.minLength = 0,
    this.maxLength = 999,
    this.repeatPassword = false,
    super.required,
    required super.label,
  }) : super(inputType: InputType.password);

  String get valueRepeat => repeatPasswordController.text;
}

class PhoneInput extends DataInput {
  //Style
  Icon? icon;

  PhoneInput({
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.phone);
}

class EmailInput extends DataInput {
  //Style
  Icon? icon;

  EmailInput({
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.email);
}

class NumberInput extends DataInput {
  int lowerBound;
  int upperBound;

  //Style
  Icon? icon;

  NumberInput({
    this.lowerBound = 0,
    this.upperBound = 999,
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.number);
}

class NumericInput extends DataInput {
  double lowerBound;
  double upperBound;

  //Style
  Icon? icon;

  NumericInput({
    this.lowerBound = 0,
    this.upperBound = 999,
    this.icon,
    super.enable = true,
    super.required,
    required super.label,
  }) : super(inputType: InputType.numeric);
}

class CurrencyInput extends DataInput {
  int lowerBound;
  int upperBound;

  //Style
  Icon? icon;

  CurrencyInput({
    this.lowerBound = 0,
    this.upperBound = 999,
    this.icon,
    super.required,
    required super.label,
    super.onChanged,
  }) : super(inputType: InputType.currency);
}

class TextAreaInput extends DataInput {
  final int minLength;
  final int maxLength;
  final int maxLines;

  //Style
  Icon? icon;

  TextAreaInput({
    this.minLength = 0,
    this.maxLength = 999,
    this.maxLines = 3,
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.textArea);
}

class DateInput extends DataInput {
  final DateTime? minDate;
  final DateTime? maxDate;
  DateTime? selectedDate;

  //Style
  Icon? icon;

  DateInput({
    this.selectedDate,
    this.minDate,
    this.maxDate,
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.date);

  void setSelectedDate(DateTime? date) {
    if (date != null) {
      selectedDate = date;
      super.controller.text = DateTimeUtils.formatToDate(date);
    }
  }
}

class TimeInput extends DataInput {
  TimeOfDay? selectedTime;

  //Style
  Icon? icon;

  TimeInput({
    this.selectedTime,
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.time);

  void setSelectedTime(TimeOfDay? time) {
    if (time != null) {
      selectedTime = time;
      super.controller.text = DateTimeUtils.formatToTime(DateTime(1999, 01, 01, time.hour, time.minute));
    }
  }
}

class GroupInput extends DataInput {
  final List<DataInput> dataInputs;
  final Widget? title;

  GroupInput({
    required this.dataInputs,
    this.title,
  }) : super(inputType: InputType.groupInput);
}

class DropdownInput extends DataInput {
  final List<DropdownMenuItem> dropdown;
  dynamic selected;

  DropdownInput({required this.selected, required this.dropdown})  : super(inputType: InputType.dropdown);
}
