import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/search_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/product/product_simple_view.dart';

class SearchResultsCustom extends StatefulWidget {
  final String name;

  const SearchResultsCustom({required this.name});

  @override
  State<SearchResultsCustom> createState() => _SearchResultsCustomState();
}

class _SearchResultsCustomState extends State<SearchResultsCustom> {
  final _refreshController = RefreshController();

  SearchModel get _searchModel =>
      Provider.of<SearchModel>(context, listen: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserModel>(context, listen: false).user?.id;
    return Consumer<SearchModel>(
      builder: (_, model, __) {
        final products = model.products;

        if (products == null) {
          return kLoadingWidget(context);
        }

        if (products.isEmpty) {
          return Center(
            child: Text(S.of(context).noProduct),
          );
        }

        return SmartRefresher(
          header: MaterialClassicHeader(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          controller: _refreshController,
          enablePullUp: !model.isEnd,
          enablePullDown: false,
          onRefresh: () => _searchModel.refresh(userId: userId),
          onLoading: () => _searchModel.loadProduct(
              name: widget.name,
              userId: userId,
              controller: _refreshController),
          footer: kCustomFooter(context),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductSimpleView(
                item: product,
                isFromSearchScreen: true,
              );
            },
          ),
        );
      },
    );
  }
}
