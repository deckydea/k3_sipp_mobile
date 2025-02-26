import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_elektromagnetic.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_elektromagnetic.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputElektroMagneticRow extends StatefulWidget {
  final DataElektromagnetik input;
  final ResultElektromagnetic? result;

  const InputElektroMagneticRow({super.key, required this.input, this.result});

  @override
  State<InputElektroMagneticRow> createState() => _InputElektroMagneticRowState();
}

class _InputElektroMagneticRowState extends State<InputElektroMagneticRow> {
  late ThemeData _theme;

  Future<void> _showDeviceDetailDialog(DeviceCalibration deviceCalibration) async {
    if (deviceCalibration.device == null) return;

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
                child: Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorResources.primaryDark))),
            const SizedBox(width: Dimens.paddingGap),
            Text(
              value ?? "",
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
      );
    }

    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
        title: Text("Alat yang Digunakan",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row(
              icon: Icons.devices,
              title: deviceCalibration.device!.name!,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tutup", style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _keyValue({required String key, required String value, Color valueColor = ColorResources.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: _theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(value,
              style: _theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 2, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return widget.result == null
        ? Container()
        : Column(
            children: [
              Text("Hasil", textAlign: TextAlign.center, style: _theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              _keyValue(
                key: "Satuan",
                value: "Tesla (T)",
              ),
              _keyValue(
                key: "NAB",
                value: "${widget.result!.bagianTubuh.nab} T",
              ),
              _keyValue(
                key: "Hasil Pengukuran (Mikro)",
                value: "${widget.result!.mikro}",
              ),
              _keyValue(
                key: "Hasil Pengukuran (Milli)",
                value: "${widget.result!.mili}",
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return CustomCard(
      color: ColorResources.backgroundDark,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage, vertical: 0),
        childrenPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: const Border.fromBorderSide(BorderSide.none),
        collapsedShape: const Border.fromBorderSide(BorderSide.none),
        dense: true,
        title: Text(
          widget.input.location,
          style: _theme.textTheme.labelMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
        ),
        children: [
          const SizedBox(height: Dimens.paddingSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
            child: Text("Informasi",
                textAlign: TextAlign.center, style: _theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: Dimens.paddingWidget),
          _keyValue(
            key: "Lokasi",
            value: widget.input.location,
            valueColor: ColorResources.primaryDark,
          ),
          _keyValue(
            key: "Waktu",
            value: DateTimeUtils.formatToTime(widget.input.time),
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Jumlah Tenaga Kerja yang terpapar",
            value: "${widget.input.jumlahTK} Orang",
          ),
          _keyValue(
            key: "Bagian Tubuh",
            value: widget.input.bagianTubuh.label,
          ),
          _keyValue(
            key: "DL",
            value: "${widget.input.dl}",
          ),
          _keyValue(
            key: "Note",
            value: TextUtils.isEmpty(widget.input.note) ? '-' : widget.input.note!,
          ),
          GestureDetector(
            onTap: () => _showDeviceDetailDialog(widget.input.deviceCalibration!),
            child: _keyValue(
              key: "Kalibrasi Alat",
              value: "${widget.input.deviceCalibration!.device!.name}",
            ),
          ),
          const SizedBox(height: Dimens.paddingMedium),
          _buildResult(),
          const SizedBox(height: Dimens.paddingMedium),
        ],
      ),
    );
  }
}
