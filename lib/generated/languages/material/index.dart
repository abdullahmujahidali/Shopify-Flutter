import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: implementation_imports
import 'package:flutter_localizations/src/utils/date_localizations.dart'
    as util;
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart' as intl;

import '../local_widgets_localizations.dart';
import 'datetime/index.dart';
import 'material_ku.dart';
import 'material_ti.dart';

// Add code for other language here
const kCustomizeSupportedLanguages = ['ku', 'ti'];

class SubMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const SubMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kCustomizeSupportedLanguages.contains(locale.languageCode);

  static final Map<Locale, Future<MaterialLocalizations>> _loadedTranslations =
      <Locale, Future<MaterialLocalizations>>{};

  GlobalMaterialLocalizations? getCustomizeTranslation(
    Locale locale,
    intl.DateFormat fullYearFormat,
    intl.DateFormat compactDateFormat,
    intl.DateFormat shortDateFormat,
    intl.DateFormat mediumDateFormat,
    intl.DateFormat longDateFormat,
    intl.DateFormat yearMonthFormat,
    intl.DateFormat shortMonthDayFormat,
    intl.NumberFormat decimalFormat,
    intl.NumberFormat twoDigitZeroPaddedFormat,
  ) {
    // Add translations for other language here
    switch (locale.languageCode) {
      case 'ku':
        return MaterialLocalizationKu(
            fullYearFormat: fullYearFormat,
            compactDateFormat: compactDateFormat,
            shortDateFormat: shortDateFormat,
            mediumDateFormat: mediumDateFormat,
            longDateFormat: longDateFormat,
            yearMonthFormat: yearMonthFormat,
            shortMonthDayFormat: shortMonthDayFormat,
            decimalFormat: decimalFormat,
            twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat);
      case 'ti':
        return MaterialLocalizationTi(
            fullYearFormat: fullYearFormat,
            compactDateFormat: compactDateFormat,
            shortDateFormat: shortDateFormat,
            mediumDateFormat: mediumDateFormat,
            longDateFormat: longDateFormat,
            yearMonthFormat: yearMonthFormat,
            shortMonthDayFormat: shortMonthDayFormat,
            decimalFormat: decimalFormat,
            twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat);
    }
    assert(false,
        'getCustomizeTranslation() called for unsupported locale "$locale"');
    return null;
  }

  // Add date patterns for other language here
  dynamic datePatterns(Locale locale) {
    switch (locale.languageCode) {
      case 'ku':
        return kuLocaleDatePatterns;
      case 'ti':
        return tiLocaleDatePatterns;
      default:
    }
  }

  // Add date symbols for other language here
  dynamic dateSymbols(Locale locale) {
    switch (locale.languageCode) {
      case 'ku':
        return kuDateSymbols;
      case 'ti':
        return tiDateSymbols;
      default:
    }
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    assert(isSupported(locale));
    return _loadedTranslations.putIfAbsent(locale, () {
      util.loadDateIntlDataIfNotLoaded();

      final localeName = intl.Intl.canonicalizedLocale(locale.toString());
      assert(
        locale.toString() == localeName,
        'Flutter does not support the non-standard locale form $locale (which '
        'might be $localeName',
      );

      final symbols = DateSymbols.deserializeFromMap(dateSymbols(locale));

      initializeDateFormattingCustom(
        locale: localeName,
        patterns: datePatterns(locale),
        symbols: symbols,
      );

      // Use the number formats instead 'en' for the LTR and 'ar' for the RTL.
      var numberFormat =
          LocalWidgetsLocalizations.rtlLanguages.contains(localeName)
              ? 'ar'
              : 'en';

      var fullYearFormat = intl.DateFormat('y', localeName);
      var compactDateFormat = intl.DateFormat('yMd', localeName);
      var shortDateFormat = intl.DateFormat('yMMMd', localeName);
      var mediumDateFormat = intl.DateFormat('EEE, MMM d', localeName);
      var longDateFormat = intl.DateFormat('EEEE, MMMM d, y', localeName);
      var yearMonthFormat = intl.DateFormat('MMMM y', localeName);
      var shortMonthDayFormat = intl.DateFormat('MM/DD', localeName);
      var decimalFormat = intl.NumberFormat('#,##0.###', numberFormat);
      var twoDigitZeroPaddedFormat = intl.NumberFormat('00', numberFormat);

      return SynchronousFuture<MaterialLocalizations>(getCustomizeTranslation(
        locale,
        fullYearFormat,
        compactDateFormat,
        shortDateFormat,
        mediumDateFormat,
        longDateFormat,
        yearMonthFormat,
        shortMonthDayFormat,
        decimalFormat,
        twoDigitZeroPaddedFormat,
      )!);
    });
  }

  @override
  bool shouldReload(SubMaterialLocalizationsDelegate old) => false;

  @override
  String toString() =>
      'GlobalCusomizeLocalizations.delegate(${kCustomizeSupportedLanguages.length} locales)';
}
