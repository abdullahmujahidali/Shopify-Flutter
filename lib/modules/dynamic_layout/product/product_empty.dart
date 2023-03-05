import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product, ProductModel;
import '../../../widgets/product/product_card_view.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';

class EmptyProductList extends StatelessWidget {
  final ProductConfig config;
  final double maxWidth;

  const EmptyProductList(
      {Key? key, required this.config, required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ratioProductImage = config.imageRatio;

    var layout = config.layout ?? Layout.threeColumn;

    var productWidth = Layout.buildProductWidth(
      screenWidth: maxWidth,
      layout: layout,
    );
    var productHeight =
        productWidth * ratioProductImage + config.productListItemHeight;

    if (ratioProductImage < 1) {
      productHeight = productHeight * (ratioProductImage * 1.2);
    }

    return Column(
      children: <Widget>[
        HeaderView(
          headerText: config.name ?? '',
          showSeeAll: false,
          callback: () => ProductModel.showList(
            config: config.jsonData,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: productHeight,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10.0),
                for (var i = 0;
                    i < Layout.getColumnCount(layout: config.layout);
                    i++)
                  ProductCard(
                    item: Product.empty(i.toString()),
                    width: productWidth,
                    maxWidth: Layout.buildProductMaxWidth(
                        context: context, layout: config.layout),
                    config: ProductConfig.empty()
                      ..imageRatio = ratioProductImage,
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class EmptyProductTile extends StatelessWidget {
  final double maxWidth;

  const EmptyProductTile({Key? key, required this.maxWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (var i = 0; i < 4; i++)
          SizedBox(
            width: maxWidth,
            child: ListTile(
              leading: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 4.0),
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.2),
              ),
              title: Container(
                width: 70,
                height: 30,
                color: Colors.grey.withOpacity(0.1),
              ),
              dense: false,
            ),
          ),
      ],
    );
  }
}

class EmptyProductGrid extends StatelessWidget {
  final ProductConfig config;
  final double maxWidth;
  final double maxHeight;

  const EmptyProductGrid({
    Key? key,
    required this.config,
    required this.maxHeight,
    required this.maxWidth,
  }) : super(key: key);

  double getGridRatio() {
    switch (config.layout) {
      case Layout.twoColumn:
        return 1.5;
      case Layout.threeColumn:
      default:
        return 1.7;
    }
  }

  @override
  Widget build(BuildContext context) {
    const padding = 12.0;
    var ratioProductImage = config.imageRatio;
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

    final numOfProduct = rows * Layout.getColumnCount(layout: config.layout);

    /// Not create a new row until the item is out of the screen.
    if (numOfProduct * productWidth * ratioProductImage <= gridWidth ||
        rows < 1) {
      rows = 1;
    }

    return Column(
      children: <Widget>[
        HeaderView(
          headerText: config.name ?? '',
          showSeeAll: false,
          callback: () => ProductModel.showList(
            config: config.jsonData,
          ),
        ),
        Container(
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
            crossAxisCount: rows,
            children: [
              for (var i = 0; i < numOfProduct; i++)
                ProductCard(
                  item: Product.empty(i.toString()),
                  width: productWidth,
                  maxWidth: Layout.buildProductMaxWidth(
                      context: context, layout: config.layout),
                  config: ProductConfig.empty()..imageRatio = ratioProductImage,
                )
            ],
          ),
        ),
      ],
    );
  }
}
