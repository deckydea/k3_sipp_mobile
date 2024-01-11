import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k3_sipp_mobile/model/other/day_of_week.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class DateTimeUtils {
  static const String dateFormat = "dd MMM yyyy";
  static const String month = "MONTH";
  static const String year = "YEAR";

  static final DateTime firstDate = DateTime(2019, 1, 1);

  static DateTime parseDate({required String string, String format = dateFormat}) {
    return DateFormat(format).parse(string);
  }

  static String format(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss, ' ', z]);
  }

  static String formatToDayDateTime(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [DD, ' ', d, ' ', M, ' ', yyyy, ' ', HH, ':', nn]);
  }

  static String formatToDateTime(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [d, ' ', M, ' ', yyyy, ' ', HH, ':', nn]);
  }

  static String formatToMonth(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [M, ' ', yyyy]);
  }

  static String formatToDate(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [d, ' ', M, ' ', yyyy]);
  }

  static String formatToISODate(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [yyyy, '-', mm, '-', dd]);
  }

  static String formatToISOTime(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [HH, ':', nn, ':', ss]);
  }

  static String formatToDayDate(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [DD, ' ', d, ' ', M, ' ', yyyy]);
  }

  static String formatToTime(DateTime dateTime) {
    return formatDate(dateTime.toLocal(), [HH, ':', nn]);
  }

  static String formatDuration(Duration duration, AppLocalizations localizations) {
    int minutes = duration.inMinutes;
    int daySpan = minutes ~/ 1440;
    int hourSpan = (minutes - (daySpan * 1440)) ~/ 60;
    int minuteSpan = minutes - (daySpan * 1440) - (hourSpan * 60);
    String dayString = daySpan > 1
        ? "$daySpan ${localizations.translate("common_days")} "
        : daySpan == 1
            ? "$daySpan ${localizations.translate("common_day")} "
            : "";
    String hourString = hourSpan > 1
        ? "$hourSpan ${localizations.translate("common_hours")} "
        : hourSpan == 1
            ? "$hourSpan ${localizations.translate("common_hour")} "
            : "";
    String minuteString = minuteSpan > 1
        ? "$minuteSpan ${localizations.translate("common_minutes")}"
        : "$minuteSpan ${localizations.translate("common_minute")}";
    return "$dayString$hourString$minuteString";
  }

  static DateTime? parseISODate(String isoDate) {
    if (TextUtils.isEmpty(isoDate)) return null;

    List<String> segments = isoDate.split("-");
    if (segments.isEmpty) return null;
    int year = 0;
    int month = 0;
    int date = 0;
    for (int i = 0; i < segments.length; i++) {
      int? temp = int.tryParse(segments[i]);
      if (temp != null) {
        if (i == 0) year = temp;
        if (i == 1) month = temp;
        if (i == 2) date = temp;
      }
    }
    return DateTime(year, month, date);
  }

  static DateTime? parseISOTime(String isoTime) {
    if (TextUtils.isEmpty(isoTime)) return null;

    List<String> segments = isoTime.split(":");
    if (segments.isEmpty) return null;
    int hour = 0;
    int minute = 0;
    int second = 0;
    for (int i = 0; i < segments.length; i++) {
      int? temp = int.tryParse(segments[i]);
      if (temp != null) {
        if (i == 0) hour = temp;
        if (i == 1) minute = temp;
        if (i == 2) second = temp;
      }
    }
    return DateTime(firstDate.year, firstDate.month, firstDate.day, hour, minute, second);
  }

  static DateTime trimToDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DayOfWeek getDayOfWeek(DateTime dateTime) {
    return DayOfWeek.values.elementAt(dateTime.weekday - 1);
  }

  static bool isSameDate(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month && dateTime1.day == dateTime2.day;
  }

  static TimeOfDay stringToTimeOfDay(String timeString) {
    int hour;
    int minute;
    String ampm = timeString.substring(timeString.length - 2);
    String result = timeString.substring(0, timeString.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    int hourComparison = time1.hour.compareTo(time2.hour);
    return hourComparison == 0 ? time1.minute.compareTo(time2.minute) : hourComparison;
  }

  static bool isWithinDateInterval(DateTime dateTime, DateTime startDate, DateTime endDate) {
    startDate = trimToDay(startDate);
    endDate = trimToDay(endDate.add(const Duration(days: 1)));
    return !dateTime.toLocal().isBefore(startDate) && !dateTime.toLocal().isAfter(endDate);
  }

  static bool isWithinTimeInterval(DateTime dateTime, DateTime startTime, DateTime endTime) {
    DateTime today = DateTime.now();
    startTime = DateTime(today.year, today.month, today.day, startTime.hour, startTime.minute, startTime.second,
        startTime.millisecond, startTime.microsecond);
    endTime = DateTime(today.year, today.month, today.day, endTime.hour, endTime.minute, endTime.second, endTime.millisecond,
        endTime.microsecond);
    return !dateTime.toLocal().isBefore(startTime) && !dateTime.toLocal().isAfter(endTime);
  }

  static bool isNowWithinDateInterval(DateTime start, DateTime end) {
    DateTime today = DateTime.now();
    start = trimToDay(start);
    end = trimToDay(end.add(const Duration(days: 1)));
    return today.isAfter(start) && today.isBefore(end);
  }

  static bool isNowWithinHourInterval(DateTime start, DateTime end) {
    DateTime today = DateTime.now();
    start = DateTime(
        today.year, today.month, today.day, start.hour, start.minute, start.second, start.millisecond, start.microsecond);
    end = DateTime(today.year, today.month, today.day, end.hour, end.minute, end.second, end.millisecond, end.microsecond);
    return today.isAfter(start) && today.isBefore(end);
  }

  static String printDifferencesShort(BuildContext context, Duration duration) {
    StringBuffer stringBuffer = StringBuffer();
    int hourDifferences = duration.inHours;
    if (hourDifferences > 0) {
      if (stringBuffer.length != 0) stringBuffer.write(" ");
      stringBuffer.write("$hourDifferences h");
    }

    int minuteDifferences = duration.inMinutes - (hourDifferences * 60);
    if (stringBuffer.length != 0) stringBuffer.write(" ");
    stringBuffer.write("$minuteDifferences m");

    if (hourDifferences <= 0) {
      int secondDifferences = duration.inSeconds - (hourDifferences * 60 * 60) - (minuteDifferences * 60);
      if (stringBuffer.length != 0) stringBuffer.write(" ");
      stringBuffer.write("$secondDifferences s");
    }

    return stringBuffer.toString();
  }

  static String intToHour(int hour) => hour ~/ 10 > 0 ? "${hour.toString()}:00" : "0$hour:00";

  static int getMinuteDifference({required TimeOfDay time1, required TimeOfDay time2}) {
    return (time1.hour * 60 + time1.minute) - (time2.hour * 60 + time2.minute);
  }

  static String durationMinutesToString(BuildContext context, int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    String durationStr = "";
    int? hour = int.tryParse(parts[0]);
    int? minute = int.tryParse(parts[1]);
    if (hour != null && hour > 0) durationStr += "$hour ${AppLocalizations.of(context).translate("common_hours")}";
    if (minute != null && minute > 0)  {
      if (TextUtils.isEmpty(durationStr)) {
        durationStr += " ";
      }
      durationStr += " $minute ${AppLocalizations.of(context).translate("common_minutes")}";

    }
    return durationStr;
  }

  static String durationMinutesToStringShort(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    String durationStr = "";
    int? hour = int.tryParse(parts[0]);
    int? minute = int.tryParse(parts[1]);
    if (hour != null && hour > 0) durationStr += "$hour h";
    if (minute != null && minute >= 0)  {
      if (TextUtils.isEmpty(durationStr)) {
        durationStr += " ";
      }
      durationStr += " $minute min";

    }
    return durationStr;
  }
}
