import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LocalWidgetsLocalizations implements WidgetsLocalizations {
  /// Construct an object that defines the localized values for the widgets
  /// library for the given `locale`.
  ///
  /// [LocalizationsDelegate] implementations typically call the static [load]
  /// function, rather than constructing this class directly.
  LocalWidgetsLocalizations(this.locale) {
    final language = locale.languageCode.toLowerCase();
    _textDirection = rtlLanguages.contains(language)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // See http://en.wikipedia.org/wiki/Right-to-left
  static const List<String> rtlLanguages = <String>[
    'ar', // Arabic
    'fa', // Farsi
    'he', // Hebrew
    'ps', // Pashto
    'ur', // Urdu
    'ku', // Kurdish
  ];

  static bool isRtlLanguage(language) => rtlLanguages.contains(language);

  /// The locale for which the values of this class's localized resources
  /// have been translated.
  final Locale locale;

  @override
  TextDirection get textDirection => _textDirection;
  late TextDirection _textDirection;

  /// Creates an object that provides localized resource values for the
  /// lowest levels of the Flutter framework.
  ///
  /// This method is typically used to create a [LocalizationsDelegate].
  /// The [WidgetsApp] does so by default.
  static Future<WidgetsLocalizations> load(Locale locale) {
    return SynchronousFuture<WidgetsLocalizations>(
        LocalWidgetsLocalizations(locale));
  }

  /// A [LocalizationsDelegate] that uses [LocalWidgetsLocalizations.load]
  /// to create an instance of this class.
  ///
  /// [WidgetsApp] automatically adds this value to [WidgetsApp.localizationsDelegates].
  static const LocalizationsDelegate<WidgetsLocalizations> delegate =
      WidgetsLocalizationsDelegate();
}

class WidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const WidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      LocalWidgetsLocalizations.load(locale);

  @override
  bool shouldReload(WidgetsLocalizationsDelegate old) => false;

  @override
  String toString() => 'LocalWidgetsLocalizations.delegate(all locales)';
}
