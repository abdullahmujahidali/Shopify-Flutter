import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools/flash.dart';
import '../common/tools/tools.dart';
import '../generated/l10n.dart';
import '../models/app_model.dart';
import '../models/index.dart'
    show CartModel, Product, ProductModel, ProductVariation;
import '../routes/flux_navigate.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/detail/widgets/index.dart' show ProductShortDescription;
import '../services/services.dart';
import '../widgets/common/webview.dart';
import '../widgets/product/widgets/quantity_selection.dart';

mixin ProductVariantMixin {
  ProductVariation? updateVariation(
    List<ProductVariation> variations,
    Map<String?, String?> mapAttribute,
  ) {
    final templateVariation =
        variations.isNotEmpty ? variations.first.attributes : null;
    final listAttributes = variations.map((e) => e.attributes);

    ProductVariation productVariation;
    var attributeString = '';

    /// Flat attribute
    /// Example attribute = { "color": "RED", "SIZE" : "S", "Height": "Short" }
    /// => "colorRedsizeSHeightShort"
    templateVariation?.forEach((element) {
      final key = element.name;
      final value = mapAttribute[key];
      attributeString += value != null ? '$key$value' : '';
    });

    /// Find attributeS contain attribute selected
    final validAttribute = listAttributes.lastWhereOrNull(
      (attributes) =>
          attributes.map((e) => e.toString()).join().contains(attributeString),
    );

    if (validAttribute == null) return null;

    /// Find ProductVariation contain attribute selected
    /// Compare address because use reference
    productVariation =
        variations.lastWhere((element) => element.attributes == validAttribute);

    for (var element in productVariation.attributes) {
      if (!mapAttribute.containsKey(element.name)) {
        mapAttribute[element.name!] = element.option!;
      }
    }
    return productVariation;
  }

  bool isPurchased(
    ProductVariation? productVariation,
    Product product,
    Map<String?, String?> mapAttribute,
    bool isAvailable,
  ) {
    var inStock;
    // ignore: unnecessary_null_comparison
    if (productVariation != null) {
      inStock = productVariation.inStock!;
    } else {
      inStock = product.inStock!;
    }

    var allowBackorder = productVariation != null
        ? (productVariation.backordersAllowed ?? false)
        : product.backordersAllowed;

    var isValidAttribute = false;
    try {
      if (product.type == 'simple') {
        isValidAttribute = true;
      }
      if (product.attributes!.length == mapAttribute.length &&
          (product.attributes!.length == mapAttribute.length ||
              product.type != 'variable')) {
        isValidAttribute = true;
      }
    } catch (_) {}

    return (inStock || allowBackorder) && isValidAttribute && isAvailable;
  }

  List<Widget> makeProductTitleWidget(BuildContext context,
      ProductVariation? productVariation, Product product, bool isAvailable) {
    var listWidget = <Widget>[];

    // ignore: unnecessary_null_comparison
    var inStock = (productVariation != null
            ? productVariation.inStock
            : product.inStock) ??
        false;

    var stockQuantity =
        (kProductDetail.showStockQuantity) && product.stockQuantity != null
            ? '  (${product.stockQuantity}) '
            : '';
    if (Provider.of<ProductModel>(context, listen: false).selectedVariation !=
        null) {
      stockQuantity = (kProductDetail.showStockQuantity) &&
              Provider.of<ProductModel>(context, listen: false)
                      .selectedVariation!
                      .stockQuantity !=
                  null
          ? '  (${Provider.of<ProductModel>(context, listen: false).selectedVariation!.stockQuantity}) '
          : '';
    }

    if (isAvailable) {
      listWidget.add(
        const SizedBox(height: 5.0),
      );

      final sku = productVariation != null ? productVariation.sku : product.sku;

      listWidget.add(
        Row(
          children: <Widget>[
            if ((kProductDetail.showSku) && (sku?.isNotEmpty ?? false)) ...[
              Text(
                '${S.of(context).sku}: ',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                sku ?? '',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: inStock
                          ? Theme.of(context).primaryColor
                          : const Color(0xFFe74c3c),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
      );

      listWidget.add(
        const SizedBox(height: 5.0),
      );

      listWidget.add(
        Row(
          children: <Widget>[
            if (kAdvanceConfig.showStockStatus) ...[
              Text(
                '${S.of(context).availability}: ',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              (productVariation != null
                      ? (productVariation.backordersAllowed ?? false)
                      : product.backordersAllowed)
                  ? Text(
                      S.of(context).backOrder,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: kStockColor.backorder,
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  : Text(
                      inStock
                          ? '${S.of(context).inStock}$stockQuantity'
                          : S.of(context).outOfStock,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: inStock
                                ? kStockColor.inStock
                                : kStockColor.outOfStock,
                            fontWeight: FontWeight.w600,
                          ),
                    )
            ],
          ],
        ),
      );
      if (productVariation?.description?.isNotEmpty ?? false) {
        listWidget.add(Services()
            .widget
            .renderProductDescription(context, productVariation!.description!));
      }
      if (product.shortDescription != null &&
          product.shortDescription!.isNotEmpty) {
        listWidget.add(
          ProductShortDescription(product),
        );
      }

      listWidget.add(
        const SizedBox(height: 15.0),
      );
    }

    return listWidget;
  }

  List<Widget> makeBuyButtonWidget(
      BuildContext context,
      ProductVariation? productVariation,
      Product product,
      Map<String?, String?>? mapAttribute,
      int maxQuantity,
      int quantity,
      Function addToCart,
      Function onChangeQuantity,
      bool isAvailable,
      bool isInAppPurchaseChecking,
      {bool ignoreBuyOrOutOfStockButton = false}) {
    final theme = Theme.of(context);

    // ignore: unnecessary_null_comparison
    var inStock = (productVariation != null
            ? productVariation.inStock
            : product.inStock) ??
        false;
    var allowBackorder = productVariation != null
        ? (productVariation.backordersAllowed ?? false)
        : product.backordersAllowed;

    final isExternal = product.type == 'external' ? true : false;
    final isVariationLoading =
        // ignore: unnecessary_null_comparison
        (product.isVariableProduct || product.type == 'configurable') &&
            productVariation == null &&
            mapAttribute == null;

    final buyOrOutOfStockButton = Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: isExternal
            ? ((inStock || allowBackorder) &&
                    mapAttribute != null &&
                    (product.attributes!.length == mapAttribute.length) &&
                    isAvailable)
                ? theme.primaryColor
                : theme.disabledColor
            : theme.primaryColor,
      ),
      child: Center(
        child: Text(
          ((((inStock || allowBackorder) && isAvailable) || isExternal) &&
                  !isVariationLoading &&
                  !isInAppPurchaseChecking
              ? S.of(context).buyNow
              : (isAvailable && !isVariationLoading && !isInAppPurchaseChecking
                      ? S.of(context).outOfStock
                      : isInAppPurchaseChecking
                          ? S.of(context).checking
                          : isVariationLoading
                              ? S.of(context).loading
                              : S.of(context).unavailable)
                  .toUpperCase()),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );

    if (!inStock && !isExternal && !allowBackorder) {
      return [
        ignoreBuyOrOutOfStockButton ? const SizedBox() : buyOrOutOfStockButton,
      ];
    }

    if ((product.isPurchased) && (product.isDownloadable ?? false)) {
      return [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async => await Tools.launchURL(product.files![0]!),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: Text(
                    S.of(context).download,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ];
    }

    return [
      if (!isExternal && kProductDetail.showStockQuantity) ...[
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                '${S.of(context).selectTheQuantity}:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: Container(
                height: 32.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: QuantitySelection(
                  height: 32.0,
                  expanded: true,
                  value: quantity,
                  color: theme.colorScheme.secondary,
                  limitSelectQuantity: maxQuantity,
                  onChanged: onChangeQuantity,
                ),
              ),
            ),
          ],
        ),
      ],
      const SizedBox(height: 10),

      /// Action Buttons: Buy Now, Add To Cart
      actionButton(
          ignoreBuyOrOutOfStockButton,
          isAvailable,
          addToCart,
          inStock,
          allowBackorder,
          buyOrOutOfStockButton,
          isExternal,
          isVariationLoading,
          isInAppPurchaseChecking,
          context)
    ];
  }

  /// Add to Cart & Buy Now function
  void addToCart(BuildContext context, Product product, int quantity,
      ProductVariation? productVariation, Map<String?, String?> mapAttribute,
      [bool buyNow = false, bool inStock = false, bool inBackground = false]) {
    /// Out of stock || Variable product but not select any variant.
    if (!inStock || (product.isVariableProduct && mapAttribute.isEmpty)) {
      return;
    }

    final cartModel = Provider.of<CartModel>(context, listen: false);
    if (product.type == 'external') {
      openExternal(context, product);
      return;
    }

    final mapAttr = <String, String>{};
    for (var entry in mapAttribute.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key != null && value != null) {
        mapAttr[key] = value;
      }
    }

    productVariation =
        Provider.of<ProductModel>(context, listen: false).selectedVariation;
    var message = cartModel.addProductToCart(
        context: context,
        product: product,
        quantity: quantity,
        variation: productVariation,
        options: mapAttr);

    if (message.isNotEmpty) {
      FlashHelper.errorMessage(context, message: message);
    } else {
      Services().firebase.firebaseAnalytics?.logAddToCart(
            currency: Provider.of<AppModel>(context, listen: false).currency,
            price: double.tryParse(product.price ?? ''),
            data: product,
            quantity: quantity,
          );
      if (buyNow) {
        FluxNavigate.pushNamed(
          RouteList.cart,
          arguments: CartScreenArgument(isModal: true, isBuyNow: true),
        );
      }
      FlashHelper.message(
        context,
        title: product.name,
        message: S.of(context).addToCartSucessfully,
      );
    }
  }

  /// Support Affiliate product
  Future<void> openExternal(BuildContext context, Product product) async {
    final url = Tools.prepareURL(product.affiliateUrl);

    if (url != null) {
      try {
        if (Tools.needToOpenExternalApp(url)) {
          await Tools.launchURL(url);
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebView(
                url: product.affiliateUrl,
                title: product.name,
              ),
            ),
          );
        }
        return;
      } catch (e) {
        printError(e);
      }
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: Text(S.of(context).notFound),
        ),
      );
    }));
  }
}

Widget actionButton(
  bool ignoreBuyOrOutOfStockButton,
  bool isAvailable,
  Function addToCart,
  bool inStock,
  bool allowBackorder,
  Widget buyOrOutOfStockButton,
  bool isExternal,
  bool isVariationLoading,
  bool isInAppPurchaseChecking,
  BuildContext context,
) {
  return Row(
    children: <Widget>[
      if (!ignoreBuyOrOutOfStockButton)
        Expanded(
          child: GestureDetector(
            onTap: (isAvailable && !isInAppPurchaseChecking)
                ? () => addToCart(true, inStock || allowBackorder)
                : null,
            child: buyOrOutOfStockButton,
          ),
        ),
      if (!ignoreBuyOrOutOfStockButton) const SizedBox(width: 10),
      if (isAvailable &&
          (inStock || allowBackorder) &&
          !isExternal &&
          !isVariationLoading)
        Expanded(
          child: GestureDetector(
            onTap: () => addToCart(false, inStock || allowBackorder),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Center(
                child: Text(
                  S.of(context).addToCart.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
