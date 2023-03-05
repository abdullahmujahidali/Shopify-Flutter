import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product, ProductModel;
import '../../../widgets/common/flux_image.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';
import 'future_builder.dart';
import 'product_grid.dart';
import 'product_list_default.dart';
import 'product_list_tile.dart';
import 'product_staggered.dart';

class ProductList extends StatelessWidget {
  final ProductConfig config;
  final bool cleanCache;

  const ProductList({
    required this.config,
    required this.cleanCache,
    Key? key,
  }) : super(key: key);

  bool isShowCountDown() {
    final isSaleOffLayout = config.layout == Layout.saleOff;
    return config.showCountDown && isSaleOffLayout;
  }

  int getCountDownDuration(List<Product>? data,
      [bool isSaleOffLayout = false]) {
    if (isShowCountDown() && data!.isNotEmpty) {
      return (DateTime.tryParse(data.first.dateOnSaleTo ?? '')
                  ?.millisecondsSinceEpoch ??
              0) -
          (DateTime.now().millisecondsSinceEpoch);
    }
    return 0;
  }

  Widget getProductLayout({maxWidth, maxHeight, products}) {
    switch (config.layout) {
      case Layout.listTile:
        return ProductListTitle(
          products: products,
          config: config..showCountDown = isShowCountDown(),
        );
      case Layout.staggered:
        return ProductStaggered(
          products: products,
          width: maxWidth,
        );

      default:
        return config.rows > 1
            ? ProductGrid(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                products: products,
                config: config..showCountDown = isShowCountDown(),
              )
            : ProductListDefault(
                maxWidth: maxWidth,
                products: products,
                config: config..showCountDown = isShowCountDown(),
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRecentLayout = config.layout == Layout.recentView;
    final isSaleOffLayout = config.layout == Layout.saleOff;

    return ProductFutureBuilder(
      config: config,
      cleanCache: cleanCache,
      child: ({maxWidth, maxHeight, products}) {
        final duration = getCountDownDuration(products, isSaleOffLayout);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (config.image != null && config.image != '')
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: FluxImage(
                  imageUrl: config.image!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            if (config.name?.isNotEmpty ?? false)
              HeaderView(
                headerText: config.name ?? '',
                showSeeAll: isRecentLayout ? false : true,
                verticalMargin: config.image != null ? 6.0 : 10.0,
                callback: () => ProductModel.showList(
                  config: config.jsonData,
                  products: products,
                  showCountdown: isShowCountDown() && duration > 0,
                  countdownDuration: Duration(milliseconds: duration),
                ),
                showCountdown: isShowCountDown() && duration > 0,
                countdownDuration: Duration(milliseconds: duration),
              ),
            getProductLayout(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              products: products,
            ),
          ],
        );
      },
    );
  }
}
