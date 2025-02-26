import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_frekuensi.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputKebisinganFrekuensiRow extends StatelessWidget {
  final DataKebisinganFrekuensi input;
  final DataKebisinganFrekuensi? result;

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

    Widget buildResult() {
      return Column(
        children: [
          keyValue(
            key: "31,5 Hz",
            value: result!.value1.toStringAsFixed(2),
          ),
          keyValue(
            key: "63,0 Hz",
            value: result!.value2.toStringAsFixed(2),
          ),
          keyValue(
            key: "125 Hz",
            value: result!.value3.toStringAsFixed(3),
          ),
          keyValue(
            key: "250 Hz",
            value: result!.value4.toStringAsFixed(2),
          ),
          keyValue(
            key: "500 Hz",
            value: result!.value5.toStringAsFixed(2),
          ),
          keyValue(
            key: "1 KHz",
            value: result!.value6.toStringAsFixed(2),
          ),
          keyValue(
            key: "2 KHz",
            value: result!.value7.toStringAsFixed(2),
          ),
          keyValue(
            key: "4 KHz",
            value: result!.value8.toStringAsFixed(2),
          ),
          keyValue(
            key: "8 KHz",
            value: result!.value9.toStringAsFixed(2),
          ),
          keyValue(
            key: "16 KHz",
            value: result!.value10.toStringAsFixed(2),
          ),
        ],
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
            input.location,
            style: theme.textTheme.titleSmall?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
          ),
          children: [
            result!.time == null
                ? Container()
                : keyValue(
                    key: "Waktu Pengukuran",
                    value: DateTimeUtils.formatToTime(result!.time!),
                    valueColor: ColorResources.primaryDark,
                  ),
            result != null ? buildResult() : Container(),
            const SizedBox(height: Dimens.paddingSmall),
          ],
        ),
      ),
    );
  }
}