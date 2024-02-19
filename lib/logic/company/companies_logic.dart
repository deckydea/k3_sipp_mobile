import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/company/company_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/company_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';

class CompaniesLogic{
  final GlobalKey<CustomSearchFieldState> searchKey = GlobalKey();
  String searchKeywords = "";

  Future<MasterMessage> queryCompanies({String? query}) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(
        QueryCompaniesRequest(token: token, filter: CompanyFilter(upperBound: null, resultSize: null, query: query)));
  }
}