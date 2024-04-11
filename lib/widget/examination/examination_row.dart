import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/enum_translation_utils.dart';
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
                      Text(examination.metode ?? "", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blueGrey)),
                      // Text(
                      //     examination.implementationDate != null
                      //         ? DateTimeUtils.formatToDate(examination.implementationDate!)
                      //         : "Not Implemented",
                      //     style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blueGrey)),
                      // Text(
                      //     examination.statusString,
                      //     style: Theme.of(context).textTheme.bodySmall?.copyWith(color: examination.statusString)),
                      examination.statusBadge,
                    ],
                  ),
                  Text(EnumTranslationUtils.examinationType(examination.typeOfExaminationName), style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: Dimens.paddingSmallGap),
                  Text(examination.examinationType != null ? examination.examinationType!.description : "",
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
