import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, Product;
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../../../services/index.dart';
import '../../../widgets/product/product_card_view.dart';

class RelatedProduct extends StatefulWidget {
  final Product? product;
  final EdgeInsets? padding;

  const RelatedProduct(
    this.product, {
    this.padding,
  });

  @override
  State<RelatedProduct> createState() => _RelatedProductState();
}

class _RelatedProductState extends State<RelatedProduct> {
  final _memoizer = AsyncMemoizer<List<Product>?>();

  final services = Services();

  Future<List<Product>?> getRelativeProducts(context) => _memoizer.runOnce(() {
        return services.api.fetchProductsByCategory(
            page: 1,
            categoryId: widget.product!.categoryId,
            include: widget.product?.relatedIds,
            lang: Provider.of<AppModel>(context).langCode);
      });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return FutureBuilder<List<Product>?>(
            future: getRelativeProducts(context),
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return SizedBox(
                    height: 100,
                    child: kLoadingWidget(context),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          S.of(context).error(snapshot.error!),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    );
                  } else {
                    snapshot.data!.removeWhere(
                        (element) => element.id == widget.product!.id);
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 18.0,
                          ),
                          padding: widget.padding ??
                              const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                          child: Text(
                            S.of(context).youMightAlsoLike,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SingleChildScrollView(
                          padding: widget.padding ??
                              const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var item in snapshot.data!)
                                ProductCard(
                                  item: item,
                                  width: constraint.maxWidth * 0.35,
                                  config: ProductConfig.empty(),
                                )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              }
            },
          );
        },
      ),
    );
  }
}
