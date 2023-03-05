import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: implementation_imports
import 'package:flutter_localizations/src/utils/date_localizations.dart'
    as util;
import 'package:intl/intl.dart' as intl;

import '../local_widgets_localizations.dart';
import 'cupertino_ku.dart';
import 'cupertino_ti.dart';

const kCustomizeSupportedLanguages = ['ku', 'ti'];

class SubCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const SubCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kCustomizeSupportedLanguages.contains(locale.languageCode);

  static final Map<Locale, Future<CupertinoLocalizations>> _loadedTranslations =
      <Locale, Future<CupertinoLocalizations>>{};

  GlobalCupertinoLocalizations? getCustomizeCupertinoTranslation(
    Locale locale,
    intl.DateFormat fullYearFormat,
    intl.DateFormat dayFormat,
    intl.DateFormat mediumDateFormat,
    intl.DateFormat singleDigitHourFormat,
    intl.DateFormat singleDigitMinuteFormat,
    intl.DateFormat doubleDigitMinuteFormat,
    intl.DateFormat singleDigitSecondFormat,
    intl.NumberFormat decimalFormat,
  ) {
    switch (locale.languageCode) {
      case 'ku':
        return CupertinoLocalizationKu(
            fullYearFormat: fullYearFormat,
            dayFormat: dayFormat,
            mediumDateFormat: mediumDateFormat,
            singleDigitHourFormat: singleDigitHourFormat,
            singleDigitMinuteFormat: singleDigitMinuteFormat,
            doubleDigitMinuteFormat: doubleDigitMinuteFormat,
            singleDigitSecondFormat: singleDigitSecondFormat,
            decimalFormat: decimalFormat);
      case 'ti':
        return CupertinoLocalizationTi(
            fullYearFormat: fullYearFormat,
            dayFormat: dayFormat,
            mediumDateFormat: mediumDateFormat,
            singleDigitHourFormat: singleDigitHourFormat,
            singleDigitMinuteFormat: singleDigitMinuteFormat,
            doubleDigitMinuteFormat: doubleDigitMinuteFormat,
            singleDigitSecondFormat: singleDigitSecondFormat,
            decimalFormat: decimalFormat);
    }
    assert(false,
        'getCustomizeCupertinoTranslation() called for unsupported locale "$locale"');
    return null;
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    assert(isSupported(locale));
    return _loadedTranslations.putIfAbsent(locale, () {
      util.loadDateIntlDataIfNotLoaded();

      final localeName = intl.Intl.canonicalizedLocale(locale.toString());
      assert(
        locale.toString() == localeName,
        'Flutter does not support the non-standard locale form $locale (which '
        'might be $localeName',
      );

      // Use the number formats for 'ar' instead for the RTL and 'en' for the LTR.
      var numberFormat =
          LocalWidgetsLocalizations.rtlLanguages.contains(localeName)
              ? 'ar'
              : 'en';

      late intl.DateFormat fullYearFormat;
      late intl.DateFormat dayFormat;
      late intl.DateFormat mediumDateFormat;
      // We don't want any additional decoration here. The am/pm is handled in
      // the date picker. We just want an hour number localized.
      late intl.DateFormat singleDigitHourFormat;
      late intl.DateFormat singleDigitMinuteFormat;
      late intl.DateFormat doubleDigitMinuteFormat;
      late intl.DateFormat singleDigitSecondFormat;
      late intl.NumberFormat decimalFormat;

      void loadFormats(String? locale) {
        fullYearFormat = intl.DateFormat.y(locale);
        dayFormat = intl.DateFormat.d(locale);
        mediumDateFormat = intl.DateFormat.MMMEd(locale);

        singleDigitHourFormat = intl.DateFormat('HH', locale);
        singleDigitMinuteFormat = intl.DateFormat.m(locale);
        doubleDigitMinuteFormat = intl.DateFormat('mm', locale);
        singleDigitSecondFormat = intl.DateFormat.s(locale);
        decimalFormat = intl.NumberFormat('#,##0.###', numberFormat);
      }

      if (intl.DateFormat.localeExists(localeName)) {
        loadFormats(localeName);
      } else if (intl.DateFormat.localeExists(locale.languageCode)) {
        loadFormats(locale.languageCode);
      } else {
        loadFormats(null);
      }

      return SynchronousFuture<CupertinoLocalizations>(
          getCustomizeCupertinoTranslation(
        locale,
        fullYearFormat,
        dayFormat,
        mediumDateFormat,
        singleDigitHourFormat,
        singleDigitMinuteFormat,
        doubleDigitMinuteFormat,
        singleDigitSecondFormat,
        decimalFormat,
      )!);
    });
  }

  @override
  bool shouldReload(SubCupertinoLocalizationsDelegate old) => false;

  @override
  String toString() =>
      'CustomizeCupertinoLocalizations.delegate(${kCupertinoSupportedLanguages.length} locales)';
}
