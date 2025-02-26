import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_uv.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputUltravioletRow extends StatefulWidget {
  final Map<Posisi, DataUltraviolet> input;
  final Map<Posisi, ResultUV>? result;

  const InputUltravioletRow({super.key, required this.input, this.result});

  @override
  State<InputUltravioletRow> createState() => _InputUltravioletRowState();
}

class _InputUltravioletRowState extends State<InputUltravioletRow> {
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

  Widget _buildResult() {
    if (widget.result != null) {
      double sumIeff = 0;
      for (var element in widget.result!.values) {
        sumIeff += element.ieff;
      }

      double nab = 0;
      switch (widget.input.values.first.durasi) {
        case 28800: // 8 jam
          nab = 0.1;
          break;
        case 14400: // 4 jam
          nab = 0.2;
          break;
        case 7200: // 2 jam
          nab = 0.4;
          break;
        case 3600: // 1 jam
          nab = 0.8;
          break;
        case 1800: // 30 menit
          nab = 1.7;
          break;
        case 900: // 15 menit
          nab = 3.3;
          break;
        case 600: // 10 menit
          nab = 5;
          break;
        case 300: // 5 menit
          nab = 10;
          break;
        case 60: // 1 menit
          nab = 50;
          break;
        case 30: // 30 detik
          nab = 100;
          break;
        case 10: // 10 detik
          nab = 300;
          break;
        case 1: // 1 detik
          nab = 3000;
          break;
        case 0.5: // 0.5 detik
          nab = 6000;
          break;
        case 0.1: // 0.1 detik
          nab = 30000;
          break;
      }

      return Column(
        children: [
          _keyValue(
            key: "Rata-rata",
            value: "${(sumIeff / 3).toStringAsFixed(3)} ",
          ),
          _keyValue(
            key: "NAB",
            value: "${nab / 1000}",
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildTable() {
    TextStyle? headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle? bodyStyle = Theme.of(context).textTheme.labelSmall;

    List<DataRow2> dataRows;

    if (widget.result != null) {
      dataRows = [
        DataRow2(
          cells: [
            DataCell(Text("Mata", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input[Posisi.mata]!.value1}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.mata]!.value2}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.mata]!.value3}", style: bodyStyle)),
            DataCell(Text("${widget.result![Posisi.mata]!.average}", style: bodyStyle)),
            DataCell(Text(widget.result![Posisi.mata]!.ieff.toStringAsFixed(3), style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("Betis", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input[Posisi.betis]!.value1}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.betis]!.value2}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.betis]!.value3}", style: bodyStyle)),
            DataCell(Text("${widget.result![Posisi.betis]!.average}", style: bodyStyle)),
            DataCell(Text(widget.result![Posisi.betis]!.ieff.toStringAsFixed(3), style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("Siku", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input[Posisi.siku]!.value1}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.siku]!.value2}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.siku]!.value3}", style: bodyStyle)),
            DataCell(Text("${widget.result![Posisi.siku]!.average}", style: bodyStyle)),
            DataCell(Text(widget.result![Posisi.siku]!.ieff.toStringAsFixed(3), style: bodyStyle)),
          ],
        ),
      ];

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
              size: ColumnSize.L,
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
              label: Text('Average'),
              size: ColumnSize.M,
              fixedWidth: 80,
            ),
            DataColumn2(
              numeric: true,
              label: Text('IEff'),
              size: ColumnSize.M,
              fixedWidth: 80,
            ),
          ],
          rows: dataRows,
        ),
      );
    } else {
      dataRows = [
        DataRow2(
          cells: [
            DataCell(Text("Mata", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input[Posisi.mata]!.value1}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.mata]!.value2}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.mata]!.value3}", style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("Betis", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input[Posisi.betis]!.value1}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.betis]!.value2}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.betis]!.value3}", style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("Siku", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input[Posisi.siku]!.value1}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.siku]!.value2}", style: bodyStyle)),
            DataCell(Text("${widget.input[Posisi.siku]!.value3}", style: bodyStyle)),
          ],
        ),
      ];

      return SizedBox(
        height: 300,
        child: DataTable2(
          headingTextStyle: headerStyle,
          minWidth: MediaQuery.of(context).size.width - Dimens.paddingLarge,
          columnSpacing: 15,
          fixedTopRows: 1,
          showBottomBorder: true,
          columns: const [
            DataColumn2(
              label: Text('#'),
              size: ColumnSize.L,
            ),
            DataColumn2(
              numeric: true,
              label: Text('1'),
              size: ColumnSize.S,
            ),
            DataColumn2(
              numeric: true,
              label: Text('2'),
              size: ColumnSize.S,
            ),
            DataColumn2(
              numeric: true,
              label: Text('3'),
              size: ColumnSize.S,
            ),
          ],
          rows: dataRows,
        ),
      );
    }
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
          widget.input.values.first.location,
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
            value: widget.input.values.first.location,
            valueColor: ColorResources.primaryDark,
          ),
          _keyValue(
            key: "Waktu",
            value: DateTimeUtils.formatToTime(widget.input.values.first.time),
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Jumlah Tenaga Kerja yang terpapar",
            value: "${widget.input.values.first.jumlahTK} Orang",
          ),
          _keyValue(
            key: "Note",
            value: TextUtils.isEmpty(widget.input.values.first.note) ? '-' : widget.input.values.first.note!,
          ),
          GestureDetector(
            onTap: () => _showDeviceDetailDialog(widget.input.values.first.deviceCalibration!),
            child: _keyValue(
              key: "Kalibrasi Alat",
              value: "${widget.input.values.first.deviceCalibration!.device!.name}",
            ),
          ),
          const SizedBox(height: Dimens.paddingSmall),
          _buildResult(),
          const SizedBox(height: Dimens.paddingSmall),
          _buildTable(),
          const SizedBox(height: Dimens.paddingMedium),
        ],
      ),
    );
  }
}