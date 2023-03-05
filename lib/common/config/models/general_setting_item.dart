import 'package:flutter/material.dart';

import '../../../modules/dynamic_layout/helper/helper.dart';
import '../../tools/tools.dart';

const defaultIcon = 'news';
const defaultIconFontFamily = 'CupertinoIcons';
const defaultId = 'web-12'; //web, post, title

class GeneralSettingItem {
  String id = defaultId;
  String title = '';
  String icon = defaultIcon;
  String iconFontFamily = defaultIconFontFamily;
  int? pageId;
  String? webUrl;
  double? fontSize;
  String? titleColor;
  Map? verticalPadding;
  Map? horizontalPadding;
  bool enableDivider = false;
  bool requiredLogin = false;
  bool webViewMode = false;
  bool enableForward = false;
  bool enableBackward = true;
  String? script;
  bool enableClose = false;
  String buttonAlignment = 'centerLeft';
  List<GeneralButton> buttons = [];
  String? product;
  String? category;
  String? banner;
  num bannerHeight = 15.0;
  String? blog;
  String? blogCategory;

  GeneralSettingItem({
    this.id = defaultId,
    this.title = '',
    this.icon = defaultIcon,
    this.iconFontFamily = defaultIconFontFamily,
    this.pageId,
    this.webUrl,
    this.fontSize,
    this.titleColor,
    this.verticalPadding,
    this.horizontalPadding,
    this.enableDivider = false,
    this.requiredLogin = false,
    this.webViewMode = false,
    this.enableBackward = true,
    this.enableForward = false,
    this.script,
    this.enableClose = false,
    this.buttonAlignment = 'centerLeft',
    this.buttons = const [],
    this.product,
    this.category,
    this.banner,
    this.bannerHeight = 15.0,
    this.blog,
    this.blogCategory,
  });

  GeneralSettingItem.fromJson(Map json) {
    id = json['id'] ?? defaultId;
    title = json['title'] ?? '';
    icon = json['icon'] ?? defaultIcon;
    iconFontFamily = json['iconFontFamily'] ?? defaultIconFontFamily;
    pageId =
        json['pageId'] != null ? int.tryParse(json['pageId'].toString()) : null;
    webUrl = json['webUrl'];
    fontSize = json['fontSize'] != null
        ? double.tryParse(json['fontSize'].toString())
        : null;
    titleColor = json['titleColor'];
    verticalPadding = json['verticalPadding'];
    horizontalPadding = json['horizontalPadding'];
    enableDivider = json['enableDivider'] ?? false;
    requiredLogin = json['requiredLogin'] ?? false;
    webViewMode = json['webViewMode'] ?? false;
    enableForward = json['enableForward'] ?? false;
    enableBackward = json['enableBackward'] ?? true;
    script = json['script'];
    enableClose = json['enableClose'] ?? false;
    buttonAlignment = json['buttonAlignment'] ?? 'centerLeft';
    if (json['buttons'] != null) {
      for (var item in json['buttons']) {
        buttons.add(GeneralButton.fromJson(item));
      }
    }
    product = json['product']?.toString();
    category = json['category']?.toString();
    banner = json['banner']?.toString();
    bannerHeight = json['bannerHeight'] ?? 15.0;
    blog = json['blog'];
    blogCategory = json['blogCategory'];
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>.from({
      'id': id,
      'title': title,
      'icon': icon,
      'iconFontFamily': iconFontFamily
    });
    if (pageId != null) json['pageId'] = pageId;
    if (webUrl != null) json['webUrl'] = webUrl;
    if (fontSize != null) json['fontSize'] = fontSize;
    if (titleColor != null) json['titleColor'] = titleColor;
    json['verticalPadding'] = verticalPadding;
    json['horizontalPadding'] = horizontalPadding;
    if (enableDivider) json['enableDivider'] = enableDivider;
    if (webViewMode) json['webViewMode'] = webViewMode;
    if (requiredLogin) json['requiredLogin'] = requiredLogin;
    if (enableForward) json['enableForward'] = enableForward;
    if (enableBackward) json['enableBackward'] = enableBackward;
    if (enableClose) json['enableClose'] = enableClose;
    if (script?.isNotEmpty ?? false) json['script'] = script;
    json['buttonAlignment'] = buttonAlignment;
    var jsonButtons = [];
    for (var item in buttons) {
      jsonButtons.add(item.toJson());
    }
    json['buttons'] = jsonButtons;
    json['product'] = product;
    json['category'] = category;
    json['banner'] = banner;
    json['bannerHeight'] = bannerHeight;
    json['blog'] = blog;
    json['blogCategory'] = blogCategory;
    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class GeneralButton {
  String? text;
  String? image;
  String? textColor;
  num textFontSize = 14.0;
  num width = 40;
  num height = 40;
  num radius = 0;
  num marginLeft = 5.0;
  num marginRight = 5.0;
  String? webUrl; // No longer in use
  Map<String, dynamic> navigator = {};

  GeneralButton({
    this.text,
    this.image,
    this.textColor,
    this.textFontSize = 14.0,
    this.width = 40,
    this.height = 40,
    this.radius = 0,
    this.marginLeft = 5.0,
    this.marginRight = 5.0,
    this.webUrl,
    this.navigator = const {},
  });

  GeneralButton.fromJson(dynamic json) {
    text = json['text'];
    image = json['image'];
    textColor = json['textColor'];
    textFontSize = json['textFontSize'] ?? 14.0;
    width = json['width'] ?? 40.0;
    height = json['height'] ?? 40.0;
    radius = json['radius'] ?? 0.0;
    marginLeft = json['marginLeft'] ?? 5.0;
    marginRight = json['marginRight'] ?? 5.0;
    webUrl = json['webUrl'];

    // To adapt to old config, include only webUrl
    navigator = Map.from(
        json['navigator'] ?? <String, dynamic>{'url_launch': json['webUrl']});
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['text'] = text;
    map['image'] = image;
    map['textColor'] = textColor;
    map['textFontSize'] = textFontSize;
    map['width'] = width;
    map['radius'] = radius;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['height'] = height;
    map['webUrl'] = webUrl;

    var navigatorMap = <String, dynamic>{};
    for (var key in navigator.keys) {
      if (navigator[key] != null) {
        navigatorMap[key] = navigator[key];
      }
    }
    map['navigator'] = Map.from(navigatorMap);
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

extension ExtensionGeneralSettingItem on GeneralSettingItem {
  AlignmentGeometry get displayButtonAlignment =>
      Tools.getAlignment(buttonAlignment);

  EdgeInsets get padding => EdgeInsets.only(
        left: Helper.formatDouble(horizontalPadding?['x']) ?? 0.0,
        right: Helper.formatDouble(horizontalPadding?['y']) ?? 0.0,
        top: Helper.formatDouble(verticalPadding?['x']) ?? 0.0,
        bottom: Helper.formatDouble(verticalPadding?['y']) ?? 0.0,
      );
}
