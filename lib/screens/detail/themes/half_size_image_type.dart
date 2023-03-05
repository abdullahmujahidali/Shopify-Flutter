import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/config.dart';
import '../../../models/index.dart' show CartModel, Product, ProductModel;
import '../../../services/services.dart';
import '../../cart/cart_screen.dart';
import '../product_detail_screen.dart';
import '../widgets/index.dart';
import '../widgets/product_common_info.dart';
import '../widgets/product_image_slider.dart';

class HalfSizeLayout extends StatefulWidget {
  final Product? product;
  final bool isLoading;

  const HalfSizeLayout({this.product, this.isLoading = false});

  @override
  State<HalfSizeLayout> createState() => _HalfSizeLayoutState();
}

class _HalfSizeLayoutState extends State<HalfSizeLayout>
    with SingleTickerProviderStateMixin {
  Map<String, String> mapAttribute = HashMap();
  late final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  var top = 0.0;

  Widget _getLowerLayer({width, height}) {
    final heightVal = height ?? MediaQuery.of(context).size.height;
    final widthVal = width ?? MediaQuery.of(context).size.width;
    var totalCart = Provider.of<CartModel>(context).totalCartQuantity;

    return ProductImageSlider(
      product: widget.product!,
      customBuilder: (BuildContext context, Widget pageView,
          PageController pageController, List<String> items, bool hasVideo) {
        return Material(
          child: Stack(
            children: <Widget>[
              if (widget.product?.imageFeature != null)
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: widthVal,
                    height: heightVal,
                    child: pageView,
                  ),
                ),
              if (widget.product?.imageFeature != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.product?.images.length ?? 0,
                        effect: const ScrollingDotsEffect(
                          dotWidth: 5.0,
                          dotHeight: 5.0,
                          spacing: 15.0,
                          fixedCenter: true,
                          dotColor: Colors.black45,
                          activeDotColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 40,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                    onPressed: () {
                      context.read<ProductModel>().clearProductVariations();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => ProductDetailScreen.showMenu(
                      context, widget.product,
                      isLoading: widget.isLoading),
                ),
              ),
              Positioned(
                top: 30,
                right: 40,
                child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Scaffold(
                            backgroundColor: Theme.of(context).colorScheme.background,
                            body: const CartScreen(isModal: true),
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    }),
              ),
              Positioned(
                top: 36,
                right: 44,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    totalCart.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _getUpperLayer({width}) {
    final widthVal = width ?? MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: widthVal,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0)),
              child: ChangeNotifierProvider(
                create: (_) => ProductModel(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (!(widget.product?.isGroupedProduct ?? false))
                        ProductTitle(widget.product),
                      ProductCommonInfo(
                        product: widget.product,
                        isLoading: widget.isLoading,
                        wrapSliver: false,
                      ),
                      if (!Services().widget.enableShoppingCart(
                              widget.product?.copyWith(isRestricted: false)) &&
                          widget.product?.shortDescription != null &&
                          (widget.product?.shortDescription?.isNotEmpty ??
                              false))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ProductShortDescription(widget.product!),
                        ),
                      Services().widget.renderVendorInfo(widget.product),
                      ProductDescription(widget.product),
                      if (kProductDetail.showProductCategories)
                        ProductDetailCategories(widget.product),
                      if (kProductDetail.showProductTags)
                        ProductTag(widget.product),
                      Services().widget.productReviewWidget(widget.product!),
                      if (kProductDetail.showRelatedProductFromSameStore &&
                          widget.product?.store?.id != null)
                        RelatedProductFromSameStore(
                          widget.product,
                          padding: EdgeInsets.zero,
                        ),
                      if (kProductDetail.showRelatedProduct)
                        RelatedProduct(
                          widget.product,
                          padding: EdgeInsets.zero,
                        ),
                      if (kProductDetail.showRecentProduct)
                        RecentProducts(excludeProduct: widget.product),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            _getLowerLayer(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder:
                    (BuildContext context, ScrollController scrollController) =>
                        SingleChildScrollView(
                  controller: scrollController,
                  child: _getUpperLayer(
                    width: constraints.maxWidth,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
