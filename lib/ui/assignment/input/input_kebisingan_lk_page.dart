import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/examination/input/form_kebisingan.dart';

enum InputView { listView, tableView }

class InputKebisinganLKPage extends StatefulWidget {
  const InputKebisinganLKPage({super.key});

  @override
  State<InputKebisinganLKPage> createState() => InputKebisinganLKPageState();
}

class InputKebisinganLKPageState extends State<InputKebisinganLKPage> {
  final Set<DataKebisinganLK> _inputs = {
    const DataKebisinganLK(
      location: "Area Boiler 1",
      value1: '86.7',
      value2: '86.2',
      value3: '86.4',
      note: 'catatan',
    ),
    const DataKebisinganLK(
      location: "Area Boiler 2",
      value1: '86.7',
      value2: '86.2',
      value3: '86.4',
      note: 'catatan',
    ),
    const DataKebisinganLK(
      location: "Area Boiler 3",
      value1: '86.7',
      value2: '86.2',
      value3: '86.4',
      note: 'catatan',
    ),
    const DataKebisinganLK(
      location: "Area Boiler 4",
      value1: '86.7',
      value2: '86.2',
      value3: '86.4',
      note: 'catatan',
    ),
  };

  InputView _view = InputView.tableView;

  Future<void> _addOrUpdateRow({DataKebisinganLK? data}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: FormKebisingan(
              data: data,
              onUpdate: (input) {
                if (data != input) {
                  _inputs.remove(data);
                  _inputs.add(input);
                }
              },
              onAdd: (input) => _inputs.add(input),
              onDelete: (input) => _inputs.remove(input),
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

  Widget _keyValue({required String key, required String value}) {
    return Row(
      children: [
        Text(key, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: Dimens.paddingWidget),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }

  Widget _buildTableView() {
    TextStyle? headerStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: const MaterialStatePropertyAll(ColorResources.primaryDark),
        columns: [
          DataColumn(label: Text('Lokasi', style: headerStyle)),
          DataColumn(numeric: true, label: Text('1', style: headerStyle)),
          DataColumn(numeric: true, label: Text('2', style: headerStyle)),
          DataColumn(numeric: true, label: Text('3', style: headerStyle)),
          DataColumn(label: Text('Waktu', style: headerStyle)),
          DataColumn(label: Text('Catatan', style: headerStyle)),
        ],
        rows: _inputs
            .map(
              (data) => DataRow(
                onLongPress: () => _addOrUpdateRow(data: data),
                color: const MaterialStatePropertyAll(Colors.white),
                cells: [
                  DataCell(Text(
                    data.location,
                    style: headerStyle?.copyWith(color: Colors.black),
                    softWrap: true,
                  )),
                  DataCell(Text(data.value1)),
                  DataCell(Text(data.value2)),
                  DataCell(Text(data.value3)),
                  DataCell(Text(data.time == null ? "" : TimeOfDay.fromDateTime(data.time!).format(context))),
                  DataCell(Text(data.note ?? "")),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildListView() {
    return Column(
        children: _inputs
            .map((data) => CustomCard(
                  color: Colors.white,
                  onTap: () => _addOrUpdateRow(data: data),
                  child: Container(
                    padding:  const EdgeInsets.all(Dimens.paddingPage),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(data.location, style: Theme.of(context).textTheme.headlineMedium),
                            ),
                            Text(data.time == null ? "" : TimeOfDay.fromDateTime(data.time!).format(context), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blueGrey)),
                          ],
                        ),
                        Visibility(
                          visible: !TextUtils.isEmpty(data.note),
                          child: Text("Note: ${data.note}", style: Theme.of(context).textTheme.bodySmall),
                        ),
                        const SizedBox(height: Dimens.paddingWidget),
                        _keyValue(key: "Value 1:", value: data.value1),
                        _keyValue(key: "Value 2:", value: data.value2),
                        _keyValue(key: "Value 3:", value: data.value3),
                      ],
                    ),
                  ),
                ))
            .toList());
  }

  @override
  void initState() {
    super.initState();
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
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorResources.primaryDark)),
            ),
            CustomCard(
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
            ),
          ],
        ),
        const SizedBox(height: Dimens.paddingWidget),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
          child: _view == InputView.tableView ? _buildTableView() : _buildListView(),
        ),
      ],
    );
  }
}
