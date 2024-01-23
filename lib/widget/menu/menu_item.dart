import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.backgroundColor = ColorResources.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingPage),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(Dimens.paddingSmall),
              decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
              child: Icon(icon, color: Colors.white, size: Dimens.iconSizeMenu),
            ),
            title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: ColorResources.primaryDark)),
            subtitle: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorResources.primaryDark)),
          ),
        ),
      ),
    );
  }
}
