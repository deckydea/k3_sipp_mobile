
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class AssignmentRow extends StatelessWidget {
  //TODO: Change to required
  final Examination? examination;
  final VoidCallback? onTap;
  const AssignmentRow({super.key, this.examination, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalDivider(thickness: 3, endIndent: 7, indent: 7, color: Colors.deepOrangeAccent),
            const SizedBox(width: Dimens.paddingWidget),
            Expanded(
              child: CustomCard(
                color: ColorResources.backgroundPending,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimens.paddingSmall),
                      Text("ISN 238: 2009",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blueGrey)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Penerangan",
                            style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark),
                          ),
                          Container(
                            padding: const EdgeInsets.all(Dimens.paddingGap),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
                            child: const Icon(Icons.light_mode_outlined, color: Colors.white, size: Dimens.iconSize),
                          ),
                        ],
                      ),
                      Text("Jenis Intensitas Penerangan Lingkungan Kerja",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorResources.primaryDark)),
                      const SizedBox(height: Dimens.paddingSmall),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(Dimens.cardRadiusLarge),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.paddingSmallGap, horizontal: Dimens.paddingGap),
                              child: Text("PENDING",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: Dimens.paddingWidget),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(Dimens.cardRadiusLarge),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.paddingSmallGap, horizontal: Dimens.paddingGap),
                              child: Text(
                                "FISIKA",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
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
