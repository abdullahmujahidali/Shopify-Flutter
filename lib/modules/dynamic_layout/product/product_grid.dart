import 'package:flutter/material.dart';

import '../../../services/index.dart';
import '../config/product_config.dart';
import '../helper/custom_physic.dart';
import '../helper/helper.dart';

class ProductGrid extends StatelessWidget {
  final products;
  final maxWidth;
  final maxHeight;
  final ProductConfig config;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.maxWidth,
    required this.maxHeight,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productList = products;
    if (productList == null || productList is! List || productList.isEmpty) {
      return const SizedBox();
    }
    const padding = 12.0;
    final ratioProductImage = config.imageRatio;
    final gridWidth = maxWidth - padding;

    var rows = config.rows;
    var productWidth = Layout.buildProductWidth(
      screenWidth: gridWidth,
      layout: config.layout,
    );
    var productHeight =
        productWidth * ratioProductImage + config.productListItemHeight;

    if (ratioProductImage < 1) {
      productHeight = productHeight * (ratioProductImage * 1.2);
    }

    // Check if Gridview is overflowed
    for (var i = config.rows; i > 0; i--) {
      if (productHeight * i > maxHeight) {
        rows = i - 1;
      }
    }

    /// Not create a new row until the item is out of the screen.
    if (products.length * productWidth * ratioProductImage <= gridWidth ||
        rows < 1) {
      rows = 1;
    }

    return Container(
      padding: const EdgeInsets.only(left: padding, top: padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(2),
      ),
      constraints: BoxConstraints(
        minHeight: productHeight,
        maxHeight: maxHeight,
      ),
      height: rows * productHeight,
      child: GridView.count(
        childAspectRatio:
            (ratioProductImage * (ratioProductImage < 1 ? 1.5 : 1)) *
                getGridRatio(),
        scrollDirection: Axis.horizontal,
        physics: config.isSnapping ?? false
            ? CustomScrollPhysic(
                width: Layout.buildProductWidth(
                  screenWidth: gridWidth / ratioProductImage,
                  layout: config.layout,
                ),
              )
            : const ScrollPhysics(),
        crossAxisCount: rows,
        children: List.generate(productList.length, (i) {
          return Services().widget.renderProductCardView(
                item: productList[i],
                width: productWidth,
                maxWidth: Layout.buildProductMaxWidth(
                    context: context, layout: config.layout),
                ratioProductImage: ratioProductImage,
                config: config,
              );
        }),
      ),
    );
  }

  double getGridRatio() {
    switch (config.layout) {
      case Layout.twoColumn:
        return 1.5;
      case Layout.threeColumn:
      default:
        return 1.7;
    }
  }
}
