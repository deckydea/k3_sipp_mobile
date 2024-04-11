import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/select_examination_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/examination_select_row.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class SelectExaminationPage extends StatefulWidget {
  final Map<ExaminationType, int>? selectedExaminationType;

  const SelectExaminationPage({super.key, this.selectedExaminationType});

  @override
  State<SelectExaminationPage> createState() => _SelectExaminationPageState();
}

class _SelectExaminationPageState extends State<SelectExaminationPage> {
  final SelectExaminationLogic _logic = SelectExaminationLogic();

  Future<void> _init() async {
    await _logic.init();
    setState(() {});
  }

  void _actionSave() {
    List<Examination> examinations = [];
    _logic.examinationKeys.forEach((type, key) {
      if (key.currentState!.value != null) {
        for(int i = 0; i < key.currentState!.value! ; i++){
          examinations.add(Examination(typeOfExaminationName: type.name, metode: type.metode));
        }
      }
    });


    navigatorKey.currentState?.pop(examinations);
  }

  Widget _buildChemical() {
    List<ExaminationType> examinationTypes = _logic.getExaminationType(masterExaminationType: MasterExaminationType.CHEMICAL);

    return examinationTypes.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: examinationTypes.length,
            itemBuilder: (context, index) {
              ExaminationType examinationType = examinationTypes[index];
              return ExaminationRow(
                key: _logic.examinationKeys[examinationType],
                examinationType: examinationType,
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMedium),
            child: Center(
              child: Text(
                "Sedang dalam proses development.",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.deepOrange),
              ),
            ),
          );
  }

  Widget _buildPhysics() {
    List<ExaminationType> examinationTypes = _logic.getExaminationType(masterExaminationType: MasterExaminationType.PHYSICS);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: examinationTypes.length,
      itemBuilder: (context, index) {
        ExaminationType examinationType = examinationTypes[index];
        return ExaminationRow(
          key: _logic.examinationKeys[examinationType],
          examinationType: examinationType,
        );
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Faktor Fisika",
              style:
                  Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorResources.primary),
            ),
            const Divider(color: ColorResources.primary, height: 10),
            _buildPhysics(),
            const SizedBox(height: Dimens.paddingSmall),
            Text(
              "Faktor Kimia",
              style:
                  Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorResources.primary),
            ),
            const Divider(color: ColorResources.primary, height: 10),
            _buildChemical(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Pengukuran", style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          TextButton(
            onPressed: _actionSave,
            child: Text(
              "Simpan",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: ColorResources.primary),
            ),
          ),
          const SizedBox(width: Dimens.paddingGap),
        ],
      ),
      body: _logic.initialized ? _buildBody() : Container(),
    );
  }
}
