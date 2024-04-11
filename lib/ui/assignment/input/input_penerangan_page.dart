import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_penerangan.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_penerangan.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_form_page.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/examination/input/penerangan/form_penerangan.dart';
import 'package:k3_sipp_mobile/widget/examination/input/penerangan/input_penerangan_row.dart';

class InputPeneranganPage extends StatefulWidget {
  final InputFormLogic logic;

  const InputPeneranganPage({super.key, required this.logic});

  @override
  State<InputPeneranganPage> createState() => _InputPeneranganPageState();
}

class _InputPeneranganPageState extends State<InputPeneranganPage> {
  InputView _view = InputView.tableView;

  Future<void> _addOrUpdateRow({DataPenerangan? data}) async {
    if(!widget.logic.examination.canUpdateInput) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: FormPenerangan(
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
      },
    );

    setState(() {});
  }

  InputView _changeView() {
    _view = _view == InputView.tableView ? InputView.listView : InputView.tableView;
    setState(() {});

    return _view;
  }

  Widget _buildTableView() {
    TextStyle? headerStyle = Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold);
    TextStyle? bodyStyle = Theme.of(context).textTheme.bodySmall;

    List<TableRow> rows = [];
    rows.add(
      TableRow(
        decoration: const BoxDecoration(color: ColorResources.primaryDark),
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingWidget),
            child: Text('Lokasi', style: headerStyle),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingWidget),
            child: Text('1', style: headerStyle, textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingWidget),
            child: Text('2', style: headerStyle, textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingWidget),
            child: Text('3', style: headerStyle, textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.paddingWidget),
            child: Text('Waktu', style: headerStyle, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    for (DataPenerangan data in widget.logic.examination.userInput) {
      rows.add(
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            GestureDetector(
              onLongPress: () => _addOrUpdateRow(data: data),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap, vertical: Dimens.paddingWidget),
                child: Text(
                  data.localLightingData,
                  style: bodyStyle?.copyWith(color: Colors.black),
                  softWrap: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap, vertical: Dimens.paddingWidget),
              child: Text(data.value1.toString(), style: bodyStyle, textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap, vertical: Dimens.paddingWidget),
              child: Text(data.value2.toString(), style: bodyStyle, textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap, vertical: Dimens.paddingWidget),
              child: Text(data.value3.toString(), style: bodyStyle, textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap, vertical: Dimens.paddingWidget),
              child: Text(
                data.time == null ? "" : TimeOfDay.fromDateTime(data.time!).format(context),
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.black),
        verticalInside: BorderSide(width: 1, color: Colors.black),
        right: BorderSide(width: 1, color: Colors.black),
        left: BorderSide(width: 1, color: Colors.black),
        bottom: BorderSide(width: 1, color: Colors.black),
        top: BorderSide(width: 1, color: Colors.black),
      ),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FixedColumnWidth(40),
        2: FixedColumnWidth(40),
        3: FixedColumnWidth(40),
        4: FixedColumnWidth(75),
      },
      children: rows,
    );
  }

  Widget _buildListView() {
    List<Widget> widgets = [];
    Map<int, ResultPenerangan> resultMap = {};
    for (ResultPenerangan result in widget.logic.examination.examinationResult) {
      resultMap[result.id] = result;
    }
    for (DataPenerangan input in widget.logic.examination.userInput) {
      widgets.add(InputPeneranganRow(input: input, result: resultMap[input.id]));
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: Dimens.paddingWidget),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _view = _changeView()),
                icon: Icon(_view == InputView.tableView ? Icons.grid_view : Icons.table_chart, size: Dimens.iconSize),
              ),
              Expanded(
                child: Text("Pengujian",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorResources.primaryDark)),
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
                            Text("Tambah", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                            const SizedBox(width: Dimens.paddingGap),
                            GestureDetector(child: const Icon(Icons.add, size: Dimens.iconSizeSmall, color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: Dimens.paddingWidget),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
            child: widget.logic.examination.userInput.isEmpty
                ? _buildNoData()
                : _view == InputView.tableView
                    ? _buildTableView()
                    : _buildListView(),
          ),
        ],
      ),
    );
  }
}
