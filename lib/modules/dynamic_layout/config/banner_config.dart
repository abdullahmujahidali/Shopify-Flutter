import 'package:flutter/cupertino.dart';

import '../helper/helper.dart';
import 'header_config.dart';
import 'text_config.dart';

/// layout : 'bannerImage'
/// design : 'default'
/// fit : 'cover'
/// marginLeft : 5
/// intervalTime : 3
/// items : [{'category':28,'image':'https://user-images.githubusercontent.com/1459805/59846818-12672e80-938b-11e9-8184-5f7bfe66f1a2.png','padding':15},{'padding':15,'image':'https://user-images.githubusercontent.com/1459805/60091575-1f12ca80-976f-11e9-962c-bdccff60d143.png','category':29},{'image':'https://user-images.githubusercontent.com/1459805/60091808-a19b8a00-976f-11e9-9cc7-576ca05c2442.png','padding':15,'product':30}]
/// marginBottom : 5
/// autoPlay : false
/// isSlider : true
/// height : 0.2
/// marginRight : 5
/// marginTop : 5
/// radius : 2

const imageDefault =
    'https://user-images.githubusercontent.com/1459805/59846818-12672e80-938b-11e9-8184-5f7bfe66f1a2.png';

class BannerConfig {
  HeaderConfig? title;

  String? text;
  String? layout;
  String? design;
  String? imageBanner;
  BoxFit? fit;
  List<BannerItemConfig> items = [];
  bool isHorizontal = false;

  /// slider
  bool autoPlay = false;
  bool isSlider = false;
  bool showNumber = false;
  bool isBlur = false;
  bool showBackground = false;
  int? intervalTime;
  double upHeight = 0.0;
  double radius = 6.0;
  double padding = 0.0;

  /// bool type
  double? height;
  double marginLeft = 0.0;
  double marginRight = 0.0;
  double marginTop = 0.0;
  double marginBottom = 0.0;
  bool enableParallax = false;
  double parallaxImageRatio = 1.2;

  BannerConfig({
    this.layout,
    this.text,
    this.title,
    this.design,
    this.imageBanner,
    this.fit,
    this.intervalTime,
    required this.items,
    required this.marginBottom,
    required this.autoPlay,
    required this.isSlider,
    required this.showNumber,
    required this.isBlur,
    required this.showBackground,
    this.height,
    required this.padding,
    required this.marginLeft,
    required this.marginRight,
    required this.marginTop,
    required this.upHeight,
    required this.radius,
    required this.enableParallax,
    required this.parallaxImageRatio,
  });

  BannerConfig.fromJson(dynamic json) {
    title = json['title'] != null ? HeaderConfig.fromJson(json['title']) : null;
    layout = json['layout'];
    text = json['text'];
    design = json['design'];
    imageBanner = json['imageBanner'];
    fit = Helper.boxFit(json['fit']);
    intervalTime = Helper.formatInt(json['intervalTime'], 3) ?? 3;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(BannerItemConfig.fromJson(v));
      });
    }

    autoPlay = json['autoPlay'] ?? false;
    showBackground = json['showBackground'] ?? false;
    isSlider = json['isSlider'] ?? false;
    showNumber = json['showNumber'] ?? false;
    isBlur = json['isBlur'] ?? false;
    enableParallax = json['parallax'] ?? false;
    parallaxImageRatio = Helper.formatDouble(json['parallaxImageRatio']) ?? 1.2;
    isHorizontal = json['isHorizontal'] ?? false;

    /// double
    height = Helper.formatDouble(json['height']);
    upHeight = Helper.formatDouble(json['upHeight']) ?? 0.0;
    padding = Helper.formatDouble(json['padding']) ?? 0.0;
    radius = Helper.formatDouble(json['radius']) ?? 6.0;

    /// spacing
    marginLeft = Helper.formatDouble(json['marginLeft']) ?? 0.0;
    marginRight = Helper.formatDouble(json['marginRight']) ?? 0.0;
    marginTop = Helper.formatDouble(json['marginTop']) ?? 0.0;
    marginBottom = Helper.formatDouble(json['marginBottom']) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['design'] = design;
    map['imageBanner'] = imageBanner;
    map['fit'] = fit?.toString().split('.').last;
    map['marginLeft'] = marginLeft;
    map['items'] = items.map((v) => v.toJson()).toList();
    map['marginBottom'] = marginBottom;
    map['height'] = height;
    map['marginRight'] = marginRight;
    map['marginTop'] = marginTop;
    map['radius'] = radius;
    map['padding'] = padding;
    map['text'] = text;
    map['title'] = title?.toJson();
    map['enableParallax'] = enableParallax;
    map['parallaxImageRatio'] = parallaxImageRatio;
    map['isHorizontal'] = isHorizontal;

    if (isSlider) {
      map['isSlider'] = isSlider;
      map['autoPlay'] = autoPlay;
      map['intervalTime'] = intervalTime;
      map['showNumber'] = showNumber;
      map['isBlur'] = isBlur;
      map['showBackground'] = showBackground;
      map['upHeight'] = upHeight;
    }
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

/// category : 28
/// image : 'https://user-images.githubusercontent.com/1459805/59846818-12672e80-938b-11e9-8184-5f7bfe66f1a2.png'
/// padding : 15

class BannerItemConfig {
  dynamic categoryId;
  late String image;
  List<dynamic>? data;
  dynamic jsonData;
  String? background;
  BannerButtonConfig? button;
  TextConfig? title;
  TextConfig? description;

  /// static layout
  double? padding;
  double? radius;
  bool bannerWithProduct = false;
  bool defaultShowProduct = false;
  int productLength = 3;
  List<String> products = [];

  /// If set it true then click to banner item, it will navigate to
  /// the [SubcategoryScreen] instead of navigate to product page as default
  bool showSubcategory = false;

  BannerItemConfig({
    this.categoryId,
    required this.image,
    this.radius,
    this.padding,
    this.data,
    this.jsonData,
    this.background,
    this.button,
    this.title,
    this.description,
    this.productLength = 3,
    this.bannerWithProduct = false,
    this.defaultShowProduct = false,
    this.products = const [],
    this.showSubcategory = false,
  });

  BannerItemConfig.fromJson(dynamic json) {
    categoryId = json['category'];
    image = json['image'] ?? imageDefault;
    padding = Helper.formatDouble(json['padding']);
    radius = Helper.formatDouble(json['radius']);
    data = json['data'];
    background = json['background'];
    if (json['button'] != null) {
      button = BannerButtonConfig.fromJson(json['button']);
    }
    if (json['title'] != null) {
      title = TextConfig.fromJson(json['title']);
    }
    if (json['description'] != null) {
      description = TextConfig.fromJson(json['description']);
    }
    bannerWithProduct = json['bannerWithProduct'] ?? false;
    defaultShowProduct = json['defaultShowProduct'] ?? false;
    products = List<String>.from(json['products'] ?? []);
    productLength = products.isNotEmpty
        ? products.length
        : (int.tryParse(json['productLength'].toString()) ?? 3);
    showSubcategory = json['showSubcategory'] ?? false;
    // ignore: prefer_initializing_formals
    jsonData = json;
  }

  Map<String, dynamic> toJson() {
    var map = Map<String, dynamic>.from(jsonData);
    map['category'] = categoryId;
    map['image'] = image;
    map['padding'] = padding;
    map['radius'] = radius;
    map['data'] = data;
    map['background'] = background;
    map['showSubcategory'] = showSubcategory;
    map['button'] = button?.toJson();
    map['title'] = title?.toJson();
    map['description'] = description?.toJson();
    map['bannerWithProduct'] = bannerWithProduct;
    map['defaultShowProduct'] = defaultShowProduct;
    map['showSubcategory'] = showSubcategory;
    map['products'] = List<String>.from(products);
    if (products.isNotEmpty) {
      map['productLength'] = products.length;
    }
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

class BannerButtonConfig {
  String text = '';
  String backgroundColor = '#3FC1BE';
  String textColor = '#3FC1BE';
  Alignment alignment = Alignment.topCenter;

  BannerButtonConfig(
      {this.text = '',
      this.backgroundColor = '#3FC1BE',
      this.textColor = '#3FC1BE',
      this.alignment = Alignment.topCenter});

  BannerButtonConfig.fromJson(Map json) {
    text = json['text'] ?? '';
    backgroundColor = json['backgroundColor'] ?? '#3FC1BE';
    textColor = json['textColor'] ?? '#3FC1BE';
    alignment = Alignment(json['x'] ?? 0.0, json['y'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['text'] = text;
    map['backgroundColor'] = backgroundColor;
    map['textColor'] = textColor;
    map['x'] = alignment.x;
    map['y'] = alignment.y;
    return map;
  }
}
