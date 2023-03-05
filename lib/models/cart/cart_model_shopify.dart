import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../index.dart';
import '../mixins/language_mixin.dart';
import 'mixin/index.dart';

class CartModelShopify
    with
        ChangeNotifier,
        CartMixin,
        MagentoMixin,
        AddressMixin,
        LocalMixin,
        CurrencyMixin,
        CouponMixin,
        OpencartMixin,
        VendorMixin,
        ShopifyMixin,
        LanguageMixin,
        OrderDeliveryMixin
    implements CartModel {
  static final CartModelShopify _instance = CartModelShopify._internal();

  factory CartModelShopify() => _instance;

  CartModelShopify._internal();

  @override
  Future<void> initData() async {
    await getShippingAddress();
    getCartInLocal();
    getCurrency();
  }

  @override
  double? getSubTotal() {
    return productsInCart.keys.fold(0.0, (sum, key) {
      if (productVariationInCart[key] != null &&
          productVariationInCart[key]!.price != null &&
          productVariationInCart[key]!.price!.isNotEmpty) {
        return (sum ?? 0) +
            double.parse(productVariationInCart[key]!.price!) *
                productsInCart[key]!;
      } else {
        var price = PriceTools.getPriceProductValue(item[key], onSale: true)!;
        if (price.isNotEmpty) {
          return (sum ?? 0) + double.parse(price) * productsInCart[key]!;
        }
        return sum;
      }
    });
  }

  @override
  double? getTax() {
    return checkout!.totalTax;
  }

  @override
  String getCoupon() {
    if (couponObj != null) {
      if (couponObj!.discountType == 'percent') {
        return '-${couponObj!.amount}%';
      } else {
        return '-${PriceTools.getCurrencyFormatted(couponObj!.amount! * totalCartQuantity, currencyRates, currency: currencyCode)!}';
      }
    } else {
      return '';
    }
  }

  @override
  double? getTotal() {
    var subtotal = getSubTotal() ?? 1;
    var shippingCost = 0.0;
    if (kPaymentConfig.enableShipping) {
      shippingCost = getShippingCost() ?? 0;
      // subtotal += shippingCost;
    }
    if (couponObj != null) {
      // Should apply result calculating by back end if coupon has apply
      return (checkout?.subtotalPrice ?? subtotal) + shippingCost;
      // final discountType = couponObj!.discountType;
      // final amount = couponObj!.amount ?? 0;
      // if (discountType == CouponType.fixedAmount) {
      //   return subtotal - amount;
      // } else if (discountType == CouponType.percentage) {
      //   return subtotal - (subtotal * (amount / 100));
      // }
      // return subtotal;
    } else {
      return subtotal + shippingCost;
    }
  }

  @override
  String addProductToCart({
    context,
    Product? product,
    int? quantity = 1,
    ProductVariation? variation,
    Function? notify,
    isSaveLocal = true,
    Map? options,
  }) {
    var defaultVariation = variation;
    var key = product!.id.toString();

    item[key] = product;

    if (defaultVariation?.id == null) {
      defaultVariation = product.variations
          ?.firstWhere((element) => (element.inStock ?? false));
    }

    key += '-${defaultVariation!.id}';
    productVariationInCart[key] = defaultVariation;

    if (isSaveLocal) {
      saveCartToLocal(
        product: product,
        quantity: quantity,
        variation: defaultVariation,
      );
    }

    var quantityOfProductInCart = productsInCart[key] ?? 0;

    if (!productsInCart.containsKey(key)) {
      productsInCart[key] = quantity;
    } else {
      final stockQuantity = defaultVariation.stockQuantity ?? 0;
      var maxAllowQuantity = kCartDetail['maxAllowQuantity'];
      if (maxAllowQuantity != null &&
          (quantityOfProductInCart + (quantity ?? 0)) > maxAllowQuantity) {
        return '${S.current.youCanOnlyPurchase} $maxAllowQuantity ${S.current.forThisProduct}';
      }
      if (quantityOfProductInCart == stockQuantity &&
          (variation?.backordersAllowed ?? false) == false) {
        return S.of(context).addToCartMaximum;
      }

      quantityOfProductInCart += quantity!;
      productsInCart[key] = quantityOfProductInCart;
    }

    productSkuInCart[key] = product.sku;

    // Re apply coupon on UI
    if (couponObj != null) {
      Future.delayed(const Duration(milliseconds: 300), notifyListeners);
      return '';
    }
    notifyListeners();

    return '';
  }

  @override
  String updateQuantity(Product product, String key, int quantity, {context}) {
    if (productsInCart.containsKey(key)) {
      final productVariation = productVariationInCart[key]!;
      final stockQuantity =
          productVariation.stockQuantity ?? product.stockQuantity;
      if (stockQuantity != null && quantity > stockQuantity) {
        return '${S.of(context).youCanOnlyPurchase} ${product.maxQuantity} ${S.of(context).forThisProduct}';
      }
      productsInCart[key] = quantity;
      updateQuantityCartLocal(key: key, quantity: quantity);
      notifyListeners();
    }
    return '';
  }

  // Removes an item from the cart.
  @override
  void removeItemFromCart(String key) {
    if (productsInCart.containsKey(key)) {
      removeProductLocal(key);
      productsInCart.remove(key);
      productVariationInCart.remove(key);
      productSkuInCart.remove(key);
    }
    notifyListeners();
  }

  @override
  double getItemTotal(
      {ProductVariation? productVariation,
      Product? product,
      int quantity = 1}) {
    return 0;
  }

  @override
  void setOrderNotes(String note) {
    notes = note;
    notifyListeners();
  }

  // Removes everything from the cart.
  @override
  void clearCart() {
    clearCartLocal();
    productsInCart.clear();
    item.clear();
    checkout = null;
    productVariationInCart.clear();
    productSkuInCart.clear();
    shippingMethod = null;
    paymentMethod = null;
    couponObj = null;
    notes = null;
    notifyListeners();
  }

  @override
  void setRewardTotal(double total) {
    rewardTotal = total;
    notifyListeners();
  }
}
