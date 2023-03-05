import '../checkout_shopify.dart';
import 'cart_mixin.dart';

mixin ShopifyMixin on CartMixin {
  CheckoutCart? checkout;

  Map<dynamic, dynamic> get checkoutCreatedInCart => {};

  double? getTax() {
    return checkout?.totalTax;
  }

  void setCheckout(value) {
    checkout = value;
  }

  @override
  String? getCheckoutId() {
    return checkout?.id;
  }
}
