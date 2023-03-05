import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:inspireui/inspireui.dart';

import '../../../../models/entities/user.dart';
import '../../../../services/services.dart';
import '../../models/entities/firebase_error_exception.dart';

enum SMSModelState { loading, complete }

class SMSModel extends ChangeNotifier {
  var _state = SMSModelState.complete;

  SMSModelState get state => _state;
  String _verificationId = '';
  String _smsCode = '';
  String _phoneNumber = '';
  CountryCode _countryCode = CountryCode();

  /// Computed
  String get smsCode => _smsCode;

  String get phoneNumber => _phoneNumber;

  String get phoneNumberWithoutZero => _removeLeadingZeros(_phoneNumber);

  String get dialPhoneNumber => _countryCode.dialCode! + phoneNumberWithoutZero;

  String get dialPhoneNumberWithoutPlus => dialPhoneNumber.replaceAll('+', '');

  String get countryDialCode => _countryCode.dialCode ?? '';

  CountryCode get country => _countryCode;

  String get flagUri => _countryCode.flagUri ?? '';

  String get countryName => _countryCode.name ?? 'Unknown';

  bool get isValidPhoneNumber => _phoneNumber.isNotEmpty;

  String _removeLeadingZeros(String num) {
    for (var i = 0; i < num.length; i++) {
      if (num[i] != '0') {
        var res = num.substring(i);
        return res;
      }
    }
    return '0';
  }

  void updateCountryCode(CountryCode countryCode) {
    _countryCode = countryCode;
    notifyListeners();
  }

  /// Update state
  void _updateState(state) {
    _state = state;
    notifyListeners();
  }

  Future<void> sendOTP({
    VoidCallback? onPageChanged,
    Function(FirebaseErrorException)? onMessage,
    VoidCallback? onVerify,
  }) async {
    try {
      _updateState(SMSModelState.loading);
      await Services().firebase.verifyPhoneNumber(
            phoneNumber: dialPhoneNumber,
            verificationCompleted: (String? smsCode) {
              _smsCode = smsCode!;
              onVerify?.call();
            },
            verificationFailed: (FirebaseErrorException e) {
              onMessage?.call(e);
              _updateState(SMSModelState.complete);
            },
            codeSent: (String verificationId, int? resendToken) {
              _verificationId = verificationId;
              onPageChanged?.call();
              _updateState(SMSModelState.complete);

              ///Test with number +84764555949
              // Future.delayed(Duration(seconds: 3)).then((value) {
              //   _smsCode = '123456';
              //   onVerify();
              // });
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
    } catch (err) {
      printLog(err.toString());
      _updateState(SMSModelState.complete);
    }
  }

  Future<bool> smsVerify(Function showMessage) async {
    _updateState(SMSModelState.loading);
    try {
      final credential = Services().firebase.getFirebaseCredential(
          verificationId: _verificationId, smsCode: _smsCode);

      final user = await Services()
          .firebase
          .loginFirebaseCredential(credential: credential);
      if (user != null) {
        _phoneNumber = _phoneNumber.replaceAll('+', '').replaceAll(' ', '');
        return true;
      }
    } on FirebaseErrorException catch (err) {
      printLog(err.toString());
      showMessage(err);
    }
    _updateState(SMSModelState.complete);
    return false;
  }

  Future<bool> isPhoneNumberExisted() async {
    final result = await Services().api.isUserExisted(phone: dialPhoneNumber);
    if (!result) {
      _updateState(SMSModelState.complete);
    }
    return result;
  }

  Future<bool> isUserExisted(String username) async {
    _updateState(SMSModelState.loading);
    final result = await Services().api.isUserExisted(username: username);
    if (result) {
      _updateState(SMSModelState.complete);
    }
    return result;
  }

  Future<User?> login() async {
    try {
      final result =
          await Services().api.loginSMS(token: dialPhoneNumberWithoutPlus);
      if (result == null) {
        _updateState(SMSModelState.complete);
      }
      _smsCode = '';
      return result;
    } catch (e) {
      _updateState(SMSModelState.complete);
      rethrow;
    }
  }

  Future<User?> createUser(data) async {
    try {
      final user = await Services().api.createUser(
            phoneNumber: data['phoneNumber'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            username: data['username'],
            password: data['password'],
          );
      _updateState(SMSModelState.complete);
      return user;
    } catch (e) {
      _updateState(SMSModelState.complete);
      rethrow;
    }
  }

  void updatePhoneNumber(val) {
    _phoneNumber = val;
    notifyListeners();
  }

  void updateSMSCode(val) {
    _smsCode = val;
    notifyListeners();
  }
}
