import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiver/strings.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../services/service_config.dart';
import '../booking/booking_model.dart';
import '../serializers/product.dart';
import '../vendor/store_model.dart';
import 'brand.dart';
import 'category.dart';
import 'listing_slots.dart';
import 'menu_price.dart';
import 'product_addons.dart';
import 'product_attribute.dart';
import 'product_variation.dart';
import 'tag.dart';
import 'vendor_admin_variation.dart';

const _defaultId = '0';

class Product {
  String id;
  String? sku;
  String? name;
  String? status;
  String? vendor;
  String? description;
  String? shortDescription;
  String? permalink;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? maxPrice;
  String? minPrice;
  bool? onSale;
  bool? inStock;
  double? averageRating;
  int? totalSales;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  int? ratingCount;
  List<String> images = [];
  String? imageFeature;
  List<ProductAttribute>? attributes;
  Map<String?, String?> attributeSlugMap = {};
  List<Attribute> defaultAttributes = <Attribute>[];
  List<ProductAttribute> infors = [];
  String? categoryId;
  String? videoUrl;
  List<dynamic>? groupedProducts;
  List<String?>? files;
  int? stockQuantity;
  int? minQuantity;
  int? maxQuantity;
  bool manageStock = false;
  bool backOrdered = false;
  String? relatedIds;
  bool backordersAllowed = false;
  Store? store;
  List<Tag> tags = [];
  Map<String, Map<String, AddonsOption>> defaultAddonsOptions = {};
  List<Category> categories = [];
  List<Map> metaData = [];
  bool isRestricted = false; //for Indeed Ultimate Membership Pro

  List<Brand> brands = [];

  List<ProductAddons>? addOns;
  List<AddonsOption>? selectedOptions;
  List<VendorAdminVariation> vendorAdminVariations = [];

  List<ProductVariation>? variationProducts;

  /// For downloadable products
  bool isPurchased = false;
  bool? isDownloadable = false;

  /// is to check the type affiliate, simple, variant
  String? type;
  String? affiliateUrl;
  List<ProductVariation>? variations;

  List<Map>? options; //for opencart

  BookingModel? bookingInfo; // for booking

  String? idShop; //for prestashop

  ///----VENDOR ADMIN----///
  bool? isFeatured = false;
  String? vendorAdminImageFeature;
  List<String> categoryIds = [];
  List<ProductAttribute> vendorAdminProductAttributes = [];

  ///----VENDOR ADMIN----///

  ///----FLUXSTORE LISTING----///

  String? distance;
  Map? pureTaxonomies;
  List? reviews;
  String? featured;
  bool? verified;
  String? tagLine;
  String? priceRange;
  String? categoryName;
  String? hours;
  String? location;
  String? phone;
  String? facebook;
  String? email;
  String? website;
  String? skype;
  String? whatsapp;
  String? youtube;
  String? twitter;
  String? instagram;
  String? eventDate;

  // String? rating;
  int? totalReview = 0;
  double? lat;
  double? long;
  List<dynamic>? listingMenu = [];
  ListingSlots? slots;
  bool? listingBookingStatus;

  ///----FLUXSTORE LISTING----///
  Product({
    this.id = _defaultId,
    String? sku,
    String? name,
    String? status,
    String? vendor,
    String? description,
    String? shortDescription,
    String? permalink,
    String? price,
    String? regularPrice,
    String? salePrice,
    String? maxPrice,
    String? minPrice,
    bool? onSale,
    bool? inStock,
    double? averageRating,
    int? totalSales,
    String? dateOnSaleFrom,
    String? dateOnSaleTo,
    int? ratingCount,
    List<String>? images,
    String? imageFeature,
    List<ProductAttribute>? attributes,
    List<Attribute>? defaultAttributes,
    List<ProductAttribute>? infors,
    String? categoryId,
    String? videoUrl,
    List<dynamic>? groupedProducts,
    List<String?>? files,
    int? stockQuantity,
    int? minQuantity,
    int? maxQuantity,
    bool? manageStock,
    bool? backOrdered,
    String? relatedIds,
    bool? backordersAllowed,
    Store? store,
    List<Tag>? tags,
    List<Category>? categories,
    List<Map>? metaData,
    List<ProductAddons>? addOns,
    List<AddonsOption>? selectedOptions,
    List<VendorAdminVariation>? vendorAdminVariations,
    List<ProductVariation>? variationProducts,
    bool? isPurchased,
    bool? isDownloadable,
    String? type,
    String? affiliateUrl,
    List<ProductVariation>? variations,
    List<Map>? options,
    BookingModel? bookingInfo,
    String? idShop,
    bool? isFeatured,
    String? vendorAdminImageFeature,
    List<String>? categoryIds,
    List<ProductAttribute>? vendorAdminProductAttributes,
    String? distance,
    Map? pureTaxonomies,
    List? reviews,
    String? featured,
    bool? verified,
    String? tagLine,
    String? priceRange,
    String? categoryName,
    String? hours,
    String? location,
    String? phone,
    String? facebook,
    String? email,
    String? website,
    String? skype,
    String? whatsapp,
    String? youtube,
    String? twitter,
    String? instagram,
    String? eventDate,
    String? rating,
    int? totalReview,
    double? lat,
    double? long,
    List<dynamic>? listingMenu,
    ListingSlots? slots,
    bool? isRestricted,
    bool? listingBookingStatus,
  });

  Product.empty(this.id) {
    name = '';
    price = '0.0';
    imageFeature = '';
  }

  bool isEmptyProduct() {
    return name == '' && price == '0.0' && imageFeature == '';
  }

  bool isTopUpProduct() {
    return name == 'Wallet Topup';
  }

  bool canBeAddedToCartFromList({bool? enableBottomAddToCart}) {
    if (enableBottomAddToCart ?? kAdvanceConfig.enableBottomAddToCart) {
      return !isEmptyProduct() &&
          ((inStock != null && inStock!) || backordersAllowed) &&
          type != 'external' &&
          type != 'booking' &&
          type != 'grouped' &&
          (addOns?.isEmpty ?? true);
    } else {
      return !isEmptyProduct() &&
          ((inStock != null && inStock!) || backordersAllowed) &&
          type != 'variable' &&
          type != 'appointment' &&
          type != 'external' &&
          type != 'booking' &&
          type != 'grouped' &&
          (addOns?.isEmpty ?? true);
    }
  }

  bool get isVariableProduct => type == 'variable';

  bool get isSimpleProduct => type == 'simple';

  bool get isGroupedProduct => type == 'grouped';

  String? get displayPrice {
    return onSale == true
        ? (isNotBlank(salePrice) ? salePrice ?? '0' : price)
        : (isNotBlank(regularPrice) ? regularPrice ?? '0' : price);
  }

  List<Category> get distinctCategories {
    final temp = categories.map((e) => e.name).toSet().toList();
    return temp
        .map((e) => categories.firstWhere((element) => element.name == e))
        .toList();
  }

  Product.cloneFrom(Product p) : id = p.id {
    sku = p.sku;
    status = p.status;
    name = p.name;
    description = p.description;
    permalink = p.permalink;
    price = p.price;
    regularPrice = p.regularPrice;
    salePrice = p.salePrice;
    onSale = p.onSale;
    inStock = p.inStock;
    averageRating = p.averageRating;
    ratingCount = p.ratingCount;
    totalSales = p.totalSales;
    dateOnSaleFrom = p.dateOnSaleFrom;
    dateOnSaleTo = p.dateOnSaleTo;
    images = p.images.toList();
    imageFeature = p.imageFeature;
    attributes = p.attributes?.toList();
    infors = p.infors.toList();
    categoryId = p.categoryId;
    videoUrl = p.videoUrl;
    groupedProducts = p.groupedProducts?.toList();
    files = p.files?.toList();
    stockQuantity = p.stockQuantity;
    minQuantity = p.minQuantity;
    maxQuantity = p.maxQuantity;
    manageStock = p.manageStock;
    backOrdered = p.backOrdered;
    backordersAllowed = p.backordersAllowed;
    type = p.type;
    affiliateUrl = p.affiliateUrl;
    variations = p.variations?.toList();
    options = List.from(jsonDecode(jsonEncode(p.options ?? [])));
    idShop = p.idShop;
    shortDescription = p.shortDescription;
    tags = p.tags.toList();
    selectedOptions = p.selectedOptions?.toList();
    addOns = p.addOns?.toList();
    variationProducts = p.variationProducts?.toList();
    vendorAdminProductAttributes = p.vendorAdminProductAttributes.toList();
    imageFeature = p.imageFeature;
    vendorAdminImageFeature = p.vendorAdminImageFeature;
    images = p.images;
    categories = p.categories.toList();
    p.defaultAddonsOptions.forEach((key, value) {
      if (value.isNotEmpty) {
        defaultAddonsOptions[key] = value;
      } else {
        defaultAddonsOptions[key] = <String, AddonsOption>{};
      }
    });
  }

  Product.fromJson(Map parsedJson) : id = parsedJson['id'].toString() {
    try {
      id = parsedJson['id'].toString();
      sku = parsedJson['sku'];
      status = parsedJson['status'];
      name = HtmlUnescape().convert(parsedJson['name']);
      type = parsedJson['type'];
      description = '${parsedJson['description'] ?? ''}';
      shortDescription = parsedJson['short_description'];
      permalink = parsedJson['permalink'];
      price = parsedJson['price'] != null ? parsedJson['price'].toString() : '';

      regularPrice = isNotBlank('${parsedJson['regular_price'] ?? ''}')
          ? parsedJson['regular_price'].toString()
          : null;
      salePrice = isNotBlank('${parsedJson['sale_price'] ?? ''}')
          ? parsedJson['sale_price'].toString()
          : null;

      if (isVariableProduct) {
        onSale = salePrice != null && (parsedJson['on_sale'] == true);
      } else {
        var onSaleByPrice = false;

        if (regularPrice != null && regularPrice != 'null') {
          onSaleByPrice = price != regularPrice &&
              double.parse(regularPrice.toString()) >
                  double.parse(parsedJson['price'].toString());
        }

        onSale = salePrice != null &&
            isNotBlank(parsedJson['price'].toString()) &&
            onSaleByPrice;
      }

      /// In case parsedJson['manage_stock'] = "parent" 😂
      manageStock = parsedJson['manage_stock'] == true;

      inStock =
          parsedJson['in_stock'] ?? parsedJson['stock_status'] == 'instock';
      if (inStock == true && manageStock) {
        inStock = (parsedJson['stock_quantity'] ?? 0) > 0;
      }
      backOrdered = parsedJson['backordered'] ?? false;
      backordersAllowed = (parsedJson['backorders_allowed'] ?? false) ||
          ((parsedJson['backorders'] ?? 'no') != 'no');

      /// In case manage stock is disabled,
      /// customers can still purchase if stockstatus is backordered;
      if (!manageStock && !backordersAllowed) {
        backordersAllowed = backOrdered;
      }

      averageRating =
          double.tryParse(parsedJson['average_rating']?.toString() ?? '0.0') ??
              0.0;
      ratingCount =
          int.tryParse((parsedJson['rating_count'] ?? 0).toString()) ?? 0;
      totalSales =
          int.tryParse((parsedJson['total_sales'] ?? 0).toString()) ?? 0;
      if (parsedJson['date_on_sale_from'] != null) {
        if (parsedJson['date_on_sale_from'] is Map) {
          dateOnSaleFrom = parsedJson['date_on_sale_from']['date'];
        } else {
          dateOnSaleFrom = parsedJson['date_on_sale_from'];
        }
      }

      if (parsedJson['date_on_sale_to'] != null) {
        if (parsedJson['date_on_sale_to'] is Map) {
          dateOnSaleTo = parsedJson['date_on_sale_to']['date'];
        } else {
          dateOnSaleTo = parsedJson['date_on_sale_to'];
        }
      }

      categoryId = parsedJson['categories'] != null &&
              parsedJson['categories'].length > 0
          ? parsedJson['categories'][0]['id'].toString()
          : '0';

      isPurchased = parsedJson['is_purchased'] ?? false;
      isDownloadable = parsedJson['downloadable'];
      // add stock limit
      if (parsedJson['manage_stock'] == true) {
        stockQuantity = parsedJson['stock_quantity'];
      }

      //minQuantity = parsedJson['meta_data']['']

      if (parsedJson['attributes'] is List) {
        parsedJson['attributes']?.forEach((item) {
          if (item['visible'] ?? true) {
            infors.add(ProductAttribute.fromLocalJson(item));
          }
        });
      }

      if (parsedJson['brands'] is List) {
        try {
          for (var item in parsedJson['brands']) {
            final brand = Brand.fromJson(item);
            brands.add(brand);
          }
        } catch (e, trace) {
          printLog(e);
          printLog(trace);
        }
      }

      /// For Vendor Manager
      if (parsedJson['attributesData'] != null) {
        try {
          parsedJson['attributesData'].forEach((element) =>
              vendorAdminProductAttributes
                  .add(ProductAttribute.fromJson(element)..isActive = true));
        } catch (e) {
          printLog(e);
        }
      }

      if (parsedJson['variation_products'] != null) {
        for (var item in parsedJson['variation_products']) {
          vendorAdminVariations.add(VendorAdminVariation.fromJson(item));
        }
      }

      if (parsedJson['related_ids'] != null &&
          parsedJson['related_ids'].isNotEmpty) {
        relatedIds = '';
        for (var item in parsedJson['related_ids']) {
          if (relatedIds!.isEmpty) {
            relatedIds = item.toString();
          } else {
            relatedIds = '$relatedIds,$item';
          }
        }
      }

      var attributeList = <ProductAttribute>[];

      /// Not check the Visible Flag from variant
      bool? notChecking = kNotStrictVisibleVariant;

      try {
        parsedJson['attributesData']?.forEach((item) {
          if (!notChecking!) {
            notChecking = item['visible'];
          }

          if (notChecking! && item['variation']) {
            final attr = ProductAttribute.fromJson(item);
            attributeList.add(attr);

            /// Custom attributes not appeared in ["attributesData"].
            if (attr.options!.isEmpty) {
              /// Need to take from ["attributes"].
              /// we should compare productAttribute.name == attr.name as the id sometime is 0.
              /// For product custom attributes has space in the attribute name,
              /// sometimes " " become "-" in json['attributes'] but not in json['attributeData'].
              attr.options!.addAll(
                infors
                        .firstWhereOrNull((ProductAttribute productAttribute) =>
                            productAttribute.name != null &&
                            attr.name != null &&
                            (productAttribute.name == attr.name ||
                                productAttribute.name!.toLowerCase() ==
                                    attr.name!.toLowerCase() ||
                                productAttribute.name!.replaceAll('-', ' ') ==
                                    attr.name!.replaceAll('-', ' ')))
                        ?.options
                        ?.map((option) => {'name': option}) ??
                    [],
              );
            }

            for (var option in attr.options!) {
              if (option['slug'] != null && option['slug'] != '') {
                attributeSlugMap[option['slug']] = option['name'];
              }
            }
          }
        });
      }
      // ignore: empty_catches
      catch (e) {}

      attributes = attributeList.toList();

      try {
        var defaultAttributesData = <Attribute>[];
        parsedJson['default_attributes']?.forEach((item) {
          defaultAttributesData.add(Attribute.fromJson(item));
        });
        defaultAttributes = defaultAttributesData.toList();
      }
      // ignore: empty_catches
      catch (e) {}

      var list = <String>[];
      if (parsedJson['images'] != null) {
        for (var item in parsedJson['images']) {
          /// If item is String => Use for Vendor Admin.
          var image = '';
          if (item is String) {
            image = item;
          }
          if (item is Map) {
            image = item['src'];
          }
          if (!list.contains(image)) {
            list.add(image);
          }
        }
      }

      final rawMetaData = parsedJson['meta_data'];
      if (rawMetaData is List) {
        metaData = List<Map>.from(rawMetaData);
      } else {
        metaData = <Map>[];
      }

      /// Mapping the product meta data
      var metaImages = metaData.firstWhere(
        (item) => item['key'] == kProductDetail.productMetaDataKey,
        orElse: () => {},
      );
      if (metaImages.isNotEmpty && metaImages['value'] != null) {
        for (var item in metaImages['value']) {
          list.add(item['url']);
        }
      }

      images = list;
      imageFeature = images.isNotEmpty ? images[0] : null;

      try {
        final tagsData = parsedJson['tags'];
        if (tagsData != null && tagsData is List && tagsData.isNotEmpty) {
          for (var tag in tagsData) {
            tags.add(Tag.fromJson(tag));
          }
        }
      } catch (_) {
        // ignore
      }

      try {
        final categoriesData = parsedJson['categories'];
        if (categoriesData != null &&
            categoriesData is List &&
            categoriesData.isNotEmpty) {
          for (var category in categoriesData) {
            if (category['slug'] != 'uncategorized') {
              categories.add(Category.fromJson(category));
            }
          }
        }
      } catch (_) {
        // ignore
      }

      ///------For Vendor Admin------///
      if (parsedJson['featured_image'] != null) {
        vendorAdminImageFeature = parsedJson['featured_image'];
      }

      if (parsedJson['featured'] != null) {
        isFeatured = parsedJson['featured'];
      }
      if (parsedJson['category_ids'] != null) {
        if (parsedJson['category_ids'] is Map) {
          parsedJson['category_ids']
              .forEach((k, v) => categoryIds.add(v.toString()));
        }
        if (parsedJson['category_ids'] is List) {
          for (var item in parsedJson['category_ids']) {
            categoryIds.add(item.toString());
          }
        }
      }

      ///------For Vendor Admin------///

      /// get video links, support following plugins
      /// - WooFeature Video: https://wordpress.org/plugins/woo-featured-video/
      ///- Yith Feature Video: https://wordpress.org/plugins/yith-woocommerce-featured-video/
      var video = metaData.firstWhere(
        (item) =>
            item['key'] == 'video_url' ||
            item['key'] == '_video_url' ||
            item['key'] == '_woofv_video_embed',
        orElse: () => {},
      );
      if (video.isNotEmpty && video['value'] != null) {
        videoUrl = video['value'] is String
            ? video['value']
            : video['value']['url'] ?? '';
      }

      affiliateUrl = parsedJson['external_url'];

      var groupedProductList = <int>[];
      parsedJson['grouped_products']?.forEach((item) {
        groupedProductList.add(item);
      });
      groupedProducts = groupedProductList;
      var files = <String?>[];
      final rawFiles = parsedJson['downloads'];
      if (rawFiles is List) {
        for (var item in List.from(parsedJson['downloads'] ?? [])) {
          files.add(item['file']);
        }
      } else if (rawFiles is Map) {
        for (var item in Map.from(parsedJson['downloads'] ?? {}).values) {
          files.add(item['file']);
        }
      }
      this.files = files;

      if (parsedJson['meta_data'] != null) {
        for (var item in parsedJson['meta_data']) {
          try {
            if (item['key'] == '_minmax_product_max_quantity') {
              var quantity = int.parse(item['value']);
              quantity == 0 ? maxQuantity = null : maxQuantity = quantity;
            }
          } catch (e) {
            printLog('maxQuantity $e');
          }

          try {
            if (item['key'] == '_minmax_product_min_quantity') {
              var quantity = int.parse(item['value']);
              quantity == 0 ? minQuantity = null : minQuantity = quantity;
            }
          } catch (e) {
            printLog('minQuantity $e');
          }

          try {
            if (item['key'] == '_product_addons') {
              /// Sometimes it returns as Map, sometimes as List.
              final List<dynamic> values = item['value'] is Map
                  ? (item['value'] as Map).values.toList()
                  : item['value'];
              final addOnNames = [];
              addOns = [];

              for (var value in values) {
                /// Customer Defined Price (custom_price) doesn't have any options.
                if (value['options'] != null ||
                    value['type'] == 'custom_price') {
                  final item = ProductAddons.fromJson(value);
                  if (item.name != null && !addOnNames.contains(item.name)) {
                    defaultAddonsOptions[item.name!] = item.defaultOptions;
                    addOns!.add(item);
                    addOnNames.add(item.name);
                  }
                }
              }
            }
          } catch (e) {
            printLog('_product_addons $e');
          }

          try {
            if (item['key'] == 'ihc_mb_who') {
              isRestricted = !item['value'].toString().contains('all') &&
                  item['value'].toString().isNotEmpty;
            }
          } catch (e) {
            printLog('maxQuantity $e');
          }
        }
      }

      minPrice = parsedJson['min_price'];
      maxPrice = parsedJson['max_price'];
      if (isVariableProduct && parsedJson['variation_products'] != null) {
        try {
          variationProducts = [];
          for (var item in parsedJson['variation_products']) {
            variationProducts!.add(ProductVariation.fromJson(Map.from(item)));
          }
        } catch (e) {
          printLog('variation_products_error ${parsedJson['id']} $e');
        }
      }
    } catch (e, trace) {
      printError(e, trace, '🔴 Get product $name :');
    }
  }

  Product.fromOpencartJson(Map parsedJson)
      : id = parsedJson['product_id'] ?? _defaultId {
    try {
      name = HtmlUnescape().convert(parsedJson['name']);
      description = parsedJson['description'];
      permalink =
          '${ServerConfig().url}/index.php?route=product/product&product_id=$id';
      regularPrice = parsedJson['price'];
      salePrice = parsedJson['special'];
      price = salePrice ?? regularPrice;
      onSale = salePrice != null;
      inStock = parsedJson['stock_status'] == 'In Stock' ||
          int.parse(parsedJson['quantity']) > 0;
      averageRating = parsedJson['rating'] != null
          ? double.parse(parsedJson['rating'].toString())
          : 0.0;
      ratingCount = parsedJson['reviews'] != null
          ? int.parse(parsedJson['reviews'].toString())
          : 0.0 as int?;
      attributes = [];

      var list = <String>[];
      if (parsedJson['images'] != null && parsedJson['images'].length > 0) {
        for (var item in parsedJson['images']) {
          if (item != null) {
            list.add(item);
          }
        }
      }
      if (list.isEmpty && parsedJson['image'] != null) {
        list.add('${ServerConfig().url}/image/${parsedJson['image']}');
      }
      images = list;
      imageFeature = images.isNotEmpty ? images[0] : '';
      options = List<Map>.from(parsedJson['options']);
    } catch (e) {
      debugPrintStack();
      printLog(e.toString());
    }
  }

  Product.fromMagentoJson(Map parsedJson) : id = "${parsedJson["id"]}" {
    try {
      sku = parsedJson['sku'];
      name = parsedJson['name'];
      permalink = parsedJson['permalink'];
      inStock = parsedJson['status'] == 1;
      averageRating = 0.0;
      ratingCount = 0;
      categoryId = "${parsedJson["category_id"]}";
      attributes = [];
    } catch (e) {
      debugPrintStack();
      printLog(e.toString());
    }
  }

  Product.fromShopify(Map json) : id = json['id'] {
    try {
      var priceData = json['variants']['edges'][0]['node']['price'];
      var compareAtPriceData =
          json['variants']['edges'][0]['node']['compareAtPrice'];
      var compareAtPrice =
          compareAtPriceData != null ? compareAtPriceData['amount'] : null;
      var collections =
          json['collections'] != null ? json['collections']['edges'] : null;
      var defaultCategory =
          (collections?.isNotEmpty ?? false) ? collections[0]['node'] : null;
      if (collections is List) {
        for (var item in collections) {
          categories.add(Category.fromJsonShopify(item['node']));
        }
      }

      categoryId = json['categoryId'] ?? (defaultCategory ?? {})['id'];
      sku = json['sku'];
      name = json['title'];
      vendor = json['vendor'];
      description = json['descriptionHtml'] ?? json['description'];
      price = priceData != null ? priceData['amount'] : null;
      regularPrice = compareAtPrice ?? price;
      onSale = compareAtPrice != null && compareAtPrice != price;
      type = '';
      salePrice = price;
      stockQuantity = json['totalInventory'];
      var productTags = json['tags'];
      if (productTags is List) {
        for (var item in productTags) {
          tags.add(Tag(
            id: item,
            name: item,
          ));
        }
      }

      inStock = json['availableForSale'] ?? false;
      if ((stockQuantity ?? 0) <= 0 && inStock!) {
        backordersAllowed = true;
        stockQuantity = null;
      }
      ratingCount = 0;
      averageRating = 0;
      permalink = json['onlineStoreUrl'];

      var imgs = <String>[];

      if (json['images']['edges'] != null) {
        for (var item in json['images']['edges']) {
          imgs.add(item['node']['url']);
        }
      }

      images = imgs;
      imageFeature = json['featuredImage']?['url'];

      var attrs = <ProductAttribute>[];

      if (json['options'] != null) {
        for (var item in json['options']) {
          attrs.add(ProductAttribute.fromShopify(item));
        }
      }

      attributes = attrs;
      var variants = <ProductVariation>[];

      if (json['variants']['edges'] != null) {
        for (var item in json['variants']['edges']) {
          variants.add(ProductVariation.fromShopifyJson(item['node']));
        }
      }

      variations = variants;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Product.fromPresta(Map parsedJson, apiLink)
      : id = parsedJson['id'] != null
            ? parsedJson['id'].toString()
            : _defaultId {
    try {
      var productName = parsedJson['name'];
      name = (productName is List && productName.isNotEmpty)
          ? '${productName[0]?['value']}'
          : '$productName';
      description =
          parsedJson['description'] is String ? parsedJson['description'] : '';
      var linkRewrite = parsedJson['link_rewrite'];
      permalink = (linkRewrite is List && linkRewrite.isNotEmpty)
          ? '${linkRewrite[0]?['value']}'
          : '$linkRewrite';
      totalSales = 0;
      regularPrice = (double.parse((parsedJson['price'] ?? 0.0).toString()))
          .toStringAsFixed(2);
      salePrice =
          (double.parse((parsedJson['wholesale_price'] ?? 0.0).toString()))
              .toStringAsFixed(2);
      price = (double.parse((parsedJson['wholesale_price'] ?? 0.0).toString()))
          .toStringAsFixed(2);
      idShop = parsedJson['id_shop_default'] ??
          parsedJson['id_shop_default'].toString();

      categoryId = parsedJson['id_category_default'];
      ratingCount = 0;
      averageRating = 0.0;
      if (salePrice != regularPrice) {
        onSale = true;
      } else {
        onSale = false;
      }
      imageFeature = parsedJson['id_default_image'] != null
          ? apiLink('images/products/$id/${parsedJson["id_default_image"]}')
          : null;
      images = [];
      if (parsedJson['associations'] != null &&
          parsedJson['associations']['images'] != null) {
        for (var item in parsedJson['associations']['images']) {
          images.add(apiLink('images/products/$id/${item["id"]}'));
        }
      } else {
        if (imageFeature != null) {
          images.add(imageFeature!);
        }
      }
      if (parsedJson['associations'] != null &&
          parsedJson['associations']['stock_availables'] != null) {
        sku = parsedJson['associations']['stock_availables'][0]['id'];
      }
      type = parsedJson['type'];
      if (type == 'simple' &&
          parsedJson['id_default_combination'].toString() != '0') {
        type = 'variable';
      }
      if (parsedJson['quantity'] != null &&
          parsedJson['quantity'].toString().isNotEmpty) {
        stockQuantity = int.parse(parsedJson['quantity']);
        if (stockQuantity! > 0) inStock = true;
      }
      inStock ??= false;
      if (parsedJson['associations'] != null &&
          parsedJson['associations']['product_bundle'] != null) {
        groupedProducts = parsedJson['associations']['product_bundle'];
      }
      var attrs = <ProductAttribute>[];
      if (parsedJson['attributes'] != null) {
        var res = Map.from(parsedJson['attributes']);
        var keys = res.keys.toList();
        for (var i = 0; i < keys.length; i++) {
          attrs.add(ProductAttribute.fromPresta(
              {'id': i, 'name': keys[i], 'options': res[keys[i]]}));
        }
        attributes = attrs;
      } else {
        attributes = [];
      }
    } catch (e, trace) {
      printLog(trace);
      printLog(e.toString());
    }
  }

  Product.fromJsonStrapi(SerializerProduct model, apiLink)
      : id = model.id.toString() {
    try {
      name = model.title;
      inStock = !model.isOutOfStock!;
      stockQuantity = model.inventory;
      images = [];
      if (model.images != null) {
        for (var item in model.images!) {
          images.add(apiLink(item.url));
        }
      }
      imageFeature =
          images.isNotEmpty ? images[0] : apiLink(model.thumbnail!.url);

      averageRating = model.review == null ? 0 : model.review!.toDouble();
      ratingCount = 0;
      price = model.price.toString();
      regularPrice = model.price.toString();
      salePrice = model.salePrice.toString();

      if (model.productCategories != null) {
        categoryId = model.productCategories!.isNotEmpty
            ? model.productCategories![0].id.toString()
            : '0';
      } else {
        categoryId = '0';
      }
      onSale = model.isSale;
    } catch (e, trace) {
      printLog(e);
      printLog(trace);
    }
  }

  /// For creating/updating product in manager app
  Map<String, dynamic> toManagerJson() {
    var listAttr = <ProductAttribute>[];
    for (var attr in vendorAdminProductAttributes) {
      if (!(attr.isActive ?? false)) {
        continue;
      }
      listAttr.add(attr);
    }
    var categoryIds = categories.map((e) => e.id).join(',');

    /// Uncategorized
    if (categoryIds.isEmpty) {
      categoryIds = '-1';
    }
    return {
      'id': id,
      'name': name ?? '',
      'status': status ?? 'pending',
      'description': description ?? '',
      'short_description': shortDescription ?? '',
      'type': type ?? '',
      'sku': sku ?? '',
      'regular_price': regularPrice ?? '',
      'sale_price': salePrice ?? '',
      'stock_quantity': stockQuantity?.toString() ?? '',
      'stock_status':
          inStock == null || inStock == false ? 'outofstock' : 'instock',
      'manage_stock': manageStock.toString(),
      'category_ids': categoryIds,
      'product_attributes':
          jsonEncode(listAttr.map((e) => e.toJson()).toList()),
      'variation_products':
          jsonEncode(variationProducts?.map((e) => e.toManagerJson()).toList()),
      'tags': tags.map((e) => e.name).join(','),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'description': description,
      'permalink': permalink,
      'price': price,
      'regularPrice': regularPrice,
      'salePrice': salePrice,
      'onSale': onSale,
      'inStock': inStock,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'total_sales': totalSales,
      'date_on_sale_from': dateOnSaleFrom,
      'date_on_sale_to': dateOnSaleTo,
      'images': images,
      'imageFeature': imageFeature,
      'attributes': attributes?.map((e) => e.toJson()).toList(),
      'addOns': addOns?.map((e) => e.toJson()).toList(),
      'addonsOptions': selectedOptions?.map((e) => e.toJson()).toList(),
      'categoryId': categoryId,
      'stock_quantity': stockQuantity,
      'idShop': idShop,
      'store': store?.toJson(),
      'variations': variations?.map((e) => e.toJson()).toList(),
      'infors': infors.map((e) => e.toJson()).toList(),

      ///----FluxStore Listing----///
      'distance': distance,
      'pureTaxonomies': pureTaxonomies,
      'reviews': reviews,
      'featured': featured,
      'verified': verified,
      'tagLine': tagLine,
      'priceRange': priceRange,
      'categoryName': categoryName,
      'hours': hours,
      'location': location,
      'phone': phone,
      'facebook': facebook,
      'email': email,
      'website': website,
      'skype': skype,
      'whatsapp': whatsapp,
      'youtube': youtube,
      'twitter': twitter,
      'instagram': instagram,
      'eventDate': eventDate,
      'totalReview': totalReview,
      'lat': lat,
      'long': long,
      'prices': listingMenu?.map((e) {
        if (e is ListingMenu) {
          return e.toJson();
        }
        return e;
      }).toList(),
      'slots': slots?.toJson(),
      'isPurchased': isPurchased,
      'isDownloadable': isDownloadable,
      'type': type,
      'bookingInfo': bookingInfo?.toJson(),
      'options': options,
      'metaData': metaData
    };
  }

  Product.fromLocalJson(Map json) : id = json['id'].toString() {
    try {
      sku = json['sku'];
      name = json['name'];
      description = json['description'];
      permalink = json['permalink'];
      price = json['price'];
      regularPrice = json['regularPrice'];
      salePrice = json['salePrice'];
      onSale = json['onSale'] ?? false;
      inStock = json['inStock'];
      averageRating = json['averageRating'];
      ratingCount = json['ratingCount'];
      totalSales = json['total_sales'];
      dateOnSaleFrom = json['date_on_sale_from'];
      dateOnSaleTo = json['date_on_sale_to'];
      idShop = json['idShop'];
      var imgs = <String>[];

      if (json['images'] != null) {
        for (var item in json['images']) {
          imgs.add(item);
        }
      }
      images = imgs;
      imageFeature = json['imageFeature'];
      var attrs = <ProductAttribute>[];

      if (json['attributes'] != null) {
        for (var item in json['attributes']) {
          attrs.add(ProductAttribute.fromLocalJson(item));
        }
      }

      if (json['infors'] != null) {
        for (var item in json['infors']) {
          infors.add(ProductAttribute.fromLocalJson(item));
        }
      }

      if (json['addOns'] != null) {
        var addOnsData = <ProductAddons>[];
        for (var item in json['addOns']) {
          addOnsData.add(ProductAddons.fromJson(item));
        }
        addOns = addOnsData;
      }

      if (json['addonsOptions'] != null) {
        var options = <AddonsOption>[];
        for (var item in json['addonsOptions']) {
          options.add(AddonsOption.fromJson(item));
        }
        selectedOptions = options;
      }

      attributes = attrs;
      categoryId = "${json['categoryId']}";
      stockQuantity = json['stock_quantity'];
      if (json['store'] != null) {
        store = Store.fromLocalJson(json['store']);
      }
      isPurchased = json['isPurchased'] ?? false;
      isDownloadable = json['isDownloadable'] ?? false;
      variations = List.from(json['variations'] ?? []).map((variantJson) {
        return ProductVariation.fromLocalJson(variantJson);
      }).toList();
      type = json['type'];

      ///----FluxStore Listing----///

      distance = json['distance'];
      pureTaxonomies = json['pureTaxonomies'];
      reviews = json['reviews'];
      featured = json['featured'];
      verified = json['verified'];
      tagLine = json['tagLine'];
      priceRange = json['priceRange'];
      categoryName = json['categoryName'];
      hours = json['hours'];
      location = json['location'];
      phone = json['phone'];
      facebook = json['facebook'];
      email = json['email'];
      website = json['website'];
      skype = json['skype'];
      whatsapp = json['whatsapp'];
      youtube = json['youtube'];
      twitter = json['twitter'];
      instagram = json['instagram'];
      eventDate = json['eventDate'];
      totalReview = json['totalReview'];
      lat = json['lat'];
      long = json['long'];
      listingMenu = json['prices'];
      if (json['bookingInfo'] != null) {
        bookingInfo = BookingModel.fromLocalJson(json['bookingInfo']);
      }
      if (json['options'] != null) {
        options = List<Map>.from(json['options']);
      }
      if (json['metaData'] != null) {
        metaData = List<Map>.from(json['metaData']);
      }
    } catch (e, trace) {
      printError(e, trace, '[product.dart] Product.fromLocalJson error');
    }
  }

  Product.fromNotion(Map json) : id = json['properties']?['id'] ?? '' {
    try {
      final properties = json['properties'];
      id = json['id'] ?? '';
      name = NotionDataTools.fromTitle(properties['Name']);

      var dataDescription =
          NotionDataTools.fromRichText(properties['Description']) ?? [];
      dataDescription
          .removeWhere((element) => element.isEmpty || element == '\n');
      description = dataDescription.join('');
      regularPrice = (double.parse(
              ('${NotionDataTools.fromNumber(properties['RegularPrice']) ?? 0.0}')
                  .toString()))
          .toStringAsFixed(2);
      price = (NotionDataTools.fromNumber(properties['Price']) ?? 0.0)
          .toStringAsFixed(2);
      // salePrice = price;
      // (double.parse(
      //         ('${NotionDataTools.fromNumber(properties['SalePrice']) ?? 0.0}')
      //             .toString()))
      //     .toStringAsFixed(2);
      // onSale = NotionDataTools.fromCheckBox(properties['OnSale']);

      final statusStock =
          NotionDataTools.fromRichText(properties['StockStatus'])?.first ?? '';

      inStock = statusStock == 'instock';
      totalSales = int.parse(
          '${NotionDataTools.fromNumber(properties['TotalSales']) ?? 0}');
      images = NotionDataTools.fromFile(properties['Image']) ?? [];
      if (images.isNotEmpty) {
        imageFeature = images.first;
      }

      ratingCount = 0;
      averageRating = 0.0;

      defaultAttributes = <Attribute>[];
      attributes = [];

      if (properties['Color'] != null) {
        final dataColor = NotionDataTools.fromMultiSelect(properties['Color']);
        if (dataColor?.isNotEmpty ?? false) {
          final attrColor = {
            'id': properties['Color']['id'],
            'name': 'color',
            'variation': true,
            'visible': false,
            'options': dataColor,
          };
          final productAttr = ProductAttribute.fromJson(attrColor);
          infors.add(productAttr);
          attributes!.add(productAttr);
        }
      }

      if (properties['Size'] != null) {
        final dataSize = NotionDataTools.fromMultiSelect(properties['Size']);
        if (dataSize?.isNotEmpty ?? false) {
          final attrSize = {
            'id': properties['Size']['id'],
            'name': 'size',
            'variation': false,
            'visible': true,
            'options': dataSize,
          };
          final productAttr = ProductAttribute.fromJson(attrSize);
          infors.add(productAttr);
          attributes!.add(productAttr);
        }
      }
    } catch (e, trace) {
      printLog(trace);
      printLog(e.toString());
    }
  }

  Product.fromBigCommerce(Map json) : id = '${json['id'] ?? ''}' {
    try {
      name = json['name'];
      categoryId = List.from(json['categories'] ?? []).first.toString();
      description = json['description'];
      regularPrice = '${json['price'] ?? '0.0'}';
      price = '${json['price'] ?? '0.0'}';
      salePrice = json['sale_price'] != null
          ? (double.tryParse('${json['sale_price']}') == 0
              ? null
              : '${json['sale_price']}')
          : null;
      onSale = (int.tryParse('$salePrice') ?? 0) > 0;
      inStock = json['availability'] == 'available';
      images = <String>[];
      if (id.isNotEmpty) {
        permalink = 'https://fluxstore/product/$id';
      }

      if (json['images'] != null &&
          json['images'] is List &&
          json['images'].isNotEmpty) {
        for (var item in json['images']) {
          if (item is Map && item['url_zoom'] != null) {
            images.add(item['url_zoom']);
          }
        }
      }

      if (json['primary_image'] != null &&
          json['primary_image']['url_standard'] != null) {
        imageFeature = json['primary_image']['url_standard'];
      } else {
        imageFeature = images.isNotEmpty ? images.first : kDefaultImage;
      }

      ratingCount = json['rating_count'] ?? 0;
      if (ratingCount != 0) {
        averageRating =
            (Tools.formatDouble(json['rating_total']) ?? 0) / ratingCount!;
      }

      variations = [];
      attributes = [];
      defaultAttributes = <Attribute>[];

      final variants = json['variants'];
      if (variants is List && variants.isNotEmpty) {
        for (var item in variants) {
          final variant = ProductVariation.fromBigCommerceJson(item);
          variations?.add(variant);
        }
      }

      final options = json['options'];
      if (options is List && options.isNotEmpty) {
        for (var item in options) {
          final option = ProductAttribute.fromBigCommerceJson(item);
          attributes?.add(option);
          if (option.isDefault ?? false) {
            defaultAttributes.add(
              Attribute.fromBigCommerceJson(json),
            );
          }
        }
      }
    } catch (e, trace) {
      printLog(trace);
      printLog(e.toString());
    }
  }

  /// The return JSON From Ajax Search Pro (WooCommerce)
  Product.fromAjaxSearch(Map json) : id = json['id'].toString() {
    try {
      name = HtmlUnescape().convert(json['title']);
      description =
          isNotBlank(json['post_title']) ? json['post_title'] : json['excerpt'];
      shortDescription = json['content'];
      permalink = json['link'];

      images = [json['image']];
      imageFeature = images.isNotEmpty ? images[0] : null;
    } catch (e, trace) {
      printLog(trace);
      printLog('🔴 Get product $name :${e.toString()}');
    }
  }

  @override
  String toString() => 'Product { id: $id name: $name type: $type }';

  /// Get productID from mix String productID-ProductVariantID+productAddonOptions
  static String cleanProductID(productString) {
    if (ServerConfig().type == ConfigType.notion) {
      return '$productString'.substring(0, NotionDataTools.lengthId);
    }

    // In case 1234+https://somelink.com/might-have-dash-character-here
    if (productString.contains('-') && !productString.contains('+')) {
      return productString.split('-')[0].toString();
    } else if (productString.contains('+')) {
      // In case 1234-6789+https://someaddonsoption
      return cleanProductID(productString.split('+')[0].toString());
    } else {
      return productString.toString();
    }
  }

  double getProductOptionsPrice(int quantity) {
    var price = 0.0;
    if (selectedOptions?.isEmpty ?? true) {
      return price;
    }

    for (var option in selectedOptions!) {
      var optionPrice = (double.tryParse(option.price ?? '0.0') ?? 0.0);
      if (option.isQuantityBased) {
        optionPrice *= quantity;
      }
      price += optionPrice;
    }
    return price;
  }

  ///----FLUXSTORE LISTING----////
  Product.fromListingJson(Map<String, dynamic> json)
      : id = Tools.getValueByKey(json, DataMapping().kProductDataMapping['id'])
            .toString() {
    try {
      name = HtmlUnescape().convert(Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['title']));
      description = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['description']);
      permalink =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['link']);

      distance = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['distance']);

      pureTaxonomies = Tools.getValueByKey(
              json, DataMapping().kProductDataMapping['pureTaxonomies']) is Map
          ? Tools.getValueByKey(
              json, DataMapping().kProductDataMapping['pureTaxonomies'])
          : null;

      final rate = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['rating']);

      averageRating = rate != null
          ? double.parse(double.parse(double.parse(rate.toString()).toString())
              .toStringAsFixed(1))
          : 0.0;

      regularPrice = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['regularPrice']);
      price = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['priceRange']);

      type =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['type']);
      categoryName = type;
      averageRating = double.tryParse(
          '${Tools.getValueByKey(json, DataMapping().kProductDataMapping['rating'])}');
      averageRating = averageRating ?? 0.0;

      final reviews = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['totalReview']);
      totalReview = reviews != null && reviews != false
          ? int.parse(reviews.toString())
          : 0;
      ratingCount = totalReview;

      location = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['address']);
      final la =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['lat']);
      final lo =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['lng']);
      lat = la != null && la.isNotEmpty ? double.parse(la.toString()) : null;
      long = lo != null && lo.isNotEmpty ? double.parse(lo.toString()) : null;

      phone =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['phone']);
      email =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['email']);
      skype =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['skype']);
      website = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['website']);
      whatsapp = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['whatsapp']);
      facebook = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['facebook']);
      twitter = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['twitter']);
      youtube = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['youtube']);
      instagram = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['instagram']);
      tagLine = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['tagLine']);
      eventDate = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['eventDate']);
      priceRange = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['priceRange']);
      featured = 'off';
      if (DataMapping().kProductDataMapping['featured'] != null) {
        featured = Tools.getValueByKey(
            json, DataMapping().kProductDataMapping['featured']);
        if (featured == '1') {
          featured = 'on';
        }
      }
      verified = false;
      if (DataMapping().kProductDataMapping['verified'] != null) {
        String? verifyText = Tools.getValueByKey(
            json, DataMapping().kProductDataMapping['verified']);
        if (verifyText == 'on' || verifyText == 'claimed') {
          verified = true;
        }
      }

      var list = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['gallery']);

      if (list == null || list is bool || list.isEmpty) {
        images = [];
      } else {
        list.forEach((element) => images.add(element));
      }

      var featureImage = Tools.getValueByKey(
          json, DataMapping().kProductDataMapping['featured_media']);

      if (featureImage == null ||
          featureImage is bool ||
          featureImage.isEmpty) {
        if (images.isEmpty) {
          imageFeature = kDefaultImage;
        } else {
          imageFeature = images[0];
        }
      } else if (featureImage is String) {
        imageFeature = featureImage;
      } else {
        imageFeature = featureImage.first;
      }

      if (imageFeature == kDefaultImage) {
        var imgJson = json['better_featured_image'];
        if (imgJson != null) {
          if (imgJson['media_details']?['sizes']?['large'] != null) {
            imageFeature =
                imgJson['media_details']?['sizes']?['large']?['source_url'];
            if (images.isEmpty) {
              images.add(imageFeature!);
            }
          }
        }
      }

      final items =
          Tools.getValueByKey(json, DataMapping().kProductDataMapping['menu']);
      if (items != null && items.length > 0) {
        for (var i = 0; i < items.length; i++) {
          var item = ListingMenu.fromJson(items[i]);
          if (item.menu.isNotEmpty) {
            listingMenu!.add(item);
          }
        }
      }

      /// Remember to check if the theme is listeo
      /// This is for testing only
      if (json['_slots_status'] == 'on') {
        if (json['_slots'] != null) {
          slots = ListingSlots.fromJson(json['_slots']);
        }
      }

      if (json['listing_data']?['_booking_status'] == 'on') {
        listingBookingStatus = true;
      } else {
        listingBookingStatus = false;
      }

      ///Set other attributes that not relate to Listing to be unusable

    } catch (err, trace) {
      printLog('err when parsed json Listing $trace');
    }
  }

  ///----FLUXSTORE LISTING----////

  Product copyWith(
      {String? id,
      String? sku,
      String? name,
      String? status,
      String? vendor,
      String? description,
      String? shortDescription,
      String? permalink,
      String? price,
      String? regularPrice,
      String? salePrice,
      String? maxPrice,
      String? minPrice,
      bool? onSale,
      bool? inStock,
      double? averageRating,
      int? totalSales,
      String? dateOnSaleFrom,
      String? dateOnSaleTo,
      int? ratingCount,
      List<String>? images,
      String? imageFeature,
      List<ProductAttribute>? attributes,
      List<Attribute>? defaultAttributes,
      List<ProductAttribute>? infors,
      String? categoryId,
      String? videoUrl,
      List<dynamic>? groupedProducts,
      List<String?>? files,
      int? stockQuantity,
      int? minQuantity,
      int? maxQuantity,
      bool? manageStock,
      bool? backOrdered,
      String? relatedIds,
      bool? backordersAllowed,
      Store? store,
      List<Tag>? tags,
      List<Category>? categories,
      List<Map>? metaData,
      List<ProductAddons>? addOns,
      List<AddonsOption>? selectedOptions,
      List<VendorAdminVariation>? vendorAdminVariations,
      List<ProductVariation>? variationProducts,
      bool? isPurchased,
      bool? isDownloadable,
      String? type,
      String? affiliateUrl,
      List<ProductVariation>? variations,
      List<Map>? options,
      BookingModel? bookingInfo,
      String? idShop,
      bool? isFeatured,
      String? vendorAdminImageFeature,
      List<String>? categoryIds,
      List<ProductAttribute>? vendorAdminProductAttributes,
      String? distance,
      Map? pureTaxonomies,
      List? reviews,
      String? featured,
      bool? verified,
      String? tagLine,
      String? priceRange,
      String? categoryName,
      String? hours,
      String? location,
      String? phone,
      String? facebook,
      String? email,
      String? website,
      String? skype,
      String? whatsapp,
      String? youtube,
      String? twitter,
      String? instagram,
      String? eventDate,
      int? totalReview,
      double? lat,
      double? long,
      List<dynamic>? listingMenu,
      ListingSlots? slots,
      bool? isRestricted}) {
    return Product(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        name: name ?? this.name,
        status: status ?? this.status,
        vendor: vendor ?? this.vendor,
        description: description ?? this.description,
        shortDescription: shortDescription ?? this.shortDescription,
        permalink: permalink ?? this.permalink,
        price: price ?? this.price,
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        maxPrice: maxPrice ?? this.maxPrice,
        minPrice: minPrice ?? this.minPrice,
        onSale: onSale ?? this.onSale,
        inStock: inStock ?? this.inStock,
        averageRating: averageRating ?? this.averageRating,
        totalSales: totalSales ?? this.totalSales,
        dateOnSaleFrom: dateOnSaleFrom ?? this.dateOnSaleFrom,
        dateOnSaleTo: dateOnSaleTo ?? this.dateOnSaleTo,
        ratingCount: ratingCount ?? this.ratingCount,
        images: images ?? this.images,
        imageFeature: imageFeature ?? this.imageFeature,
        attributes: attributes ?? this.attributes,
        defaultAttributes: defaultAttributes ?? this.defaultAttributes,
        infors: infors ?? this.infors,
        categoryId: categoryId ?? this.categoryId,
        videoUrl: videoUrl ?? this.videoUrl,
        groupedProducts: groupedProducts ?? this.groupedProducts,
        files: files ?? this.files,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        minQuantity: minQuantity ?? this.minQuantity,
        maxQuantity: maxQuantity ?? this.maxQuantity,
        manageStock: manageStock ?? this.manageStock,
        backOrdered: backOrdered ?? this.backOrdered,
        relatedIds: relatedIds ?? this.relatedIds,
        backordersAllowed: backordersAllowed ?? this.backordersAllowed,
        store: store ?? this.store,
        tags: tags ?? this.tags,
        categories: categories ?? this.categories,
        metaData: metaData ?? this.metaData,
        addOns: addOns ?? this.addOns,
        selectedOptions: selectedOptions ?? this.selectedOptions,
        vendorAdminVariations:
            vendorAdminVariations ?? this.vendorAdminVariations,
        variationProducts: variationProducts ?? this.variationProducts,
        isPurchased: isPurchased ?? this.isPurchased,
        isDownloadable: isDownloadable ?? this.isDownloadable,
        type: type ?? this.type,
        affiliateUrl: affiliateUrl ?? this.affiliateUrl,
        variations: variations ?? this.variations,
        options: options ?? this.options,
        bookingInfo: bookingInfo ?? this.bookingInfo,
        idShop: idShop ?? this.idShop,
        isFeatured: isFeatured ?? this.isFeatured,
        vendorAdminImageFeature:
            vendorAdminImageFeature ?? this.vendorAdminImageFeature,
        categoryIds: categoryIds ?? this.categoryIds,
        vendorAdminProductAttributes:
            vendorAdminProductAttributes ?? this.vendorAdminProductAttributes,
        distance: distance ?? this.distance,
        pureTaxonomies: pureTaxonomies ?? this.pureTaxonomies,
        reviews: reviews ?? this.reviews,
        featured: featured ?? this.featured,
        verified: verified ?? this.verified,
        tagLine: tagLine ?? this.tagLine,
        priceRange: priceRange ?? this.priceRange,
        categoryName: categoryName ?? this.categoryName,
        hours: hours ?? this.hours,
        location: location ?? this.location,
        phone: phone ?? this.phone,
        facebook: facebook ?? this.facebook,
        email: email ?? this.email,
        website: website ?? this.website,
        skype: skype ?? this.skype,
        whatsapp: whatsapp ?? this.whatsapp,
        youtube: youtube ?? this.youtube,
        twitter: twitter ?? this.twitter,
        instagram: instagram ?? this.instagram,
        eventDate: eventDate ?? this.eventDate,
        totalReview: totalReview ?? this.totalReview,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        listingMenu: listingMenu ?? this.listingMenu,
        slots: slots ?? this.slots,
        isRestricted: isRestricted ?? this.isRestricted);
  }
}
