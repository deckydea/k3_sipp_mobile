import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/examination/input_form_logic.dart';
import 'package:k3_sipp_mobile/model/examination/examination.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/assignment/input/input_kebisingan_lk_page.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:material_symbols_icons/symbols.dart';

class InputFormPage extends StatefulWidget {
  //TODO: Change this to required later
  final Examination? examination;

  const InputFormPage({super.key, this.examination});

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final InputFormLogic _logic = InputFormLogic();

  Future<void> _actionDone() async {}

  Future<void> _actionSave() async {}

  Future<void> _actionContinue() async {
    List<String> options = [];
    List<Icon> icons = [];
    List<Function()> callbacks = [];
    List<Color> colors = [];

    options.add("Simpan Pengujian");
    callbacks.add(() => Navigator.of(context).pop(0));
    icons.add(const Icon(Icons.save, color: Colors.black));
    colors.add(Colors.black);

    options.add("Selesai dan Lanjutkan Approval");
    callbacks.add(() => Navigator.of(context).pop(1));
    icons.add(const Icon(Symbols.order_approve_rounded, color: Colors.black));
    colors.add(Colors.black);

    if (mounted) {
      var result = context.mounted
          ? await DialogUtils.showOptionDialog(
              context: context, title: "Pilih Opsi", options: options, onSelected: callbacks, icons: icons, color: colors)
          : null;

      if (result != null && result is int) {
        switch (result) {
          case 0:
            _actionSave();
            break;
          case 1:
            _actionDone();
            break;
          default:
        }
      }
    }
  }

  Widget _buildInputForm() {
    // if(ExaminationTypeName.kebisingan)

    return InputKebisinganLKPage(key: _logic.kebisinganKey);
  }

  Widget _titleRow({
    required IconData icon,
    required String title,
    String? value,
    Widget? valueWidget,
    VoidCallback? onTapValue,
  }) {
    if (value == null && valueWidget == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: Dimens.paddingWidget),
          Icon(icon, color: ColorResources.primaryDark, size: Dimens.iconSizeTitle),
          const SizedBox(width: Dimens.paddingGap),
          Expanded(
              flex: 2,
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primaryDark))),
          const SizedBox(width: Dimens.paddingGap),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: onTapValue,
              child: valueWidget ??
                  Text(
                    value ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: onTapValue != null ? ColorResources.primaryLight : Colors.black),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingPage),
        child: Column(
          children: [
            CustomCard(
              borderRadius: Dimens.cardRadius,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(Dimens.paddingPage),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kebisingan", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text("Jenis Intensitas Kebisingan Linkungan Kerja", style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: Dimens.paddingSmall),
                    _titleRow(icon: Icons.home_work_rounded, title: "Perusahaan", value: "PT ABC Indonesia Aman"),
                    _titleRow(
                        icon: Icons.map, title: "Alamat", value: "Apt. 906 288 Emmerich Crossroad, Lake Gale, GA 31723-0155"),
                    _titleRow(
                      icon: Icons.devices,
                      title: "Alat yang digunakan",
                      value: "Sound Kalibrator",
                      onTapValue: () => print("SHOW DETAIL DEVICE MODAL"),
                    ),
                    _titleRow(
                      icon: Icons.calendar_month,
                      title: "Due Date",
                      value: "06 Agustus 2018",
                    ),
                    _titleRow(
                      icon: Icons.check_box,
                      title: "Status",
                      valueWidget: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.paddingSmallGap, horizontal: Dimens.paddingGap),
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(Dimens.cardRadiusLarge),
                          ),
                          child: const Text("PENDING", style: TextStyle(color: Colors.white, fontSize: Dimens.fontXSmall)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimens.paddingSmall),
            _buildInputForm(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.background,
        title: Text("Pengujian", style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingWidget),
            child: IconButton(
              onPressed: _actionContinue,
              icon: const Icon(
                Symbols.check,
                color: ColorResources.primary,
                weight: Dimens.iconWeightAppbar,
                size: Dimens.iconSizeAppbar,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
