import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dialog_title.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerArgument {
  DateRangePickerSelectionMode mode;
  DateTime? selectedDate;
  DateTime? startDate; // for date range
  DateTime? endDate; // for date range
  DateTime minDate;
  DateTime maxDate;

  DatePickerArgument({
    required this.mode,
    this.selectedDate,
    this.startDate,
    this.endDate,
    required this.minDate,
    required this.maxDate,
  });
}

class DatePickerPage extends StatefulWidget {
  final DatePickerArgument argument;

  const DatePickerPage({super.key, required this.argument});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  late DateRangePickerSelectionMode mode;
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  late DateTime minDate;
  late DateTime maxDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs selected) {
    switch (mode) {
      case DateRangePickerSelectionMode.single:
        selectedDate = selected.value;
        break;
      case DateRangePickerSelectionMode.range:
        PickerDateRange dateRange = selected.value;
        startDate = dateRange.startDate;
        endDate = dateRange.endDate;
        break;
      default:
    }
  }

  void _onCancel() => Navigator.of(context).pop();

  void _onSubmit(Object? value) {
    switch (mode) {
      case DateRangePickerSelectionMode.single:
        Navigator.of(context).pop(selectedDate?.toLocal());
        break;
      case DateRangePickerSelectionMode.range:
        endDate ??= startDate;
        Navigator.of(context).pop(startDate != null && endDate != null ? [startDate!.toLocal(), endDate!.toLocal()] : null);
        break;
      default:
        Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    mode = widget.argument.mode;
    selectedDate = widget.argument.selectedDate;
    startDate = widget.argument.startDate;
    endDate = widget.argument.endDate;
    minDate = widget.argument.minDate;
    maxDate = widget.argument.maxDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: Column(
        children: [
          CustomDialogTitle(
            title: mode == DateRangePickerSelectionMode.range ? "Pilih Batasan Tanggal" : "Pilih Tanggal",
            withCloseButton: false,
          ),
          Expanded(
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              showTodayButton: true,
              headerStyle: DateRangePickerHeaderStyle(
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ColorResources.primary),
                textAlign: TextAlign.center,
              ),
              headerHeight: Dimens.buttonHeight,
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: Theme.of(context).textTheme.headlineSmall),
              ),
              onSelectionChanged: _onSelectionChanged,
              selectionMode: mode,
              initialSelectedDate: selectedDate,
              initialSelectedRange: startDate != null && endDate != null ? PickerDateRange(startDate, endDate) : null,
              initialDisplayDate: selectedDate ?? startDate,
              minDate: minDate,
              maxDate: maxDate,
              showActionButtons: true,
              onCancel: _onCancel,
              selectionColor: ColorResources.primary,
              startRangeSelectionColor: ColorResources.primary,
              endRangeSelectionColor: ColorResources.primary,
              onSubmit: (value) => _onSubmit(value),
            ),
          ),
        ],
      ),
    );
  }
}
