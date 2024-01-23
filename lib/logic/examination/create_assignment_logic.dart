import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

class CreateAssignmentLogic {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController templateNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final List<Examination> examinations = [];

  Future<MasterMessage> onCreate() async {
    return MasterMessage(response: MasterResponseType.failed);
  }
}
