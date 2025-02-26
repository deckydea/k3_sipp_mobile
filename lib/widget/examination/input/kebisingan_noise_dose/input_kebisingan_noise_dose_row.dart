import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_noise_dose.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputKebisinganFrekuensiRow extends StatelessWidget {
  final DataNoiseDose input;
  final DataNoiseDose? result;

  const InputKebisinganFrekuensiRow({super.key, required this.input, this.result});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget keyValue({required String key, required String value, Color valueColor = ColorResources.text}) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key,
              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(value,
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 2, color: valueColor)),
          ],
        ),
      );
    }

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
          childrenPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
          backgroundColor: Colors.transparent,
          shape: const Border.fromBorderSide(BorderSide.none),
          collapsedShape: const Border.fromBorderSide(BorderSide.none),
          title: Text(
            "${input.name} - ${input.nik}",
            style: theme.textTheme.titleSmall?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
          ),
          children: [
            const SizedBox(height: Dimens.paddingSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
              child: Text("Identitas Karyawan",
                  textAlign: TextAlign.center, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: Dimens.paddingWidget),
            keyValue(
              key: "Nama",
              value: input.name,
            ),
            keyValue(
              key: "Bagian",
              value: input.bagian,
            ),
            keyValue(
              key: "NIK",
              value: input.nik,
            ),
            const SizedBox(height: Dimens.paddingSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
              child: Text("Pengukuran",
                  textAlign: TextAlign.center, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: Dimens.paddingWidget),
            keyValue(
              key: "Waktu",
              value: "${DateTimeUtils.formatToTime(input.timeStart)} - ${DateTimeUtils.formatToTime(input.timeEnd)}",
            ),
            keyValue(
              key: "TWA (dBA)",
              value: "${input.twa}",
            ),
            keyValue(
              key: "Dose (%)",
              value: "${input.dose}",
            ),
            keyValue(
              key: "Leq (dBA)",
              value: "${input.leq}",
            ),
            const SizedBox(height: Dimens.paddingSmall),
            TextUtils.isEmpty(input.note)
                ? Container()
                : keyValue(
                    key: "Keterangan",
                    value: "${input.note}",
                  ),
            const SizedBox(height: Dimens.paddingSmall),
          ],
        ),
      ),
    );
  }
}
