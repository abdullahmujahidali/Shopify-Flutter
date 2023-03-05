import 'package:flutter/material.dart';

import '../../../models/entities/product.dart';
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../../../services/services.dart';
import '../action_button_mixin.dart';

class CartIcon extends StatelessWidget with ActionButtonMixin {
  final Product product;
  final ProductConfig config;
  final int quantity;

  const CartIcon({
    Key? key,
    required this.product,
    required this.config,
    this.quantity = 1,
  }) : super(key: key);

  void _addToCart(context, enableBottomSheet) {
    addToCart(
      context,
      product: product,
      quantity: quantity,
      enableBottomAddToCart: enableBottomSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!config.showCartIcon ||
        product.isEmptyProduct() ||
        !Services().widget.enableShoppingCart(product)) {
      return const SizedBox();
    }

    var enableBottomSheet = config.enableBottomAddToCart
        ? true
        : !product.canBeAddedToCartFromList();

    if (config.showCartIconColor) {
      return Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(config.cartIconRadius),
          color: Theme.of(context).primaryColor,
        ),
        child: IconButton(
          onPressed: () => _addToCart(context, enableBottomSheet),
          icon: const Icon(
            Icons.add,
            size: 18.0,
            color: Colors.white,
          ),
        ),
      );
    }
    return InkWell(
      // constraints: showQuantitySelector ? const BoxConstraints() : null,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Icon(
          Icons.add_shopping_cart,
          size: 18.0,
        ),
      ),
      onTap: () => _addToCart(context, enableBottomSheet),
    );
  }
}
