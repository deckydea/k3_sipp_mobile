import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double elevation;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.onLongPress,
    this.margin,
    this.borderRadius = Dimens.cardRadius,
    this.elevation = Dimens.cardElevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      color: color,
      margin: margin,
      child: onTap == null && onLongPress == null
          ? ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: child)
          : InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: child),
            ),
    );
  }
}
