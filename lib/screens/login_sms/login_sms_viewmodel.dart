import 'dart:async';

import 'package:flutter/material.dart';

import '../../modules/firebase/firebase_service.dart';

class LoginSmsViewModel extends ChangeNotifier {
  final FirebaseServices _firebaseServices;
  late final StreamController? _verifySuccessStream;

  String? _code;
  String? _dialCode;
  String? _name;
  String? _phone;
  var _isLoading = false;
  String? _flagUri;

  LoginSmsViewModel(this._firebaseServices)
      : _verifySuccessStream = _firebaseServices.getFirebaseStream();

  bool get isLoading => _isLoading;
  String? get countryCode => _code;
  String? get countryName => _name;
  String? get countryDialCode => _dialCode;
  String get phoneFullText => '${_dialCode ?? ''}${_phone ?? ''}';
  String get phoneNumber => _phone ?? '';
  String get flagUri => _flagUri ?? '';
  Stream? get getStreamSuccess => _verifySuccessStream?.stream;

  bool get isValidPhoneNumber => _phone?.isNotEmpty ?? false;

  void loadConfig({
    String? code,
    String? dialCode,
    String? name,
    String? flagUri,
  }) {
    _code = (code?.isEmpty ?? true) ? null : code;
    _dialCode = (dialCode?.isEmpty ?? true) ? null : dialCode;
    _name = (name?.isEmpty ?? true) ? null : name;
    _flagUri = (flagUri?.isEmpty ?? true) ? null : flagUri;
    // notifyListeners();
  }

  void updateCountryCode({
    String? code,
    String? dialCode,
    String? name,
    String? flagUri,
  }) {
    loadConfig(code: code, dialCode: dialCode, name: name, flagUri: flagUri);
    notifyListeners();
  }

  void enableLoading([bool isEnable = true]) {
    _isLoading = isEnable;
    notifyListeners();
  }

  Future<void> verify({
    required Future Function(String verId, [int? forceCodeResend]) smsCodeSent,
    required Future Function(String verId) autoRetrieve,
    required Future<bool> Function() startVerify,
    required Function(dynamic exception) verifyFailed,
  }) async {
    if (_isLoading) {
      return;
    }

    try {
      final isChecked = await startVerify();
      if (isChecked) {
        unawaited(_firebaseServices.verifyPhoneNumber(
          phoneNumber: phoneFullText,
          codeAutoRetrievalTimeout: autoRetrieve,
          verificationCompleted: (value) => _verifySuccessStream?.add(value),
          verificationFailed: verifyFailed,
          codeSent: smsCodeSent,
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

  void updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }
}
