import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/tools.dart';
import '../../models/index.dart' show CartModel, Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/services.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show
        CartButton,
        CartIcon,
        CartQuantity,
        HeartButton,
        ProductImage,
        ProductOnSale,
        ProductPricing,
        ProductRating,
        ProductTitle,
        SaleProgressBar,
        StockStatus,
        StoreName;
import 'widgets/cart_button_with_quantity.dart';

class ProductCard extends StatefulWidget {
  final Product item;
  final double? width;
  final double? maxWidth;
  final bool hideDetail;
  final offset;
  final ProductConfig config;
  final onTapDelete;

  const ProductCard({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    this.hideDetail = false,
    required this.config,
    this.onTapDelete,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with ActionButtonMixin {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final width = (widget.maxWidth != null &&
            widget.width != null &&
            widget.width! > widget.maxWidth!)
        ? widget.maxWidth!
        : (widget.width ??
            Layout.buildProductMaxWidth(
                context: context, layout: widget.config.layout));

    /// use for Staged layout
    if (widget.hideDetail) {
      return ProductImage(
        width: width,
        product: widget.item,
        config: widget.config,
        ratioProductImage: widget.config.imageRatio,
        offset: widget.offset,
        onTapProduct: () =>
            onTapProduct(context, product: widget.item, config: widget.config),
      );
    }

    Widget productInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ProductTitle(
          product: widget.item,
          hide: widget.config.hideTitle,
          maxLines: widget.config.titleLine,
        ),
        StoreName(product: widget.item, hide: widget.config.hideStore),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.bottomLeft,
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProductPricing(
                          product: widget.item,
                          hide: widget.config.hidePrice,
                        ),
                        const SizedBox(height: 2),
                        StockStatus(
                            product: widget.item, config: widget.config),
                        ProductRating(
                          product: widget.item,
                          config: widget.config,
                        ),
                        SaleProgressBar(
                          width: widget.width,
                          product: widget.item,
                          show: widget.config.showCountDown,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              if (!widget.config.showQuantity) ...[
                Positioned(
                  left: context.isRtl ? 0 : null,
                  right: context.isRtl ? null : 0,
                  child: CartIcon(product: widget.item, config: widget.config),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
        CartQuantity(
          product: widget.item,
          config: widget.config,
          onChangeQuantity: (val) {
            setState(() {
              _quantity = val;
            });
          },
        ),
        if (widget.config.showCartButton &&
            Services().widget.enableShoppingCart(widget.item)) ...[
          const SizedBox(height: 6),
          CartButton(
            product: widget.item,
            hide: !widget.item.canBeAddedToCartFromList(
                enableBottomAddToCart: widget.config.enableBottomAddToCart),
            enableBottomAddToCart: widget.config.enableBottomAddToCart,
            quantity: _quantity,
          ),
        ],
      ],
    );

    return GestureDetector(
      onTap: () =>
          onTapProduct(context, product: widget.item, config: widget.config),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(maxWidth: widget.maxWidth ?? width),
        width: widget.width!,
        margin: EdgeInsets.symmetric(
          horizontal: widget.config.hMargin,
          vertical: widget.config.vMargin,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(widget.config.borderRadius ?? 3),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  if (widget.config.boxShadow != null)
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(
                        widget.config.boxShadow?.x ?? 0.0,
                        widget.config.boxShadow?.y ?? 0.0,
                      ),
                      blurRadius: widget.config.boxShadow?.blurRadius ?? 0.0,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(widget.config.borderRadius ?? 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: [
                        ProductImage(
                          width: width,
                          product: widget.item,
                          config: widget.config,
                          ratioProductImage: widget.config.imageRatio,
                          offset: widget.offset,
                          onTapProduct: () => onTapProduct(context,
                              product: widget.item, config: widget.config),
                        ),
                        if (widget.config.showCartButtonWithQuantity &&
                            widget.item.canBeAddedToCartFromList(
                              enableBottomAddToCart:
                                  widget.config.enableBottomAddToCart,
                            ) &&
                            Services().widget.enableShoppingCart(widget.item))
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Selector<CartModel, int>(
                                selector: (context, cartModel) =>
                                    cartModel.productsInCart[widget.item.id] ??
                                    0,
                                builder: (context, quantity, child) {
                                  return CartButtonWithQuantity(
                                    quantity: quantity,
                                    borderRadiusValue:
                                        widget.config.cartIconRadius,
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
                                        product: widget.item,
                                      );
                                    },
                                    decreaseQuantityFunction: () {
                                      if (quantity <= 0) return;
                                      updateQuantity(
                                        context: context,
                                        quantity: quantity - 1,
                                        product: widget.item,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.config.hPadding,
                        vertical: widget.config.vPadding,
                      ),
                      child: productInfo,
                    ),
                  ],
                ),
              ),
            ),
            ProductOnSale(
              product: widget.item,
              config: widget.config,
              margin: const EdgeInsets.all(0),
            ),
            if (widget.config.showHeart && !widget.item.isEmptyProduct())
              Positioned(
                right: context.isRtl ? null : widget.config.hMargin,
                left: context.isRtl ? widget.config.hMargin : null,
                child: HeartButton(
                  product: widget.item,
                  size: 18,
                ),
              ),
            if (widget.onTapDelete != null)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: widget.onTapDelete,
                ),
              )
          ],
        ),
      ),
    );
  }
}
