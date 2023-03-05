import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../models/entities/product.dart';
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../../../services/services.dart';
import 'cart_icon.dart';
import 'quantity_selection.dart';

class CartQuantity extends StatefulWidget {
  final Product product;
  final ProductConfig config;
  final Function(int)? onChangeQuantity;

  const CartQuantity({
    Key? key,
    required this.product,
    required this.config,
    this.onChangeQuantity,
  }) : super(key: key);

  @override
  State<CartQuantity> createState() => _CartQuantityState();
}

class _CartQuantityState extends State<CartQuantity> {
  var _quantity = 1;

  @override
  Widget build(BuildContext context) {
    var show = widget.product.canBeAddedToCartFromList(
          enableBottomAddToCart: widget.config.enableBottomAddToCart,
        ) &&
        widget.config.showQuantity &&
        Services().widget.enableShoppingCart(widget.product);

    if (!show) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuantitySelection(
            height: 30,
            color: Theme.of(context).colorScheme.secondary,
            limitSelectQuantity: kCartDetail['maxAllowQuantity'] ?? 100,
            value: _quantity,
            onChanged: (int value) {
              setState(() {
                _quantity = value;
              });
              if (widget.onChangeQuantity != null) {
                widget.onChangeQuantity!(value);
              }
            },
            useNewDesign: true,
          ),
          const Spacer(),
          if (widget.config.showCartIcon) ...[
            CartIcon(
              config: widget.config,
              quantity: _quantity,
              product: widget.product,
            ),
            const SizedBox(width: 3),
          ],
        ],
      ),
    );
  }
}
