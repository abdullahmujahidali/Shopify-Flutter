import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../common/app_bar_mixin.dart';
import '../products/products_screen.dart';
import 'widgets/search_widget.dart';

class SearchScreen extends StatefulWidget {
  final bool isModal;
  final bool autoFocusSearch;

  const SearchScreen({
    Key? key,
    this.isModal = false,
    this.autoFocusSearch = true,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _StateSearchScreen();
}

class _StateSearchScreen extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen>, AppBarMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    printLog('[SearchScreen] build');
    super.build(context);

    /// Use the old Search UX config which is limit Filter
    if (kAdvanceConfig.enableProductBackdrop) {
      return SearchWidget(isModal: widget.isModal);
    }

    return ProductsScreen(
      enableSearchHistory: true,
      autoFocusSearch: widget.autoFocusSearch,
      config: ProductConfig.empty()..layout = Layout.listTile,
      routeName: RouteList.search,
    );
  }
}
