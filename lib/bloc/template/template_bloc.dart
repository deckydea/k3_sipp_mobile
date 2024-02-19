import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/logic/menu/template_examinations_logic.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/template/template_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

abstract class TemplateEvent {}

class FetchTemplateEvent extends TemplateEvent {
  final TemplateFilter filter;
  final TemplateExaminationsLogic logic;

  FetchTemplateEvent({required this.filter, required this.logic});
}

class LoadMoreTemplateEvent extends TemplateEvent {
  final TemplateFilter filter;
  final TemplateExaminationsLogic logic;

  LoadMoreTemplateEvent({required this.filter, required this.logic });
}

abstract class TemplateState {}

class TemplateLoadingState extends TemplateState {}

class TemplateLoadedState extends TemplateState {
  final List<Template> templates;

  TemplateLoadedState({required this.templates});
}

class TemplateEmptyState extends TemplateState {}

class TemplateErrorState extends TemplateState {}

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {

  TemplateBloc() : super(TemplateEmptyState()) {
    on<FetchTemplateEvent>((event, emit) async {
      TemplateExaminationsLogic logic = event.logic;
      emit(TemplateLoadingState());
      try {
        MasterMessage message = await logic.queryTemplates(filter: event.filter);
        if (message.response == MasterResponseType.success) {
          List<Template> templates = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Template template = Template.fromJson(element);
            templates.add(template);
          }
          if(templates.length < logic.maxQuerySize) logic.hasMore = false;
          logic.templates.clear();
          logic.templates.addAll(templates);
          logic.templates.sort(Template.registerDateComparator);
          emit(TemplateLoadedState(templates: logic.templates));
        } else {
          emit(TemplateErrorState());
        }
      } catch (_) {
        emit(TemplateErrorState());
      }
    });

    on<LoadMoreTemplateEvent>((event, emit) async {
      TemplateExaminationsLogic logic = event.logic;
      try {
        MasterMessage message = await logic.queryTemplates(filter: event.filter);
        if (message.response == MasterResponseType.success) {
          List<Template> templates = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Template template = Template.fromJson(element);
            templates.add(template);
          }
          if(templates.length < logic.maxQuerySize) logic.hasMore = false;
          templates.sort(Template.registerDateComparator);
          logic.templates.addAll(templates);
          logic.templates.sort(Template.registerDateComparator);
          emit(TemplateLoadedState(templates: logic.templates));
        } else {
          emit(TemplateErrorState());
        }
      } catch (_) {
        emit(TemplateErrorState());
      }
    });
  }
}
