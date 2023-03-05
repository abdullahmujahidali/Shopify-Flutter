import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../routes/flux_navigate.dart';
import '../services/index.dart';
import 'entities/back_drop_arguments.dart';
import 'entities/product.dart';
import 'entities/product_variation.dart';

class ProductModel with ChangeNotifier {
  final Services _service = Services();
  List<List<Product?>> products = [];
  String? message;

  /// current select product id/name
  String? categoryId;
  String? listingLocationId;
  String? categoryName;
  int? tagId;
  double minPrice = 0.0;
  double maxPrice = 0.0;
  String? search;

  //list products for products screen
  bool isFetching = false;
  List<Product>? productsList;
  String? errMsg;
  bool? isEnd;

  List<Product>? recentSearch;

  List<ProductVariation> variations = [];
  List<String> variationsFeatureImages = [];
  ProductVariation? selectedVariation;
  List<Product>? lstGroupedProduct;
  String? cardPriceRange;
  String detailPriceRange = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  CancelableOperation? _cancelLoadProduct;

  void clearProductVariations() {
    variations.clear();
    variationsFeatureImages = [];
    selectedVariation = null;
    notifyListeners();
  }

  void changeSelectedVariation(ProductVariation? variation) {
    selectedVariation = variation;

    if (kProductDetail.showSelectedImageVariant) {
      eventBus.fire(EventChangeSelectedVariation(variation));
    }
    notifyListeners();
  }

  void changeProductVariations(
    List<ProductVariation> newVariations, {
    bool notify = true,
  }) {
    variationsFeatureImages = [];
    variations.clear();
    variations.addAll(newVariations);
    variationsFeatureImages
        .addAll(variations.map((e) => e.imageFeature).whereType<String>());
    if (notify) {
      notifyListeners();
    }
  }

  void setCategoryName(String? name) {
    categoryName = name;
  }

  Future<List<Product>?> fetchGroupedProducts(
      {required Product product}) async {
    lstGroupedProduct = [];
    for (var productID in product.groupedProducts as Iterable<int>) {
      await _service.api.getProduct(productID)!.then((product) {
        if (product != null) {
          lstGroupedProduct!.add(product);
        }
      });
    }
    return lstGroupedProduct;
  }

  void changeDetailPriceRange(String? currency, Map<String, dynamic> rates) {
    if (lstGroupedProduct!.isNotEmpty) {
      var currentPrice = double.parse(lstGroupedProduct![0].price!);
      var max = currentPrice;
      var min = 0;
      for (var product in lstGroupedProduct!) {
        min = double.parse(product.price!).toInt();
        if (min > max) {
          var temp = min;
          max = min.toDouble();
          min = temp;
        }
        detailPriceRange = currentPrice != max
            ? '${PriceTools.getCurrencyFormatted(currentPrice, rates, currency: currency)} - ${PriceTools.getCurrencyFormatted(max, rates, currency: currency)}'
            : PriceTools.getCurrencyFormatted(currentPrice, rates,
                    currency: currency)
                .toString();
      }
    }
  }

  Future<List<Product>?> fetchProductLayout(config, lang, {userId}) async {
    return _service.api
        .fetchProductsLayout(config: config, lang: lang, userId: userId);
  }

  void fetchProductsByCategory({
    categoryId,
    categoryName,
    listingLocationId,
    bool notify = true,
  }) {
    this.categoryId = categoryId;
    this.categoryName = categoryName;
    this.listingLocationId = listingLocationId;
    if (notify) notifyListeners();
  }

  void updateTagId({tagId, bool notify = true}) {
    this.tagId = int.tryParse(tagId.toString());
    if (notify) notifyListeners();
  }

  Future<void> getProductsList(
      {categoryId,
      minPrice,
      maxPrice,
      orderBy,
      order,
      String? tagId,
      lang,
      required page,
      featured,
      onSale,
      attribute,
      attributeTerm,
      listingLocation,
      userId,
      List? include,
      String? search}) async {
    try {
      if (isFetching) {
        await _cancelLoadProduct?.cancel();
      }

      isFetching = true;

      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      if (search != null) {
        this.search = search;
      }
      if (tagId != null && tagId.isNotEmpty) {
        this.tagId = int.tryParse(tagId);
      }
      if (listingLocation != null) {
        listingLocationId = listingLocation;
      }
      isEnd = false;
      notifyListeners();
      String? cursor;
      if (ServerConfig().isNotion && (productsList?.isNotEmpty ?? false)) {
        if (page == 1) {
          cursor = null;
        } else {
          cursor = productsList!.last.id;
        }
      }

      _cancelLoadProduct =
          CancelableOperation.fromFuture(_service.api.fetchProductsByCategory(
        categoryId: categoryId,
        tagId: tagId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        orderBy: orderBy,
        order: order,
        lang: lang,
        page: page,
        featured: featured,
        onSale: onSale,
        attribute: attribute,
        attributeTerm: attributeTerm,
        listingLocation: listingLocation,
        userId: userId,
        nextCursor: cursor,
        include: include?.join(','),
        search: search,
      ));

      final products = await _cancelLoadProduct!.value;

      isEnd = products!.isEmpty;

      if (page == 0 || page == 1) {
        productsList = products;
      } else {
        productsList = [...productsList!, ...products];
      }

      if (search?.isNotEmpty ?? false) {
        recentSearch = productsList;
      }

      isFetching = false;
      errMsg = null;

      notifyListeners();
    } catch (err, trace) {
      errMsg =
          'There is an issue with the app during request the data, please contact admin for fixing the issues $err';
      isFetching = false;
      printError(err, trace);
      notifyListeners();
    }
  }

  void setProductsList(List<Product> products, {bool notify = true}) {
    if (products.isNotEmpty) {
      isFetching = false;
    }
    productsList = products;
    isEnd = false;
    if (notify) notifyListeners();
  }

  Future<void> createProduct(
      List galleryImages,
      List<File> fileImages,
      String? cookie,
      String nameProduct,
      String? type,
      String? idCategory,
      double? salePrice,
      double regularPrice,
      String description) async {
    Future uploadImage() async {
      try {
        if (fileImages.isNotEmpty) {
          for (var i = 0; i < fileImages.length; i++) {
            printLog('path ${path.basename(fileImages[i].path)}');
            await _service.api.uploadImage({
              'title': {'rendered': path.basename(fileImages[i].path)},
              'media_attachment': base64.encode(fileImages[i].readAsBytesSync())
            }, cookie)!.then((photo) {
              galleryImages.add('${photo['id']}');
            });
          }
        } else {
          return;
        }
      } catch (e) {
        rethrow;
      }
    }

    await uploadImage().then((_) async {
      await _service.api.createProduct(cookie, {
        'title': nameProduct,
        'product_type': type,
        'content': description,
        'regular_price': regularPrice,
        'sale_price': salePrice,
        'image_ids': galleryImages,
        'categories': [
          {'id': idCategory}
        ],
        'status': kNewProductStatus
      });
    });
  }

  Future<void> deleteProduct({
    required String? productId,
    required String? cookie,
  }) async {
    _isLoading = true;
    notifyListeners();
    await _service.api.deleteProduct(cookie: cookie, productId: productId);
    _isLoading = false;
    notifyListeners();
  }

  /// Show the product list
  // ignore: missing_return
  static Future showList({
    cateId,
    cateName,
    String? tag,
    List<Product>? products,
    Map<String, dynamic>? config,
    bool showCountdown = false,
    Duration countdownDuration = Duration.zero,
  }) async {
    try {
      await FluxNavigate.pushNamed(
        RouteList.backdrop,
        arguments: BackDropArguments(
          config: config,
          data: products ?? [],
          showCountdown: showCountdown,
          countdownDuration: countdownDuration,
          cateId: cateId,
          cateName: cateName,
          tag: tag,
        ),
      );
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  /// parse product from json
  static List<Product> parseProductList(response, config) {
    var list = <Product>[];
    if (response != null) {
      var products = [];

      /// sort include product
      var include = config['include'];
      if (include != null && include is List) {
        for (var productID in include) {
          var item = (response as List).firstWhereOrNull(
              (element) => element['id'].toString() == productID.toString());
          if (item != null) {
            products.add(item);
          }
        }
      } else {
        products = response;
      }
      for (var item in products) {
        /// ignore the hidden catalog
        if (item['catalog_visibility'] == 'hidden') {
          continue;
        }

        var product = Product.fromJson(item);

        if ((kAdvanceConfig.hideOutOfStock) &&
            !product.inStock! &&
            !product.backordersAllowed) {
          /// hideOutOfStock product
          continue;
        }

        if (config['category'] != null && "${config["category"]}".isNotEmpty) {
          product.categoryId = config['category'].toString();
        }
        if (item['store'] != null) {
          if (item['store']['errors'] != null) {
            list.add(product);
            continue;
          }
          product = Services().widget.updateProductObject(product, item);
        }
        list.add(product);
      }
    }
    return list;
  }

  void setPrices({required double min, required double max}) {
    minPrice = min;
    maxPrice = max;
  }

  void resetPrice() {
    minPrice = 0.0;
    maxPrice = 0.0;
  }

  void resetTag() {
    tagId = null;
  }

  bool enableCounting() {
    return categoryId != null &&
        (listingLocationId?.isEmpty ?? true) &&
        tagId == null &&
        maxPrice == 0.0 &&
        (search?.isEmpty ?? true);
  }
}
