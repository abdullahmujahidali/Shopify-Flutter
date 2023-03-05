import '../../../modules/dynamic_layout/helper/helper.dart';
import '../../tools.dart';

class ProductDetailConfig {
  late final double height;
  late final double marginTop;
  late final bool safeArea;
  late final bool showVideo;
  late final int showThumbnailAtLeast;
  late final String layout;
  late final double borderRadius;
  late final bool showSelectedImageVariant;
  late final bool forceWhiteBackground;
  late final bool autoSelectFirstAttribute;
  late final bool enableReview;
  late final double attributeImagesSize;
  late final bool showSku;
  late final bool showStockQuantity;
  late final bool showProductCategories;
  late final bool showProductTags;
  late final bool hideInvalidAttributes;
  late final bool showImageGallery;
  late final bool autoPlayGallery;
  late final bool allowMultiple;
  late final bool showBrand;
  late final bool showQuantityInList;
  late final bool showAddToCartInSearchResult;
  late final double productListItemHeight;
  late final String boxFit;
  late final bool sliderShowGoBackButton;
  late final SliderIndicatorType sliderIndicatorType;
  late final int? limitDayBooking;
  late final String productMetaDataKey;
  late final bool showRelatedProductFromSameStore;
  late final bool showRelatedProduct;
  late final bool showRecentProduct;

  /// list, page
  late final ProductImageType productImageLayout;

  ProductDetailConfig({
    required this.height,
    required this.marginTop,
    required this.safeArea,
    required this.showVideo,
    required this.showThumbnailAtLeast,
    required this.layout,
    required this.borderRadius,
    required this.showSelectedImageVariant,
    required this.forceWhiteBackground,
    required this.autoSelectFirstAttribute,
    required this.enableReview,
    required this.attributeImagesSize,
    required this.showSku,
    required this.showStockQuantity,
    required this.showProductCategories,
    required this.showProductTags,
    required this.hideInvalidAttributes,
    required this.showImageGallery,
    required this.autoPlayGallery,
    required this.allowMultiple,
    required this.showBrand,
    required this.showQuantityInList,
    required this.showAddToCartInSearchResult,
    required this.productListItemHeight,
    required this.boxFit,
    required this.sliderShowGoBackButton,
    required this.sliderIndicatorType,
    required this.productMetaDataKey,
    required this.showRelatedProductFromSameStore,
    required this.showRelatedProduct,
    required this.showRecentProduct,
    this.limitDayBooking,
    required this.productImageLayout,
  });

  ProductDetailConfig.fromJson(Map config) {
    height = Tools.formatDouble(config['height']) ?? 0.4;
    marginTop = Tools.formatDouble(config['marginTop']) ?? 0.0;
    safeArea = config['safeArea'] ?? false;
    showVideo = config['showVideo'] ?? true;
    showThumbnailAtLeast = config['showThumbnailAtLeast'] ?? 1;
    layout = config['layout'] ?? 'simpleType';
    borderRadius = Tools.formatDouble(config['borderRadius']) ?? 3.0;
    showSelectedImageVariant = config['ShowSelectedImageVariant'] ?? true;
    forceWhiteBackground = config['ForceWhiteBackground'] ?? false;
    autoSelectFirstAttribute = config['AutoSelectFirstAttribute'] ?? true;
    enableReview = config['enableReview'] ?? false;
    attributeImagesSize =
        Tools.formatDouble(config['attributeImagesSize']) ?? 50.0;
    showSku = config['showSku'] ?? true;
    showStockQuantity = config['showStockQuantity'] ?? true;
    showProductCategories = config['showProductCategories'] ?? true;
    showProductTags = config['showProductTags'] ?? true;
    hideInvalidAttributes = config['hideInvalidAttributes'] ?? false;
    showImageGallery = config['ShowImageGallery'] ?? false;
    autoPlayGallery = config['autoPlayGallery'] ?? false;
    allowMultiple = config['allowMultiple'] ?? false;
    showBrand = config['showBrand'] ?? false;
    showQuantityInList = config['showQuantityInList'] ?? false;
    showAddToCartInSearchResult =
        config['showAddToCartInSearchResult'] ?? false;
    productListItemHeight =
        Helper.formatDouble(config['productListItemHeight']) ?? 125.0;
    limitDayBooking = config['limitDayBooking'];
    boxFit = config['boxFit'] ?? 'cover';
    sliderShowGoBackButton = config['SliderShowGoBackButton'] ?? true;
    sliderIndicatorType =
        '${config['SliderIndicatorType']}'.toSliderIndicatorType();
    productMetaDataKey = config['productMetaDataKey'] ?? '';
    showRelatedProductFromSameStore =
        config['showRelatedProductFromSameStore'] ?? true;
    showRelatedProduct = config['showRelatedProduct'] ?? true;
    showRecentProduct = config['showRecentProduct'] ?? true;
    productImageLayout =
        ProductImageType.fromString(config['productImageLayout']);
  }

  ProductDetailConfig copyWith({
    double? height,
    double? marginTop,
    bool? safeArea,
    bool? showVideo,
    int? showThumbnailAtLeast,
    String? layout,
    double? borderRadius,
    bool? showSelectedImageVariant,
    bool? forceWhiteBackground,
    bool? autoSelectFirstAttribute,
    bool? enableReview,
    double? attributeImagesSize,
    bool? showSku,
    bool? showStockQuantity,
    bool? showProductCategories,
    bool? showProductTags,
    bool? hideInvalidAttributes,
    bool? showImageGallery,
    bool? autoPlayGallery,
    bool? allowMultiple,
    bool? showBrand,
    bool? showQuantityInList,
    bool? showAddToCartInSearchResult,
    double? productListItemHeight,
    int? limitDayBooking,
    String? boxFit,
    bool? sliderShowGoBackButton,
    SliderIndicatorType? sliderIndicatorType,
    String? productMetaDataKey,
    bool? showRelatedProductFromSameStore,
    bool? showRelatedProduct,
    bool? showRecentProduct,
    String? productImageLayout,
  }) {
    return ProductDetailConfig(
      height: height ?? this.height,
      marginTop: marginTop ?? this.marginTop,
      safeArea: safeArea ?? this.safeArea,
      showVideo: showVideo ?? this.showVideo,
      showThumbnailAtLeast: showThumbnailAtLeast ?? this.showThumbnailAtLeast,
      layout: layout ?? this.layout,
      borderRadius: borderRadius ?? this.borderRadius,
      showSelectedImageVariant:
          showSelectedImageVariant ?? this.showSelectedImageVariant,
      forceWhiteBackground: forceWhiteBackground ?? this.forceWhiteBackground,
      autoSelectFirstAttribute:
          autoSelectFirstAttribute ?? this.autoSelectFirstAttribute,
      enableReview: enableReview ?? this.enableReview,
      attributeImagesSize: attributeImagesSize ?? this.attributeImagesSize,
      showSku: showSku ?? this.showSku,
      showStockQuantity: showStockQuantity ?? this.showStockQuantity,
      showProductCategories:
          showProductCategories ?? this.showProductCategories,
      showProductTags: showProductTags ?? this.showProductTags,
      hideInvalidAttributes:
          hideInvalidAttributes ?? this.hideInvalidAttributes,
      showImageGallery: showImageGallery ?? this.showImageGallery,
      autoPlayGallery: autoPlayGallery ?? this.autoPlayGallery,
      allowMultiple: allowMultiple ?? this.allowMultiple,
      showBrand: showBrand ?? this.showBrand,
      showQuantityInList: showQuantityInList ?? this.showQuantityInList,
      showAddToCartInSearchResult:
          showAddToCartInSearchResult ?? this.showAddToCartInSearchResult,
      productListItemHeight:
          productListItemHeight ?? this.productListItemHeight,
      limitDayBooking: limitDayBooking ?? this.limitDayBooking,
      boxFit: boxFit ?? this.boxFit,
      sliderShowGoBackButton:
          sliderShowGoBackButton ?? this.sliderShowGoBackButton,
      sliderIndicatorType: sliderIndicatorType ?? this.sliderIndicatorType,
      productMetaDataKey: productMetaDataKey ?? this.productMetaDataKey,
      showRelatedProductFromSameStore: showRelatedProductFromSameStore ??
          this.showRelatedProductFromSameStore,
      showRelatedProduct: showRelatedProduct ?? this.showRelatedProduct,
      showRecentProduct: showRecentProduct ?? this.showRecentProduct,
      productImageLayout: ProductImageType.fromString(
          productImageLayout ?? this.productImageLayout.name),
    );
  }

  Map toJSon() {
    return {
      'height': height,
      'marginTop': marginTop,
      'safeArea': safeArea,
      'showVideo': showVideo,
      'showThumbnailAtLeast': showThumbnailAtLeast,
      'layout': layout,
      'borderRadius': borderRadius,
      'ShowSelectedImageVariant': showSelectedImageVariant,
      'ForceWhiteBackground': forceWhiteBackground,
      'AutoSelectFirstAttribute': autoSelectFirstAttribute,
      'enableReview': enableReview,
      'attributeImagesSize': attributeImagesSize,
      'showSku': showSku,
      'showStockQuantity': showStockQuantity,
      'showProductCategories': showProductCategories,
      'showProductTags': showProductTags,
      'hideInvalidAttributes': hideInvalidAttributes,
      'ShowImageGallery': showImageGallery,
      'autoPlayGallery': autoPlayGallery,
      'allowMultiple': allowMultiple,
      'showBrand': showBrand,
      'showQuantityInList': showQuantityInList,
      'showAddToCartInSearchResult': showAddToCartInSearchResult,
      'productListItemHeight': productListItemHeight,
      'limitDayBooking': limitDayBooking,
      'boxFit': boxFit,
      'SliderShowGoBackButton': sliderShowGoBackButton,
      'SliderIndicatorType': sliderIndicatorType.toShortString(),
      'productMetaDataKey': productMetaDataKey,
      'showRelatedProductFromSameStore': showRelatedProductFromSameStore,
      'showRelatedProduct': showRelatedProduct,
      'showRecentProduct': showRecentProduct,
      'productImageLayout': productImageLayout.name,
    };
  }
}

enum SliderIndicatorType {
  number,
  dot,
  dotAlt,
}

enum ProductImageType {
  list,
  page;

  bool get isList => this == ProductImageType.list;

  bool get isPage => this == ProductImageType.page;

  factory ProductImageType.fromString(String? type) {
    switch (type) {
      case 'list':
        return ProductImageType.list;
      case 'page':
        return ProductImageType.page;
      default:
        return ProductImageType.page;
    }
  }
}

extension SliderIndicatorTypeExt on SliderIndicatorType? {
  String toShortString() {
    switch (this) {
      case SliderIndicatorType.dot:
        return 'dot';
      case SliderIndicatorType.dotAlt:
        return 'dotAlt';
      case SliderIndicatorType.number:
      default:
        return 'number';
    }
  }
}

extension on String? {
  SliderIndicatorType toSliderIndicatorType() {
    switch (this) {
      case 'dot':
        return SliderIndicatorType.dot;
      case 'dotAlt':
        return SliderIndicatorType.dotAlt;
      case 'number':
      default:
        return SliderIndicatorType.number;
    }
  }
}
