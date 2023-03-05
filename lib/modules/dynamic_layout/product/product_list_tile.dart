import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product;
import '../../../services/index.dart';
import '../config/product_config.dart';

class ProductListTitle extends StatelessWidget {
  final List<Product>? products;
  final ProductConfig config;

  const ProductListTitle({this.products, required this.config});

  Widget renderProductItemTileView({required Product item, dynamic config}) {
    return Services().widget.renderProductItemTileView(
          item: item,
          config: config,
        );
  }

  @override
  Widget build(BuildContext context) {
    var productList = products ?? [];

    /// mark empty
    if (productList.isEmpty) {
      return const SizedBox(height: 200);
    }

    if (productList.length < 3) {
      return Column(
        children: List.generate(
          productList.length,
          (index) => renderProductItemTileView(
            item: productList[index],
            config: config,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: 220 * config.imageRatio * 3,
          ),
          width: constraints.maxWidth,
          height: (constraints.maxWidth + 180) * config.imageRatio,
          child: PageView(
            children: <Widget>[
              for (var i = 0; i < products!.length; i = i + 3)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: renderProductItemTileView(
                        item: products![i],
                        config: config,
                      ),
                    ),
                    if (i + 1 < products!.length)
                      Expanded(
                        child: renderProductItemTileView(
                          item: products![i + 1],
                          config: config,
                        ),
                      ),
                    if (i + 2 < products!.length)
                      Expanded(
                        child: renderProductItemTileView(
                          item: products![i + 2],
                          config: config,
                        ),
                      ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
