import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class ValidatorUtils {
  static const int intMaxValue = 9999999999999;

  static String? validateNotEmpty(BuildContext context, String? value) {
    return TextUtils.isEmpty(value) ? AppLocalizations.of(context).translate("invalid_input_required") : null;
  }

  static String? validateMinInputLength(
    BuildContext context,
    String? value,
    int minLength, {
    bool required = false,
  }) {
    return TextUtils.isEmpty(value) && required
        ? AppLocalizations.of(context).translate("invalid_input_required")
        : value!.length >= minLength
            ? null
            : "${AppLocalizations.of(context).translate("invalid_input_length")}: value < $minLength.";
  }

  static String? validateInputLength(
    BuildContext context,
    String? value,
    int minLength,
    int maxLength, {
    bool required = false,
  }) {
    return TextUtils.isEmpty(value) && required
        ? AppLocalizations.of(context).translate("invalid_input_required")
        : value!.length >= minLength && value.length <= maxLength
            ? null
            : "${AppLocalizations.of(context).translate("invalid_input_length")}: $minLength <= value <= $maxLength.";
  }

  static String? validateIntegerValue(BuildContext context, int value, int lowerBound, int upperBound) {
    return value >= lowerBound && value <= upperBound
        ? null
        : "${AppLocalizations.of(context).translate("invalid_value")}: $lowerBound <= value <= $upperBound.";
  }

  static String? validateNumericValue(BuildContext context, double value, double lowerBound, double upperBound) {
    return value >= lowerBound && value <= upperBound
        ? null
        : "${AppLocalizations.of(context).translate("invalid_value")}: $lowerBound <= value <= $upperBound.";
  }

  static String? validateIntegerValueNotEmpty(BuildContext context, int? value, int lowerBound, int upperBound) {
    return value == null
        ? AppLocalizations.of(context).translate("invalid_input_required")
        : value >= lowerBound && value <= upperBound
            ? null
            : "${AppLocalizations.of(context).translate("invalid_value")}: $lowerBound <= value <= $upperBound.";
  }

  static String? validateDecimalValue(BuildContext context, Decimal? value, Decimal lowerBound, Decimal upperBound) {
    return value == null || (value.compareTo(lowerBound) >= 0 && value.compareTo(upperBound) <= 0)
        ? null
        : "${AppLocalizations.of(context).translate("invalid_value")}: $lowerBound <= value <= $upperBound.";
  }

  static String? validateDecimalValueNotEmpty(BuildContext context, Decimal? value, Decimal lowerBound, Decimal upperBound,
      {bool inclusive = true}) {
    if (value == null) return AppLocalizations.of(context).translate("invalid_input_required");
    if (inclusive) {
      return value.compareTo(lowerBound) >= 0 && value.compareTo(upperBound) <= 0
          ? null
          : "${AppLocalizations.of(context).translate("invalid_value")}: $lowerBound <= value <= $upperBound.";
    } else {
      return value.compareTo(lowerBound) > 0 && value.compareTo(upperBound) < 0
          ? null
          : "${AppLocalizations.of(context).translate("invalid_value")}: $lowerBound < value < $upperBound.";
    }
  }

  static String? validateEmail(BuildContext context, String? value, {bool required = false}) {
    String pattern = r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";
    RegExp regExp = RegExp(pattern);

    String? result;
    if (required) {
      result = validateNotEmpty(context, value);
      if (result != null) return result;
    } else if (TextUtils.isEmpty(value)) {
      return null;
    }

    result = validateInputLength(context, value, 0, 256);
    if (result != null) return result;

    return regExp.hasMatch(value!) ? null : AppLocalizations.of(context).translate("invalid_email");
  }

  static String? validatePhone(BuildContext context, String? value, {bool required = false}) {
    String pattern = r"^[0-9]{8,12}$";
    RegExp regExp = RegExp(pattern);

    String? result;
    if (required) {
      result = validateNotEmpty(context, value);
      if (result != null) return result;
    } else if (TextUtils.isEmpty(value)) {
      return null;
    }

    result = validateInputLength(context, value, 0, 16);
    if (result != null) return result;

    return regExp.hasMatch(value!) ? null : AppLocalizations.of(context).translate("invalid_phone");
  }

  static String? validatePostalCode(BuildContext context, String value, {bool required = false}) {
    String pattern = r'^\d{5}(?:[-\s]\d{4})?$';
    RegExp regExp = RegExp(pattern);

    String? result;
    if (required) {
      result = validateNotEmpty(context, value);
      if (result != null) return result;
    } else if (TextUtils.isEmpty(value)) {
      return null;
    }

    result = validateInputLength(context, value, 0, 5);
    if (result != null) return result;

    return regExp.hasMatch(value) ? null : AppLocalizations.of(context).translate("invalid_postal_code");
  }

  static String? validateDate(BuildContext context, DateTime date) {
    return AppLocalizations.of(context).translate("invalid_date");
  }

  static String? validateMinimumDate(BuildContext context, DateTime date, DateTime minimum) {
    return minimum.compareTo(date) <= 0 ? null : AppLocalizations.of(context).translate("invalid_date");
  }

  static String? validateTime(BuildContext context, TimeOfDay time, TimeOfDay minimum) {
    return DateTimeUtils.compareTimeOfDay(time, minimum) >= 0 ? null : AppLocalizations.of(context).translate("invalid_time");
  }

  static String? validateUsername(BuildContext context, String? value) {
    String pattern = r'^(?=.{4,16}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
    RegExp regExp = RegExp(pattern);

    String? result = validateNotEmpty(context, value);
    if (result != null) return result;
    result = validateInputLength(context, value, 4, 16);
    if (result != null) return result;

    return regExp.hasMatch(value!) ? null : AppLocalizations.of(context).translate("invalid_username");
  }

  static String? validatePassword(BuildContext context, String? value) {
    String pattern = r'^(?=.*[^\da-zA-Z0-9])(?=.*\d).{6,32}$';
    RegExp regExp = RegExp(pattern);

    value = value?.replaceAll(" ", "");
    String? result = validateNotEmpty(context, value);
    if (result != null) return result;
    result = validateInputLength(context, value, 6, 32);
    if (result != null) return result;

    return regExp.hasMatch(value!) ? null : AppLocalizations.of(context).translate("invalid_password");
  }

  static String? validateRepeatPassword(BuildContext context, String? password1, String? password2) {
    if (TextUtils.isEmpty(password1) || TextUtils.isEmpty(password2)) {
      return AppLocalizations.of(context).translate("invalid_input_required");
    } else if (!TextUtils.equals(password1, password2)) {
      return AppLocalizations.of(context).translate("invalid_password_not_match");
    }
    return null;
  }

  static String? validatePositive(BuildContext context, String? value, {bool required = false}) {
    if (TextUtils.isEmpty(value) && !required) return null;

    Decimal? amount = Decimal.tryParse(value!);
    return amount == null || amount <= Decimal.zero ? "Harus lebih besar dari 0" : null;
  }

  static String? validateNonNegative(BuildContext context, String value, bool required) {
    if (TextUtils.isEmpty(value) && !required) return null;

    Decimal? amount = Decimal.tryParse(value);
    return amount == null || amount < Decimal.zero ? AppLocalizations.of(context).translate("invalid_negative") : null;
  }
}
