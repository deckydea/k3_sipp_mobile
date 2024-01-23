import 'package:flutter/cupertino.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/user_request.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

class UsersLogic {
  final GlobalKey<CustomSearchFieldState> searchKey = GlobalKey();
  String searchKeywords = "";

  Future<MasterMessage> queryUsers({String? query = ""}) async {
    String? token = await AppRepository().getToken();
    MasterMessage message =
        QueryUsers(token: token, filter: UserFilter(query: query, userGroupId: null, resultSize: null, upperBoundEpoch: null));
    return await ConnectionUtils.sendRequest(message);
  }
}
