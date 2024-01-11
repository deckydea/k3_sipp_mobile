import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final Size minimumSize;
  final OutlinedBorder? shape;
  final Widget? icon;
  final Widget label;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = ColorResources.primary,
    this.foregroundColor = Colors.white,
    this.padding = const EdgeInsets.all(Dimens.paddingSmall),
    this.minimumSize = const Size(Dimens.buttonWidth, Dimens.buttonHeight),
    this.shape,
    this.icon,
  });

  @override
  State<StatefulWidget> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool _loading = false;

  static const TextStyle _textStyle = TextStyle(fontSize: Dimens.fontButton, fontFamily: "Nunito");

  Widget _buildIconButton() {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(_textStyle),
        backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
        foregroundColor: MaterialStateProperty.all(widget.foregroundColor),
        padding: MaterialStateProperty.all(widget.padding),
        minimumSize: MaterialStateProperty.all(widget.minimumSize),
        shape: MaterialStateProperty.all(
          widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.buttonRadius)),
        ),
      ),
      icon: widget.icon!,
      label: _loading
          ? SizedBox(
              width: Dimens.iconSize,
              height: Dimens.iconSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(widget.foregroundColor),
                strokeWidth: 2.0,
              ),
            )
          : widget.label,
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(_textStyle),
        backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
        foregroundColor: MaterialStateProperty.all(widget.foregroundColor),
        padding: MaterialStateProperty.all(widget.padding),
        minimumSize: MaterialStateProperty.all(widget.minimumSize),
        shape: MaterialStateProperty.all(
            widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.buttonRadius))),
      ),
      child: _loading
          ? SizedBox(
              width: Dimens.iconSize,
              height: Dimens.iconSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(widget.foregroundColor),
                strokeWidth: 2.0,
              ),
            )
          : widget.label,
    );
  }

  void setLoading({required bool loading}) {
    if (_loading != loading) setState(() => _loading = loading);
  }

  @override
  Widget build(BuildContext context) => widget.icon == null ? _buildButton() : _buildIconButton();
}
