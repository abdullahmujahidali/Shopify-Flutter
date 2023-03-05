part of '../boxes.dart';

class SettingsBox extends FluxBox {
  static final _instance = SettingsBox._internal();

  factory SettingsBox() => _instance;

  SettingsBox._internal();

  @override
  String get boxKey => BoxKeys.hiveSettingsBox;
}
