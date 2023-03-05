import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show
        AppModel,
        CategoryModel,
        FilterAttributeModel,
        Product,
        ProductModel,
        TagModel,
        UserModel;
import '../../modules/dynamic_layout/helper/countdown_timer.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../modules/dynamic_layout/index.dart';
import '../../services/index.dart';
import '../../widgets/asymmetric/asymmetric_view.dart';
import '../../widgets/backdrop/backdrop.dart';
import '../../widgets/backdrop/backdrop_menu.dart';
import '../../widgets/product/product_bottom_sheet.dart';
import '../../widgets/product/product_list.dart';
import '../common/app_bar_mixin.dart';
import 'filter_mixin/products_filter_mixin.dart';
import 'products_backdrop.dart';
import 'products_flatview.dart';
import 'products_mixin.dart';
import 'widgets/category_menu.dart';

class ProductsScreen extends StatefulWidget {
  final List<Product>? products;
  final ProductConfig? config;
  final Duration countdownDuration;
  final String? listingLocation;
  final bool enableSearchHistory;
  final String? routeName;
  final bool autoFocusSearch;

  const ProductsScreen({
    this.products,
    this.countdownDuration = Duration.zero,
    this.listingLocation,
    this.config,
    this.enableSearchHistory = false,
    this.routeName,
    this.autoFocusSearch = true,
  });

  @override
  State<StatefulWidget> createState() {
    return ProductsScreenState();
  }
}

class ProductsScreenState extends State<ProductsScreen>
    with
        SingleTickerProviderStateMixin,
        AppBarMixin,
        ProductsMixin,
        ProductsFilterMixin {
  late AnimationController _controller;

  bool get hasAppBar => showAppBar(widget.routeName ?? RouteList.backdrop);

  ProductConfig get productConfig => widget.config ?? ProductConfig.empty();

  @override
  bool get enableSearchHistory => widget.enableSearchHistory;

  @override
  CategoryModel get categoryModel =>
      Provider.of<CategoryModel>(context, listen: false);

  TagModel get tagModel => Provider.of<TagModel>(context);

  ProductModel get productModel =>
      Provider.of<ProductModel>(context, listen: false);

  @override
  FilterAttributeModel get filterAttrModel =>
      Provider.of<FilterAttributeModel>(context, listen: false);

  UserModel get userModel => Provider.of<UserModel>(context, listen: false);

  AppModel get appModel => Provider.of<AppModel>(context, listen: false);

  /// Image ratio from Product Cart
  double get ratioProductImage => appModel.ratioProductImage;

  double get productListItemHeight => kProductDetail.productListItemHeight;

  bool get enableProductBackdrop => kAdvanceConfig.enableProductBackdrop;

  bool get showBottomCornerCart => kAdvanceConfig.showBottomCornerCart;

  List<Product>? products = [];
  String? errMsg;

  String _currentTitle = '';

  String get currentTitle =>
      search != null ? S.of(context).results : _currentTitle;

  @override
  void initState() {
    super.initState();
    initFilter(config: productConfig);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );

    Services().firebase.firebaseAnalytics?.logViewItemList(
          itemListId: productModel.categoryId ?? productModel.tagId?.toString(),
          itemListName: productModel.categoryName,
          data: widget.products,
        );

    /// only request to server if there is empty config params
    // / If there is config, load the products one
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        resetFilter();
        onRefresh();
      }
    });
  }

  @override
  void clearProductList() {
    productModel.setProductsList([]);
  }

  @override
  Future<void> getProductList() async {
    await productModel.getProductsList(
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
      lang: appModel.langCode,
      orderBy: filterSortBy.orderByType?.name,
      order: filterSortBy.orderType?.name,
      featured: filterSortBy.featured,
      onSale: filterSortBy.onSale,
      tagId: tagId,
      attribute: attribute,
      attributeTerm: getAttributeTerm(),
      userId: userModel.user?.id,
      listingLocation: listingLocationId,
      include: include,
      search: search,
    );
  }

  ProductBackdrop backdrop({
    products,
    isFetching,
    errMsg,
    isEnd,
    width,
    required String layout,
  }) {
    return ProductBackdrop(
      backdrop: Backdrop(
        hasAppBar: hasAppBar,
        bgColor: productConfig.backgroundColor,
        frontLayer: layout.isListView
            ? ProductList(
                products: products,
                onRefresh: onRefresh,
                onLoadMore: onLoadMore,
                isFetching: isFetching,
                errMsg: errMsg,
                isEnd: isEnd,
                layout: layout,
                ratioProductImage: ratioProductImage,
                productListItemHeight: productListItemHeight,
                width: width,
              )
            : AsymmetricView(
                products: products,
                isFetching: isFetching,
                isEnd: isEnd,
                onLoadMore: onLoadMore,
                width: width),
        backLayer: BackdropMenu(
          onFilter: onFilter,
          categoryId: categoryId,
          tagId: tagId,
          sortBy: filterSortBy,
          listingLocationId: listingLocationId,
        ),
        frontTitle: productConfig.showCountDown
            ? Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentTitle),
                      CountDownTimer(widget.countdownDuration)
                    ],
                  ),
                ],
              )
            : Text(currentTitle),
        backTitle: Text(S.of(context).filter),
        controller: _controller,
        appbarCategory: ProductCategoryMenu(
          enableSearchHistory: widget.enableSearchHistory,
          newCategoryId: categoryId,
          onTap: (categoryId) {
            include = null;
            onFilter(categoryId: categoryId);
          },
        ),
        onTapShareButton: () async {
          await shareProductsLink(context);
        },
      ),
      expandingBottomSheet: (Services().widget.enableShoppingCart(null) &&
              !ServerConfig().isListingType &&
              kAdvanceConfig.showBottomCornerCart)
          ? ExpandingBottomSheet(hideController: _controller)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentTitle = productConfig.name ??
        productModel.categoryName ??
        S.of(context).results;

    Widget buildMain = LayoutBuilder(
      builder: (context, constraint) {
        return FractionallySizedBox(
          widthFactor: 1.0,
          child: Selector<AppModel, String>(
            selector: (context, provider) => provider.productListLayout,
            builder: (context, productListLayout, child) {
              /// override the layout to listTile if enableSearchUX
              /// otherwise, using default productListLayout from the Config
              var layout = widget.enableSearchHistory
                  ? Layout.simpleList
                  : productListLayout;

              return ListenableProvider.value(
                value: productModel,
                child: Consumer<ProductModel>(
                  builder: (context, model, child) {
                    var backdropLayout = enableProductBackdrop;

                    if (!backdropLayout) {
                      var currentCategory =
                          categoryModel.categoryList[productModel.categoryId];

                      return ProductFlatView(
                        hasAppBar: hasAppBar,
                        autoFocusSearch: widget.autoFocusSearch,
                        enableSearchHistory: widget.enableSearchHistory,
                        builder: layout.isListView
                            ? ProductList(
                                products: model.productsList,
                                onRefresh: onRefresh,
                                onLoadMore: onLoadMore,
                                isFetching: model.isFetching,
                                errMsg: model.errMsg,
                                isEnd: model.isEnd,
                                layout: layout,
                                ratioProductImage: ratioProductImage,
                                productListItemHeight: productListItemHeight,
                                width: constraint.maxWidth,
                                appbar: renderFilters(context),
                                header: [
                                  ProductCategoryMenu(
                                    imageLayout: true,
                                    enableSearchHistory:
                                        widget.enableSearchHistory,
                                    newCategoryId: categoryId,
                                    onTap: (categoryId) {
                                      include = null;
                                      onFilter(categoryId: categoryId);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 25),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              currentTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    height: 0.6,
                                                  ),
                                            ),
                                            const Spacer(),
                                            if ((currentCategory
                                                            ?.totalProduct ??
                                                        0) >
                                                    0 &&
                                                model.enableCounting()) ...[
                                              Text(
                                                '${currentCategory!.totalProduct} ${S.of(context).items}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                    ),
                                              ),
                                              const SizedBox(width: 5),
                                            ]
                                          ],
                                        ),
                                        if (productConfig.showCountDown) ...[
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                S
                                                    .of(context)
                                                    .endsIn('')
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                          .withOpacity(0.8),
                                                    )
                                                    .apply(fontSizeFactor: 0.6),
                                              ),
                                              CountDownTimer(
                                                  widget.countdownDuration),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : AsymmetricView(
                                products: model.productsList,
                                isFetching: model.isFetching,
                                isEnd: model.isEnd,
                                onLoadMore: onLoadMore,
                                width: constraint.maxWidth),
                        titleFilter:
                            layout.isListView ? null : renderFilters(context),
                        onFilter: onFilter,
                        onSearch: (String searchText) => {
                          onFilter(
                            minPrice: minPrice,
                            maxPrice: maxPrice,
                            categoryId: categoryId,
                            tagId: tagId,
                            listingLocationId: listingLocationId,
                            search: searchText,
                          )
                        },
                        bottomSheet: (Services()
                                    .widget
                                    .enableShoppingCart(null) &&
                                !ServerConfig().isListingType &&
                                showBottomCornerCart)
                            ? ExpandingBottomSheet(hideController: _controller)
                            : null,
                      );
                    }
                    return backdrop(
                      products: model.productsList,
                      isFetching: model.isFetching,
                      errMsg: model.errMsg,
                      isEnd: model.isEnd,
                      width: constraint.maxWidth,
                      layout: layout,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );

    buildMain = renderScaffold(
      routeName: widget.routeName ?? RouteList.backdrop,
      child: buildMain,
    );

    return kIsWeb
        ? WillPopScope(
            onWillPop: () async {
              eventBus.fire(const EventOpenCustomDrawer());
              // LayoutWebCustom.changeStateMenu(true);
              Navigator.of(context).pop();
              return false;
            },
            child: buildMain,
          )
        : buildMain;
  }

  @override
  String get lang => appModel.langCode;

  @override
  void onCategorySelected(String name) {
    productModel.categoryName = name;
    _currentTitle = name;
  }

  @override
  void onCloseFilter() {
    _controller.forward();
  }

  @override
  void rebuild() {
    setState(() {});
  }

  @override
  String get tagName => tagModel.getTagName(tagId);
}
