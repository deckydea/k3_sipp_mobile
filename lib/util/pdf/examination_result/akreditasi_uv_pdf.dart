import 'dart:typed_data';
import 'package:k3_sipp_mobile/model/examination/input/input_uv.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_uv.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/template/pdf_template_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';

class AkreditasiUVPdf {
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
            widget:
                Text("No", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
          _cell(
            widget: Text("Lokasi",
                textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
          _cell(
            widget: Text("Waktu\nPengukuran",
                textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
          _cell(
            widget: Text(
              "Satuan",
              textAlign: TextAlign.center,
              style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          _cell(
            widget: Text(
              "Hasil\nPengukuran\n(mW/cm²)",
              textAlign: TextAlign.center,
              style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    //Body
    final Map<String, Map<Posisi, ResultUV>> resultUV = {};
    for (ResultUV result in examination.examinationResult) {
      resultUV[result.location] ??= {};

      Map<Posisi, ResultUV> data = resultUV[result.location]!;
      data[result.posisi] = result;
      resultUV[result.location] = data;
    }

    int i = 1;
    resultUV.forEach((location, resultByPosition) {
      ResultUV result = resultByPosition.values.first;
      tableContent.add(
        TableRow(
          children: [
            _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(result.location, style: PdfHelperUtils.smallStyle)),
            _cell(
                widget:
                    Text(DateTimeUtils.formatToTime(result.time), textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _cellPengukuran(
                    widget: Text("Mata",
                        textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
                  ),
                  _cellPengukuran(
                    widget: Text("Siku",
                        textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
                  ),
                  _cellPengukuran(
                    widget: Text("Betis",
                        textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _cellPengukuran(
                    widget: Text(resultByPosition[Posisi.mata]!.average.toStringAsFixed(4),
                        textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
                  ),
                  _cellPengukuran(
                    widget: Text(resultByPosition[Posisi.siku]!.average.toStringAsFixed(4),
                        textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
                  ),
                  _cellPengukuran(
                    widget: Text(resultByPosition[Posisi.betis]!.average.toStringAsFixed(4),
                        textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      i++;
    });

    if (i < 10) {
      for (i; i < 10; i++) {
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
                  1: const FixedColumnWidth(75),
                  2: const FixedColumnWidth(45),
                  3: const FixedColumnWidth(40),
                  4: const FixedColumnWidth(50),
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
                children: [
                  TableRow(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 2, color: PdfColors.black))),
                        padding: const EdgeInsets.all(Dimens.paddingWidget),
                        child: Text(
                          "Keterangan\n\n\n",
                          textAlign: TextAlign.center,
                          style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold, lineSpacing: 2.6),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
                        child: Text(
                          "\nNilai Ambang Batas Radiasi Sinar Ultra\nViolet untuk tempat kerja berdasarkan\nPeraturan Menteri Ketenagakerjaan R.I No.\n5 tahun 2018:\n",
                          textAlign: TextAlign.start,
                          style: PdfHelperUtils.xSmallStyle.copyWith(lineSpacing: 2.4),
                        ),
                      ),
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
                            0: const FixedColumnWidth(100),
                            1: const FixedColumnWidth(100),
                          },
                          children: [
                            TableRow(
                              children: [
                                _cell(
                                    widget: Text("Masa\nPemajanan\nper hari",
                                        textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cell(
                                    widget: Text("Iradiasi Efektif\n(Eeff)\n(mW/cm²)\n",
                                        textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("8 Jam", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,0001", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("4 Jam", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,0002", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("2 Jam", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,0004", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("1 jam", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,0008", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("30 Menit", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,0017", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("15 menit", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,0033", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("10 menit", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,005", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("5 menit", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,01", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("1 menit", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,05", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("30 Detik", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,1", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("10 Detik", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("0,3", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("1 Detik", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("3", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("0,5 Detik", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("6", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                              ],
                            ),
                            TableRow(
                              children: [
                                _cellNote(widget: Text("0,1 Detik", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
                                _cellNote(widget: Text("30", textAlign: TextAlign.center, style: PdfHelperUtils.xxSmallStyle)),
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
    List<ResultUV> result = examination.examinationResult;
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

  static Widget _cellNote({required Widget widget, Border? border}) {
    return Container(
      decoration: BoxDecoration(border: border),
      padding: const EdgeInsets.all(3.0),
      child: widget,
    );
  }

  static Widget _cellPengukuran({required Widget widget}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap, horizontal: Dimens.paddingGap),
      width: 90,
      decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(width: 1))),
      child: widget,
    );
  }
}
