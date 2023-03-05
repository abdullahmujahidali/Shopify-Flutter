import 'package:flutter/material.dart';

import '../services/index.dart';
import 'cart/cart_base.dart';
import 'entities/address.dart';
import 'entities/credit_card.dart';
import 'payment_settings_model.dart';

export 'entities/credit_card.dart';

class CreditCardModel extends ChangeNotifier {
  final Services _service = Services();
  CreditCard? creditCard;
  bool isLoading = true;
  String? message;

  void setCreditCard(
      String cardNumber, String cardHolderName, String expiryDate, String cvv) {
    creditCard!.setCreditCard(cardNumber, cardHolderName, expiryDate, cvv);
  }

  // ignore: missing_return
  Future<String> checkoutWithCreditCard(String? vaultId, CartModel cartModel,
      Address address, PaymentSettingsModel paymentSettingsModel) async {
    try {
      var result = await _service.api.checkoutWithCreditCard(
          vaultId, cartModel, address, paymentSettingsModel);

      isLoading = false;
      message = null;
      notifyListeners();

      return result;
    } catch (err) {
      isLoading = false;
      message =
          'There is an issue with the app during request the data, please contact admin for fixing the issues $err';
      notifyListeners();
      return '';
    }
  }

  CreditCard? getCreditCard() {
    return creditCard;
  }
}
