import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';

class ExaminationRow extends StatefulWidget {
  final ExaminationType examinationType;

  const ExaminationRow({super.key, required this.examinationType});

  @override
  State<ExaminationRow> createState() => ExaminationRowState();
}

class ExaminationRowState extends State<ExaminationRow> {
  final TextEditingController _controller = TextEditingController();

  int? get value => int.tryParse(_controller.text);

  void setValue(int value) {
    _controller.text = "$value";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingWidget),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.examinationType.examinationTypeName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.examinationType.description,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimens.paddingWidget),
          Expanded(
            flex: 2,
            child: CustomEditText(
              controller: _controller,
              label: "Jumlah",
              textInputType: TextInputType.number,
              validator: (value) => ValidatorUtils.validateIntegerValue(context, int.parse(value!), 0, 999),
            ),
          ),
        ],
      ),
    );
  }
}
