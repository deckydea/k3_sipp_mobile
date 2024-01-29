import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/assignment/assignment_bloc.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/assignment/assignment_row.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_date_timeline.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  void _navigateTo(Examination examination) {
    switch (examination.status) {
      case ExaminationStatus.PENDING:
      case ExaminationStatus.REVISION_QC1:
        navigatorKey.currentState?.pushNamed("/input_form");
        return;
      case ExaminationStatus.PENDING_APPROVE_QC1:
      case ExaminationStatus.REVISION_QC2:
      //TODO: Navigate to Koordinator Approval
        return;
      case ExaminationStatus.PENDING_INPUT_LAB:
      case ExaminationStatus.REVISION_INPUT_LAB:
      //TODO: Navigate to input lab
        return;
      case ExaminationStatus.PENDING_APPROVE_QC2:
      case ExaminationStatus.REJECT_SIGNED:
      //TODO: Navigate to Penyelia Approval
        return;
      case ExaminationStatus.PENDING_SIGNED:
      case ExaminationStatus.SIGNED:
      // TODO: Navigate to Signed and View Report
        return;
      case ExaminationStatus.COMPLETED:
      // TODO: Navigate to View Report
        return;
      case null:
    }
  }

  Widget _buildNoData() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Tidak ada assignment.",
          style: Theme
              .of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: ColorResources.warningText),
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
          style: Theme
              .of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => const CustomShimmer(),
      separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
    );
  }

  Widget _buildData(List<Examination> examinations) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage, vertical: Dimens.paddingMedium),
        itemCount: 5,
        itemBuilder: (context, index) =>
            AssignmentRow(
              onTap: () => navigatorKey.currentState?.pushNamed("/input_form"),
            ),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: Dimens.paddingGap),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        CustomDateTimeLine(
            onDateChange: (selectedDate) => context.read<AssignmentBloc>().add(FetchAssignmentEvent(date: selectedDate))),
        const SizedBox(height: Dimens.paddingSmall),
        BlocBuilder<AssignmentBloc, AssignmentState>(
          builder: (BuildContext context, AssignmentState state) {
            if (state is AssignmentLoadingState) {
              return _buildShimmer();
            } else if (state is AssignmentLoadedState) {
              if (state.examinations.isNotEmpty) {
                return _buildData(state.examinations);
              } else {
                return _buildNoData();
              }
            } else {
              return _buildError();
            }
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AssignmentBloc>().add(FetchAssignmentEvent(date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.background,
        title: Text("Assignment", style: Theme
            .of(context)
            .textTheme
            .headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}
