import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/examination_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class ExaminationRepository {
  static const String _examinationTypeKey = "EXAMINATION_TYPE";
  static const String _inputExaminationSavedKey = "INPUT_EXAMINATION_SAVED";

  static final ExaminationRepository _instance = ExaminationRepository._internal();

  factory ExaminationRepository() => _instance;

  ExaminationRepository._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final Map<String, ExaminationType> _examinationTypes = {};

  ExaminationType? getExaminationTypeByName(String examinationTypeName) =>  _examinationTypes[examinationTypeName];

  Future<List<ExaminationType>> getExaminationTypes() async {
    if (_examinationTypes.isEmpty) {
      String? result = await _secureStorage.read(key: _examinationTypeKey);
      if (!TextUtils.isEmpty(result)) {
        Iterable iterable = jsonDecode(result!);
        for (var element in iterable) {
          ExaminationType examinationType = ExaminationType.fromJson(element);
          _examinationTypes[examinationType.name] = examinationType;
        }
      } else {
        await _loadExaminationType();
      }
    }

    return _examinationTypes.values.toList();
  }

  Future<void> _loadExaminationType() async{
    String? token = await AppRepository().getToken();
    MasterMessage message = await ConnectionUtils.sendRequest(QueryExaminationsTypeRequest(token: token));
    if(message.response == MasterResponseType.success){
      if(!TextUtils.isEmpty(message.content)){
        Iterable iterable = jsonDecode(message.content!);
        List<ExaminationType> types = [];
        for (var element in iterable) {
          ExaminationType examinationType = ExaminationType.fromJson(element);
          types.add(examinationType);
        }
        await _setExaminationType(types);
      }
    }
  }

  Future<void> _setExaminationType(List<ExaminationType> examinationTypes) async {
    if(examinationTypes.isNotEmpty){
      _examinationTypes.clear();
      for (var type in examinationTypes) {
        _examinationTypes[type.name] = type;
      }
      await _secureStorage.write(key: _examinationTypeKey, value: jsonEncode(_examinationTypes));
    }
  }

  Future<void> init() async{
    await _loadExaminationType();
  }
}
