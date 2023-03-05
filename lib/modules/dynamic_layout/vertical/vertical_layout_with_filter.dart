import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/category/category_model.dart';
import '../../../models/filter_attribute_model.dart';
import '../../../models/index.dart'
    show AppModel, Product, ProductModel, TagModel;
import '../../../screens/common/app_bar_mixin.dart';
import '../../../screens/products/filter_mixin/products_filter_mixin.dart';
import '../../../services/index.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';

class VerticalViewLayoutWithFilter extends StatefulWidget {
  final ProductConfig config;

  const VerticalViewLayoutWithFilter({required this.config, Key? key})
      : super(key: key);

  @override
  State<VerticalViewLayoutWithFilter> createState() =>
      _VerticalViewLayoutWithFilterState();
}

class _VerticalViewLayoutWithFilterState
    extends State<VerticalViewLayoutWithFilter>
    with AppBarMixin, ProductsFilterMixin {
  final Services _service = Services();
  ValueNotifier<List<Product>> products = ValueNotifier<List<Product>>([]);
  ValueNotifier<bool> canLoad = ValueNotifier(true);
  bool loading = false;

  TagModel get tagModel => Provider.of<TagModel>(context);

  Future<void> _loadProduct() async {
    if (loading) return;
    if (!canLoad.value) return;
    dynamic config = ProductConfig.fromJson(widget.config.toJson());
    (config as ProductConfig).tag = tagId ?? config.tag;
    config.category = categoryId ?? config.category;
    config.order = order;
    config.orderby = orderBy;
    config.featured = featured;
    if (onSale != null) {
      config.onSale = onSale!;
    }
    config.include = include;
    config = config.toJson();
    config['attribute'] = attribute;
    config['attributeId'] = getAttributeTerm();
    config['minPrice'] = minPrice;
    config['maxPrice'] = maxPrice;
    config['page'] = page;
    loading = true;
    rebuild();
    var newProducts = await _service.api.fetchProductsLayout(
      config: config,
      lang: lang,
    );

    if (config['shuffle'] == true && filterSortBy.displayOrderBy == null) {
      newProducts?.shuffle();
    }

    if (newProducts == null || newProducts.isEmpty) {
      canLoad.value = false;
    }
    if (newProducts != null && newProducts.isNotEmpty) {
      products.value = [...products.value, ...newProducts];
    }
    page = page + 1;
    loading = false;
    rebuild();
  }

  @override
  void initState() {
    super.initState();
    initFilter(config: widget.config);

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        resetFilter();
        onRefresh();
      }
    });
  }

  bool get hasAppbar => showAppBar(RouteList.home) && (appBar?.pinned ?? false);

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final isTablet = Helper.isTablet(query);
    var column = isTablet ? 3 : 2;

    return StickyHeaderBuilder(
      builder: (BuildContext context, double stuckAmount) {
        return SafeArea(
          top: stuckAmount <= 0.0 ? true : false,
          bottom: false,
          //BUG: https://tppr.me/e7ugh, file https://www.dropbox.com/s/nsnp1piztle5ybp/18916%20Archivo%20comprimido.zip?dl=0
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.config.name != null)
                HeaderView(
                  headerText: widget.config.name ?? '',
                  showSeeAll: !ServerConfig().isListingType,
                  callback: () => ProductModel.showList(
                    config: widget.config.jsonData,
                  ),
                ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      if (stuckAmount <= 0.0)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: renderFilters(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      content: LimitedBox(
        maxHeight: query.size.height - query.padding.vertical,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(top: 16.0),
              sliver: SliverPadding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.config.vPadding,
                  horizontal: widget.config.hPadding,
                ),
                sliver: ValueListenableBuilder<List<Product>>(
                  valueListenable: products,
                  builder: (context, value, child) {
                    var rows = value.length ~/ column;
                    if (rows * column < value.length) rows++;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        addAutomaticKeepAlives: false,
                        childCount: rows,
                        (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              column,
                              (indexColumn) {
                                return Expanded(
                                  child: index * column + indexColumn <
                                          value.length
                                      ? LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Services()
                                                  .widget
                                                  .renderProductCardView(
                                                    item: value[index * column +
                                                        indexColumn],
                                                    width: constraints.maxWidth,
                                                    config: widget.config,
                                                    ratioProductImage: widget
                                                        .config.imageRatio,
                                                  ),
                                            );
                                          },
                                        )
                                      : const SizedBox(),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                bottom: kToolbarHeight * 3,
              ),
              sliver: SliverToBoxAdapter(
                child: VisibilityDetector(
                  key: const Key('loading_vertical'),
                  onVisibilityChanged: (VisibilityInfo info) => _loadProduct(),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: canLoad,
                    builder: (context, value, child) {
                      if (!value) return const SizedBox();
                      return child ?? const SizedBox();
                    },
                    child: Center(
                      child: Text(S.of(context).loading),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  CategoryModel get categoryModel => context.read<CategoryModel>();

  @override
  void clearProductList() {
    products.value.clear();
    rebuild();
  }

  @override
  FilterAttributeModel get filterAttrModel =>
      context.read<FilterAttributeModel>();

  @override
  Future<void> getProductList() async {
    canLoad.value = true;
    await _loadProduct();
  }

  @override
  String get lang => context.read<AppModel>().langCode;

  @override
  void onCategorySelected(String name) {}

  @override
  void onCloseFilter() {}

  @override
  void rebuild() {
    setState(() {});
  }

  @override
  String get tagName => tagModel.getTagName(tagId);

  @override
  bool get shouldShowLayout => false;
}
