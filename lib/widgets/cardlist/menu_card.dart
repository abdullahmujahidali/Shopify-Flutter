import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../models/index.dart' show Category, Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../services/index.dart';
import 'list_card.dart';

class MenuCard extends StatefulWidget {
  final List<Category> categories;
  final Category category;

  const MenuCard(this.categories, this.category);

  @override
  State<MenuCard> createState() => _StateMenuCard();
}

class _StateMenuCard extends State<MenuCard> {
  int position = 0;
  int pColor = 0;
  List<List<Product>?> products = [];
  double _width = 0.0;
  int durations = 0;

  Future<List<Product>?> getProductFromCategory(
      {categoryId,
      minPrice,
      maxPrice,
      orderBy,
      order,
      lang,
      required page}) async {
    var service = Services();
    final product = await service.api.fetchProductsByCategory(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        orderBy: orderBy,
        order: order,
        lang: lang,
        page: page);
    return product;
  }

  Future<List<List<Product>?>> getAllListProducts({page = 1}) async {
    var products = <List<Product>?>[];
    var service = Services();
    for (var category in widget.categories) {
      var product = await service.api.fetchProductsByCategory(
        categoryId: category.id,
        page: page,
      );
      products.add(product);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var productHeight = kIsWeb
            ? constraints.maxWidth * 0.4
            : constraints.maxWidth * 0.4 +
                130 * ProductConfig.empty().imageRatio;

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.category.name!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              widget.categories.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 26,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              if (position == index) return;
                              setState(() {
                                _width = constraints.maxWidth - 50;
                                durations = 0;
                                pColor = index;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 50));
                              setState(() {
                                position = index;
                                durations = 200;
                                _width = 0.0;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: index == pColor
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: Center(
                                        child: index == pColor
                                            ? Text(
                                                widget.categories[index].name!,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                widget.categories[index].name!,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: widget.categories.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
              widget.categories.isEmpty
                  ? const SizedBox()
                  : Container(
                      height: 20,
                    ),
              FutureBuilder<List<List<Product>?>>(
                future: getAllListProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: productHeight,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(3, (index) {
                          return Services().widget.renderProductCardView(
                                item: Product.empty(index.toString()),
                                width: productHeight * 0.5,
                                config: ProductConfig.empty(),
                                ratioProductImage:
                                    ProductConfig.empty().imageRatio,
                              );
                        }),
                      ),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return FutureBuilder<List<Product>?>(
                      future: getProductFromCategory(
                          categoryId: widget.category.id, page: 1),
                      builder: (context, product) {
                        if (!product.hasData) {
                          return SizedBox(
                            height: productHeight,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(3, (index) {
                                return Services().widget.renderProductCardView(
                                      item: Product.empty(index.toString()),
                                      width: productHeight * 0.5,
                                      config: ProductConfig.empty(),
                                      ratioProductImage:
                                          ProductConfig.empty().imageRatio,
                                    );
                              }),
                            ),
                          );
                        }
                        return SizedBox(
                          height: productHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.data!.length,
                            itemBuilder: (context, index) {
                              return Services().widget.renderProductCardView(
                                    item: product.data![index],
                                    width: productHeight * 0.5,
                                    config: ProductConfig.empty(),
                                    ratioProductImage:
                                        ProductConfig.empty().imageRatio,
                                  );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox(
                    height: productHeight,
                    child: SingleChildScrollView(
                      child: Row(
                        children: <Widget>[
                          AnimatedContainer(
                            width: _width,
                            duration: Duration(milliseconds: durations),
                            decoration: const BoxDecoration(),
                          ),
                          Expanded(
                            child: ListCard(
                              data: snapshot.data![position],
                              width: constraints.maxWidth,
                              id: widget.categories[position].id,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
