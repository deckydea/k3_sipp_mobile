
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class DeviceCalibrationRow extends StatelessWidget {
  final DeviceCalibration deviceCalibration;
  final Function(DeviceCalibration)? onDelete;

  const DeviceCalibrationRow({super.key, required this.deviceCalibration, this.onDelete});

  @override
  Widget build(BuildContext context) {
    Widget row({
      IconData? icon,
      required String title,
      String? value,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon == null ? Container() : Icon(icon, color: ColorResources.primaryDark, size: Dimens.iconSizeTitle),
            const SizedBox(width: Dimens.paddingGap),
            Expanded(
                flex: 2,
                child:
                Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark))),
            const SizedBox(width: Dimens.paddingGap),
            Text(
              value ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      );
    }

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
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingPage),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              row(
                icon: Icons.devices,
                title: deviceCalibration.deviceName!,
                value: deviceCalibration.device!.calibrationValue!.toStringAsFixed(2),
              ),
              row(
                icon: Icons.format_size,
                title: "U95",
                value: deviceCalibration.device!.u95!.toStringAsFixed(2),
              ),
              row(
                icon: Icons.map,
                title: "K (Coverage Factor)",
                value: deviceCalibration.device!.coverageFactor!.toStringAsFixed(2),
              ),
              deviceCalibration.internalCalibration != null
                  ? row(
                icon: Icons.compass_calibration,
                title: "Kalibrasi Internal",
                value: deviceCalibration.internalCalibration!.toStringAsFixed(2),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
