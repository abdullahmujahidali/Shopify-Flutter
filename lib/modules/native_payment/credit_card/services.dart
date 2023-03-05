import 'dart:async';

import 'package:provider/provider.dart';

import '../../../models/index.dart'
    show Address, CartModel, CreditCard, CreditCardModel, PaymentSettingsModel;

class CreditCardServices {
  CreditCard? creditCard;

  Future<String> executePayment(context, String cardNumber,
      String cardHolderName, String expiryDate, String cvv) async {
    try {
      final paymentSettingsModel =
          Provider.of<PaymentSettingsModel>(context, listen: false);
      final creditCardModel =
          Provider.of<CreditCardModel>(context, listen: false);
      final cartModel = Provider.of<CartModel>(context, listen: false);
      final address = Provider.of<Address>(context, listen: false);

      // set credit card to model
      creditCardModel.setCreditCard(
          cardNumber, cardHolderName, expiryDate, cvv);

      // get payment settings
      await paymentSettingsModel.getPaymentSettings();

      // apply credit card from vaultId
      var vaultId = await paymentSettingsModel.getVaultId(
          paymentSettingsModel, creditCardModel);

      var result = await creditCardModel.checkoutWithCreditCard(
          vaultId, cartModel, address, paymentSettingsModel);

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
