import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

class SelectCompanyPage extends StatefulWidget {
  final Company? selectedCompany;

  const SelectCompanyPage({super.key, this.selectedCompany});

  @override
  State<SelectCompanyPage> createState() => _SelectCompanyPageState();
}

class _SelectCompanyPageState extends State<SelectCompanyPage> {
  Widget _buildBody() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: Dimens.paddingWidget),
            const Expanded(child: CustomCard(child: CustomSearchField())),
            CustomCard(child: IconButton(onPressed: () {}, icon: const Icon(Icons.sort, size: Dimens.iconSizeSmall))),
            CustomCard(
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined, size: Dimens.iconSizeSmall))),
            const SizedBox(width: Dimens.paddingWidget),
          ],
        ),
        const SizedBox(height: Dimens.paddingWidget),
        const Expanded(child: Center(child: Text("Company"))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Company", style: Theme.of(context).textTheme.headlineLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState!.pushNamed("/create_company"),
        shape: const CircleBorder(),
        backgroundColor: ColorResources.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildBody(),
    );
  }
}
