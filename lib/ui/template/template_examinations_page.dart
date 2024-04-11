
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/template/template_bloc.dart';
import 'package:k3_sipp_mobile/logic/menu/template_examinations_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/template/template_filter.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/enum_translation_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_chip.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_chip_group.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_circular_progress_indicator.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';

enum TemplateExaminationsTabCategory { pending, revision, signature, completed }

class TemplateExaminationsPage extends StatefulWidget {
  const TemplateExaminationsPage({super.key});

  @override
  State<TemplateExaminationsPage> createState() => _TemplateExaminationsPageState();
}

class _TemplateExaminationsPageState extends State<TemplateExaminationsPage> {
  final TemplateExaminationsLogic _logic = TemplateExaminationsLogic();

  Future<void> _queryTemplates({bool force = true, bool clear = true}) async {
    if ((!force && !_logic.hasMore)) return;

    DateTime? upperBound = force || _logic.templates.isEmpty ? null : _logic.templates.last.createdAt;

    TemplateFilter filter = TemplateFilter(
      query: "",
      companyId: null,
      upperBound: upperBound,
      resultSize: null,
    );

    if (clear) _logic.templates.clear();

    if (force) {
      context.read<TemplateBloc>().add(FetchTemplateEvent(filter: filter, logic: _logic));
    } else {
      context.read<TemplateBloc>().add(LoadMoreTemplateEvent(filter: filter, logic: _logic));
    }
  }

  Widget _buildStatusChips() {
    List<CustomChip> chips = [];
    for (ExaminationStatus status in ExaminationStatus.values) {
      chips.add(
        CustomChip(
          label: Text(EnumTranslationUtils.examinationStatus(status)),
          selected: _logic.selectedStatuses.contains(status),
          onSelected: _logic.loading
              ? null
              : (selected) {
                  if (selected) {
                    _logic.selectedStatuses.add(status);
                  } else {
                    _logic.selectedStatuses.remove(status);
                  }
                  _queryTemplates();
                },
        ),
      );
    }

    return CustomChipGroup(chips: chips, horizontalPadding: Dimens.paddingSmall);
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: Dimens.paddingWidget),
            const Expanded(child: CustomCard(child: CustomSearchField())),
            // CustomCard(child: IconButton(onPressed: () {}, icon: const Icon(Icons.sort, size: Dimens.iconSizeSmall))),
            CustomCard(
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined, size: Dimens.iconSizeSmall))),
            const SizedBox(width: Dimens.paddingWidget),
          ],
        ),
        // _buildStatusChips(),
        const SizedBox(height: Dimens.paddingMedium),
        Expanded(
          child: BlocBuilder<TemplateBloc, TemplateState>(
            builder: (context, state) {
              if (state is TemplateLoadingState) {
                return _buildShimmer();
              } else if (state is TemplateLoadedState) {
                if (state.templates.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async => _queryTemplates(),
                    child: _buildData(),
                  );
                } else {
                  return _buildNoData();
                }
              } else {
                return _buildError();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildData() {
    return ListView.separated(
      controller: _logic.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
      itemCount: _logic.hasMore ? _logic.templates.length + 1 : _logic.templates.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == _logic.templates.length && _logic.hasMore) {
          return const CustomCircularProgressIndicator();
        } else {
          Template template = _logic.templates.elementAt(index);
          return CustomCard(
            onTap: () => navigatorKey.currentState?.pushNamed("/update_assignment", arguments: template),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
              child: ListTile(
                title: Text(
                  template.company.companyName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  template.company.companyAddress!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => const CustomShimmer(),
        separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
      ),
    );
  }

  Widget _buildNoData() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Tidak ada pengujian.",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Our service is currently unavailable.",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _logic.scrollController.addListener(() {
      if (_logic.scrollController.position.atEdge &&
          _logic.scrollController.position.pixels != 0 &&
          _logic.templates.isNotEmpty &&
          _logic.hasMore) {
        _queryTemplates(force: false, clear: false);
      }
    });

    _logic.selectedStatuses.addAll(ExaminationStatus.values);
    _queryTemplates();
  }

  @override
  void dispose() {
    _logic.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Template Pengujian", style: Theme.of(context).textTheme.headlineLarge),
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
