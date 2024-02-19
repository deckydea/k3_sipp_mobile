import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';

class AddExaminationLogic {
  final GlobalKey<FormState> formKey = GlobalKey();

  final List<DropdownMenuItem<ExaminationType>> dropdownExaminationTypes = [];

  final TextEditingController petugasController = TextEditingController();
  final TextEditingController metodeController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  ExaminationType? selectedExaminationType;
  User? selectedPetugas;
  User? selectedAnalis;
  DateTime? selectedDeadline;

  bool initialized = false;

  void dispose() {
    petugasController.dispose();
    metodeController.dispose();
    deadlineController.dispose();
  }
}