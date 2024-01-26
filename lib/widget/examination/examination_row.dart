import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class ExaminationRow extends StatelessWidget {
  final Examination examination;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const ExaminationRow({super.key, required this.examination, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      onLongPress: onLongPress,
      color: Colors.white,
      borderRadius: Dimens.cardRadiusLarge,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingPage),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Dimens.paddingGap),
              decoration: BoxDecoration(shape: BoxShape.circle, color: examination.color),
              child: examination.icon,
            ),
            const SizedBox(width: Dimens.paddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(examination.metode, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blueGrey)),
                      Text(
                          examination.implementationDate != null
                              ? DateTimeUtils.format(examination.implementationDate!)
                              : "Not Implemented",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: Dimens.paddingSmallGap),
                  Text(examination.typeOfExaminationName, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: Dimens.paddingSmallGap),
                  Text("Jenis Intensitas Kebisingan Lingkungan Kerja", style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
