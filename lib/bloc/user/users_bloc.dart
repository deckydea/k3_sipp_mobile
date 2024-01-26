import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/logic/user/users_logic.dart';
import 'package:k3_sipp_mobile/model/group/user_group.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

@immutable
abstract class UsersEvent {}

class FetchUsersEvent extends UsersEvent {
  final String? query;
  final UserFilter? userFilter;

  FetchUsersEvent({this.query, this.userFilter});
}

class AddUserEvent extends UsersEvent {
  final User user;

  AddUserEvent(this.user);
}

class UpdateUserEvent extends UsersEvent {
  final User user;

  UpdateUserEvent(this.user);
}

class DeleteUserEvent extends UsersEvent {
  final int id;

  DeleteUserEvent(this.id);
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
  final Set<UserGroup> usersGroups = {};
  final Map<int, User> _userMap = {};

  UsersBloc() : super(UserListsState()) {
    on<FetchUsersEvent>((event, emit) async {
      emit(UsersLoadingState());
      try {
        MasterMessage message = await _logic.queryUsers(query: event.query, filter: event.userFilter);
        if (message.response == MasterResponseType.success) {
          _userMap.clear();
          Iterable iterable = jsonDecode(message.content!);
          for (var element in iterable) {
            User user = User.fromJson(element);
            _userMap[user.id!] = user;
            if (user.userGroup != null) usersGroups.add(user.userGroup!);
          }
          emit(UsersLoadedState(usersSorted()));
        } else {
          emit(UsersErrorState());
        }
      } catch (_) {
        emit(UsersErrorState());
      }
    });


    on<AddUserEvent>((event, emit) {
      _userMap[event.user.id!] = event.user;
      emit(UsersLoadedState(usersSorted()));
    });

    on<UpdateUserEvent>((event, emit) {
      _userMap[event.user.id!] = event.user;
      emit(UsersLoadedState(usersSorted()));
    });

    on<DeleteUserEvent>((event, emit) {
      _userMap.remove(event.id);
      emit(UsersLoadedState(usersSorted()));
    });
  }

  List<User> usersSorted() {
    return _userMap.values.toList().reversed.toList();
  }
}
