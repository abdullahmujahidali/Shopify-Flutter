import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/index.dart' show AppModel, Product, RecentModel;
import '../../../models/user_model.dart';
import '../../../services/index.dart';
import '../config/product_config.dart';
import '../helper/helper.dart';
import 'product_empty.dart';

/// Handle the product network request, caching and empty product
class ProductFutureBuilder extends StatefulWidget {
  final ProductConfig config;
  final Function child;
  final Widget? waiting;
  final bool cleanCache;

  const ProductFutureBuilder({
    required this.config,
    this.waiting,
    required this.child,
    this.cleanCache = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductFutureBuilder> createState() => _ProductListLayoutState();
}

class _ProductListLayoutState extends State<ProductFutureBuilder> {
  ValueNotifier<List<Product>?> productsNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    if (productsNotifier.value != null) {
      return;
    }
    if (widget.config.layout == Layout.recentView) {
      context.read<RecentModel>().getRecentProduct();
      return;
    }
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        productsNotifier.value = await getProductLayout(context);
      }
    });
  }

  Future<List<Product>?> getProductLayout(BuildContext context) {
    // final startTime = DateTime.now();
    if (widget.config.layout == Layout.recentView) {
      return context.read<RecentModel>().getRecentProduct();
    }
    if (widget.config.layout == Layout.saleOff) {
      /// Fetch only onSale products for saleOff layout.
      widget.config.onSale = true;
    }
    final userId = Provider.of<UserModel>(context, listen: false).user?.id;

    var result = Services().api.fetchProductsLayout(
          config: widget.config.jsonData,
          lang: Provider.of<AppModel>(context, listen: false).langCode,
          userId: userId,
          refreshCache: widget.cleanCache,
        );
    // printLog('[getProductLayout]', startTime);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final recentProduct = Provider.of<RecentModel>(context).products;
    final isRecentLayout = widget.config.layout == Layout.recentView;
    final isSaleOffLayout = widget.config.layout == Layout.saleOff;
    if (isRecentLayout) {
      productsNotifier.value = context.select((RecentModel _) => _.products);
    }
    if (isRecentLayout && recentProduct.length < 3) return const SizedBox();

    return ValueListenableBuilder<List<Product>?>(
        valueListenable: productsNotifier,
        builder: (context, products, child) {
          return LayoutBuilder(
            builder: (context, constraint) {
              var maxWidth = Layout.isDisplayDesktop(context)
                  ? kMaxProductWidth
                  : constraint.maxWidth;

              //Do not include HeaderView height
              var maxHeight = constraint.maxHeight - 50;

              if (products == null) {
                if (widget.waiting != null) return widget.waiting!;

                return widget.config.layout == Layout.listTile
                    ? EmptyProductTile(maxWidth: maxWidth)
                    : widget.config.rows > 1
                        ? EmptyProductGrid(
                            config: widget.config,
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                          )
                        : EmptyProductList(
                            config: widget.config,
                            maxWidth: maxWidth,
                          );
              }

              /// Hide sale off layout when product list is empty.
              if (products.isEmpty &&
                  isSaleOffLayout &&
                  kSaleOffProduct.hideEmptySaleOffLayout) {
                return const SizedBox();
              }

              /// Hide section if product list is empty.
              if (widget.config.hideEmptyProductLayout && products.isEmpty) {
                return const SizedBox();
              }

              return widget.child(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                products: products,
              );
            },
          );
        });
  }
}
