import 'dart:math';

import 'package:flutter/material.dart';

class TextUtils {
  static bool isEmpty(String? string) => string == null || string.isEmpty;

  static bool equals(String? string1, String? string2) {
    if (string1 == null && string2 == null) {
      return true;
    } else if ((string1 != null && string2 == null) || (string1 == null && string2 != null)) {
      return false;
    }
    return string1 == null || string1 == string2;
  }

  static void replaceDecimalComa(TextEditingController controller) {
    if (controller.text.isNotEmpty && controller.text.contains(",")) {
      controller.text = controller.text.replaceAll(",", ".");
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    }
  }

  static String getInitials(String name, int numWords) {
    if (TextUtils.isEmpty(name) || numWords <= 0) return "";
    List<String> words = name.split(RegExp(r"\s+"));
    StringBuffer stringBuffer = StringBuffer();
    int maxLength = min(words.length, numWords);
    for (int i = 0; i < maxLength; i++) {
      String word = words[i].replaceAll(RegExp(r"\[\(\)\]"), "");
      if (!TextUtils.isEmpty(word)) {
        if (i != 0) stringBuffer.write(" ");
        stringBuffer.write(word[0].toUpperCase());
      }
    }
    return stringBuffer.toString();
  }

  static String ellipsize(String string, int maxLength) {
    if (TextUtils.isEmpty(string)) return "";
    if (string.length <= maxLength) return string;
    StringBuffer buffer = StringBuffer(string.substring(0, maxLength - 3));
    buffer.write("...");
    return buffer.toString();
  }

  static String generateURL(String string) {
    if (TextUtils.isEmpty(string)) return "";
    if (!string.startsWith('https://')) string = 'https://$string';
    return string;
  }

  static String generateShortNumber(double number) {
    bool positive = number >= 0.0;
    StringBuffer stringBuffer = StringBuffer(positive ? '' : '-');
    number = number.abs();
    if (number < 1 && number != 0) {
      stringBuffer.write(number.toStringAsFixed(1));
    } else if (number < 1000) {
      if (number - number.toInt() != 0) {
        stringBuffer.write(number.toStringAsFixed(1));
      } else {
        stringBuffer.write(number.toInt());
      }
    } else if (number < 1000000) {
      if (number % 1000 == 0) {
        stringBuffer.write(number ~/ 1000);
      } else {
        stringBuffer.write((number / 1000).toStringAsFixed(1));
      }
      stringBuffer.write('K');
    } else if (number < 1000000000) {
      if (number % 1000000 == 0) {
        stringBuffer.write(number ~/ 1000000);
      } else {
        stringBuffer.write((number / 1000000).toStringAsFixed(1));
      }
      stringBuffer.write('M');
    } else if (number < 1000000000000) {
      if (number % 1000000000 == 0) {
        stringBuffer.write(number ~/ 1000000000);
      } else {
        stringBuffer.write((number / 1000000000).toStringAsFixed(1));
      }
      stringBuffer.write('B');
    } else {
      if (number % 1000000000000 == 0) {
        stringBuffer.write(number ~/ 1000000000000);
      } else {
        stringBuffer.write((number / 1000000000000).toStringAsFixed(1));
      }
      stringBuffer.write('T');
    }
    return stringBuffer.toString();
  }

  static bool isNumeric(String? s) => s == null ? false : double.tryParse(s) != null;

  static String initials({required String name, int numWords = 3}) {
    if (TextUtils.isEmpty(name) || numWords <= 0) return "";
    List<String> words = name.split("\\s+");
    StringBuffer stringBuffer = StringBuffer();
    int maxLength = min(words.length, numWords);
    for (int i = 0; i < maxLength; i++) {
      String word = words[i].replaceAll("\\[", "").replaceAll("]", "").replaceAll("\\(", "").replaceAll("\\)", "");
      if (!TextUtils.isEmpty(word)) {
        if (i != 0) {
          stringBuffer.write(" ");
        }
        stringBuffer.write(word[0].toUpperCase());
      }
    }
    return stringBuffer.toString();
  }
}
