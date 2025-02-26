import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_penerangan.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputPeneranganRow extends StatelessWidget {
  final DataPenerangan input;
  final ResultPenerangan? result;

  const InputPeneranganRow({super.key, required this.input, this.result});

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
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(value,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 2, color: valueColor)),
          ],
        ),
      );
    }

    Widget buildResult() {
      return Column(
        children: [
          keyValue(
            key: "Waktu Pengukuran",
            value: DateTimeUtils.formatToTime(result!.time),
            valueColor: Colors.black,
          ),
          keyValue(
            key: "Rata-rata",
            value: result!.average.toStringAsFixed(2),
            valueColor: Colors.blueAccent,
          ),
          keyValue(
            key: "Standar Deviasi",
            value: result!.standardDeviation.toStringAsFixed(2),
          ),
          keyValue(
            key: "U presisi",
            value: result!.upresisi.toStringAsFixed(3),
            valueColor: Colors.green,
          ),
          keyValue(
            key: "U kalibrasi",
            value: result!.ukalibrasi.toStringAsFixed(2),
            valueColor: Colors.amber,
          ),
          keyValue(
            key: "U gabungan",
            value: result!.ugabungan.toStringAsFixed(2),
            valueColor: Colors.green[300]!,
          ),
          keyValue(
            key: "U 95% (ketidakpastian)",
            value: result!.u95.toStringAsFixed(2),
            valueColor: Colors.blue,
          ),
          keyValue(
            key: "RSU",
            value: result!.rsu.toStringAsFixed(2),
            valueColor: Colors.lightGreen,
          ),
          keyValue(
            key: "Toleransi Kebisingan",
            value: result!.toleransi.toStringAsFixed(2),
            valueColor: Colors.orangeAccent,
          ),
          keyValue(
            key: "Batas Keberterimaan",
            value: result!.batasKeterimaan.toStringAsFixed(2),
            valueColor: Colors.redAccent,
          ),
        ],
      );
    }

    return CustomCard(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
        childrenPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
        backgroundColor: Colors.transparent,
        shape: const Border.fromBorderSide(BorderSide.none),
        collapsedShape: const Border.fromBorderSide(BorderSide.none),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              input.location,
              style: theme.textTheme.bodyMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: Dimens.paddingWidget),
            Text(
              input.localLightingData,
              style: theme.textTheme.bodyMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: [
          keyValue(
            key: "Data Penerangan",
            value: "${input.value1}, ${input.value2}, ${input.value3}",
            valueColor: ColorResources.primaryDark,
          ),
          result != null ? buildResult() : Container(),
          const SizedBox(height: Dimens.paddingSmall),
        ],
      ),
    );
  }
}
