import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_chip.dart';

class CustomChipGroup extends StatelessWidget {
  final List<CustomChip> chips;
  final double horizontalPadding;

  const CustomChipGroup({super.key, required this.chips, this.horizontalPadding = 0});

  @override
  Widget build(BuildContext context) {
    chips.sort((a, b) => a.selected == b.selected
        ? 0
        : a.selected
            ? -1
            : 1);

    List<Widget> widgets = [];
    if (horizontalPadding > 0) widgets.add(SizedBox(width: horizontalPadding));
    if (chips.isNotEmpty) widgets.addAll(chips);
    if (horizontalPadding > 0) widgets.add(SizedBox(width: horizontalPadding));
    return SizedBox(
      height: Dimens.chipHeight,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
        separatorBuilder: (context, index) {
          if (horizontalPadding == 0) {
            return const SizedBox(width: Dimens.paddingWidget);
          } else if (index == 0 || index == widgets.length - 1) {
            return Container();
          } else {
            return const SizedBox(width: Dimens.paddingWidget);
          }
        },
      ),
    );
  }
}
