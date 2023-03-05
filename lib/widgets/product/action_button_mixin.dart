import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import '../../models/cart/cart_base.dart';
import '../../models/entities/product.dart';
import '../../models/entities/product_variation.dart';
import '../../models/recent_product_model.dart';
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import 'dialog_add_to_cart.dart';

mixin ActionButtonMixin {
  void onTapProduct(
    context, {
    bool isFromSearchScreen = false,
    required Product product,
    ProductConfig? config,
  }) {
    if (product.imageFeature == '') return;

    Services().firebase.firebaseAnalytics?.logSelectItem(
          itemListId: config?.category ?? config?.tag ?? product.categoryId,
          itemListName: config?.name ?? product.categoryName,
          data: product,
        );

    Provider.of<RecentModel>(context, listen: false).addRecentProduct(product);

    if (isFromSearchScreen) {
      Navigator.of(context).pushNamed(
        RouteList.productDetail,
        arguments: product,
      );
      return;
    }

    FluxNavigate.pushNamed(
      RouteList.productDetail,
      arguments: product,
    );
  }

  void addToCart(
    BuildContext context, {
    int quantity = 1,
    bool enableBottomAddToCart = false,
    required Product product,
  }) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    final String Function({
      dynamic context,
      dynamic isSaveLocal,
      Function notify,
      Map<String, dynamic> options,
      Product? product,
      int quantity,
      ProductVariation variation,
    }) addProductToCart =
        Provider.of<CartModel>(context, listen: false).addProductToCart;
    if (enableBottomAddToCart) {
      DialogAddToCart.show(context, product: product, quantity: quantity);
    } else {
      var message = addProductToCart(
        product: product,
        context: context,
        quantity: quantity,
      );
      if (message.isEmpty) {
        Services().firebase.firebaseAnalytics?.logAddToCart(
              currency: Provider.of<AppModel>(context, listen: false).currency,
              price: double.tryParse(product.price ?? ''),
              data: product,
              quantity: quantity,
            );
      }
      FlashHelper.message(
        context,
        title: message.isEmpty ? product.name : null,
        message: message.isEmpty ? S.of(context).addToCartSucessfully : message,
        isError: message.isNotEmpty,
      );
    }
  }

  void updateQuantity({
    required Product product,
    required int quantity,
    required BuildContext context,
  }) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    if (quantity == 0) {
      cartModel.removeItemFromCart(product.id);
      return;
    }
    cartModel.updateQuantity(product, product.id, quantity);
  }
}
