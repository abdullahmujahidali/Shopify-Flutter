import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Product, ProductVariation;

class SaleProgressBar extends StatelessWidget {
  final Product? product;
  final ProductVariation? productVariation;
  final double? width;
  final bool show;

  const SaleProgressBar({
    Key? key,
    this.product,
    this.width,
    this.show = false,
    this.productVariation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// If empty product we don't need to show
    if (!show ||
        product!.price == '0.0' ||
        product!.price == null ||
        product!.totalSales == null) {
      return const SizedBox();
    }

    var almostSoldOut = false;
    final stockQuantity =
        productVariation?.stockQuantity ?? product!.stockQuantity;
    final inStock = productVariation?.inStock ?? product!.inStock!;

    var progress = 0.9;

    var progressBackground = kSaleOffProduct.color != null
        ? HexColor(kSaleOffProduct.color).withOpacity(0.6)
        : Theme.of(context).primaryColor.withOpacity(0.6);
    var progressColor = kSaleOffProduct.color != null
        ? HexColor(kSaleOffProduct.color)
        : Theme.of(context).primaryColor;

    if (stockQuantity == null) {
      /// In case [stockQuantity] is null.
      /// Display total sales with 90 percent progress by default.
      progress = 0.9;
    } else {
      progress = (product!.totalSales! + stockQuantity) > 0
          ? product!.totalSales! / (product!.totalSales! + stockQuantity)
          : 0;
    }

    /// Apply 'Almost sold out' for product has less than 10% products in stock.
    /// Exclude the case when [stockQuantity] is null
    /// in which progress is set to 0.9 by default.
    if (inStock && stockQuantity != null && progress >= 0.9) {
      almostSoldOut = true;
    }

    var progressText = '';

    /// In stock. Display total sales.
    if ((inStock || ((stockQuantity ?? 0) > 0)) &&
        product!.totalSales != null) {
      progressText = S.of(context).sold(product!.totalSales!);
    }

    /// Almost Sold Out.
    if (almostSoldOut) {
      progressText = S.of(context).almostSoldOut;
    }

    /// Out of stock.
    if ((!inStock) || (stockQuantity == 0)) {
      progressText = S.of(context).outOfStock;
    }

    return Container(
      width: width! - 22,
      height: 20.0,
      margin: const EdgeInsets.only(bottom: 8.0),
      constraints: const BoxConstraints(maxWidth: 160),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 20.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: LinearProgressIndicator(
                  minHeight: 20.0,
                  value: progress,
                  backgroundColor: progressBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor,
                  ),
                ),
              ),
            ),
          ),
          if (almostSoldOut)
            const Positioned(
              left: -3,
              top: 0,
              bottom: 0,
              child: _FireIcon(),
            ),
          Positioned(
            top: 6,
            bottom: 2,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 10.0,
              child: Center(
                child: Text(
                  progressText,
                  style: Theme.of(context).textTheme.bodySmall!.apply(
                        color: Colors.white,
                        fontSizeFactor: 0.8,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FireIcon extends StatelessWidget {
  const _FireIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      width: 24.0,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned.fill(
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 24.0,
              color: Colors.redAccent,
            ),
          ),
          Positioned.fill(
            child: Icon(
              Icons.local_fire_department,
              size: 18.0,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
