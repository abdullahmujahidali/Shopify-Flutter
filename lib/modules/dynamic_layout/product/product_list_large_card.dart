import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../models/index.dart' show BackDropArguments, Product;
import '../../../routes/flux_navigate.dart';
import '../../../widgets/product/action_button_mixin.dart';
import '../../../widgets/product/index.dart';
import '../helper/helper.dart';
import '../index.dart';
import 'future_builder.dart';

class ProductListLargeCard extends StatelessWidget {
  final ProductConfig config;

  const ProductListLargeCard({required this.config, Key? key})
      : super(key: key);

  Widget getProductListWidgets(List<Product> products) {
    return Row(
      children: [
        const SizedBox(width: 10.0),
        for (var item in products)
          LargeProductCard(
            config: config,
            item: item,
            width: Helper.formatDouble(config.imageWidth),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProductFutureBuilder(
      config: config,
      waiting: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < 3; i++)
                LargeProductCard(
                  config: config,
                  item: Product.empty(i.toString()),
                  width: Helper.formatDouble(config.imageWidth),
                ),
            ],
          ),
        ),
      ),
      child: ({maxWidth, maxHeight, products}) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              HeaderView(
                headerText: config.name ?? ' ',
                showSeeAll: true,
                callback: () => FluxNavigate.pushNamed(
                  RouteList.backdrop,
                  arguments: BackDropArguments(
                    config: config.toJson(),
                    data: null,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: config.hPadding,
                  vertical: config.vPadding,
                ),
                child: Row(
                  children: List.generate(
                    products.length,
                    (index) => LargeProductCard(
                      config: config,
                      key: Key('imageWidth-${config.imageWidth}-$index'),
                      item: products[index],
                      width: Helper.formatDouble(config.imageWidth),
                      maxWidth: maxWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LargeProductCard extends StatelessWidget with ActionButtonMixin {
  final ProductConfig? config;
  final Product? item;
  final double? width;
  final double? maxWidth;

  const LargeProductCard({
    this.item,
    this.width,
    Key? key,
    this.config,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var columns = Tools.isPhone(MediaQuery.of(context)) ? 2.0 : 3.0;
    var imageWidth = width ?? (maxWidth ?? screenWidth) / columns;
    var priceFontSize = imageWidth / 12.0;
    var titleFontSize = imageWidth / 10.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () => onTapProduct(context, product: item!, config: config),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: ImageResize(
                url: item!.imageFeature,
                width: imageWidth,
                size: kSize.medium,
                isResize: true,
                height: imageWidth * 1.7,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: imageWidth,
              height: imageWidth * 1.7,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                    colors: [Colors.black54, Colors.black26, Colors.black12],
                    stops: [0.4, 0.7, 0.9],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: imageWidth,
                  ),
                  width: imageWidth - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        item!.name!,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: imageWidth / 35,
                      ),
                      ProductPricing(
                        product: item!,
                        hide: config?.hidePrice ?? false,
                        priceTextStyle: TextStyle(
                          fontSize: priceFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
