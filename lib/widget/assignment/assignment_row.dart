import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class AssignmentRow extends StatelessWidget {
  final Examination examination;
  final VoidCallback? onTap;

  const AssignmentRow({super.key, required this.examination, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalDivider(thickness: 3, endIndent: 7, indent: 7, color: examination.color),
            const SizedBox(width: Dimens.paddingWidget),
            Expanded(
              child: CustomCard(
                color: examination.backgroundColorStatus,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimens.paddingSmall),
                      Text(examination.metode, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blueGrey)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            examination.typeOfExaminationName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark),
                          ),
                          Container(
                            padding: const EdgeInsets.all(Dimens.paddingGap),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: examination.color),
                            child: examination.icon,
                          ),
                        ],
                      ),
                      Text(examination.examinationType!.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorResources.primaryDark)),
                      const SizedBox(height: Dimens.paddingSmall),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          examination.statusBadge,
                          const SizedBox(width: Dimens.paddingWidget),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(Dimens.cardRadiusLarge),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: Dimens.paddingSmallGap, horizontal: Dimens.paddingGap),
                              child: Text(
                                examination.examinationType!.type.name,
                                style: const TextStyle(color: Colors.white, fontSize: Dimens.fontXSmall),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.paddingSmall),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
