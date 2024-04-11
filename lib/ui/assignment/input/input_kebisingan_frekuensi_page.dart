import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_frekuensi.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_form_page.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/examination/input/kebisingan_frekuensi/form_kebisingan_frekuensi.dart';
import 'package:k3_sipp_mobile/widget/examination/input/kebisingan_frekuensi/input_kebisingan_frekuensi_row.dart';

class InputKebisinganFrekuensiPage extends StatefulWidget {
  final InputFormLogic logic;

  const InputKebisinganFrekuensiPage({super.key, required this.logic});

  @override
  State<InputKebisinganFrekuensiPage> createState() => _InputKebisinganFrekuensiPageState();
}

class _InputKebisinganFrekuensiPageState extends State<InputKebisinganFrekuensiPage> {
  InputView _view = InputView.tableView;

  Future<void> _addOrUpdateRow({DataKebisinganFrekuensi? data}) async {
    if (!widget.logic.examination.canUpdateInput) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormKebisinganFrekuensi(
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

  InputView _changeView() {
    _view = _view == InputView.tableView ? InputView.listView : InputView.tableView;
    setState(() {});

    return _view;
  }

  Widget _buildDataTable() {
    TextStyle? headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle? bodyStyle = Theme.of(context).textTheme.labelSmall;
    return DataTable2(
      minWidth: 1000,
      columnSpacing: 10,
      fixedTopRows: 1,
      fixedLeftColumns: 2,
      isHorizontalScrollBarVisible: true,
      columns: [
        DataColumn2(
          label: Text('#', style: headerStyle),
          size: ColumnSize.S,
          fixedWidth: 20,
        ),
        DataColumn2(
          label: Text('Lokasi', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Waktu', style: headerStyle),
          size: ColumnSize.S,
          fixedWidth: 50,
        ),
        DataColumn2(
          numeric: true,
          label: Text('31,5Hz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('63,0Hz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('125Hz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('250Hz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('500Hz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('1KHz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('2KHz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('4KHz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('8KHz', style: headerStyle),
          size: ColumnSize.S,
        ),
        DataColumn2(
          numeric: true,
          label: Text('16KHz', style: headerStyle),
          size: ColumnSize.S,
        ),
      ],
      rows: List.generate(widget.logic.examination.userInput.length, (index) {
        DataKebisinganFrekuensi data = widget.logic.examination.userInput[index];
        return DataRow2(
          cells: [
            DataCell(
              const Icon(Icons.edit, color: ColorResources.primaryDark, size: Dimens.iconSizeEdit),
              onTap: () => _addOrUpdateRow(data: data),
            ),
            DataCell(Text(data.location, style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text(DateTimeUtils.formatToTime(data.time!), style: bodyStyle)),
            DataCell(Text("${data.value1}", style: bodyStyle)),
            DataCell(Text("${data.value2}", style: bodyStyle)),
            DataCell(Text("${data.value3}", style: bodyStyle)),
            DataCell(Text("${data.value4}", style: bodyStyle)),
            DataCell(Text("${data.value5}", style: bodyStyle)),
            DataCell(Text("${data.value6}", style: bodyStyle)),
            DataCell(Text("${data.value7}", style: bodyStyle)),
            DataCell(Text("${data.value8}", style: bodyStyle)),
            DataCell(Text("${data.value9}", style: bodyStyle)),
            DataCell(Text("${data.value10}", style: bodyStyle)),
          ],
        );
      }),
    );
  }

  Widget _buildListView() {
    List<Widget> widgets = [];
    Map<int, DataKebisinganFrekuensi> resultMap = {};
    for (DataKebisinganFrekuensi result in widget.logic.examination.examinationResult) {
      resultMap[result.id!] = result;
    }
    for (DataKebisinganFrekuensi input in widget.logic.examination.userInput) {
      widgets.add(InputKebisinganFrekuensiRow(input: input, result: resultMap[input.id] ?? input));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
      child: Column(children: widgets),
    );
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
    return Column(
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
        const SizedBox(height: Dimens.paddingWidget),
        Expanded(
          child: widget.logic.examination.userInput.isEmpty
              ? _buildNoData()
              : _view == InputView.tableView
                  ? _buildDataTable()
                  : _buildListView(),
        ),
      ],
    );
  }
}
