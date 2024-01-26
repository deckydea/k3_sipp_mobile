import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class ExaminationsState extends Equatable {
  final Map<int, Examination>? examinationMap;

  const ExaminationsState({this.examinationMap});

  List<Examination> get examinations  => examinationMap != null ? examinationMap!.values.toList().reversed.toList() : [];

  ExaminationsState copyWith({Map<int, Examination>? examinationMap}) =>
      ExaminationsState(examinationMap: examinationMap ?? this.examinationMap);

  @override
  List<Object?> get props => [examinationMap];
}

class ExaminationsCubit extends Cubit<ExaminationsState> {
  static const tag = 'ExaminationsCubit';

  ExaminationsCubit() : super(const ExaminationsState());

  void addOrUpdateExamination(Examination examination) {
    final updatedMap = Map<int, Examination>.from(state.examinationMap ?? {});
    examination.id ??= TextUtils.generateRandomInt();
    updatedMap[examination.id!] = examination;
    emit(state.copyWith(examinationMap: updatedMap));
  }

  void deleteExamination(Examination examination) {
    final updatedMap = Map<int, Examination>.from(state.examinationMap ?? {});
    updatedMap.remove(examination.id);
    emit(state.copyWith(examinationMap: updatedMap));
  }

  void clear() {
    emit(const ExaminationsState(examinationMap: {}));
  }
}
