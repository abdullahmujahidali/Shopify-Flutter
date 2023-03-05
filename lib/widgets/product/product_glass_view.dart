import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show Product, CartModel;
import '../../modules/dynamic_layout/config/product_config.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show
        CartIcon,
        HeartButton,
        ProductImage,
        ProductOnSale,
        ProductPricing,
        ProductTitle;
import 'widgets/cart_button_with_quantity.dart';

class ProductGlass extends StatelessWidget with ActionButtonMixin {
  final Product item;
  final double? width;
  final double? maxWidth;
  final offset;
  final ProductConfig config;

  const ProductGlass({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    Widget productImage = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              BorderRadius.circular(((config.borderRadius ?? 3) * 0.7)),
          child: Stack(
            children: [
              ProductImage(
                width: width!,
                product: item,
                config: config,
                ratioProductImage: config.imageRatio,
                offset: offset,
                onTapProduct: () =>
                    onTapProduct(context, product: item, config: config),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: ProductOnSale(
                  product: item,
                  config: ProductConfig.empty()..hMargin = 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(config.borderRadius ?? 12),
                    ),
                  ),
                ),
              ),
              if (config.showCartButtonWithQuantity)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Selector<CartModel, int>(
                      selector: (context, cartModel) =>
                          cartModel.productsInCart[item.id] ?? 0,
                      builder: (context, quantity, child) {
                        return CartButtonWithQuantity(
                          quantity: quantity,
                          borderRadiusValue: config.cartIconRadius,
                          increaseQuantityFunction: () {
                            // final minQuantityNeedAdd =
                            //     widget.item.getMinQuantity();
                            // var quantityWillAdd = 1;
                            // if (quantity == 0 &&
                            //     minQuantityNeedAdd > 1) {
                            //   quantityWillAdd = minQuantityNeedAdd;
                            // }
                            addToCart(
                              context,
                              quantity: 1,
                              product: item,
                            );
                          },
                          decreaseQuantityFunction: () {
                            if (quantity <= 0) return;
                            updateQuantity(
                              context: context,
                              quantity: quantity - 1,
                              product: item,
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );

    Widget productInfo = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ProductTitle(
          product: item,
          hide: config.hideTitle,
          maxLines: config.titleLine,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: ProductPricing(product: item, hide: config.hidePrice),
            ),
            CartIcon(
              config: config,
              quantity: 1,
              product: item,
            ),
          ],
        )
      ],
    );

    return GestureDetector(
      onTap: () => onTapProduct(context, product: item, config: config),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? width!),
            margin: EdgeInsets.symmetric(
              horizontal: config.hMargin,
              vertical: config.vMargin,
            ),
            width: width!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(config.borderRadius ?? 3),
              child: Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      Theme.of(context).cardColor,
                      Theme.of(context).primaryColor.withOpacity(0.5),
                      Theme.of(context).colorScheme.background,
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Container(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      productImage,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (config.borderRadius ?? 6) * 0.25,
                        ),
                        child: productInfo,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (config.showHeart && !item.isEmptyProduct())
            Positioned(
              top: 5,
              right: 5,
              child: HeartButton(product: item, size: 18),
            )
        ],
      ),
    );
  }
}
