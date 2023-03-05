import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/utils.dart';

import '../../common/constants.dart';
import '../../services/index.dart' show Services, injector;
import '../../services/wallet/wallet_services.dart';
import '../index.dart' show User, Product;
import 'wallet_transaction_model.dart';

class WalletModel with ChangeNotifier {
  final User user;
  final WalletTransactionModel _walletTransactionModel;

  final _walletServices = injector<WalletServices>();

  var _balance = 0.0;
  var _isLoading = false;
  String? _errMessage;

  bool get isLoading => _isLoading;

  String? get errMessage => _errMessage;

  WalletModel({
    required this.user,
  }) : _walletTransactionModel = WalletTransactionModel(
            Services().getWalletTransaction(user.cookie ?? '')) {
    printLog('Wallet token ne ${user.cookie}');
  }

  String get token => user.cookie ?? '';

  double get balance => _balance;

  WalletTransactionModel get walletTransactionModel => _walletTransactionModel;

  Future<void> refreshWallet() => Future.wait([
        getBalance(),
        refreshListTransaction(),
      ]);

  Future<void> getBalance() async {
    _balance = await _walletServices.getBalance(token: token);
    notifyListeners();
  }

  Future<void> getListTransaction() => _walletTransactionModel.getData();

  Future<void> refreshListTransaction() => _walletTransactionModel.refresh();

  Future<Product?> topUp(int price) async {
    try {
      _isLoading = true;
      _errMessage = null;
      notifyListeners();

      final product = await _walletServices.checkRecharge(amount: price);

      _isLoading = false;
      notifyListeners();

      if (product != null) {
        return product;
      }
      return null;
    } catch (e) {
      _isLoading = false;
      _errMessage = e.toString();
      notifyListeners();

      printLog(e);
      return null;
    }
  }

  Future<void> partialPayment(String orderId, String token) async {
    try {
      await _walletServices.partialPayment(
        orderId: orderId,
        token: token,
      );
      await getBalance();
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> processPayment(String orderId, String token) async {
    try {
      await _walletServices.processPayment(
        orderId: orderId,
        token: token,
      );
      await getBalance();
    } catch (e) {
      printLog(e);
    }
  }
}
