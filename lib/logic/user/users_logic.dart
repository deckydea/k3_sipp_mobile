import 'package:flutter/cupertino.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/user_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

class UsersLogic {
  final GlobalKey<CustomSearchFieldState> searchKey = GlobalKey();
  String searchKeywords = "";

  Set<User> selectedUsers = {};

  Future<MasterMessage> queryUsers({String? query = "", UserFilter? filter}) async {
    String? token = await AppRepository().getToken();
    filter ??= UserFilter(query: query, userAccessMenu: "", resultSize: null, upperBound: null);
    filter.query = query;
    MasterMessage message = QueryUsersRequest(token: token, filter: filter);
    return await ConnectionUtils.sendRequest(message);
  }

  Future<MasterMessage> onDeleteUser(int userId) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(DeleteUserRequest(userRequest: UserRequest(userId: userId), token: token));
  }
}
