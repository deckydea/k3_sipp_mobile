import 'dart:convert';

import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class MasterLoginRequest extends MasterMessage {
  MasterLoginRequest({required User user})
      : super(request: MasterRequestType.masterLogin, content: jsonEncode(user), path: "auth/login");
}

class QueryUsers extends MasterMessage {
  QueryUsers({required super.token, required UserFilter? filter})
      : super(request: MasterRequestType.queryUsers, content: jsonEncode(filter), path: "users/query-users");
}

// class UpdateUserPasswordRequest extends MasterMessage {
//   UpdateUserPasswordRequest({required PasswordUpdate passwordUpdate, required Token token})
//       : super(
//           request: MasterRequestType.updateUserPassword,
//           content: jsonEncode(passwordUpdate),
//           token: token,
//         );
// }
