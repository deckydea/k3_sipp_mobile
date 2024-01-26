import 'dart:convert';

import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class UserRequest {
  final int userId;

  UserRequest({required this.userId});

  Map<String, dynamic> toJson() => {'userId': userId};

  factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(userId: json['userId']);
}

class MasterLoginRequest extends MasterMessage {
  MasterLoginRequest({required User user})
      : super(request: MasterRequestType.masterLogin, content: jsonEncode(user), path: "auth/login");
}

class QueryUsersRequest extends MasterMessage {
  QueryUsersRequest({required super.token, required UserFilter? filter})
      : super(request: MasterRequestType.queryUsers, content: jsonEncode(filter), path: "users/query-users");
}

class CreateUserRequest extends MasterMessage {
  CreateUserRequest({required super.token, required User? user})
      : super(request: MasterRequestType.createUser, content: jsonEncode(user), path: "users/create-user");
}

class UpdateUserRequest extends MasterMessage {
  UpdateUserRequest({required super.token, required User? user})
      : super(request: MasterRequestType.updateUser, content: jsonEncode(user), path: "users/update-user");
}

class DeleteUserRequest extends MasterMessage {
  DeleteUserRequest({required super.token, required UserRequest? userRequest})
      : super(request: MasterRequestType.deleteUser, content: jsonEncode(userRequest), path: "users/delete-user");
}

// class UpdateUserPasswordRequest extends MasterMessage {
//   UpdateUserPasswordRequest({required PasswordUpdate passwordUpdate, required Token token})
//       : super(
//           request: MasterRequestType.updateUserPassword,
//           content: jsonEncode(passwordUpdate),
//           token: token,
//         );
// }
