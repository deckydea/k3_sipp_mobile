import 'package:flutter/cupertino.dart';
import 'package:k3_sipp_mobile/model/examination/examination_select_row.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/repository/examination_repository.dart';

class SelectExaminationLogic {
  List<ExaminationType>? examinationTypes;
  final Map<ExaminationType, int> selectedExaminationType = {};
  final Map<ExaminationType, GlobalKey<ExaminationRowState>> examinationKeys = {};

  bool initialized = false;

  Future<void> init() async {
    examinationTypes = await ExaminationRepository().getExaminationTypes();
    for(ExaminationType type in examinationTypes!){
      examinationKeys[type] = GlobalKey<ExaminationRowState>();
    }

    initialized = true;
  }

  List<ExaminationType> getExaminationType({required MasterExaminationType masterExaminationType}){
    List<ExaminationType> types = [];
    for(ExaminationType type in examinationTypes!){
      if(type.type == masterExaminationType){
        types.add(type);
      }
    }

    return types;
  }

}
