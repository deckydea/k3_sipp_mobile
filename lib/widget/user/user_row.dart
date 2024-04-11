import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class UserRow extends StatelessWidget {
  final GestureLongPressCallback? onLongPress;
  final VoidCallback? onTap;
  final User user;
  final Widget? description;
  final bool isSelected;
  final bool hideGroup;

  const UserRow(
      {super.key,
      required this.user,
      this.onTap,
      this.onLongPress,
      this.isSelected = false,
      this.description,
      this.hideGroup = false});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      onLongPress: onLongPress,
      color: isSelected ? ColorResources.backgroundPending : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.person),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
              description == null
                  ? hideGroup
                      ? Container()
                      : Text(user.userGroup?.name ?? "",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.primaryLight))
                  : description!,
            ],
          ),
          subtitle: Text(user.nip, style: Theme.of(context).textTheme.titleSmall),
        ),
      ),
    );
  }
}
