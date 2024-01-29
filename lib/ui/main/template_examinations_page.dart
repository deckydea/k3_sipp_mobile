import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/menu/template_examinations_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

enum TemplateExaminationsTabCategory { pending, revision, signature, completed }

class TemplateExaminationsPage extends StatefulWidget {
  const TemplateExaminationsPage({super.key});

  @override
  State<TemplateExaminationsPage> createState() => _TemplateExaminationsPageState();
}

class _TemplateExaminationsPageState extends State<TemplateExaminationsPage> {
  final TemplateExaminationsLogic _logic = TemplateExaminationsLogic();

  Widget _buildBody() {
    return DefaultTabController(
      length: TemplateExaminationsTabCategory.values.length,
      child: Column(
        children: [
          TabBar(
            padding: EdgeInsets.zero,
            isScrollable: false,
            unselectedLabelColor: ColorResources.primary.withOpacity(0.7),
            indicatorColor: ColorResources.primary,
            labelColor: ColorResources.primary,
            labelStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w800),
            labelPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingSmall, vertical: Dimens.paddingSmall * 1.4),
            tabs: TemplateExaminationsTabCategory.values.map((e) => Text(e.name.toUpperCase())).toList(),
          ),
          const SizedBox(height: Dimens.paddingWidget),
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
          Expanded(
            child: TabBarView(
              children: TemplateExaminationsTabCategory.values.map((e) => Center(child: Text(e.name.toUpperCase()))).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print("BUILD TemplateExaminationsPage");
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Examinations", style: Theme.of(context).textTheme.headlineLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState!.pushNamed("/create_assignment"),
        shape: const CircleBorder(),
        backgroundColor: ColorResources.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildBody(),
    );
  }
}
