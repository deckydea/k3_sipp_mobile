import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class CompanyRow extends StatelessWidget {
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final Function(Company)? onSwipeDelete;
  final Company company;

  const CompanyRow({super.key, required this.company, this.onTap, this.onLongPress, this.onSwipeDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (onSwipeDelete != null) onSwipeDelete!(company);
      },
      child: CustomCard(
        onTap: onTap,
        onLongPress: onLongPress,
        color: Colors.white,
        child: ListTile(
          dense: true,
          isThreeLine: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
          focusColor: Colors.red,
          leading: const Icon(Icons.devices, size: Dimens.iconSize),
          title: Text(company.companyName ?? "", style: Theme.of(context).textTheme.headlineSmall),
          subtitle: Text(company.companyAddress ?? "", style: Theme.of(context).textTheme.labelSmall),
        ),
      ),
    );
  }
}
