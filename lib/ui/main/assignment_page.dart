import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/assignment/assignment_bloc.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_date_timeline.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _navigateExaminationDetail(Examination examination) async {
    var result = await navigatorKey.currentState?.pushNamed("/input_form", arguments: examination);
    if (result != null && result is bool && result && mounted) {
      context.read<AssignmentBloc>().add(FetchAssignmentEvent(date: _selectedDate));
    }
  }

  Widget _buildNoData() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Tidak ada assignment.",
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

  Widget _buildData(List<Template> templates) {
    return Container();
    // return Container(
    //   color: Colors.white,
    //   child: ListView.separated(
    //     padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage, vertical: Dimens.paddingMedium),
    //     itemCount: examinations.length,
    //     itemBuilder: (context, index) {
    //       Examination examination = examinations.elementAt(index);
    //       return AssignmentRow(
    //         examination: examination,
    //         onTap: () => _navigateExaminationDetail(examination),
    //       );
    //     },
    //     separatorBuilder: (BuildContext context, int index) => const SizedBox(height: Dimens.paddingGap),
    //   ),
    // );
  }

  Widget _buildBody() {
    return Column(
      children: [
        CustomDateTimeLine(
            onDateChange: (selectedDate) {
              _selectedDate = selectedDate;
              context.read<AssignmentBloc>().add(FetchAssignmentEvent(date: _selectedDate));
            }),
        const SizedBox(height: Dimens.paddingSmall),
        Expanded(
          child: BlocBuilder<AssignmentBloc, AssignmentState>(
            builder: (BuildContext context, AssignmentState state) {
              if (state is AssignmentLoadingState) {
                return _buildShimmer();
              } else if (state is AssignmentLoadedState) {
                if (state.templates.isNotEmpty) {
                  return _buildData(state.templates);
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

  @override
  void initState() {
    super.initState();
    context.read<AssignmentBloc>().add(FetchAssignmentEvent(date: _selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.background,
        title: Text("Assignment", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}
