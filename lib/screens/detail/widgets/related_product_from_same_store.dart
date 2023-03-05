import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, Product;
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../../../services/index.dart';
import '../../../widgets/product/product_card_view.dart';

class RelatedProductFromSameStore extends StatefulWidget {
  final Product? product;
  final EdgeInsets? padding;

  const RelatedProductFromSameStore(
    this.product, {
    this.padding,
  });

  @override
  State<RelatedProductFromSameStore> createState() =>
      _RelatedProductFromSameStoreState();
}

class _RelatedProductFromSameStoreState
    extends State<RelatedProductFromSameStore> {
  final _memoizer = AsyncMemoizer<List<Product>?>();

  final services = Services();

  Future<List<Product>?> getProductsFromSameStore(context) =>
      _memoizer.runOnce(() {
        return services.api.getProductsByStore(
            page: 1,
            storeId: widget.product?.store?.id,
            catId: int.tryParse(widget.product!.categoryId.toString()),
            lang: Provider.of<AppModel>(context).langCode);
      });

  @override
  Widget build(BuildContext context) {
    if (widget.product?.store?.id == null) {
      return const SizedBox();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return FutureBuilder<List<Product>?>(
            future: getProductsFromSameStore(context),
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
                    var storeName =
                        widget.product?.store?.name ?? S.of(context).store;
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
                            S.of(context).moreFromStore(storeName),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: constraint.maxWidth * 0.75,
                          child: ListView(
                            shrinkWrap: true,
                            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
                            cacheExtent: MediaQuery.of(context).size.width,
                            scrollDirection: Axis.horizontal,
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
