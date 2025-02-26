import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/device/device_calibration.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_hand_arm.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_hand_arm.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';

class InputHandArmRow extends StatefulWidget {
  final DataHandArm input;
  final ResultHandArm? result;

  const InputHandArmRow({super.key, required this.input, this.result});

  @override
  State<InputHandArmRow> createState() => _InputHandArmRowState();
}

class _InputHandArmRowState extends State<InputHandArmRow> {
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
    return widget.result == null
        ? Container()
        : Column(
            children: [
              _keyValue(
                key: "NAB",
                value: "${widget.result!.nab}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "Rerata",
                value: "${widget.result!.average}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "Standar Deviasi",
                value: "${widget.result!.standarDeviasi}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "U Presisi",
                value: "${widget.result!.upresisi}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "U Kalibrasi",
                value: "${widget.result!.ukalibrasi}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "U Gabungan",
                value: "${widget.result!.ugabungan}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "U95%",
                value: "${widget.result!.u95}",
                valueColor: Colors.black,
              ),
              _keyValue(
                key: "Laporan m/s2",
                value: "${widget.result!.laporanMSrerata}",
                valueColor: Colors.black,
              ),
            ],
          );
  }

  Widget _buildInput() {
    TextStyle? headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle? bodyStyle = Theme.of(context).textTheme.labelSmall;

    List<DataRow2> dataRows;

    if (widget.result != null) {
      dataRows = [
        DataRow2(
          cells: [
            DataCell(Text("1", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input.x1}", style: bodyStyle)),
            DataCell(Text("${widget.input.y1}", style: bodyStyle)),
            DataCell(Text("${widget.input.z1}", style: bodyStyle)),
            DataCell(Text("${widget.result!.dominan1}", style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("2", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input.x2}", style: bodyStyle)),
            DataCell(Text("${widget.input.y2}", style: bodyStyle)),
            DataCell(Text("${widget.input.z2}", style: bodyStyle)),
            DataCell(Text("${widget.result!.dominan2}", style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("3", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input.x3}", style: bodyStyle)),
            DataCell(Text("${widget.input.y3}", style: bodyStyle)),
            DataCell(Text("${widget.input.z3}", style: bodyStyle)),
            DataCell(Text("${widget.result!.dominan3}", style: bodyStyle)),
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
              label: Text('Repeat'),
              size: ColumnSize.S,
              fixedWidth: 80
            ),
            DataColumn2(
              label: Text('Sumbu X\nm/s2'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Sumbu Y\nm/s2'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Sumbu Z\nm/s2'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Sumbu\nDominan'),
              size: ColumnSize.M,
            ),
          ],
          rows: dataRows,
        ),
      );
    } else {
      dataRows = [
        DataRow2(
          cells: [
            DataCell(Text("1", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input.x1}", style: bodyStyle)),
            DataCell(Text("${widget.input.y1}", style: bodyStyle)),
            DataCell(Text("${widget.input.z1}", style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("1", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input.x2}", style: bodyStyle)),
            DataCell(Text("${widget.input.y2}", style: bodyStyle)),
            DataCell(Text("${widget.input.z2}", style: bodyStyle)),
          ],
        ),
        DataRow2(
          cells: [
            DataCell(Text("1", style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
            DataCell(Text("${widget.input.x3}", style: bodyStyle)),
            DataCell(Text("${widget.input.y3}", style: bodyStyle)),
            DataCell(Text("${widget.input.z3}", style: bodyStyle)),
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
              label: Text('Repeat'),
              size: ColumnSize.S,
              fixedWidth: 80,
            ),
            DataColumn2(
              label: Text('Sumbu X\n(mm/s)'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Sumbu Y\n(mm/s)'),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Sumbu Z\n(mm/s)'),
              size: ColumnSize.M,
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
            key: "NIK",
            value: widget.input.nik,
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Name",
            value: widget.input.name,
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Bagian",
            value: widget.input.bagian,
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Adaptor",
            value: widget.input.adaptor.label,
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Sumber Getaran",
            value: widget.input.sumberGetaran,
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Jumlah Tenaga Kerja yang terpapar",
            value: "${widget.input.jumlahTK} Orang",
          ),
          _keyValue(
            key: "Durasi Jam Pemaparan per Hari",
            value: widget.input.sumberGetaran,
            valueColor: Colors.black,
          ),
          _keyValue(
            key: "Note",
            value: TextUtils.isEmpty(widget.input.note) ? '-' : widget.input.note!,
          ),
          GestureDetector(
            onTap: () => _showDeviceDetailDialog(widget.input.deviceCalibration!),
            child: _keyValue(
              key: "Kalibrasi Alat",
              value: "${widget.input.deviceCalibration!.device!.name}",
            ),
          ),
          const SizedBox(height: Dimens.paddingMedium),
          _buildResult(),
          const SizedBox(height: Dimens.paddingSmall),
          _buildInput(),
          const SizedBox(height: Dimens.paddingMedium),
        ],
      ),
    );
  }
}
