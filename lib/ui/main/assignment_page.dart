import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/assignment_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

enum AssignmentTabCategory { pending, revision, signature, completed }

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final AssignmentLogic _logic = AssignmentLogic();

  Widget _buildBody() {
    return DefaultTabController(
      length: AssignmentTabCategory.values.length,
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
            tabs: AssignmentTabCategory.values.map((e) => Text(e.name.toUpperCase())).toList(),
          ),
          const SizedBox(height: Dimens.paddingWidget),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: Dimens.paddingWidget),
              const Expanded(child: CustomCard(child: CustomSearchField(), )),
              CustomCard(child: IconButton(onPressed: () {}, icon: const Icon(Icons.sort, size: Dimens.iconSizeSmall))),
              CustomCard(child: IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined, size: Dimens.iconSizeSmall))),
              const SizedBox(width: Dimens.paddingWidget),
            ],
          ),
          const SizedBox(height: Dimens.paddingWidget),
          Expanded(
            child: TabBarView(
              children: AssignmentTabCategory.values.map((e) => Center(child: Text(e.name.toUpperCase()))).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print("BUILD AssignmentPage");
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Assignment", style: Theme.of(context).textTheme.headlineLarge),
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
