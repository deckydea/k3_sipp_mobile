import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final EdgeInsets padding;
  final String tooltip;

  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.padding = EdgeInsets.zero,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Padding(
        padding: padding,
        child: icon,
      ),
    );
  }
}