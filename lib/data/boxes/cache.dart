part of '../boxes.dart';

class CacheBox extends FluxBox with PeriodicallyCleanMixin {
  static final _instance = CacheBox._internal();

  factory CacheBox() => _instance;

  CacheBox._internal();

  @override
  String get boxKey => BoxKeys.hiveCacheBox;

  @override
  Duration get cleanInterval => const Duration(days: 1);
}
