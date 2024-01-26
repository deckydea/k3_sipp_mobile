import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final int level;

  const CustomDialog({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    double widthRatio = level == 0 ? 1.0 : (1.0 - level * 0.05);
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(Dimens.dialogRadius)),
          color: Colors.white,
        ),
        width: widthRatio * (width ?? MediaQuery.of(context).size.width * Dimens.dialogWidthRatio),
        height: height,
        child: child,
      ),
    );
  }
}
