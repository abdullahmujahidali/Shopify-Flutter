import 'package:flutter/material.dart';

import '../../services/index.dart';
import '../../services/wallet/wallet_services.dart';
import '../entities/transfer_form.dart';
import '../index.dart';
import 'wallet_model.dart';

class WalletTransferModel with ChangeNotifier {
  WalletTransferModel({required WalletModel walletModel})
      : _walletModel = walletModel;

  final WalletModel _walletModel;
  final _walletServices = injector<WalletServices>();

  var _isLoading = false;

  bool? _isValidAmount;

  var _isValidEmail = false;

  String get _token => _walletModel.token;

  bool get isLoading => _isLoading;

  bool? get isValidAmount => _isValidAmount;

  bool get isValidEmail => _isValidEmail;

  double get currentBalance => _walletModel.balance;

  void markEmailNotValid() {
    if (!_isValidEmail) return;

    _isValidEmail = false;
    notifyListeners();
  }

  void markAmountNotValid() {
    _isValidAmount = null;
    notifyListeners();
  }

  Future<void> refreshWallet() => _walletModel.refreshWallet();

  Future<User> checkValidEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user =
          await _walletServices.checkEmailTransfer(email: email, token: _token);
      _isLoading = false;
      _isValidEmail = true;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _isValidEmail = false;
      notifyListeners();
      rethrow;
    }
  }

  void checkValidAmount(int amount) {
    _isValidAmount = amount <= _walletModel.balance;
    notifyListeners();
  }

  Future<bool> transfer({
    required String email,
    required int amount,
    String? note,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _walletServices.transfer(
        token: _token,
        transferForm: TransferForm(
          amount: amount,
          email: email,
          note: note,
        ),
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
