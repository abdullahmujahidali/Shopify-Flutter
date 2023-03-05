import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, Product, ProductModel;
import '../../../services/index.dart';
import '../../../widgets/product/product_simple_view.dart';
import '../config/product_config.dart';
import '../helper/header_view.dart';
import '../helper/helper.dart';

class VerticalViewLayout extends StatefulWidget {
  final ProductConfig config;
  final bool enableScrollView;

  const VerticalViewLayout(
      {required this.config, Key? key, required this.enableScrollView})
      : super(key: key);

  @override
  State<VerticalViewLayout> createState() => _PinterestLayoutState();
}

class _PinterestLayoutState extends State<VerticalViewLayout> {
  final Services _service = Services();
  ValueNotifier<List<Product>> products = ValueNotifier<List<Product>>([]);
  ValueNotifier<bool> canLoad = ValueNotifier(true);
  int _page = 0;
  bool loading = false;
  final key = const Key('loading_vertical');

  void _loadProduct() async {
    if (loading) return;
    var config = widget.config.toJson();
    _page = _page + 1;
    config['page'] = _page;
    if (!canLoad.value) return;
    loading = true;
    var newProducts = await _service.api.fetchProductsLayout(
        config: config,
        lang: Provider.of<AppModel>(context, listen: false).langCode);
    if (newProducts == null || newProducts.isEmpty) {
      canLoad.value = false;
    }
    if (newProducts != null && newProducts.isNotEmpty) {
      products.value = [...products.value, ...newProducts];
    }
    loading = false;
    // VisibilityDetectorController.instance.forget(key);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) _loadProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    var column = 1;
    final isTablet = Helper.isTablet(MediaQuery.of(context));

    if (widget.config.layout == 'card') {
      column = 1;
    } else if (widget.config.layout == 'columns') {
      column = isTablet ? 4 : 3;
    } else {
      //layout is list
      column = isTablet ? 3 : 2;
    }

    final enableScrollView = widget.enableScrollView &&
        ['list', 'columns', 'columnsWithFilter'].contains(widget.config.layout);
    return CustomScrollView(
      cacheExtent: 1000,
      physics: enableScrollView ? null : const NeverScrollableScrollPhysics(),
      controller: PrimaryScrollController.of(context),
      slivers: [
        if (widget.config.name != null)
          SliverToBoxAdapter(
            child: HeaderView(
              headerText: widget.config.name ?? '',
              showSeeAll: !ServerConfig().isListingType,
              callback: () => ProductModel.showList(
                config: widget.config.jsonData,
              ),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: widget.config.vPadding,
            horizontal: widget.config.hPadding,
          ),
          sliver: ValueListenableBuilder<List<Product>>(
            valueListenable: products,
            builder: (context, value, child) {
              var rows = widget.config.layout == 'list'
                  ? value.length
                  : value.length ~/ column;
              if (rows * column < value.length) rows++;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  addAutomaticKeepAlives: false,
                  childCount: rows,
                  (context, index) {
                    if (widget.config.layout == 'list') {
                      return ProductSimpleView(
                        item: value[index],
                        type: SimpleType.backgroundColor,
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        column,
                        (indexColumn) {
                          return Expanded(
                            child: index * column + indexColumn < value.length
                                ? LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Services()
                                            .widget
                                            .renderProductCardView(
                                                item: value[index * column +
                                                    indexColumn],
                                                width: constraints.maxWidth,
                                                config: widget.config,
                                                ratioProductImage:
                                                    widget.config.imageRatio),
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
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: key,
            onVisibilityChanged: (VisibilityInfo info) => _loadProduct(),
            // BUG: always show loading so can't load product anymore in tablet
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
        )
      ],
    );
  }
}
