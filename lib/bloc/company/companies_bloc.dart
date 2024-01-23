


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/logic/company/companies_logic.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

@immutable
abstract class CompaniesEvent {}

class FetchCompaniesEvent extends CompaniesEvent {
  final String? query;

  FetchCompaniesEvent({this.query});
}

class AddCompanyEvent extends CompaniesEvent {
  final Company company;

  AddCompanyEvent(this.company);
}

class UpdateCompanyEvent extends CompaniesEvent {
  final Company company;

  UpdateCompanyEvent(this.company);
}

class DeleteCompanyEvent extends CompaniesEvent {
  final int id;

  DeleteCompanyEvent(this.id);
}

@immutable
abstract class CompaniesState {}

class CompaniesEmptyState extends CompaniesState {}

class CompaniesLoadingState extends CompaniesState {}

class CompaniesLoadedState extends CompaniesState {
  final List<Company> companies;

  CompaniesLoadedState(this.companies);
}

class CompaniesErrorState extends CompaniesState {}

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final CompaniesLogic _logic = CompaniesLogic();
  final Map<int, Company> _companyMap = {};

  CompaniesBloc() : super(CompaniesEmptyState()) {
    on<FetchCompaniesEvent>((event, emit) async {
      emit(CompaniesLoadingState());
      try {
        MasterMessage message = await _logic.queryCompanies(query: event.query);
        if (message.response == MasterResponseType.success) {
          _companyMap.clear();
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            Company company = Company.fromJson(element);
            _companyMap[company.id!] = company;
          }
          emit(CompaniesLoadedState(_reverse()));
        } else {
          emit(CompaniesErrorState());
        }
      } catch (_) {
        emit(CompaniesErrorState());
      }
    });

    on<AddCompanyEvent>((event, emit) {
      _companyMap[event.company.id!] = event.company;
      emit(CompaniesLoadedState(_reverse()));
    });

    on<UpdateCompanyEvent>((event, emit) {
      _companyMap[event.company.id!] = event.company;
      emit(CompaniesLoadedState(_reverse()));
    });

    on<DeleteCompanyEvent>((event, emit) {
      _companyMap.remove(event.id);
      emit(CompaniesLoadedState(_reverse()));
    });
  }

  List<Company> _reverse() {
    return _companyMap.values.toList().reversed.toList();
  }
}
