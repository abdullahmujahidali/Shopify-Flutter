part of '../boxes.dart';

/// Enable encryption for user-related data.
class UserBox extends FluxBox with EncryptionMixin {
  static final _instance = UserBox._internal();

  factory UserBox() => _instance;

  UserBox._internal();

  @override
  String get boxKey => BoxKeys.hiveUserBox;

  @override
  String get encryptionKeyName => BoxKeys.hiveUserBoxEncryptionKey;
}

extension UserBoxExtension on UserBox {
  /// Call this upon logout to clear all user data.
  void cleanUpForLogout() {
    box.clear();
  }
}
