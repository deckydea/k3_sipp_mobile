import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final double width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final TextStyle? style;
  final Decoration? decoration;
  final String? hint;

  const CustomDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.width = Dimens.textBoxWidth,
    this.height = Dimens.dropDownHeightSmall,
    this.padding,
    this.enabled = true,
    this.style,
    this.decoration,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 5.0, horizontal: Dimens.paddingWidget),
      decoration: decoration ??
          BoxDecoration(
            border: Border.all(color: enabled ? Colors.black54 : Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(Dimens.textBoxRadius),
            color: Colors.white,
          ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: value,
          hint: Text(hint ?? ""),
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          elevation: Dimens.cardElevation.toInt(),
          underline: Container(height: 1, color: ColorResources.primary),
          style: style ??
              (enabled
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorResources.disableText)),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}
