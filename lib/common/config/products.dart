part of '../config.dart';

/// Everything Config about the Product Setting

Map get kProductVariantLayout => Configurations.productVariantLayout;

ProductDetailConfig get kProductDetail =>
    ProductDetailConfig.fromJson(Configurations.productDetail);

Map get kProductAddons => Configurations.productAddons;

Map get kCartDetail => Configurations.cartDetail;

Map get kProductVariantLanguage => Configurations.productVariantLanguage;

int get kExcludedCategory => Configurations.excludedCategory;

SaleoffProductConfig get kSaleOffProduct => SaleoffProductConfig.fromJson(Configurations.saleOffProduct);

bool get kNotStrictVisibleVariant => Configurations.notStrictVisibleVariant;

ProductCardConfig get kProductCard => ProductCardConfig.fromJson(Configurations.productCard);

BoxFit get kCardFit => ImageTools.boxFit(kProductCard.boxFit);