import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_icon_button.dart';

class CustomDialogTitle extends StatelessWidget {
  final String? title;
  final Color? titleColor;
  final Widget? titleWidget;
  final Widget? leading;
  final Widget? trailing;
  final bool withCloseButton;
  final VoidCallback? onDismiss;
  final TextAlign titleAlign;

  const CustomDialogTitle({
    super.key,
    this.title,
    this.titleColor,
    this.titleWidget,
    this.leading,
    this.trailing,
    this.withCloseButton = true,
    this.onDismiss,
    this.titleAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.paddingWidget),
      child: Column(
        children: [
          Row(
            children: [
              leading == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: Dimens.paddingSmall),
                      child: leading!,
                    ),
              Expanded(
                child: titleWidget ??
                    Text(
                      title ?? "",
                      textAlign: titleAlign,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleColor == null
                          ? Theme.of(context).textTheme.headlineMedium
                          : Theme.of(context).textTheme.headlineMedium!.copyWith(color: titleColor),
                    ),
              ),
              trailing == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: Dimens.paddingSmall),
                      child: trailing!,
                    ),
              withCloseButton
                  ? Padding(
                      padding: const EdgeInsets.only(left: Dimens.paddingSmall),
                      child: CustomIconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onDismiss ?? () => navigatorKey.currentState!.pop(),
                        tooltip: "Tutup",
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
