import 'package:flutter/cupertino.dart';

import '../../../models/entities/payment_method.dart';
import '../repositories/tera_wallet_transaction_repository.dart';
import '../route.dart';
import '../views/partial_payment.dart';
import '../views/widgets/payment_method_item.dart';

mixin WalletServiceMixin {
  Widget renderWalletPayPartialPayment() {
    return const PayPartialPayment();
  }

  Widget renderCheckoutWalletInfo() {
    return const CheckoutWalletInfo();
  }

  Widget renderWalletPaymentMethodItem(PaymentMethod paymentMethod,
      Function(String? p1) onSelected, String? selectedId) {
    return PaymentMethodItem(
        paymentMethod: paymentMethod,
        onSelected: onSelected,
        selectedId: selectedId);
  }

  dynamic getWalletRoutesWithSettings(RouteSettings settings) {
    return TeraWalletRoute.getRoutesWithSettings(settings);
  }

  dynamic getWalletTransaction(String cookie) {
    return TeraWalletTransactionRepository(cookie);
  }
}
