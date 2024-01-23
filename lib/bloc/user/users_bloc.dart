import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/logic/user/users_logic.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

@immutable
abstract class UsersEvent {}

class FetchUsersEvent extends UsersEvent {
  final String? query;

  FetchUsersEvent({this.query});
}

@immutable
abstract class UsersState {}

class UserListsState extends UsersState {}

class UsersLoadingState extends UsersState {}

class UsersLoadedState extends UsersState {
  final List<User> users;

  UsersLoadedState(this.users);
}

class UsersErrorState extends UsersState {}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersLogic _logic = UsersLogic();

  UsersBloc() : super(UserListsState()) {
    on<FetchUsersEvent>((event, emit) async {
      emit(UsersLoadingState());
      try {
        MasterMessage message = await _logic.queryUsers(query: event.query);
        if (message.response == MasterResponseType.success) {
          List<User> users = [];
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            User user = User.fromJson(element);
            users.add(user);
          }
          emit(UsersLoadedState(users));
        } else {
          emit(UsersErrorState());
        }
      } catch (_) {
        emit(UsersErrorState());
      }
    });
  }
}
