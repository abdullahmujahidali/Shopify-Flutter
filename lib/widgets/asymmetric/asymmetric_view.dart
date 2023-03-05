import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../generated/l10n.dart';
import '../../models/index.dart' show Product;
import 'asymmetric_columns.dart';

class AsymmetricView extends StatefulWidget {
  final List<Product>? products;
  final Function? onLoadMore;
  final bool? isFetching;
  final bool? isEnd;
  final double? width;

  const AsymmetricView(
      {Key? key,
      this.products,
      this.isFetching,
      this.isEnd,
      this.onLoadMore,
      this.width});

  @override
  State<AsymmetricView> createState() => _AsymmetricViewState();
}

class _AsymmetricViewState extends State<AsymmetricView> {
  void _onLoading() async {
    if (!widget.isFetching! && !widget.isEnd!) {
      widget.onLoadMore?.call();
    }
  }

  List<Widget> _buildColumns(BuildContext context, List<Product>? products) {
    /// This will return a list of columns. It will oscillate between the two
    /// kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    /// TwoProductCardColumn and the odd cases will be OneProductCardColumn.
    ///
    /// Each pair of columns will advance us 3 products forward (2 + 1). That's
    /// some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    /// helpers for creating the index of the product list that will correspond
    /// to the index of the list of columns.
    var listItemCount = _listItemCount(products!.length);
    var productsList = List.generate(listItemCount, (int index) {
      var minWidth = math.min(widget.width!, 400);
      var width = .59 * minWidth;
      Widget column;
      if (index % 2 == 0) {
        /// Even cases
        var bottom = _evenCasesIndex(index);
        column = TwoProductCardColumn(
            bottom: products[bottom],
            top: products.length - 1 >= bottom + 1
                ? products[bottom + 1]
                : null);
        width += 32.0;
      } else {
        /// Odd cases
        column = OneProductCardColumn(
          product: products[_oddCasesIndex(index)],
        );
      }

      return SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: column,
        ),
      );
    }).toList();

    var loadingMore = VisibilityDetector(
      key: const Key('loading_visible'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.5) {
          _onLoading();
        }
      },
      child: Center(
        child: Text(S.of(context).loading),
      ),
    );

    if (widget.isEnd!) {
      return productsList;
    }
    return [...productsList, loadingMore];
  }

  int _evenCasesIndex(int input) {
    /// The operator ~/ is a cool one. It's the truncating division operator. It
    /// divides the number and if there's a remainder / decimal, it cuts it off.
    /// This is like dividing and then casting the result to int. Also, it's
    /// functionally equivalent to floor() in this case.
    return input ~/ 2 * 3;
  }

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    if (totalItems % 3 == 0) {
      return totalItems ~/ 3 * 2;
    } else {
      return (totalItems / 3).ceil() * 2 - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNoProduct = widget.products == null || widget.products!.isEmpty;
    final products = hasNoProduct && (widget.isFetching ?? false)
        ? [Product.empty('1'), Product.empty('2'), Product.empty('3')]
        : widget.products;

    if (widget.isEnd! && (products == null || products.isEmpty)) {
      return Center(
        child: Text(
          S.of(context).noProduct,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 16.0, 44.0),
      physics: const AlwaysScrollableScrollPhysics(),
      children: _buildColumns(context, products),
    );
  }
}
