import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';

class CreateAssignmentLogic{
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController templateNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final List<Examination> examinations = [];
}
