import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';

class CreateAssignmentState {
  final String? templateName;
  final Company? company;
  final List<Examination>? examinations;

  CreateAssignmentState({this.templateName, this.company, this.examinations});

  CreateAssignmentState.copyFrom(
    CreateAssignmentState old, {
    String? templateName,
    Company? company,
    List<Examination>? examinations,
  }) : this(
          templateName: templateName ?? old.templateName,
          company: company ?? old.company,
          examinations: examinations ?? old.examinations,
        );
}

class CreateAssignmentCubit extends Cubit<CreateAssignmentState> {
  static const tag = 'CreateAssignmentCubit';

  CreateAssignmentCubit() : super(CreateAssignmentState());

  void setAssignment({
    String? templateName,
    Company? company,
    List<Examination>? examinations,
    Map<int, DeviceCalibration>? deviceCalibrationMap,
  }) {
    emit(
      CreateAssignmentState.copyFrom(
        state,
        templateName: templateName,
        company: company,
        examinations: examinations,
      ),
    );
  }
}
