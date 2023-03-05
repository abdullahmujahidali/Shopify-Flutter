import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/index.dart' show Product;
import '../../../widgets/product/product_card_view.dart';
import '../config/product_config.dart';

var _staggeredTiles = const [
  StaggeredGridTile.count(
    crossAxisCellCount: 2,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 3,
    mainAxisCellCount: 2,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
  StaggeredGridTile.count(
    crossAxisCellCount: 1,
    mainAxisCellCount: 1,
    child: SizedBox(),
  ),
];

class ProductStaggered extends StatelessWidget {
  final List<Product>? products;
  final double width;

  const ProductStaggered({Key? key, this.products, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? size = width / 3;
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 15.0),
      height: screenSize.height * 0.8 / (screenSize.height / width),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: [
            for (var i = 0; i < products!.length; i++)
              StaggeredGridTile.count(
                crossAxisCellCount: _staggeredTiles[i % 6].crossAxisCellCount,
                mainAxisCellCount: _staggeredTiles[i % 6].mainAxisCellCount!,
                child: ProductCard(
                  width: size * _staggeredTiles[i % 6].mainAxisCellCount!,
                  item: products![i],
                  hideDetail: true,
                  config: ProductConfig.empty(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
