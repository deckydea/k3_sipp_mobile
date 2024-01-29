
import 'package:k3_sipp_mobile/repository/examination_repository.dart';

class MainMenuLogic{

  bool initialized = false;

  Future<void> init() async{
    await ExaminationRepository().init();
  }
}