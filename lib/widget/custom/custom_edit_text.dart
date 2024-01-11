import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class CustomEditText extends StatelessWidget {
  final double width;
  final double? height;
  final String? label;
  final Widget? icon;
  final bool obscure;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool enabled;
  final bool autofocus;
  final String? initialValue;
  final bool cursorVisible;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final bool withBorder;
  final FocusNode? focusNode;
  final GestureTapCallback? onIconTap;
  final List<TextInputFormatter>? inputFormatters;

  const CustomEditText({
    super.key,
    this.width = Dimens.textBoxWidth,
    this.height,
    this.label,
    this.icon,
    this.obscure = false,
    this.textInputType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
    this.initialValue,
    this.cursorVisible = true,
    this.readOnly = false,
    this.withBorder = true,
    this.maxLength,
    this.maxLines,
    this.fontSize = Dimens.fontDefault,
    this.focusNode,
    this.onIconTap,
    this.inputFormatters,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        scrollPadding: EdgeInsets.zero,
        keyboardType: textInputType,
        obscureText: obscure,
        controller: controller,
        validator: validator,
        enabled: enabled,
        autofocus: autofocus,
        showCursor: cursorVisible,
        onTap: onTap,
        onChanged: onChanged,
        initialValue: initialValue,
        readOnly: readOnly,
        autocorrect: false,
        textAlign: textAlign,
        inputFormatters: inputFormatters,
        focusNode: focusNode,
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[50],
          labelText: label,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: fontSize, color: enabled ? ColorResources.text : Colors.grey),
          focusedBorder: withBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.textBoxRadius),
                  borderSide: const BorderSide(color: ColorResources.primary, width: 1.2),
                )
              : null,
          enabledBorder: withBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimens.textBoxRadius),
                  borderSide: const BorderSide(color: Colors.black54, width: 0.8),
                )
              : null,
          suffixIcon: icon != null
              ? GestureDetector(
                  onTap: onIconTap,
                  child: Padding(
                    padding: padding ?? const EdgeInsets.symmetric(vertical: 5.0, horizontal: Dimens.paddingWidget),
                    child: icon,
                  ),
                )
              : null,
          border: withBorder ? OutlineInputBorder(borderRadius: BorderRadius.circular(Dimens.textBoxRadius)) : null,
          errorMaxLines: 5,
          errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
        ),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: enabled ? ColorResources.text : Colors.grey),
        maxLength: maxLength,
        maxLines: maxLines ?? (textInputType == TextInputType.multiline ? 3 : 1),
      ),
    );
  }
}