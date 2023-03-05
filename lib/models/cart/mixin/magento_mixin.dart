import 'cart_mixin.dart';

mixin MagentoMixin on CartMixin {
  double discountAmount = 0.0;

  final Map<String, String?> productSkuInCart = {};
}
