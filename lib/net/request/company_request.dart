import 'dart:convert';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/model/company/company_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class QueryCompaniesRequest extends MasterMessage {
  QueryCompaniesRequest({
    required CompanyFilter filter,
    required super.token,
  }) : super(
    request: MasterRequestType.queryCompanies,
    content: jsonEncode(filter),
    path: "company/query-company"
  );
}

class CreateCompanyRequest extends MasterMessage {
  CreateCompanyRequest({
    required Company company,
    required super.token,
  }) : super(
      request: MasterRequestType.manajementCompany,
      content: jsonEncode(company),
      path: "company/create-company"
  );
}


class UpdateCompanyRequest extends MasterMessage {
  UpdateCompanyRequest({
    required Company company,
    required super.token,
  }) : super(
      request: MasterRequestType.manajementCompany,
      content: jsonEncode(company),
      path: "company/update-company"
  );
}