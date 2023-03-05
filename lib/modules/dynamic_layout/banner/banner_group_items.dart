import 'package:flutter/material.dart';

import '../../../models/entities/product.dart';
import '../../../services/index.dart';
import '../../../widgets/product/product_simple_view.dart';
import '../helper/helper.dart';
import '../index.dart';

/// The Banner Group type to display the image as multi columns
class BannerGroupItems extends StatefulWidget {
  final BannerConfig config;
  final onTap;

  const BannerGroupItems({required this.config, required this.onTap, Key? key})
      : super(key: key);

  @override
  State<BannerGroupItems> createState() => _StateBannerGroupItems();
}

class _StateBannerGroupItems extends State<BannerGroupItems> {
  int? indexSelected;

  @override
  void initState() {
    super.initState();
    if (widget.config.items.isNotEmpty) {
      var firstItem = widget.config.items.first;
      if (firstItem.defaultShowProduct && firstItem.bannerWithProduct) {
        indexSelected = 0;
      }
    }
  }

  double? bannerPercent(context, width) {
    final screenSize = MediaQuery.of(context).size;
    return Helper.formatDouble(
        widget.config.height ?? 0.3 / (screenSize.height / width));
  }

  void onTap(int index, value) {
    var bannerItems = widget.config.items;
    var item = bannerItems[index];
    if (item.bannerWithProduct) {
      if (indexSelected == index) {
        setState(() {
          indexSelected = null;
        });
      } else {
        setState(() {
          indexSelected = index;
        });
      }
      return;
    }
    widget.onTap(value);
  }

  Future<Product?> getProductById(String id) async {
    try {
      return await Services().api.getProduct(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>?> getProductsByCategoryId() async {
    try {
      var bannerItems = widget.config.items;
      var item = bannerItems[indexSelected!];
      return await Services().api.fetchProductsByCategory(
            categoryId: item.categoryId?.toString(),
            page: 1,
          );
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List items = widget.config.items;
    final screenSize = MediaQuery.of(context).size;

    final boxFit = widget.config.fit;
    var headerHeight = 0.0;
    // var headerHeight = config.title != null
    //     ? config.title['height']  +
    //         (config['title']['marginTop'] ?? 0) +
    //         (config['title']['marginBottom'] ?? 0) +
    //         30
    //     : 0.0;

    return LayoutBuilder(builder: (context, constraint) {
      var bannerPercentWidth = bannerPercent(context, constraint.maxWidth)!;
      var height = screenSize.height * bannerPercentWidth;
      return Column(
        children: [
          Container(
            // color: Theme.of(context).backgroundColor,
            height: height + headerHeight,
            margin: EdgeInsets.only(
              left: widget.config.marginLeft,
              right: widget.config.marginRight,
              top: widget.config.marginTop,
              bottom: widget.config.marginBottom,
            ),
            child: Column(
              children: [
                if (widget.config.title != null)
                  HeaderText(config: widget.config.title!),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      for (int i = 0; i < items.length; i++)
                        Expanded(
                          child: BannerImageItem(
                            config: items[i],
                            boxFit: boxFit,
                            height: height,
                            onTap: (value) => onTap(i, value),
                            padding: widget.config.padding,
                            radius: widget.config.radius,
                            enableParallax: widget.config.enableParallax,
                            parallaxImageRatio:
                                widget.config.parallaxImageRatio,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (indexSelected != null)
            Builder(builder: (context) {
              var bannerItems = widget.config.items;
              var bannerSelected = bannerItems[indexSelected!];

              /// display with list products
              if (bannerSelected.products.isNotEmpty) {
                return Column(
                  children: List.generate(
                    bannerSelected.productLength,
                    (index) => FutureBuilder<Product?>(
                        future: getProductById(bannerSelected.products[index]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ProductSimpleView(
                              item: snapshot.data,
                              type: SimpleType.backgroundColor,
                              enableBackgroundColor: false,
                            );
                          }
                          return ProductSimpleView(
                            item: Product.empty(index.toString()),
                            type: SimpleType.backgroundColor,
                            enableBackgroundColor: false,
                          );
                        }),
                  ),
                );
              }

              /// display with category id
              return FutureBuilder<List<Product>?>(
                future: getProductsByCategoryId(),
                builder: (context, snapshot) {
                  var length = snapshot.data?.length ?? 0;
                  if (length > bannerSelected.productLength) {
                    length = bannerSelected.productLength;
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: List.generate(
                        length,
                        (index) => ProductSimpleView(
                          item: snapshot.data![index],
                          type: SimpleType.backgroundColor,
                          enableBackgroundColor: false,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: List.generate(
                      bannerSelected.productLength,
                      (index) => ProductSimpleView(
                        item: Product.empty(index.toString()),
                        type: SimpleType.backgroundColor,
                        enableBackgroundColor: false,
                      ),
                    ),
                  );
                },
              );
            }),
        ],
      );
    });
  }
}
