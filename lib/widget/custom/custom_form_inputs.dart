import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/other/data_input.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';

enum InputType { text, textArea, numeric, password, phone }

class CustomFormInputs extends StatefulWidget {
  final List<DataInput> dataInputs;
  final GlobalKey<FormState> formKey;

  const CustomFormInputs({super.key, required this.formKey, required this.dataInputs});

  @override
  State<CustomFormInputs> createState() => _CustomFormInputsState();
}

class _CustomFormInputsState extends State<CustomFormInputs> {
  Widget _buildPhoneInput(PhoneInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      validator: (value) => ValidatorUtils.validatePhone(context, value, required: dataInput.required),
      textInputType: TextInputType.phone,
    );
  }

  Widget _buildTextInput(TextInput dataInput) {
    return CustomEditText(
      width: double.infinity,
      label: dataInput.label,
      controller: dataInput.controller,
      icon: dataInput.icon,
      validator: (value) => ValidatorUtils.validateInputLength(context, value, dataInput.minLength, dataInput.maxLength,
          required: dataInput.required),
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
      validator: (value) => ValidatorUtils.validateInputLength(context, value, dataInput.minLength, dataInput.maxLength,
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
        icon: dataInput.icon ?? const Icon(Icons.lock, color: Colors.black45),
        onIconTap: () => insideState(() => obscure = !obscure),
        validator: (value) => ValidatorUtils.validateRepeatPassword(context, dataInput.value, dataInput.valueRepeat),
        textInputType: TextInputType.text,
      );
    });
  }

  Widget _buildInputs() {
    List<Widget> inputs = [];

    for (DataInput dataInput in widget.dataInputs) {
      switch (dataInput.inputType) {
        case InputType.text:
          inputs.add(_buildTextInput(dataInput as TextInput));
          break;
        case InputType.textArea:
          inputs.add(_buildTextAreaInput(dataInput as TextAreaInput));
          break;
        case InputType.password:
          inputs.add(_buildPassword(dataInput as PasswordInput));
          if (dataInput.repeatPassword) inputs.add(_buildRepeatPassword(dataInput));
          break;
        case InputType.phone:
          inputs.add(_buildPhoneInput(dataInput as PhoneInput));
          break;
        case InputType.numeric:
          break;
      }
    }

    return Column(
      children: inputs
          .map(
            (input) => Padding(
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
      key: widget.formKey,
      child: _buildInputs(),
    );
  }
}
