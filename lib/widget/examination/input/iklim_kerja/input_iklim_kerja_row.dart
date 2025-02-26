import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_iklim_kerja.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_iklim_kerja.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputIklimKerjaRow extends StatefulWidget {
  final DataIklimKerja input;
  final ResultIklimKerja? result;

  const InputIklimKerjaRow({super.key, required this.input, this.result});

  @override
  State<InputIklimKerjaRow> createState() => _InputIklimKerjaRowState();
}

class _InputIklimKerjaRowState extends State<InputIklimKerjaRow> {
  late ThemeData _theme;

  Future<void> _showDeviceDetailDialog(DeviceCalibration deviceCalibration) async {
    if (deviceCalibration.device == null) return;

    Widget row({
      IconData? icon,
      required String title,
      String? value,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon == null ? Container() : Icon(icon, color: ColorResources.primaryDark, size: Dimens.iconSizeTitle),
            const SizedBox(width: Dimens.paddingGap),
            Expanded(
                flex: 2,
                child: Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorResources.primaryDark))),
            const SizedBox(width: Dimens.paddingGap),
            Text(
              value ?? "",
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
      );
    }

    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
        title: Text("Alat yang Digunakan",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row(
              icon: Icons.devices,
              title: deviceCalibration.device!.name!,
              value: deviceCalibration.device!.calibrationValue!.toStringAsFixed(2),
            ),
            row(
              icon: Icons.format_size,
              title: "U95",
              value: deviceCalibration.device!.u95!.toStringAsFixed(2),
            ),
            row(
              icon: Icons.map,
              title: "K (Coverage Factor)",
              value: deviceCalibration.device!.coverageFactor!.toStringAsFixed(2),
            ),
            deviceCalibration.internalCalibration != null
                ? row(
                    icon: Icons.compass_calibration,
                    title: "Kalibrasi Internal",
                    value: deviceCalibration.internalCalibration!.toStringAsFixed(2),
                  )
                : Container(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tutup", style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return widget.result == null
        ? Container()
        : Column(
            children: [
              _keyValue(
                key: "Rata-rata ISBB",
                value: "${widget.result!.average}",
              ),
              _keyValue(
                key: "Standar Deviasi",
                value: "${widget.result!.standarDeviasi}",
              ),
              _keyValue(
                key: "U Presisi",
                value: "${widget.result!.upresisi}",
              ),
              _keyValue(
                key: "U Kalibrasi",
                value: "${widget.result!.ukalibrasi}",
              ),
              _keyValue(
                key: "U Bias",
                value: "${widget.result!.ubias}",
              ),
              _keyValue(
                key: "U Gabungan",
                value: "${widget.result!.ugabungan}",
              ),
              _keyValue(
                key: "U 95% (Ketidakpastian)",
                value: "${widget.result!.u95}",
              ),
            ],
          );
  }

  Widget _keyValue({required String key, required String value, Color valueColor = ColorResources.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: _theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(value,
              style: _theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 2, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildTable() {
    TextStyle? headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle? bodyStyle = Theme.of(context).textTheme.labelSmall;

    List<DataRow2> dataRows = [
      DataRow2(
        cells: [
          DataCell(Text("TA", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
          DataCell(Text("${widget.input.ta1}", style: bodyStyle)),
          DataCell(Text("${widget.input.ta2}", style: bodyStyle)),
          DataCell(Text("${widget.input.ta3}", style: bodyStyle)),
          DataCell(Text("${widget.input.ta4}", style: bodyStyle)),
          DataCell(Text("${widget.input.ta5}", style: bodyStyle)),
          DataCell(Text("${widget.input.ta6}", style: bodyStyle)),
        ],
      ),
      DataRow2(
        cells: [
          DataCell(Text("TW", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
          DataCell(Text("${widget.input.tw1}", style: bodyStyle)),
          DataCell(Text("${widget.input.tw2}", style: bodyStyle)),
          DataCell(Text("${widget.input.tw3}", style: bodyStyle)),
          DataCell(Text("${widget.input.tw4}", style: bodyStyle)),
          DataCell(Text("${widget.input.tw5}", style: bodyStyle)),
          DataCell(Text("${widget.input.tw6}", style: bodyStyle)),
        ],
      ),
      DataRow2(
        cells: [
          DataCell(Text("TG", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
          DataCell(Text("${widget.input.tg1}", style: bodyStyle)),
          DataCell(Text("${widget.input.tg2}", style: bodyStyle)),
          DataCell(Text("${widget.input.tg3}", style: bodyStyle)),
          DataCell(Text("${widget.input.tg4}", style: bodyStyle)),
          DataCell(Text("${widget.input.tg5}", style: bodyStyle)),
          DataCell(Text("${widget.input.tg6}", style: bodyStyle)),
        ],
      ),
      DataRow2(
        cells: [
          DataCell(Text("RH", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
          DataCell(Text("${widget.input.rh1}", style: bodyStyle)),
          DataCell(Text("${widget.input.rh2}", style: bodyStyle)),
          DataCell(Text("${widget.input.rh3}", style: bodyStyle)),
          DataCell(Text("${widget.input.rh4}", style: bodyStyle)),
          DataCell(Text("${widget.input.rh5}", style: bodyStyle)),
          DataCell(Text("${widget.input.rh6}", style: bodyStyle)),
        ],
      ),
    ];

    if (widget.result != null) {
      dataRows.add(DataRow2(
        cells: [
          DataCell(Text("ISBB", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
          DataCell(Text("${widget.result!.isbb1}", style: bodyStyle)),
          DataCell(Text("${widget.result!.isbb2}", style: bodyStyle)),
          DataCell(Text("${widget.result!.isbb3}", style: bodyStyle)),
          DataCell(Text("${widget.result!.isbb4}", style: bodyStyle)),
          DataCell(Text("${widget.result!.isbb5}", style: bodyStyle)),
          DataCell(Text("${widget.result!.isbb6}", style: bodyStyle)),
        ],
      ));
    }

    return SizedBox(
      height: 300,
      child: DataTable2(
        headingTextStyle: headerStyle,
        minWidth: 1000,
        columnSpacing: 15,
        fixedTopRows: 1,
        isHorizontalScrollBarVisible: true,
        showBottomBorder: true,
        columns: const [
          DataColumn2(
            label: Text('#'),
            size: ColumnSize.M,
            fixedWidth: 40,
          ),
          DataColumn2(
            numeric: true,
            label: Text('1'),
            size: ColumnSize.S,
            fixedWidth: 40,
          ),
          DataColumn2(
            numeric: true,
            label: Text('2'),
            size: ColumnSize.S,
            fixedWidth: 40,
          ),
          DataColumn2(
            numeric: true,
            label: Text('3'),
            size: ColumnSize.S,
            fixedWidth: 40,
          ),
          DataColumn2(
            numeric: true,
            label: Text('4'),
            size: ColumnSize.S,
            fixedWidth: 40,
          ),
          DataColumn2(
            numeric: true,
            label: Text('5'),
            size: ColumnSize.S,
            fixedWidth: 40,
          ),
          DataColumn2(
            numeric: true,
            label: Text('6'),
            size: ColumnSize.S,
            fixedWidth: 40,
          ),
        ],
        rows: dataRows,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return CustomCard(
      color: ColorResources.backgroundDark,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage, vertical: 0),
        childrenPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: const Border.fromBorderSide(BorderSide.none),
        collapsedShape: const Border.fromBorderSide(BorderSide.none),
        dense: true,
        title: Text(
          widget.input.location,
          style: _theme.textTheme.labelMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
        ),
        children: [
          const SizedBox(height: Dimens.paddingSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
            child: Text("Informasi",
                textAlign: TextAlign.center, style: _theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: Dimens.paddingWidget),
          _keyValue(
            key: "Lokasi",
            value: widget.input.location,
            valueColor: ColorResources.primaryDark,
          ),
          _keyValue(
            key: "Waktu",
            value: DateTimeUtils.formatToTime(widget.input.time),
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Jumlah Tenaga Kerja yang terpapar",
            value: "${widget.input.jumlahTK} Orang",
          ),
          _keyValue(
            key: "Durasi Paparan Terhadap Pekerja",
            value: "${widget.input.durasi} Jam",
          ),
          _keyValue(
            key: "Laju Metabolit",
            value: widget.input.lajuMetabolit.label,
          ),
          _keyValue(
            key: "Siklus Waktu Kerja",
            value: widget.input.siklusKerja.label,
          ),
          _keyValue(
            key: "Tindakan Pengendalian yang Telah Dilakukan",
            value: TextUtils.isEmpty(widget.input.pengendalian) ? '-' : widget.input.pengendalian,
          ),
          _keyValue(
            key: "Note",
            value: TextUtils.isEmpty(widget.input.note) ? '-' : widget.input.note!,
          ),
          const SizedBox(height: Dimens.paddingMedium),
          Text("Kalibrasi Alat",
              textAlign: TextAlign.center, style: _theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => _showDeviceDetailDialog(widget.input.deviceCalibrationTW!),
            child: _keyValue(
              key: "Alat TW",
              value: "${widget.input.deviceCalibrationTW!.device!.name}",
              valueColor: ColorResources.primaryLight,
            ),
          ),
          GestureDetector(
            onTap: () => _showDeviceDetailDialog(widget.input.deviceCalibrationTW!),
            child: _keyValue(
              key: "Alat TG",
              value: "${widget.input.deviceCalibrationTG!.device!.name}",
              valueColor: ColorResources.primaryLight,
            ),
          ),
          GestureDetector(
            onTap: () => _showDeviceDetailDialog(widget.input.deviceCalibrationTW!),
            child: _keyValue(
              key: "Alat ISBB",
              value: "${widget.input.deviceCalibrationISBB!.device!.name}",
              valueColor: ColorResources.primaryLight,
            ),
          ),
          const SizedBox(height: Dimens.paddingMedium),
          Text("Hasil", textAlign: TextAlign.center, style: _theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
          _buildResult(),
          const SizedBox(height: Dimens.paddingMedium),
          _buildTable(),
        ],
      ),
    );
  }
}
