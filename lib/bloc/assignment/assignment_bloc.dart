import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/logic/assignment/assignment_logic.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

@immutable
abstract class AssignmentEvent {}

class FetchAssignmentEvent extends AssignmentEvent {
  final DateTime date;

  FetchAssignmentEvent({required this.date});
}


@immutable
abstract class AssignmentState {}

class AssignmentEmptyState extends AssignmentState {}

class AssignmentLoadingState extends AssignmentState {}

class AssignmentLoadedState extends AssignmentState {
  final List<Examination> examinations;

  AssignmentLoadedState(this.examinations);
}

class AssignmentErrorState extends AssignmentState {}

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentLogic _logic = AssignmentLogic();

  AssignmentBloc() : super(AssignmentEmptyState()) {
    on<FetchAssignmentEvent>((event, emit) async {
      emit(AssignmentLoadingState());
      try {
        MasterMessage message = await _logic.queryExaminations(date: event.date);
        if (message.response == MasterResponseType.success) {
          List<Examination> examinations = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Examination examination = Examination.fromJson(element);
            examinations.add(examination);
          }
          emit(AssignmentLoadedState(examinations));
        } else {
          emit(AssignmentErrorState());
        }
      } catch (_) {
        print("___: $_");
        emit(AssignmentErrorState());
      }
    });
  }
}