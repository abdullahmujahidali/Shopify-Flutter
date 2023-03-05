import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/index.dart';
import '../entities/index.dart' show Product, ProductVariation, Tax;
import '../entities/product_addons.dart';
import 'cart_base.dart';
import 'mixin/index.dart';

class CartModelWoo
    with
        ChangeNotifier,
        CartMixin,
        MagentoMixin,
        AddressMixin,
        LocalMixin,
        CurrencyMixin,
        CouponMixin,
        ShopifyMixin,
        OpencartMixin,
        VendorMixin,
        OrderDeliveryMixin
    implements CartModel {
  static final CartModelWoo _instance = CartModelWoo._internal();

  factory CartModelWoo() => _instance;

  CartModelWoo._internal();

  @override
  Future<void> initData() async {
    await getShippingAddress();
    getCartInLocal();
    getCurrency();
  }

  @override
  double getTotal() {
    var subtotal = getSubTotal() ?? 1.0;

    if (couponObj != null) {
      subtotal -= getCouponCost();
    }

    if (subtotal < 0.0) {
      subtotal = 0.0;
    }

    if (kPaymentConfig.enableShipping) {
      subtotal += getShippingCost()!;
    }

    if (taxes.isNotEmpty) {
      subtotal += taxesTotal;
    }

    subtotal -= rewardTotal;

    subtotal -= walletAmount;

    subtotal += getCODExtraFee();

    return subtotal;
  }

  @override
  double getProductPrice(id) {
    var productId = Product.cleanProductID(id);
    if (item[productId] != null) {
      if (item[productId]!.type == 'subscription') {
        final signUpFee = item[productId]!.metaData.firstWhere(
            (element) => element['key'] == '_subscription_sign_up_fee',
            orElse: () => {})['value'];
        if ((signUpFee?.isNotEmpty ?? false) &&
            productsInCart[id] != null &&
            double.parse(signUpFee!) > 0) {
          return double.parse(signUpFee!) * productsInCart[id]!;
        }
      }
    }

    return super.getProductPrice(id);
  }

  @override
  bool isEnabledShipping() {
    List ids = productsInCart.keys.where((id) {
      var productId = Product.cleanProductID(id);
      return item[productId]!.type == 'subscription' ||
          item[productId]!.type == 'variable-subscription';
    }).toList();
    if (ids.length == productsInCart.keys.length || isWalletCart()) {
      return false;
    }
    return super.isEnabledShipping();
  }

  @override
  double getItemTotal(
      {ProductVariation? productVariation,
      Product? product,
      int quantity = 1}) {
    var subtotal = double.parse(product!.price!) * quantity;
    if (productVariation != null) {
      subtotal = double.parse(productVariation.price!) * quantity;
    } else {
      subtotal = double.parse(product.price!) * quantity;
    }
    if (product.selectedOptions?.isNotEmpty ?? false) {
      subtotal += product.getProductOptionsPrice(quantity);
    }
    return subtotal;
  }

  @override
  String updateQuantity(Product product, String key, int quantity) {
    final isClosed =
        (product.store != null && product.store!.storeHour != null) &&
            (product.store!.storeHour!.isDisablePurchase! &&
                !product.store!.storeHour!.isOpen());
    final isOnVacation =
        (product.store != null && product.store!.vacationSettings != null) &&
            (product.store!.vacationSettings!.vacationMode &&
                !product.store!.vacationSettings!.isOpen() &&
                product.store!.vacationSettings!.disableVacationPurchase);

    if (isClosed) {
      return S.current.storeClosed;
    }
    if (isOnVacation) {
      return S.current.onVacation;
    }
    var message = '';
    var total = quantity;
    ProductVariation? variation;

    if (key.contains('-')) {
      variation = getProductVariationById(key);
    }

    var stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;

    final allowBackorder = variation != null
        ? (variation.backordersAllowed ?? false)
        : product.backordersAllowed;

    if (!product.manageStock) {
      productsInCart[key] = total;
    } else if (total <= stockQuantity!) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity!
            ? message = '${S.current.minimumQuantityIs} ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        (total > product.maxQuantity! && !allowBackorder)
            ? message =
                '${S.current.youCanOnlyPurchase} ${product.maxQuantity} ${S.current.forThisProduct}'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity! && total <= product.maxQuantity!) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity!) {
            message = '${S.current.minimumQuantityIs} ${product.minQuantity}';
          }
          if (total > product.maxQuantity! && !allowBackorder) {
            message =
                '${S.current.youCanOnlyPurchase} ${product.maxQuantity} ${S.current.forThisProduct}';
          }
        }
      }
    } else {
      message =
          '${S.current.currentlyWeOnlyHave} $stockQuantity ${S.current.ofThisProduct}';
    }
    if (message.isEmpty) {
      updateQuantityCartLocal(key: key, quantity: quantity);
      notifyListeners();
    }

    updateDiscount(onFinish: notifyListeners);

    Services().widget.syncCartToWebsite(this);

    return message;
  }

// Removes an item from the cart.
  @override
  void removeItemFromCart(String key) {
    if (productsInCart.containsKey(key)) {
      productsInCart.remove(key);
      productVariationInCart.remove(key);
      productAddonsOptionsInCart.remove(key);

      /// In case there are multiple item with same product ID.
      /// Example: [1234+Small, 1234+Medium]
      var shouldRemove = true;
      var productId = Product.cleanProductID(key);
      for (var inCartKey in productsInCart.keys) {
        var productIdInCart = Product.cleanProductID(inCartKey);
        if (productIdInCart == productId) {
          shouldRemove = false;
          break;
        }
      }
      if (shouldRemove) {
        item.remove(productId);
      }

      removeProductLocal(key);
    }

    updateDiscount(onFinish: notifyListeners);
    notifyListeners();

    Services().widget.syncCartToWebsite(this);
  }

  // Removes an item from the cart.
  @override
  void removeItemFromProductId(String productId) {
    productsInCart.removeWhere((key, value) => key.contains(productId));
    removeProductLocal(productId);

    updateDiscount(onFinish: notifyListeners);
    notifyListeners();

    Services().widget.syncCartToWebsite(this);
  }

// Removes everything from the cart.
  @override
  void clearCart() {
    if (isWalletCart()) {
      getCurrency();
    }
    clearCartLocal();
    productsInCart.clear();
    item.clear();
    productVariationInCart.clear();
    productAddonsOptionsInCart.clear();
    shippingMethod = null;
    paymentMethod = null;
    resetCoupon();
    notes = null;
    rewardTotal = 0;
    walletAmount = 0;
    taxesTotal = 0;
    taxes = [];
    notifyListeners();

    Services().widget.syncCartToWebsite(this);
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
    if (isWalletCart()) {
      clearCart();
    }

    if (product != null && product.store != null) {
      final isClosed = (product.store!.storeHour != null) &&
          (product.store!.storeHour!.isDisablePurchase! &&
              !product.store!.storeHour!.isOpen());
      if (isClosed) {
        return S.current.storeClosed;
      }

      if (product.store?.vacationSettings != null) {
        final isOnVacation = (product.store!.vacationSettings!.vacationMode &&
            !product.store!.vacationSettings!.isOpen() &&
            product.store!.vacationSettings!.disableVacationPurchase);
        if (isOnVacation) {
          return S.current.onVacation;
        }
      }
    }

    var message = '';

    var key = product!.id.toString();
    if (variation != null) {
      if (variation.id != null) {
        key += '-${variation.id}';
      }
      if (options != null) {
        for (var option in options.keys) {
          key += '-$option${options[option]}';
        }
      }
    } else if (product.bookingInfo != null) {
      key += '-${product.bookingInfo!.timeStart.toString()}';
    }

    final allowBackorder = variation != null
        ? (variation.backordersAllowed ?? false)
        : product.backordersAllowed;
    var stockQuantity = product.stockQuantity;
    if (kCartDetail['maxAllowQuantity'] != null) {
      var maxAllowQuantity = Helper.formatInt(kCartDetail['maxAllowQuantity']);
      if (stockQuantity == null) {
        stockQuantity = maxAllowQuantity;
      } else if (maxAllowQuantity != null && stockQuantity > maxAllowQuantity) {
        stockQuantity = maxAllowQuantity;
      }
    }
    if (stockQuantity != null) {
      var isExceeded = ((productsInCart[key] ?? 0) + quantity!) > stockQuantity;
      if (isExceeded && !allowBackorder) {
        return '${S.current.youCanOnlyPurchase} $stockQuantity ${S.current.forThisProduct}';
      }
    }

    try {
      /// Product variations.
      if (product.isVariableProduct) {
        /// Loading attributes & variants.
        if (variation == null && (options?.isEmpty ?? true)) {
          message = S.current.loading;
          return message;
        }

        /// Not selected all attributes.
        if (options != null &&
            options.isNotEmpty &&
            options.values.contains(null)) {
          message = S.current.pleaseSelectAllAttributes;
          return message;
        }
      }

      /// Product addons.
      if (product.addOns?.isNotEmpty ?? false) {
        for (var addOns in product.addOns!) {
          if (addOns.required ?? false) {
            /// For customer-defined price, text & upload type, label is entered by user.
            /// So we need to check using addon name.
            final requiredOptions = addOns.options!.map((e) {
              if (e.isEnteredByUser) {
                return e.parent;
              }
              return e.label;
            }).toList();
            final check = product.selectedOptions?.firstWhereOrNull(
              (option) => requiredOptions.contains(
                option.isEnteredByUser ? option.parent : option.label,
              ),
            );
            if (check == null) {
              message = S.current.pleaseSelectRequiredOptions;
              return message;
            }
          }
        }
      }

      if (product.selectedOptions?.isNotEmpty ?? false) {
        key += '+${product.selectedOptions!.map((e) => e.label).join('+')}';
      }

      //Check product's quantity before adding to cart
      var total = !productsInCart.containsKey(key)
          ? quantity
          : productsInCart[key]! + quantity!;
      var stockQuantity =
          variation == null ? product.stockQuantity : variation.stockQuantity;

      if (!product.manageStock || allowBackorder) {
        productsInCart[key] = total;
      } else if (total! <= stockQuantity!) {
        if (product.minQuantity == null && product.maxQuantity == null) {
          productsInCart[key] = total;
        } else if (product.minQuantity != null && product.maxQuantity == null) {
          total < product.minQuantity!
              ? message =
                  '${S.current.minimumQuantityIs} ${product.minQuantity}'
              : productsInCart[key] = total;
        } else if (product.minQuantity == null && product.maxQuantity != null) {
          (total > product.maxQuantity! && !allowBackorder)
              ? message =
                  '${S.current.youCanOnlyPurchase} ${product.maxQuantity} ${S.current.forThisProduct}'
              : productsInCart[key] = total;
        } else if (product.minQuantity != null && product.maxQuantity != null) {
          if (total >= product.minQuantity! && total <= product.maxQuantity!) {
            productsInCart[key] = total;
          } else {
            if (total < product.minQuantity!) {
              message = '${S.current.minimumQuantityIs} ${product.minQuantity}';
            }
            if (total > product.maxQuantity! && !allowBackorder) {
              message =
                  '${S.current.youCanOnlyPurchase} ${product.maxQuantity} ${S.current.forThisProduct}';
            }
          }
        }
      } else {
        message =
            '${S.current.currentlyWeOnlyHave} $stockQuantity ${S.current.ofThisProduct}';
      }

      if (message.isEmpty) {
        item[product.id] = product;
        productVariationInCart[key] = variation;
        productsMetaDataInCart[key] = options;
        productAddonsOptionsInCart[key] =
            product.selectedOptions?.map(AddonsOption.copy).toList();

        if (isSaveLocal) {
          saveCartToLocal(
              product: product,
              quantity: quantity,
              variation: variation,
              options: options);
        }
      }

      updateDiscount(onFinish: notifyListeners);
      notifyListeners();
      Services().widget.syncCartToWebsite(this);
    } catch (err) {
      if (err is ArgumentError) {
        return S.current.pleaseSelectAllAttributes;
      }
    }
    return message;
  }

  @override
  void setRewardTotal(double total) {
    rewardTotal = total;
    notifyListeners();
  }

  double getShippingVendorCost() {
    var sum = 0.0;

    for (var element in selectedShippingMethods) {
      sum += element.shippingMethods[0].cost ?? 0.0;
    }
    return sum;
  }

  @override
  double? getShippingCost() {
    var isMultiVendor = ServerConfig().typeName.isMultiVendor;
    return isMultiVendor ? getShippingVendorCost() : super.getShippingCost();
  }

  @override
  void loadSavedCoupon() {
    savedCoupon = UserBox().savedCoupon;
    notifyListeners();
  }

  @override
  void setWalletAmount(double total) {
    super.setWalletAmount(total);
    notifyListeners();
  }

  bool isTopUpProduct(Product? product) {
    return product != null && product.isTopUpProduct();
  }

  @override
  bool isWalletCart() {
    var isWallet = false;
    for (var key in productsInCart.keys) {
      var productId = Product.cleanProductID(key);
      var product = item[productId];
      if (isTopUpProduct(product)) {
        isWallet = true;
        break;
      }
    }

    return isWallet;
  }

  @override
  void setTaxInfo(List<Tax> taxes, double taxesTotal) {
    super.setTaxInfo(taxes, taxesTotal);
    notifyListeners();
  }
}
