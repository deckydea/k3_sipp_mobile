import 'package:flutter/services.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfHelperUtils {
  static const String title = "Laboratorium Pengujian";
  static const String subtitle = "Balai Keselamatan dan Kesehatan Kerja Bandung\nKementrian Ketenagakerjaan R.I";
  static const String address = "Jl. Golf No. 34 Ujungberung, Bandung 40294 Jawa Barat";
  static const String phone = "(022) 7800995 / 7834262";
  static const String fax = "(022) 7834262";
  static const String email = "hiperkes@bdg.centrin.nnet.id";

  static final TextStyle titleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.fontMedium, color: PdfColor.fromInt(ColorResources.text.value));
  static final TextStyle subtitleStyle =
      TextStyle(fontSize: Dimens.fontSmall, color: PdfColor.fromInt(ColorResources.text.value));
  static final TextStyle mediumStyle = TextStyle(fontSize: Dimens.fontXSmall, color: PdfColor.fromInt(ColorResources.text.value));
  static final TextStyle smallStyle = TextStyle(fontSize: Dimens.fontXXSmall, color: PdfColor.fromInt(ColorResources.text.value));
  static final TextStyle xSmallStyle =
      TextStyle(fontSize: Dimens.fontXXXSmall, color: PdfColor.fromInt(ColorResources.text.value));

  static Future<Widget> buildHeader() async {
    final k3Logo = MemoryImage((await rootBundle.load("assets/drawable/raw.png")).buffer.asUint8List());
    final kanLogo = MemoryImage((await rootBundle.load("assets/drawable/kan.png")).buffer.asUint8List());

    return Container(
      padding: const EdgeInsets.only(bottom: Dimens.paddingWidget),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: PdfColors.black))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(k3Logo, fit: BoxFit.contain, height: Dimens.logoSizeLarge, width: Dimens.logoSizeSmall),
          SizedBox(width: Dimens.paddingGap),
          Expanded(
            flex: 5,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                text: TextSpan(
                  style: const TextStyle(lineSpacing: 1),
                  children: [
                    TextSpan(
                        text: title.toUpperCase(),
                        style: subtitleStyle.copyWith(fontSize: Dimens.fontSmall, fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: "\n${subtitle.toUpperCase()}",
                      style: subtitleStyle.copyWith(fontSize: Dimens.fontSmall, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "\n$address", style: smallStyle.copyWith(color: PdfColors.grey)),
                    TextSpan(
                      text: "\nTelp $phone Fax. $fax E-mail: $email",
                      style: smallStyle.copyWith(color: PdfColors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.paddingGap),
          Image(kanLogo, fit: BoxFit.contain, height: Dimens.logoSizeLarge, width: Dimens.logoSizeSmall),
        ],
      ),
    );
  }

  static Future<Widget> buildBackground() async {
    final k3Logo = MemoryImage((await rootBundle.load("assets/drawable/background_kemnaker.png")).buffer.asUint8List());

    return Container(
      padding: const EdgeInsets.only(bottom: Dimens.paddingWidget),
      decoration: const BoxDecoration(color: PdfColors.white),
      child: Center(
        child: Image(k3Logo, fit: BoxFit.contain, height: Dimens.logoSizeBackground, width: Dimens.logoSizeBackground),
      ),
    );
  }

  //===================== Custom Widget =======================

  static Widget keyValue({required Widget title, Widget? subtitle, required Widget value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: subtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title,
                    SizedBox(height: Dimens.paddingGap),
                    subtitle,
                  ],
                )
              : title,
        ),
        SizedBox(width: Dimens.paddingSmall),
        Expanded(flex: 4, child: value),
      ],
    );
  }

  static Widget keyValueSeparated({required Widget title, Widget? subtitle, required Widget value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: subtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title,
                    SizedBox(height: Dimens.paddingGap),
                    subtitle,
                  ],
                )
              : title,
        ),
        SizedBox(width: Dimens.paddingSmall),
        Text(": ", style: smallStyle),
        Expanded(flex: 5, child: value),
      ],
    );
  }

  static Widget signatureWidget(
      {required DateTime date, required String title, required String name, required String nip, Uint8List? signature}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Bandung, ${DateTimeUtils.formatToDate(date)}\n$title,",
          style: PdfHelperUtils.smallStyle,
          textAlign: TextAlign.center,
        ),
        signature == null
            ? SizedBox(height: Dimens.paddingLarge)
            : Image(MemoryImage(signature), fit: BoxFit.contain, height: Dimens.iconSizeMedium, width: Dimens.iconSizeMedium),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(lineSpacing: 1),
            children: [
              TextSpan(
                text: name,
                style: PdfHelperUtils.smallStyle.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              TextSpan(text: "\nNIP: $nip", style: PdfHelperUtils.smallStyle),
            ],
          ),
        ),
      ],
    );
  }

  static Widget bulletWidget({required Text text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingSmallGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.5),
            child: Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(color: PdfColors.black, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: Dimens.paddingGap),
          text,
        ],
      ),
    );
  }
}
