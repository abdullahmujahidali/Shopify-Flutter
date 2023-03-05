import 'dart:async';
import 'dart:ui';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/config.dart';
import '../../../common/config/models/index.dart';
import '../../../common/constants.dart';
import '../../../common/tools/image_tools.dart';
import '../../../models/entities/index.dart';
import '../../../models/product_model.dart';
import 'image_galery.dart';
import 'product_image_thumbnail.dart';
import 'video_feature.dart';

class ProductImageList extends StatefulWidget {
  final Product product;
  final Function onChange;

  const ProductImageList({
    Key? key,
    required this.product,
    required this.onChange,
  }) : super(key: key);

  @override
  State<ProductImageList> createState() => _ProductImageListState();
}

class _ProductImageListState extends State<ProductImageList> {
  final InfiniteScrollController _infiniteController =
      InfiniteScrollController();

  bool initialized = false;
  bool hasVideo = false;
  bool variationLoaded = false;

  late final String _videoUrl;
  final List<String> _images = [];
  final List<String> _variationImages = [];

  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  List<String> get itemList => {
        if (hasVideo) _videoUrl,
        ..._images,
        ..._variationImages,
      }.toList();

  List<String> get imagesList => {..._images, ..._variationImages}.toList();

  StreamSubscription? _subChangeSelectedVariation;

  void updateVariationImages(List<String> newImages) {
    if (!widget.product.isVariableProduct ||
        _variationImages.isNotEmpty ||
        newImages.isEmpty ||
        newImages.length == _variationImages.length) {
      return;
    }
    for (var url in newImages) {
      if (!_variationImages.contains(url)) {
        _variationImages.add(url);
      }
    }
    initialized = true;
    if (!mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        afterFirstLayout(context);
      }
    });

    final url = widget.product.videoUrl;
    if (url != null && url.isNotEmpty) {
      _videoUrl = url.replaceAll('http://', 'https://');
      hasVideo = true;
    }

    _images.addAll(widget.product.images);

    if (kProductDetail.showSelectedImageVariant) {
      _subChangeSelectedVariation =
          eventBus.on<EventChangeSelectedVariation>().listen((event) {
        if (!mounted) {
          return;
        }

        /// Skip first time when variation loaded.
        if (!variationLoaded) {
          variationLoaded = true;
          return;
        }

        final image = event.productVariation?.imageFeature;
        _infiniteController.goToUrl(image, imagesList);
      });
    }
  }

  @override
  void dispose() {
    _infiniteController.dispose();
    _currentPage.dispose();
    _subChangeSelectedVariation?.cancel();
    super.dispose();
  }

  void afterFirstLayout(BuildContext context) {
    if (widget.product.isVariableProduct) {
      updateVariationImages(
          context.read<ProductModel>().variationsFeatureImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      updateVariationImages(
          context.select((ProductModel _) => _.variationsFeatureImages));
    }

    if (itemList.isEmpty) {
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          background: Stack(
            children: [
              Positioned.fill(
                top: kProductDetail.marginTop,
                child: InfiniteCarousel.builder(
                  controller: _infiniteController,
                  itemCount: itemList.length,
                  itemExtent: 400,
                  loop: true,
                  velocityFactor: 1,
                  axisDirection: Axis.vertical,
                  onIndexChanged: _onPageChange,
                  anchor: 0.5,
                  itemBuilder: (BuildContext context, int index, _) {
                    final item = itemList[index];
                    if (hasVideo && index == 0) {
                      return FeatureVideoPlayer(
                        item,
                        autoPlay: true,
                      );
                    }

                    return GestureDetector(
                      onTap: () => _onShowGallery(context, index),
                      child: ImageResize(
                        url: item,
                        fit: ImageTools.boxFit(kProductDetail.boxFit),
                        size: kSize.large,
                        width: constraints.maxWidth,
                        hidePlaceHolder: true,
                        forceWhiteBackground:
                            kProductDetail.forceWhiteBackground,
                      ),
                    );
                  },
                ),
              ),
              if (kProductDetail.showImageGallery &&
                  kProductDetail.sliderIndicatorType ==
                      SliderIndicatorType.number)
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        height: 55,
                        width: constraints.maxWidth,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              if (_currentPage.value != 0 &&
                  kProductDetail.sliderShowGoBackButton)
                Positioned(
                  bottom: 4.0,
                  left: 2.0,
                  child: GestureDetector(
                    onTap: () {
                      // _infiniteController.goTo(0);
                      widget.onChange(0);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child: Icon(
                        CupertinoIcons.arrow_left_square_fill,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              if (kProductDetail.sliderIndicatorType ==
                  SliderIndicatorType.number) ...[
                Positioned(
                  bottom: 8.0,
                  right: 4.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentPage,
                      builder: (context, currentPage, child) {
                        return Text(
                          '${currentPage + 1}/${itemList.length}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              if (kProductDetail.showImageGallery) ...[
                Positioned(
                  bottom: 4.0,
                  left: 44,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, currentPage, child) {
                      return ProductImageThumbnail(
                        itemList: itemList,
                        onSelect: ({required int index, bool? fullScreen}) {
                          if (fullScreen ?? false) {
                            _onShowGallery(context, index);
                          }
                          _infiniteController.animateToItem(index);
                        },
                        selectIndex: currentPage,
                      );
                    },
                  ),
                )
              ],
              if (!kProductDetail.showImageGallery &&
                  kProductDetail.sliderIndicatorType == SliderIndicatorType.dot)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentPage,
                      builder: (context, currentPage, child) {
                        return AnimatedSmoothIndicator(
                          count: itemList.length,
                          activeIndex: currentPage,
                          axisDirection: Axis.vertical,
                          effect: const ScrollingDotsEffect(
                            dotWidth: 8.0,
                            dotHeight: 8.0,
                            spacing: 15.0,
                            fixedCenter: true,
                            dotColor: Colors.black45,
                            activeDotColor: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onShowGallery(BuildContext context, [index = 0]) async {
    final currentIndex = await Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (context, __, ___) {
        return ImageGalery(
          images: imagesList,
          index: hasVideo ? index - 1 : index,
          heroTagPrefix: 'slider_hero_tag_',
        );
      }),
    );
    if (currentIndex == null) return;
    await _infiniteController.animateToItem(currentIndex);
  }

  void _onPageChange(int index) {
    EasyDebounce.debounce(
      'slider_page_change',
      const Duration(milliseconds: 200),
      () {
        _currentPage.value = index;
        widget.onChange(index);
      },
    );
  }
}

extension on InfiniteScrollController {
  Future<void> goToUrl(String? url, List<String> urls) async {
    if (url == null || urls.isEmpty) {
      return;
    }

    final index = urls.indexOf(url);
    if (index == -1) {
      return;
    }
    return animateToItem(index);
  }
}
