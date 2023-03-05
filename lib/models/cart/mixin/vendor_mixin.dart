import '../../entities/product.dart';
import 'cart_mixin.dart';

mixin VendorMixin on CartMixin {
  List<dynamic> selectedShippingMethods = [];

  void setSelectedMethods(List<dynamic> selected) {
    selectedShippingMethods = selected;
  }

  bool isDisableMultiVendorCheckoutValid(productsInCart, getProductById) {
    var isValid = true;
    var storeId;
    if (productsInCart.keys.isNotEmpty) {
      productsInCart.keys.forEach((key) {
        var id = Product.cleanProductID(key);
        final product = getProductById(id);
        if (storeId == null) {
          storeId = product?.store?.id;
        } else {
          if (storeId != product?.store?.id) {
            isValid = false;
          }
        }
      });
    }
    return isValid;
  }
}
