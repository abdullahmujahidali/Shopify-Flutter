import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'boxes.dart';

class SecureStorage {
  static late final FlutterSecureStorage? _secureStorage;

  static late final Map<String, dynamic> _storage;

  bool _isInitialized = false;

  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  SecureStorage._internal();

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    if (kDisableWebCookies) {
      _storage = {};
    } else {
      _secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          resetOnError: true,
        ),
      );
      try {
        _storage = await _secureStorage?.readAll() ?? {};
      } catch (e) {
        await _secureStorage?.deleteAll();
        _storage = {};
      }
    }

    _isInitialized = true;
  }

  String get(String key) {
    return _storage[key] ?? '';
  }

  void set(String key, String value) {
    _secureStorage?.write(key: key, value: value);
    _storage[key] = value;
  }
}
