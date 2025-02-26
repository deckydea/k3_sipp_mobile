import 'package:flutter/foundation.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/input/input_kebisingan_noise_dose.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/template/pdf_template_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class AkreditasiNoiseDosePdf {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.paddingSmallGap),
            Text(
              text,
              textAlign: TextAlign.center,
              style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold),
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
              widget: Text("Identitas Karyawan\nNama / NIK / Jabatan / plant",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Waktu\nPengukuran",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: Dimens.paddingWidget),
                Text("Hasil Pengukuran",
                    textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: Dimens.paddingWidget),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _cellNumber(
                        widget: Text("TWA (dBA)",
                            textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      _cellNumber(
                        widget: Text("Dose (%)",
                            textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      _cellNumber(
                        widget: Text("Leq (dBA)",
                            textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          _cell(
              widget: Text("Keterangan",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
        ],
      ),
    );

    //Body
    int i = 1;
    for (DataNoiseDose result in examination.examinationResult) {
      tableContent.add(
        TableRow(
          verticalAlignment: TableCellVerticalAlignment.full,
          children: [
            _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(
                widget: Text("Nama : ${result.name}\nBagian : ${result.bagian}\nNIK :${result.nik}",
                    style: PdfHelperUtils.xSmallStyle)),
            _cell(
              widget: Text("${DateTimeUtils.formatToTime(result.timeStart)} - ${DateTimeUtils.formatToTime(result.timeEnd)}",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cellResult("${result.twa}"),
                  cellResult("${result.dose}"),
                  cellResult("${result.leq}"),
                ],
              ),
            ),
          ],
        ),
      );
      i++;
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Table(
        border: const TableBorder(
          verticalInside: BorderSide(width: 1),
          horizontalInside: BorderSide(width: 1),
          right: BorderSide(width: 1),
          left: BorderSide(width: 1),
        ),
        columnWidths: <int, TableColumnWidth>{
          0: const FixedColumnWidth(30),
          1: const FixedColumnWidth(100),
          2: const FixedColumnWidth(80),
          3: const FlexColumnWidth(),
          4: const FixedColumnWidth(70),
        },
        children: tableContent,
      ),
    );
  }

  static Widget _buildInfo(Examination examination) {
    List<DataNoiseDose> result = examination.examinationResult;
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
      width: 90,
      decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(width: 1))),
      child: widget,
    );
  }
}