part of '../config.dart';

/// Supported language
/// Download from https://github.com/hjnilsson/country-flags/tree/master/png100px
/// https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html
List<Map> getLanguages() {
  return List<Map>.from(Configurations.languagesInfo);
}

/// For Vendor Admin
List<String> unsupportedLanguages = ['ku', 'ti'];
