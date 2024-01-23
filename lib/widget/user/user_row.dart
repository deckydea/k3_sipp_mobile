import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class UserRow extends StatelessWidget {
  final VoidCallback? onSelected;
  final User user;

  const UserRow({super.key, required this.user, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onSelected,
      color: Colors.white,
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
              Text(user.userGroup?.name ?? "",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.primaryLight))
            ],
          ),
          subtitle: Text(user.nip ?? "", style: Theme.of(context).textTheme.titleSmall),
        ),
      ),
    );
  }
}
