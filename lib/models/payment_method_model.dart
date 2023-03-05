import 'package:flutter/material.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../models/cart/cart_model.dart';
import '../services/index.dart';
import 'entities/payment_method.dart';
import 'entities/shipping_method.dart';

const kStripeApplePayMethod = 'stripe_v2_apple_pay';
const kStripeGooglePayMethod = 'stripe_v2_google_pay';

class PaymentMethodModel extends ChangeNotifier {
  final Services _service = Services();
  List<PaymentMethod> paymentMethods = [];

  bool isLoading = true;
  String? message;

  Future<void> getPaymentMethods(
      {CartModel? cartModel,
      ShippingMethod? shippingMethod,
      String? token,
      required String? langCode}) async {
    try {
      isLoading = paymentMethods.isEmpty ? true : false;
      message = null;
      notifyListeners();
      paymentMethods = await _service.api.getPaymentMethods(
          cartModel: cartModel,
          shippingMethod: shippingMethod,
          token: token,
          langCode: langCode)!;

      paymentMethods.removeWhere((element) =>
          kPaymentConfig.excludedPaymentIds?.contains(element.id) ?? false);

      final shouldShowApplePay = isIos &&
          kStripeConfig['enabled'] == true &&
          kStripeConfig['useV1'] != true &&
          kStripeConfig['enableApplePay'] == true &&
          ServerConfig().isPayPluginSupported;
      if (shouldShowApplePay) {
        paymentMethods.add(PaymentMethod(
          id: kStripeApplePayMethod,
          title: 'Apple Pay',
          enabled: true,
        ));
      }

      final shouldShowGooglePay = isAndroid &&
          kStripeConfig['enabled'] == true &&
          kStripeConfig['useV1'] != true &&
          kStripeConfig['enableGooglePay'] == true &&
          ServerConfig().isPayPluginSupported;
      if (shouldShowGooglePay) {
        paymentMethods.add(
          PaymentMethod(
            id: kStripeGooglePayMethod,
            title: 'Google Pay',
            enabled: true,
          ),
        );
      }

      isLoading = false;
      message = null;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      message =
          'There is an issue with the app during request the data, please contact admin for fixing the issues $err';
      notifyListeners();
    }
  }
}
