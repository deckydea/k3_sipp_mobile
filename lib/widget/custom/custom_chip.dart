// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';

class CustomChip extends ChoiceChip {
  @override
  final Widget label;
  @override
  final TextStyle? labelStyle;
  @override
  final bool selected;
  @override
  final ValueChanged<bool>? onSelected;
  @override
  final Color backgroundColor;
  @override
  final Color selectedColor;

  const CustomChip({
    super.key,
    required this.label,
    this.labelStyle,
    this.selected = false,
    this.onSelected,
    this.backgroundColor = Colors.white,
    this.selectedColor = ColorResources.primary,
  }) : super(label: label, selected: selected);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      label: label,
      labelStyle: labelStyle ?? Theme.of(context).textTheme.labelMedium,
      backgroundColor: backgroundColor,
      disabledColor: Colors.grey,
      onSelected: onSelected,
    );
  }
}
