import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/examination_request.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class AddExaminationLogic {
  final GlobalKey<FormState> formKey = GlobalKey();

  final List<DropdownMenuItem<ExaminationType>> dropdownExaminationTypes = [];
  final Set<DeviceCalibration> deviceCalibrations = {};

  final TextEditingController petugasController = TextEditingController();
  final TextEditingController metodeController = TextEditingController();

  ExaminationType? selectedExaminationType;
  int? petugasId;
  int? analisId;

  bool initialized = false;

  Future<MasterMessage> loadExaminationTypes() async {
    String? token = await AppRepository().getToken();
    MasterMessage message = QueryExaminationsTypeRequest(token: token);
    return await ConnectionUtils.sendRequest(message);
  }

  void dispose() {
    petugasController.dispose();
    metodeController.dispose();
  }
}
