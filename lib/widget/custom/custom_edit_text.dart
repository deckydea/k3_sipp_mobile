import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  // Add isCurrencyInput property to determine if currency input is enabled
  final bool isCurrencyInput;

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
    this.padding,

    // Initialize isCurrencyInput with default value false
    this.isCurrencyInput = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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

        // Conditionally apply CurrencyInputFormatter based on isCurrencyInput
        inputFormatters: isCurrencyInput
            ? [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                CurrencyInputFormatter(), // Format input as currency
              ]
            : null,

        textAlign: textAlign,

        focusNode: focusNode,

        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: Dimens.textBoxHeightSmall, horizontal: Dimens.paddingSmall),
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
                  borderSide: const BorderSide(color: Colors.black54, style: BorderStyle.solid, width: 0.5),
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

// CurrencyInputFormatter class for formatting currency input
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == newValue.selection.extentOffset) {
      if (newValue.text.startsWith('0') && newValue.text.length > 1) {
        return newValue.copyWith(
          text: newValue.text.substring(0, newValue.text.length - 1),
          selection: TextSelection.collapsed(offset: newValue.text.length - 1),
        );
      }
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return const TextEditingValue();
    }

    int value = int.parse(newText);

    final moneyMask = NumberFormat("#,##0", "en_US");

    String newTextFormatted = moneyMask.format(value);

    return TextEditingValue(
      text: newTextFormatted,
      selection: TextSelection.collapsed(offset: newTextFormatted.length),
    );
  }
}
