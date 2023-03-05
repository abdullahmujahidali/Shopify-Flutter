import 'package:flutter/material.dart';
import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';
import '../tabbar/tab_indicator/material_indicator.dart';

/// indicatorSize : 'label' #remove: not use
/// indicatorColor : '', #remove: use theme color
/// unselectedLabelColor : '' #remove: use theme color
/// height : 0.0
/// tabPosition : 0.0
/// topRightRadius : 0.0
/// topLeftRadius : 0.0
/// bottomRightRadius : 0.0
/// bottomLeftRadius : 0.0
/// color : 0.0
/// horizontalPadding : 0.0
/// verticalPadding : 0.0
/// strokeWidth : 0.0
/// radius : 0.0
/// distanceFromCenter : 0.0

TabPosition stringToTabPosition(String? value) {
  if (value.toString().toLowerCase() == 'top') {
    return TabPosition.top;
  }
  return TabPosition.bottom;
}

String tabPositionToString(TabPosition value) =>
    value.toString().split('.').last;

PaintingStyle stringToPaintingStyle(String? value) {
  if (value.toString().toLowerCase() == 'stroke') {
    return PaintingStyle.stroke;
  }
  return PaintingStyle.fill;
}

String? paintingStyleToString(PaintingStyle? value) =>
    value?.toString().split('.').last;

class TabBarIndicatorConfig {
  double? height;
  TabPosition tabPosition = TabPosition.bottom;
  double? topRightRadius;
  double? topLeftRadius;
  double? bottomRightRadius;
  double? bottomLeftRadius;
  HexColor? color;
  double? horizontalPadding;
  double? verticalPadding;
  PaintingStyle? paintingStyle;
  double? strokeWidth;
  double? radius;
  double? distanceFromCenter;

  TabBarIndicatorConfig({
    this.height,
    this.tabPosition = TabPosition.bottom,
    this.topRightRadius,
    this.topLeftRadius,
    this.bottomRightRadius,
    this.bottomLeftRadius,
    this.color,
    this.horizontalPadding,
    this.verticalPadding,
    this.strokeWidth,
    this.radius,
    this.distanceFromCenter,
    this.paintingStyle,
  });

  TabBarIndicatorConfig.fromJson(dynamic json) {
    if (json['color'] != null) {
      color = HexColor(json['color']);
    }
    height = Helper.formatDouble(json['height'], 0.0);
    tabPosition = stringToTabPosition(json['tabPosition']);
    topRightRadius = Helper.formatDouble(json['topRightRadius'], 0.0);
    topLeftRadius = Helper.formatDouble(json['topLeftRadius'], 0.0);
    bottomRightRadius = Helper.formatDouble(json['bottomRightRadius'], 0.0);
    bottomLeftRadius = Helper.formatDouble(json['bottomLeftRadius'], 0.0);
    horizontalPadding = Helper.formatDouble(json['horizontalPadding'], 0.0);
    verticalPadding = Helper.formatDouble(json['verticalPadding'], 0.0);
    strokeWidth = Helper.formatDouble(json['strokeWidth'], 0.0);
    radius = Helper.formatDouble(json['radius'], 0.0);
    distanceFromCenter = Helper.formatDouble(json['distanceFromCenter'], 0.0);
    paintingStyle = stringToPaintingStyle(json['paintingStyle']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['height'] = height;
    map['tabPosition'] = tabPositionToString(tabPosition);
    map['topRightRadius'] = topRightRadius;
    map['topLeftRadius'] = topLeftRadius;
    map['bottomRightRadius'] = bottomRightRadius;
    map['bottomLeftRadius'] = bottomLeftRadius;
    map['color'] = color?.value.toRadixString(16);
    map['horizontalPadding'] = horizontalPadding;
    map['verticalPadding'] = verticalPadding;
    map['strokeWidth'] = strokeWidth;
    map['radius'] = radius;
    map['distanceFromCenter'] = distanceFromCenter;
    map['paintingStyle'] = paintingStyleToString(paintingStyle);
    return map;
  }
}
