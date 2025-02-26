import 'dart:typed_data';

import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_hand_arm.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_hand_arm.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/template/pdf_template_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class AkreditasiHandArmPdf {
  static Future<Uint8List> generatePrint({required Examination examination}) async {
    Widget header = await PdfHelperUtils.buildHeader();
    Widget background = await PdfHelperUtils.buildBackground();

    final Document pdf = Document();
    pdf.addPage(
      MultiPage(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const EdgeInsets.all(Dimens.paddingMedium),
          buildBackground: (context) => background,
        ),
        header: (context) => header,
        crossAxisAlignment: CrossAxisAlignment.center,
        build: (context) => [
          SizedBox(height: Dimens.paddingMedium),
          Text(
            "LAPORAN HASIL PENGUJIAN",
            style: PdfHelperUtils.mediumStyle.copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "No. 58 /AS.03.01/V/2023",
            style: PdfHelperUtils.smallStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.paddingLarge),
          _buildInfo(examination),
          SizedBox(height: Dimens.paddingMedium),
          _buildTable(examination),
          SizedBox(height: Dimens.paddingLarge + Dimens.paddingSmall),
          _buildFooter(examination),
        ],
      ),
    );

    return await pdf.save();
  }

  static Widget _buildFooter(Examination examination) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Catatan:", style: PdfHelperUtils.xSmallStyle.copyWith(decoration: TextDecoration.underline)),
            SizedBox(height: Dimens.paddingGap),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
              child: Text(
                "1. Dilarang menggandakan laporan tanpa izin Penanggung Jawab Teknis.",
                style: PdfHelperUtils.xSmallStyle,
              ),
            ),
            SizedBox(height: Dimens.paddingSmallGap),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
              child: Text(
                "2. Hasil Pengujian hanya berlaku pada kondisi saat pengujian.",
                style: PdfHelperUtils.xSmallStyle,
              ),
            ),
          ],
        ),
        SizedBox(width: Dimens.paddingWidget),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
              child: PdfHelperUtils.signatureWidget(
                date: DateTime.now(),
                title: "Penanggung Jawab Teknis",
                name: "dr. Diana Rosa",
                nip: "19770215 200501 2 002",
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildTable(Examination examination) {
    List<TableRow> tableContent = [];

    Widget cellResult(String text) {
      return _cellNumber(
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.paddingSmallGap),
            Text(
              text,
              textAlign: TextAlign.center,
              style: PdfHelperUtils.smallStyle,
            ),
          ],
        ),
      );
    }

    //Header
    tableContent.add(
      TableRow(
        decoration: BoxDecoration(border: Border.all(width: 1)),
        children: [
          _cell(
              widget: Text("No",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Nama /\nPekerjaan /\nUnit",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Adaptor",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: Dimens.paddingSmall),
                Text("Percepatan Getaran Equivalen aeq\n(m/dt²)",
                    textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: Dimens.paddingSmall),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _cellNumber(
                        widget: Text("Sumbu x",
                            textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      _cellNumber(
                        widget: Text("Sumbu y",
                            textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      _cellNumber(
                        widget: Text("Sumbu z",
                            textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          _cell(
              widget: Text("aeq\n(m / dt²)\nSumbu Dominan",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Lama\nPaparan",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
        ],
      ),
    );

    //Body
    int i = 1;
    for (ResultHandArm result in examination.examinationResult) {
      tableContent.add(
        TableRow(
          verticalAlignment: TableCellVerticalAlignment.full,
          children: [
            _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(
                widget: Text("Nama : ${result.name}\nBagian : ${result.bagian}\nNIK :${result.nik}",
                    style: PdfHelperUtils.xSmallStyle)),
            _cell(
              widget: Text(result.adaptor.label, textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cellResult(result.averageX.toStringAsFixed(3)),
                  cellResult(result.averageY.toStringAsFixed(3)),
                  cellResult(result.averageZ.toStringAsFixed(3)),
                ],
              ),
            ),
            _cell(
              widget:
                  Text(result.averageDominan.toStringAsFixed(3), textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
            ),
            _cell(
              widget: Text("${result.durasi} Jam", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
            ),
          ],
        ),
      );
      i++;
    }

    if (i < 6) {
      for (i; i < 6; i++) {
        tableContent.add(
          TableRow(
            verticalAlignment: TableCellVerticalAlignment.full,
            children: [
              _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.xSmallStyle)),
              _cell(
                widget: Text("", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cellResult(""),
                    cellResult(""),
                    cellResult(""),
                  ],
                ),
              ),
              _cell(
                widget:
                    Text("", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
              ),
              _cell(
                widget: Text("", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(width: 1))),
              child: Table(
                border: const TableBorder(
                  verticalInside: BorderSide(width: 1),
                  horizontalInside: BorderSide(width: 1),
                  right: BorderSide(width: 1),
                  left: BorderSide(width: 1),
                ),
                columnWidths: <int, TableColumnWidth>{
                  0: const FixedColumnWidth(20),
                  1: const FixedColumnWidth(45),
                  2: const FixedColumnWidth(35),
                  3: const FixedColumnWidth(110),
                  4: const FixedColumnWidth(43),
                  5: const FixedColumnWidth(37),
                },
                children: tableContent,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(width: 1))),
              child: Table(
                border: const TableBorder(horizontalInside: BorderSide(width: 1)),
                children: [
                  TableRow(
                    children: [
                      _cell(
                          widget: Text("Keterangan\n\n",
                              textAlign: TextAlign.center,
                              style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold, lineSpacing: 1.9)))
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingSmall, vertical: Dimens.paddingSmall),
                        child: Table(
                          border: const TableBorder(
                            verticalInside: BorderSide(width: 1),
                            horizontalInside: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                            left: BorderSide(width: 1),
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                          ),
                          columnWidths: <int, TableColumnWidth>{
                            0: const FixedColumnWidth(50),
                            1: const FixedColumnWidth(50),
                          },
                          children: [
                            TableRow(
                              children: [
                                _cell(
                                    widget: Text("Jumlah waktu\npajanan per\nhari kerja\n(Jam)",
                                        textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(
                                    widget: Text("Nilai Ambang\nBatas\n(m/dt²)",
                                        textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("6 - 8", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(widget: Text("5", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("4 - 6", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(widget: Text("6", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("2 - 4", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(widget: Text("7", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("1 - 2", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(widget: Text("10", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("0,5 - 1", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(widget: Text("14", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("< 0,5", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                                _cell(widget: Text("20", textAlign: TextAlign.center, style: PdfHelperUtils.xSmallStyle)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfo(Examination examination) {
    List<ResultHandArm> result = examination.examinationResult;
    String devices = result.first.deviceCalibration!.device!.name ?? "";

    List<Widget> widgets = [
      PdfHelperUtils.keyValueSeparated(
        title: Text("Nama Perusahaan", style: PdfHelperUtils.smallStyle),
        value: Text(examination.company!.companyName, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
      ),
      PdfHelperUtils.keyValueSeparated(
        title: Text("Alamat", style: PdfHelperUtils.smallStyle),
        value: Text("${examination.company!.companyAddress}", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.keyValueSeparated(
        title: Text("Tanggal Pelaksanaan", style: PdfHelperUtils.smallStyle),
        value: Text(DateTimeUtils.formatToDate(examination.implementationTimeStart!), style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.keyValueSeparated(
        title: Text("Jenis Pengujian", style: PdfHelperUtils.smallStyle),
        value: Text(examination.examinationType!.description, style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.keyValueSeparated(
        title: Text("Metode", style: PdfHelperUtils.smallStyle),
        value: Text(examination.metode!, style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.keyValueSeparated(
        title: Text("Peralatan", style: PdfHelperUtils.smallStyle),
        value: Text(devices, style: PdfHelperUtils.smallStyle),
      ),
    ];

    return ListView.separated(
      itemBuilder: (context, index) => widgets.elementAt(index),
      separatorBuilder: (context, index) => SizedBox(height: Dimens.paddingGap),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
      itemCount: widgets.length,
    );
  }

  static Widget _cell({required Widget widget, Border? border}) {
    return Container(
      decoration: BoxDecoration(border: border),
      padding: const EdgeInsets.all(Dimens.paddingWidget),
      child: widget,
    );
  }

  static Widget _cellNumber({required Widget widget}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
      width: 50,
      decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(width: 1))),
      child: widget,
    );
  }
}