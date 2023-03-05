import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/tools.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../cart/cart_screen.dart';
import 'products_mixin.dart';
import 'products_searchview.dart';

enum MenuType { cart, wishlist, share, login }

class ProductFlatView extends StatefulWidget {
  final Widget builder;
  final Widget? bottomSheet;
  final Widget? titleFilter;
  final Function? onSort;
  final Function onFilter;
  final Function onSearch;
  final bool enableSearchHistory;
  final bool autoFocusSearch;
  final bool hasAppBar;

  const ProductFlatView({
    required this.builder,
    required this.onSearch,
    this.bottomSheet,
    this.titleFilter,
    this.onSort,
    required this.onFilter,
    this.enableSearchHistory = false,
    this.autoFocusSearch = true,
    this.hasAppBar = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductFlatView> createState() => _ProductFlatViewState();
}

class _ProductFlatViewState extends State<ProductFlatView> with ProductsMixin {
  Color get labelColor => Colors.black;

  bool get isLoggedIn =>
      Provider.of<UserModel>(context, listen: false).loggedIn;

  PopupMenuItem<String> _buildMenuItem({
    required IconData icon,
    required String label,
    required String value,
    bool isSelect = false,
  }) {
    final menuItemStyle = TextStyle(
      fontSize: 13.0,
      color: isSelect
          ? Theme.of(context).primaryColor
          : Theme.of(context).colorScheme.secondary,
      height: 24.0 / 15.0,
    );
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(icon,
                color: isSelect
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                size: 17),
          ),
          Text(label, style: menuItemStyle),
        ],
      ),
    );
  }

  Future<void> _onSeeMore(MenuType type) async {
    switch (type) {
      case MenuType.cart:
        await Navigator.of(context).pushNamed(
          RouteList.cart,
          arguments: CartScreenArgument(isBuyNow: true, isModal: false),
        );
        break;
      case MenuType.share:
        await shareProductsLink(context);
        break;
      case MenuType.wishlist:
        await Navigator.of(context).pushNamed(RouteList.wishlist);
        break;
      case MenuType.login:
        await Navigator.of(context).pushNamed(RouteList.login);
        break;
    }
  }

  Widget _buildMoreWidget(bool loggedIn) {
    final sortByData = [
      if (Services().widget.enableShoppingCart(null) &&
          !ServerConfig().isListingType)
        {
          'type': MenuType.cart.name,
          'title': S.of(context).myCart,
          'icon': CupertinoIcons.bag,
        },
      {
        'type': MenuType.wishlist.name,
        'title': S.of(context).myWishList,
        'icon': CupertinoIcons.heart,
      },
      if (firebaseDynamicLinkConfig['isEnabled'] &&
          ServerConfig().isWooType &&
          !ServerConfig().isListingType)
        {
          'type': MenuType.share.name,
          'title': S.of(context).share,
          'icon': CupertinoIcons.share,
        },
      if (!loggedIn)
        {
          'type': MenuType.login.name,
          'title': S.of(context).login,
          'icon': CupertinoIcons.person,
        },
    ];

    return PopupMenuButton<String>(
      onSelected: (value) => _onSeeMore(MenuType.values.byName(value)),
      itemBuilder: (BuildContext context) =>
          List<PopupMenuItem<String>>.generate(
        sortByData.length,
        (index) => _buildMenuItem(
          icon: sortByData[index]['icon'] as IconData,
          label: '${sortByData[index]['title']}',
          value: '${sortByData[index]['type']}',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Icon(
          CupertinoIcons.ellipsis,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void onSearch(String value) {
    EasyDebounce.debounce('searchCategory', const Duration(milliseconds: 200),
        () => widget.onSearch(value));
  }

  Widget _getStickyWidget() {
    if (widget.titleFilter == null) return const SizedBox();

    return Container(
      alignment: Alignment.center,
      height: 44,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 2,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: widget.titleFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// using for the Search Screen UX
    if (widget.enableSearchHistory) {
      return ProductSearchView(
        hasAppBar: widget.hasAppBar,
        builder: widget.builder,
        onSearch: widget.onSearch,
        bottomSheet: widget.bottomSheet,
        titleFilter: widget.titleFilter,
        onSort: widget.onSort,
        onFilter: widget.onFilter,
        autoFocusSearch: widget.autoFocusSearch,
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          AppBar(
              primary: !widget.hasAppBar,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              leading: Navigator.of(context).canPop()
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.back),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              title: Padding(
                padding: EdgeInsets.only(
                    left: Navigator.of(context).canPop() ? 0 : 15),
                child: CupertinoSearchTextField(
                  onChanged: onSearch,
                  onSubmitted: onSearch,
                  placeholder: S.of(context).searchForItems,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              actions: [
                Selector<UserModel, bool>(
                  selector: (context, provider) => provider.loggedIn,
                  builder: (context, loggedIn, child) {
                    return _buildMoreWidget(loggedIn);
                  },
                ),
                const SizedBox(width: 4),
              ]),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    _getStickyWidget(),
                    Expanded(child: widget.builder),
                  ],
                ),
                Align(
                  alignment: Tools.isRTL(context)
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  child: widget.bottomSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
