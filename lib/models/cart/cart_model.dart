import 'cart_base.dart';
import 'cart_model_bigcommerce.dart';
import 'cart_model_magento.dart';
import 'cart_model_opencart.dart';
import 'cart_model_presta.dart';
import 'cart_model_shopify.dart';
import 'cart_model_strapi.dart';
import 'cart_model_woo.dart';

export 'cart_base.dart';

class CartInject {
  static final CartInject _instance = CartInject._internal();

  factory CartInject() => _instance;

  CartInject._internal();

  /// init default CartModel
  CartModel model = CartModelWoo();

  void init(config) {
    switch (config['type']) {
      case 'magento':
        model = CartModelMagento();
        break;
      case 'shopify':
        model = CartModelShopify();
        break;
      case 'opencart':
        model = CartModelOpencart();
        break;
      case 'presta':
        model = CartModelPresta();
        break;
      case 'strapi':
        model = CartModelStrapi();
        break;
      case 'bigCommerce':
        model = CartModelBigCommerce();
        break;
      default:
        model = CartModelWoo();
    }
    model.initData();
  }
}
