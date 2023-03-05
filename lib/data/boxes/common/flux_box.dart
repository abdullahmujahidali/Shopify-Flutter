part of '../../boxes.dart';

abstract class FluxBox {
  String get boxKey;

  bool get isEncrypted => false;

  String get encryptionKeyName => BoxKeys.hiveBoxDefaultEncryptionKey;

  bool _isInitialized = false;

  Box? _box;

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    /// Enable [kDisableWebCookies] for Shopify Builder.
    if (kDisableWebCookies) {
      _box = WebBox();
      _isInitialized = true;
      return;
    }

    if (isEncrypted) {
      var key = SecureStorage().get(encryptionKeyName);
      if (key.isEmpty) {
        final hiveGeneratedKey = base64UrlEncode(Hive.generateSecureKey());
        SecureStorage().set(encryptionKeyName, hiveGeneratedKey);
        key = hiveGeneratedKey;
      }
      final encryptionKey = base64Url.decode(key);
      try {
        _box = await Hive.openBox(
          boxKey,
          encryptionCipher: HiveAesCipher(encryptionKey),
        );
      } catch (_) {
        printLog('[FluxBox] Failed to open encrypted box $boxKey. Deleting...');
        await Hive.deleteBoxFromDisk(boxKey);
        _box = await Hive.openBox(
          boxKey,
          encryptionCipher: HiveAesCipher(encryptionKey),
        );
      }
    } else {
      _box = await Hive.openBox(boxKey);
    }

    _isInitialized = true;
  }

  Box get box {
    final result = _box;
    if (result == null) {
      throw Exception('[FluxBox] $boxKey is not initialized');
    }
    return result;
  }
}
