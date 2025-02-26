import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_uv.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/examination/input/ultraviolet/form_ultraviolet.dart';
import 'package:k3_sipp_mobile/widget/examination/input/ultraviolet/input_ultraviolet_row.dart';

class InputUVPage extends StatefulWidget {
  final InputFormLogic logic;

  const InputUVPage({super.key, required this.logic});

  @override
  State<InputUVPage> createState() => _InputUVPageState();
}

class _InputUVPageState extends State<InputUVPage> {
  final Map<String, Map<Posisi, DataUltraviolet>> _dataUV = {};
  final Map<String, Map<Posisi, ResultUV>> _resultUV = {};

  Future<void> _addOrUpdateRow({Map<Posisi, DataUltraviolet>? data}) async {
    if (!widget.logic.examination.canUpdateInput) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormUltravioletPage(
          data: data,
          onUpdate: (input) {
            if (data != input) {
              for (var element in data!.values) {
                widget.logic.examination.userInput.remove(element);
              }
              for (var element in input.values) {
                widget.logic.examination.userInput.add(element);
              }
            }
          },
          onAdd: (input) {
            for (var element in input.values) {
              widget.logic.examination.userInput.add(element);
            }
          },
          onDelete: (input) {
            for (var element in input.values) {
              widget.logic.examination.userInput.remove(element);
            }
          },
        ),
      ),
    );
    _load();
    setState(() {});
  }

  void _load(){
    for (DataUltraviolet input in widget.logic.examination.userInput) {
      _dataUV[input.location] ??= {};

      Map<Posisi, DataUltraviolet> data = _dataUV[input.location]!;
      data[input.posisi] = input;
      _dataUV[input.location] = data;
    }

    for (ResultUV result in widget.logic.examination.examinationResult) {
      _resultUV[result.location] ??= {};

      Map<Posisi, ResultUV> data = _resultUV[result.location]!;
      data[result.posisi] = result;
      _resultUV[result.location] = data;
    }
  }

  Widget _buildData() {
    List<Widget> widgets = [];

    _dataUV.forEach((location, input) {
      widgets.add(InputUltravioletRow(input: input, result: _resultUV[location]));
    });

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
  void initState() {
    super.initState();

    _load();
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
