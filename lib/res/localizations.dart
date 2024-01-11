import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Map<String, String> _localizedStrings = {};
  final Locale _locale;
  final bool test;

  AppLocalizations(this._locale, {this.test = false});

  static AppLocalizations of(BuildContext context) => Localizations.of(context, AppLocalizations);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static const LocalizationsDelegate<AppLocalizations> testDelegate = _AppLocalizationsDelegate(test: true);

  String get languageCode => _locale.languageCode;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/string/${_locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings.clear();
    _localizedStrings.addAll(jsonMap.map((key, value) => MapEntry(key, value.toString())));
    return true;
  }

  String translate(String key) => test ? key : _localizedStrings[key] ?? "";
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final bool test;

  const _AppLocalizationsDelegate({this.test = false});

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale, test: test);
    if (!test) await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
