import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../common/tools.dart';
import '../../models/index.dart' show CartModel, Product;
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../product/action_button_mixin.dart';

class ProductCard extends StatelessWidget with ActionButtonMixin {
  const ProductCard({this.imageAspectRatio = 33 / 49, this.product})
      : assert(imageAspectRatio > 0);

  final double imageAspectRatio;
  final Product? product;

  static const kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addProductToCart = Provider.of<CartModel>(context).addProductToCart;
    final currency = Provider.of<CartModel>(context).currencyCode;
    final currencyRates = Provider.of<CartModel>(context).currencyRates;
    final imageWidget = ImageResize(
        url: product!.imageFeature, isResize: true, fit: BoxFit.cover);

    return GestureDetector(
      onTap: () => onTapProduct(context, product: product!),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: imageAspectRatio,
                child: imageWidget,
              ),
              SizedBox(
                height: kTextBoxHeight * MediaQuery.of(context).textScaleFactor,
//                width: 140.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product == null ? '' : product!.name!,
                      style: theme.textTheme.labelLarge,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      product == null
                          ? ''
                          : PriceTools.getPriceProduct(
                              product, currencyRates, currency)!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!ServerConfig().isListingType &&
              product!.canBeAddedToCartFromList() &&
              Services().widget.enableShoppingCart(product))
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  addProductToCart(product: product);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class TwoProductCardColumn extends StatelessWidget {
  const TwoProductCardColumn({
    required Product this.bottom,
    this.top,
    // ignore: prefer_asserts_with_message
  });

  final Product? bottom, top;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const spacerHeight = 44.0;

        var heightOfCards = (constraints.biggest.height - spacerHeight) / 2.0;
        var heightOfImages = heightOfCards - ProductCard.kTextBoxHeight;
        var imageAspectRatio = (heightOfImages >= 0.0 &&
                constraints.biggest.width > heightOfImages)
            ? constraints.biggest.width / heightOfImages
            : 33 / 49;

        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 28.0),
              child: top != null
                  ? ProductCard(
                      imageAspectRatio: imageAspectRatio,
                      product: top,
                    )
                  : SizedBox(
                      height: heightOfCards > 0 ? heightOfCards : spacerHeight,
                    ),
            ),
            const SizedBox(height: spacerHeight),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 28.0),
              child: ProductCard(
                imageAspectRatio: imageAspectRatio,
                product: bottom,
              ),
            ),
          ],
        );
      },
    );
  }
}

class OneProductCardColumn extends StatelessWidget {
  const OneProductCardColumn({this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      children: <Widget>[
        const SizedBox(height: 40.0),
        ProductCard(
          product: product,
        ),
      ],
    );
  }
}
