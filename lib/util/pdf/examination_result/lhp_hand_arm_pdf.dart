import 'package:flutter/foundation.dart';
import 'package:k3_sipp_mobile/model/device/device.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/model/examination/result/result_hand_arm.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/pdf/template/pdf_template_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class LHPHandArmPdf {
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "1. DATA UMUM",
              style: PdfHelperUtils.smallStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: Dimens.paddingGap),
          _buildInfo(examination),
          SizedBox(height: Dimens.paddingSmall),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "2. PEMERIKSAAN DAN/ATAU PENGUJIAN TEKNIS",
              style: PdfHelperUtils.smallStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: Dimens.paddingGap),
          _buildTeknis(examination),
          SizedBox(height: Dimens.paddingSmall),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "3. PEMERIKSAAN DAN/ATAU PENGUJIAN TEKNIS",
              style: PdfHelperUtils.smallStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: Dimens.paddingGap),
          _buildTable(examination),
          SizedBox(height: Dimens.paddingSmallGap),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("*Berdasarkan Permenaker RI No. 5 tahun 2018 mengenai intensitas kebisingan",
                style: PdfHelperUtils.xSmallStyle),
          ),
          SizedBox(height: Dimens.paddingSmall),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "4. METODE PENGUKURAN YANG DIPAKAI",
              style: PdfHelperUtils.smallStyle,
              textAlign: TextAlign.left,
            ),
          ),
          //TODO: remove hard code
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "SNI 7186 : 2021  Pengukuran dan evaluasi paparan getaran pada  seluruh tubuh pekerja",
                style: PdfHelperUtils.smallStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(height: Dimens.paddingSmall),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "5. ANALISIS",
              style: PdfHelperUtils.smallStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: Dimens.paddingGap),
          _buildAnalisis(examination),
          SizedBox(height: Dimens.paddingSmall),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "6. KESIMPULAN",
              style: PdfHelperUtils.smallStyle,
              textAlign: TextAlign.left,
            ),
          ),
          _buildKesimpulan(examination),
          // SizedBox(height: Dimens.paddingSmall),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "7. SARAN",
          //     style: PdfHelperUtils.smallStyle,
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          // _buildSaran(examination),
          SizedBox(height: Dimens.paddingLarge + Dimens.paddingSmall),
          _buildFooter(examination),
        ],
      ),
    );

    return await pdf.save();
  }

  static Widget _buildAnalisis(Examination examination) {
    List<ResultHandArm> results = examination.examinationResult;

    ResultHandArm? highResult;
    ResultHandArm? lowResult;
    for (ResultHandArm result in results) {
      if (highResult == null || result.average > highResult.average) {
        highResult = result;
      }

      if (lowResult == null || result.average < lowResult.average) {
        lowResult = result;
      }
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Pengukuran Getaran dilakukan sesuai dengan Standar nasional Indonesia, maka hasil pengukuran yang dihasilkan bertujuan untuk melihat potensi bahaya faktor getaran yang ada, sedangkan dari hasil pengukuran getaran dari ${results.length} lokasi yang diukur diperoleh nilai tertinggi sebesar ${highResult!.average} m/det² dan terendah ${lowResult!.average} m/det², Sesuai dengan Permenaker No 5 Tahun 2018.",
        style: PdfHelperUtils.smallStyle.copyWith(lineSpacing: 1),
      ),
    );
  }

  static Widget _buildKesimpulan(Examination examination) {
    List<ResultHandArm> highNAB = [];
    List<ResultHandArm> lowNAB = [];

    for (ResultHandArm result in examination.examinationResult) {
      if (result.average > result.nab) {
        highNAB.add(result);
      } else {
        lowNAB.add(result);
      }
    }

    String highNabString = highNAB.map((e) => e.location).join(',');
    String lowNabString = lowNAB.map((e) => e.location).join(',');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Hasil pengukuran dari ${examination.examinationResult.length} lokasi yang diukur diperoleh ${lowNAB.length} lokasi yaitu $lowNabString yang diukur terindikasi masih dibawah Nilai Ambang Batas (NAB) dan ${highNAB.length} lokasi $highNabString yang terindikasi diatas Nilai Ambang Batas (NAB) sesuai Permenaker No 5 Tahun 2018.",
          style: PdfHelperUtils.smallStyle,
        ),
      ),
    );
  }

  static Widget _buildSaran(Examination examination) {
    RichText text;
    List<ResultHandArm> result = examination.examinationResult;

    bool highNAB = false;
    for (var element in result) {
      if (element.average > element.nab) {
        highNAB = true;
        break;
      }
    }

    if (highNAB) {
      text = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: PdfHelperUtils.smallStyle,
          children: const [
            TextSpan(text: "Segera melakukan Tindakan pengendalian Sesuai Hirarki of Control\n"),
            TextSpan(text: "a. Menghilangkan sumber Kebisingan  dari  Tempat Kerja;\n"),
            TextSpan(text: "b. Mengganti alat,bahan, dan proses kerja yang menimbulkan sumber Kebisingan;\n"),
            TextSpan(text: "c. Memasang pembatas, peredam suara, penutupan sebagian atau seluruh alat;\n"),
            TextSpan(text: "d. Mengatur atau membatasi pajanan Kebisingan atau pengaturan waktu kerja;\n"),
            TextSpan(text: "e. Menggunakan alat pelindung diri yang sesuai; dan/atau\n"),
            TextSpan(text: "f. Melakukan pengendalian lainnya sesuai dengan perkembangan ilmu pengetahuan dan teknologi.\n"),
          ],
        ),
      );
    } else {
      text = RichText(
        text: TextSpan(
          style: PdfHelperUtils.smallStyle,
          children: const [
            TextSpan(
                text:
                    "Pertahankan kondisi lingkungan kerja yang aman sehat dan Produktif, dan lakukan pengujian lingkungan kerja secara berkala."),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
      child: Align(alignment: Alignment.centerLeft, child: text),
    );
  }

  static Widget _buildFooter(Examination examination) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
                child: PdfHelperUtils.signatureWidget(
                  title: "Disetujui,\nSubkoordinator Pengujian & Analisis K3",
                  name: "dr. Diana Rosa",
                  nip: "19770215 200501 2 002",
                ),
              ),
            ),
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
                  title: "Yang Memeriksa dan Menguji,\nPenguji K3 Ahli Pertama/Muda/Madya",
                  name: examination.petugasExaminations!.name,
                  nip: examination.petugasExaminations!.nip,
                ),
              ),
            ),
          ),
        ],
      ),
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
              widget: Text("Ruang Kerja/Bagian",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Jumlah Tenaga Kerja yang terpapar (orang)",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
            widget: Text("Sumber\nGetaran",
                textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold)),
          ),
          _cell(
              widget: Text("Durasi Jam Pemaparan per Hari",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Hasil Uji\n(m/det²)",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("NAB\n(m/det²)",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
          _cell(
              widget: Text("Tindakan\nPengendalian yang\nTelah Dilakukan",
                  textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold))),
        ],
      ),
    );

    //Body
    int i = 1;
    for (ResultHandArm result in examination.examinationResult) {
      tableContent.add(
        TableRow(
          children: [
            _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(
                widget: Text("Nama : ${result.name}\nBagian : ${result.bagian}\nNIK :${result.nik}\n${result.location}",
                    style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text("${result.jumlahTK}", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(result.sumberGetaran, textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text("${result.durasi}", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text(result.average.toStringAsFixed(2), textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(widget: Text("${result.nab}", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
            _cell(
                widget: Text(TextUtils.isEmpty(result.tindakan) ? "" : result.tindakan,
                    textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
          ],
        ),
      );
      i++;
    }

    if (i < 4) {
      for (i; i < 4; i++) {
        tableContent.add(
          TableRow(
            children: [
              _cell(widget: Text("$i", textAlign: TextAlign.center, style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
              _cell(widget: Text("", style: PdfHelperUtils.smallStyle)),
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
      child: Table(
        border: const TableBorder(
          verticalInside: BorderSide(width: 1),
          horizontalInside: BorderSide(width: 1),
          right: BorderSide(width: 1),
          left: BorderSide(width: 1),
        ),
        columnWidths: <int, TableColumnWidth>{
          0: const FixedColumnWidth(20),
          1: const FixedColumnWidth(80),
          2: const FixedColumnWidth(35),
          3: const FixedColumnWidth(35),
          4: const FixedColumnWidth(30),
          5: const FixedColumnWidth(35),
          6: const FixedColumnWidth(30),
          7: const FixedColumnWidth(40),
        },
        children: tableContent,
      ),
    );
  }

  static Widget _buildTeknis(Examination examination) {
    List<ResultHandArm> result = examination.examinationResult;
    Device device = result.first.deviceCalibration.device!;

    List<Widget> widgets = [
      PdfHelperUtils.titleValue(
        title: Text("Nama Alat Ukur Yang Digunakan", style: PdfHelperUtils.smallStyle),
        value: Text("${device.name}", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Type/Nomor Seri", style: PdfHelperUtils.smallStyle),
        value: Text(device.nomorSeriAlat ?? "", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Negara Pembuat", style: PdfHelperUtils.smallStyle),
        value: Text(device.negaraPembuat ?? "", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Tanggal Kalibrasi Eksternal Terakhir", style: PdfHelperUtils.smallStyle),
        value: Text(
            device.tanggalKalibrasiEksternalTerakhir == null
                ? ""
                : DateTimeUtils.formatToDate(device.tanggalKalibrasiEksternalTerakhir!),
            style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Instansi Pengkalibrasi", style: PdfHelperUtils.smallStyle),
        value: Text(device.instansiPengkalibrasi ?? "", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Tanggal Pengujian", style: PdfHelperUtils.smallStyle),
        value: Text(
            examination.implementationTimeStart == null ? "" : DateTimeUtils.formatToDate(examination.implementationTimeStart!),
            style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Waktu Pengujian", style: PdfHelperUtils.smallStyle),
        value: Text(
            "Pukul ${examination.implementationTimeStart == null ? "-" : DateTimeUtils.formatToTime(examination.implementationTimeStart!)} s.d ${examination.implementationTimeEnd == null ? "-" : DateTimeUtils.formatToTime(examination.implementationTimeEnd!)} WIB",
            style: PdfHelperUtils.smallStyle),
      ),
    ];

    return ListView.separated(
      itemBuilder: (context, index) => widgets.elementAt(index),
      separatorBuilder: (context, index) => SizedBox(height: Dimens.paddingGap),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
      itemCount: widgets.length,
    );
  }

  static Widget _buildInfo(Examination examination) {
    List<Widget> widgets = [
      PdfHelperUtils.titleValue(
        title: Text("Perusahaan", style: PdfHelperUtils.smallStyle),
        value: Text(examination.company!.companyName, style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Alamat", style: PdfHelperUtils.smallStyle),
        value: Text("${examination.company!.companyAddress}", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Pengurus/Penanggungjawab", style: PdfHelperUtils.smallStyle),
        value: Text(examination.company!.picName ?? "", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Lokasi Pemeriksaan", style: PdfHelperUtils.smallStyle),
        value: Text(examination.lokasi ?? "", style: PdfHelperUtils.smallStyle),
      ),
      PdfHelperUtils.titleValue(
        title: Text("Nomor SKP Penguji K3", style: PdfHelperUtils.smallStyle),
        value: Text(examination.petugasExaminations!.noSKP ?? "", style: PdfHelperUtils.smallStyle),
      ),
    ];

    return ListView.separated(
      itemBuilder: (context, index) => widgets.elementAt(index),
      separatorBuilder: (context, index) => SizedBox(height: Dimens.paddingGap),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
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
