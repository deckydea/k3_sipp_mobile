import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/service/assignment_service.dart';

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
  final List<Template> templates;

  AssignmentLoadedState(this.templates);
}

class AssignmentErrorState extends AssignmentState {}

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {

  AssignmentBloc() : super(AssignmentEmptyState()) {
    on<FetchAssignmentEvent>((event, emit) async {
      emit(AssignmentLoadingState());
      try {
        MasterMessage message = await AssignmentService.queryTemplates(date: event.date);
        if (message.response == MasterResponseType.success) {
          List<Template> templates = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Template template = Template.fromJson(element);
            templates.add(template);
          }
          emit(AssignmentLoadedState(templates));
        } else {
          emit(AssignmentErrorState());
        }
      } catch (_) {
        print("__$_");
        emit(AssignmentErrorState());
      }
    });
  }
}