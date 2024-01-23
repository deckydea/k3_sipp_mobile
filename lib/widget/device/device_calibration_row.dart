import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class DeviceCalibrationRow extends StatelessWidget {
  final DeviceCalibration deviceCalibration;
  final Function(DeviceCalibration)? onDelete;

  const DeviceCalibrationRow({super.key, required this.deviceCalibration, this.onDelete});

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
        if (onDelete != null) onDelete!(deviceCalibration);
      },
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
          child: ListTile(
            title: Text(deviceCalibration.deviceName, style: Theme.of(context).textTheme.headlineSmall),
            trailing: Text(
              "${deviceCalibration.internalCalibration}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            subtitle: TextUtils.isEmpty(deviceCalibration.name)
                ? null
                : Text(deviceCalibration.name, style: Theme.of(context).textTheme.titleSmall),
          ),
        ),
      ),
    );
  }
}
