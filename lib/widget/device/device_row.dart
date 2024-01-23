import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class DeviceRow extends StatelessWidget {
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final Function(Device)? onSwipeDelete;
  final Device device;

  const DeviceRow({super.key, required this.device, this.onTap, this.onLongPress, this.onSwipeDelete});

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
        if (onSwipeDelete != null) onSwipeDelete!(device);
      },
      child: CustomCard(
        onTap: onTap,
        onLongPress: onLongPress,
        color: Colors.white,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
          focusColor: Colors.red,
          leading: const Icon(Icons.devices, size: Dimens.iconSize),
          title: Text(device.name!, style: Theme.of(context).textTheme.headlineSmall),
          subtitle: Text(device.description!, style: Theme.of(context).textTheme.labelSmall),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Kalibrasi: ${device.calibrationValue}", style: Theme.of(context).textTheme.labelSmall),
              Text("k: ${device.coverageFactor}", style: Theme.of(context).textTheme.labelSmall),
              Text("U95: ${device.u95}", style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
