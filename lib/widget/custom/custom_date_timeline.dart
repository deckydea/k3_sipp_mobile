
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';

class CustomDateTimeLine extends StatelessWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateChange;

  const CustomDateTimeLine({super.key, required this.onDateChange, this.initialDate});

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: initialDate ?? DateTime.now(),
      onDateChange: onDateChange,
      activeColor: ColorResources.primary,
      headerProps:
      const EasyHeaderProps(monthPickerType: MonthPickerType.switcher, dateFormatter: DateFormatter.fullDateDMonthAsStrY()),
      dayProps: const EasyDayProps(
        activeDayStyle: DayStyle(borderRadius: Dimens.cardRadiusXLarge),
        inactiveDayStyle: DayStyle(borderRadius: Dimens.cardRadiusXLarge),
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayStyle: DayStyle(borderRadius: Dimens.cardRadiusXLarge),
      ),
      timeLineProps: const EasyTimeLineProps(
        hPadding: Dimens.paddingPage, // padding from left and right
        separatorPadding: Dimens.paddingPage, // padding between days
      ),
      locale: "id",
    );
  }
}
