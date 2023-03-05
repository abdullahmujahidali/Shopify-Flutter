import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../entities/product.dart';
import '../entities/product_variation.dart';
import 'cart_base.dart';
import 'mixin/index.dart';

class CartModelOpencart
    with
        ChangeNotifier,
        CartMixin,
        MagentoMixin,
        AddressMixin,
        LocalMixin,
        CurrencyMixin,
        CouponMixin,
        ShopifyMixin,
        VendorMixin,
        OpencartMixin,
        OrderDeliveryMixin
    implements CartModel {
  static final CartModelOpencart _instance = CartModelOpencart._internal();

  factory CartModelOpencart() => _instance;

  CartModelOpencart._internal();

  @override
  Future<void> initData() async {
    await getShippingAddress();
    getCartInLocal();
    getCurrency();
  }

  @override
  double getSubTotal() {
    return productsInCart.keys.fold(0.0, (sum, id) {
      return sum + getProductPrice(id);
    });
  }

  @override
  double getTotal() {
    var subtotal = getSubTotal();

    if (couponObj != null) {
      if (couponObj!.discountType == 'percent') {
        subtotal -= subtotal * couponObj!.amount! / 100;
      } else {
        subtotal -= (couponObj!.amount! * totalCartQuantity);
      }
    }

    if (kPaymentConfig.enableShipping) {
      subtotal += getShippingCost()!;
    }
    return subtotal;
  }

  @override
  double getItemTotal(
      {ProductVariation? productVariation,
      Product? product,
      int quantity = 1}) {
    var subtotal = double.parse(product!.price!) * quantity;

    if (couponObj != null) {
      if (couponObj!.discountType == 'percent') {
        return subtotal - subtotal * couponObj!.amount! / 100;
      } else {
        return subtotal - (couponObj!.amount! * quantity);
      }
    } else {
      return subtotal;
    }
  }

  @override
  String updateQuantity(Product product, String key, int quantity, {context}) {
    var message = '';
    var total = quantity;
    ProductVariation? variation;

    if (key.contains('-')) {
      variation = getProductVariationById(key);
    }
    var stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;

    if (!product.manageStock) {
      productsInCart[key] = total;
    } else if (total <= stockQuantity!) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity!
            ? message = 'Minimum quantity is ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        total > product.maxQuantity!
            ? message =
                'You can only purchase ${product.maxQuantity} for this product'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity! && total <= product.maxQuantity!) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity!) {
            message = 'Minimum quantity is ${product.minQuantity}';
          }
          if (total > product.maxQuantity!) {
            message =
                'You can only purchase ${product.maxQuantity} for this product';
          }
        }
      }
    } else {
      message = 'Currently we only have $stockQuantity of this product';
    }
    if (message.isEmpty) {
      updateQuantityCartLocal(key: key, quantity: quantity);
      notifyListeners();
    }
    return message;
  }

  @override
  // Removes an item from the cart.
  void removeItemFromCart(String key) {
    if (productsInCart.containsKey(key)) {
      productsInCart.remove(key);
      productVariationInCart.remove(key);
      removeProductLocal(key);
    }
    notifyListeners();
  }

  @override
  // Removes everything from the cart.
  void clearCart() {
    clearCartLocal();
    productsInCart.clear();
    item.clear();
    productVariationInCart.clear();
    productOptionInCart.clear();
    shippingMethod = null;
    paymentMethod = null;
    resetCoupon();
    notes = null;
    notifyListeners();
  }

  @override
  void setOrderNotes(String note) {
    notes = note;
    notifyListeners();
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
    var message = '';

    var key = product!.id.toString();
    if (options != null) {
      for (var option in options.keys) {
        String optionValue = options[option] is List
            ? List.from(options[option]).join('')
            : options[option];
        key += '-$option$optionValue';
      }

      //validate required options
      if ((product.options ?? []).isNotEmpty) {
        for (var option in (product.options ?? [])) {
          if (option['required'] == '1' &&
              options[option['product_option_id']] == null) {
            message = option['name'] + ' is required';
            break;
          }
        }
      }
    } else {
      //validate required options
      if ((product.options ?? []).isNotEmpty) {
        final requiredOption = product.options!
            .firstWhereOrNull((option) => option['required'] == '1');
        if (requiredOption != null) {
          message = requiredOption['name'] + ' is required';
        }
      }
    }

    if (message.isNotEmpty) return message;

    //Check product's quantity before adding to cart
    var total = !productsInCart.containsKey(key)
        ? quantity
        : (productsInCart[key]! + quantity!);
    var stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;

    if (!product.manageStock) {
      productsInCart[key] = total;
    } else if (total! <= stockQuantity!) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity!
            ? message = 'Minimum quantity is ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        total > product.maxQuantity!
            ? message =
                'You can only purchase ${product.maxQuantity} for this product'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity! && total <= product.maxQuantity!) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity!) {
            message = 'Minimum quantity is ${product.minQuantity}';
          }
          if (total > product.maxQuantity!) {
            message =
                'You can only purchase ${product.maxQuantity} for this product';
          }
        }
      }
    } else {
      message = 'Currently we only have $stockQuantity of this product';
    }

    if (message.isEmpty) {
      item[product.id] = product;
      productVariationInCart[key] = ProductVariation.fromJson(
          {'id': key, 'price': product.price, 'in_stock': true, 'image': {}});
      if (options != null) {
        productsMetaDataInCart[key] = {...options};
        productOptionInCart[key] = {...options};
      }

      if (isSaveLocal) {
        saveCartToLocal(
            product: product,
            quantity: quantity,
            variation: ProductVariation.fromJson({
              'id': key,
              'price': product.price,
              'in_stock': true,
              'image': {}
            }),
            options: options != null ? {...options} : {});
      }
    }

    notifyListeners();
    return message;
  }

  @override
  void setRewardTotal(double total) {
    rewardTotal = total;
    notifyListeners();
  }
}
