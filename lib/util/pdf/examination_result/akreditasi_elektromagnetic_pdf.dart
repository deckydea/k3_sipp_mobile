import 'package:flutter/foundation.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_elektromagnetic.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/template/pdf_template_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class AkreditasiElektromagneticPdf {
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
                "3. Nilai Ambang Batas (NAB) Pemaparan Medan Magnit Statis yang diperkenankan di tempat kerja\n    berdasarkan Peraturan  Menteri Ketenagakerjaan R.I  No. 5 tahun 2018.",
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
                name: "Waluyo, PG.Dip.Sc (OHS) M.Si",
                nip: "1982837182738",
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
              widget: Text("Satuan",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
            widget: Text("Hasil Pengukuran",
                textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    //Body
    int i = 1;
    for (ResultElektromagnetic result in examination.examinationResult) {
      tableContent.add(
        TableRow(
          children: [
            _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(result.location, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text("Tesla (T)", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text("${result.mikro}", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
          ],
        ),
      );
      i++;
    }

    if (i < 9) {
      for (i; i < 9; i++) {
        tableContent.add(
          TableRow(
            children: [
              _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
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
                  0: const FixedColumnWidth(17),
                  1: const FixedColumnWidth(90),
                  2: const FixedColumnWidth(35),
                  3: const FixedColumnWidth(35),
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
                            0: const FixedColumnWidth(35),
                            1: const FixedColumnWidth(90),
                            2: const FixedColumnWidth(80),
                          },
                          children: [
                            TableRow(
                              children: [
                                _cell(
                                    widget: Text("No",
                                        textAlign: TextAlign.center,
                                        style: PdfHelperUtils.xxSmallStyle)),
                                _cell(
                                    widget: Text("Bagian Tubuh", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cell(
                                    widget: Text("Kadar tertinggi yang diperkenankan (Ceiling)",
                                        textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("1", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("Seluruh tubuh (tempat kerja umum)", style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("2 T", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("2", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cell(
                                    widget: Text("Seluruh tubuh (pekerja khusus dan lingkungan kerja yang terkendali)",
                                        style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("8 T", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("3", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("Anggota gerak (Limbs)", style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("20 T", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cell(widget: Text("4", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("Pengguna peralatan medis elektronik", style: PdfHelperUtils.xxSmallStyle)),
                                _cell(widget: Text("0,5 T", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
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
    List<ResultElektromagnetic> result = examination.examinationResult;
    // String devices = result.map((e) => e.deviceCalibration!.name).join(',');
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
}