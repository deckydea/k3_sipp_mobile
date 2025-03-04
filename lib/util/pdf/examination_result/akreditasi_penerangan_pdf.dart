import 'package:flutter/foundation.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_penerangan.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/template/pdf_template_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class AkreditasiPeneranganResultPdf {
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
            SizedBox(height: Dimens.paddingSmallGap),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
              child: Text(
                "3. Standar Intensitas Pencahayaan di tempat kerja berdasarkan Peraturan Menteri Ketenagakerjaan R.I No. 5 Tahun 2018.",
                style: PdfHelperUtils.xSmallStyle,
              ),
            ),
          ],
        ),
        SizedBox(width: Dimens.paddingWidget),
        Expanded(
          flex: 3,
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
    //Header
    tableContent.add(
      TableRow(
        decoration: BoxDecoration(border: Border.all(width: 1)),
        children: [
          _cell(
              widget: Text("No",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Lokasi",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Waktu Pengukuran",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Satuan",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
            widget: Text("Intensitas Pencahayaan (Lokal)",
                textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    //Body
    int i = 1;
    for (ResultPenerangan result in examination.examinationResult) {
      tableContent.add(
        TableRow(
          children: [
            _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(result.location, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(DateTimeUtils.formatToTime(result.time), textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text("Lux", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(result.average.toStringAsFixed(2), textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
          ],
        ),
      );
      i++;
    }

    if (i < 7) {
      for (i; i < 7; i++) {
        tableContent.add(
          TableRow(
            children: [
              _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
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
            flex: 4,
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
                  0: const FixedColumnWidth(17),
                  1: const FixedColumnWidth(90),
                  2: const FixedColumnWidth(40),
                  3: const FixedColumnWidth(30),
                  4: const FixedColumnWidth(40),
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
                        widget: Text(
                          "Keterangan\n\n\n",
                          textAlign: TextAlign.center,
                          style: PdfHelperUtils.smallStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            lineSpacing: 2.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      _cell(
                        widget: Padding(
                          padding: const EdgeInsets.only(right: Dimens.paddingGap),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Standar minimal pencahayaan berdasarkan jenis pekerjaan adalah:",
                                softWrap: true,
                                style: PdfHelperUtils.xSmallStyle,
                              ),
                              SizedBox(height: Dimens.paddingSmallGap),
                              PdfHelperUtils.bulletWidget(
                                text: Text(
                                  "Pekerjaan membedakan barang kecil secara \nsepintas: 100 Lux",
                                  softWrap: true,
                                  style: PdfHelperUtils.xSmallStyle,
                                ),
                              ),
                              PdfHelperUtils.bulletWidget(
                                text: Text(
                                  "Pekerjaan membedakan barang kecil yang \nagak teliti: 200 Lux",
                                  softWrap: true,
                                  style: PdfHelperUtils.xSmallStyle,
                                ),
                              ),
                              PdfHelperUtils.bulletWidget(
                                text: Text(
                                  "Pekerjaan membedakan barang halus dengan \nkontras sedang dan \ndalam waktu yang lama: 500 - 1000 Lux",
                                  softWrap: true,
                                  style: PdfHelperUtils.xSmallStyle,
                                ),
                              ),
                              PdfHelperUtils.bulletWidget(
                                text: Text(
                                  "Pekerjaan membedakan barang halus dengan \nkontras yang sangat \nkurang untuk waktu yang lama: 1000 Lux",
                                  softWrap: true,
                                  style: PdfHelperUtils.xSmallStyle,
                                ),
                              ),
                            ],
                          ),
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
    List<ResultPenerangan> result = examination.examinationResult;
    String devices = result.first.deviceCalibration!.device!.name ?? "";

    List<Widget> widgets = [
      PdfHelperUtils.keyValueSeparated(
        title: Text("Nama Perusahaan", style: PdfHelperUtils.smallStyle),
        value:
            Text(examination.company!.companyName, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
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
}
