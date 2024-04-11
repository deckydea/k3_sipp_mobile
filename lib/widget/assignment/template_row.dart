import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class AssignmentTemplateRow extends StatelessWidget {
  final Template template;
  final VoidCallback? onTap;

  const AssignmentTemplateRow({super.key, required this.template, this.onTap});

  @override
  Widget build(BuildContext context) {
    Company company = template.company;

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalDivider(thickness: 3, endIndent: 7, indent: 7, color: ColorResources.primary),
            const SizedBox(width: Dimens.paddingWidget),
            Expanded(
              child: CustomCard(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimens.paddingSmall),
                      Text(company.companyName, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: Dimens.paddingGap),
                      Text(company.companyAddress ?? "", style: Theme.of(context).textTheme.labelSmall),
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
