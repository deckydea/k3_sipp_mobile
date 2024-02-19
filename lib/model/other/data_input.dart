import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_form_inputs.dart';

class DataInput {
  final InputType inputType;
  final String label;
  final bool required;

  final TextEditingController controller = TextEditingController();

  DataInput({required this.inputType, required this.label, this.required = false});

  String get value => controller.text;

  void setValue(String? value) => controller.text = value ?? "";
}

class TextInput extends DataInput {
  final int minLength;
  final int maxLength;

  //Style
  Icon? icon;

  TextInput({
    this.minLength = 0,
    this.maxLength = 999,
    this.icon,
    super.required,
    required super.label,
  }) : super(inputType: InputType.text);
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
