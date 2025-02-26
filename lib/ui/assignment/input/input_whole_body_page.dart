import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_whole_body.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_whole_body.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/examination/input/whole_body/form_whole_body.dart';
import 'package:k3_sipp_mobile/widget/examination/input/whole_body/input_whole_body_row.dart';

class InputWholeBodyPage extends StatefulWidget {
  final InputFormLogic logic;

  const InputWholeBodyPage({super.key, required this.logic});

  @override
  State<InputWholeBodyPage> createState() => _InputWholeBodyPageState();
}

class _InputWholeBodyPageState extends State<InputWholeBodyPage> {
  Future<void> _addOrUpdateRow({DataWholeBody? data}) async {
    if (!widget.logic.examination.canUpdateInput) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormWholeBodyPage(
          data: data,
          onUpdate: (input) {
            if (data != input) {
              widget.logic.examination.userInput.remove(data);
              widget.logic.examination.userInput.add(input);
            }
          },
          onAdd: (input) => widget.logic.examination.userInput.add(input),
          onDelete: (input) => widget.logic.examination.userInput.remove(input),
        ),
      ),
    );
    setState(() {});
  }

  Widget _buildData() {
    List<Widget> widgets = [];
    Map<int, ResultWholeBody> resultMap = {};
    for (ResultWholeBody result in widget.logic.examination.examinationResult) {
      resultMap[result.id] = result;
    }
    for (DataWholeBody input in widget.logic.examination.userInput) {
      widgets.add(InputWholeBodyRow(input: input, result: resultMap[input.id]));
    }

    return Column(children: widgets);
  }

  Widget _buildNoData() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Tidak ada data pengujian. Silahkan tambahkan telebih dahulu",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.deepOrange),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingPage),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: Dimens.paddingMedium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Pengujian",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark)),
                  ),
                  widget.logic.examination.status == ExaminationStatus.PENDING ||
                          widget.logic.examination.status == ExaminationStatus.REVISION_QC1
                      ? CustomCard(
                          color: ColorResources.primary,
                          borderRadius: Dimens.cardRadiusXLarge,
                          onTap: _addOrUpdateRow,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimens.paddingWidget, horizontal: Dimens.paddingPage),
                            child: Row(
                              children: [
                                Text("Tambah",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(width: Dimens.paddingGap),
                                GestureDetector(child: const Icon(Icons.add, size: Dimens.iconSizeTitle, color: Colors.white)),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(height: Dimens.paddingSmall),
            widget.logic.examination.userInput.isEmpty ? _buildNoData() : _buildData(),
            const SizedBox(height: Dimens.paddingMedium),
          ],
        ),
      ),
    );
  }
}
