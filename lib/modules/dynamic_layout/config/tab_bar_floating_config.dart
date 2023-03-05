import 'package:flutter/material.dart';
import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';

/// position : 0
/// radius : 0.0
/// color : ''
/// marginTop : 0.0
/// marginBottom : 0.0
/// marginLeft : 0.0
/// marginRight : 0.0

FloatingActionButtonLocation? stringToFloatingActionButtonLocation(
    String? value) {
  switch (value) {
    case 'centerDocked':
      return FloatingActionButtonLocation.centerDocked;
    case 'startDocked':
      return FloatingActionButtonLocation.startDocked;
    case 'endDocked':
      return FloatingActionButtonLocation.endDocked;
    case 'miniCenterDocked':
      return FloatingActionButtonLocation.miniCenterDocked;
    case 'miniStartDocked':
      return FloatingActionButtonLocation.miniStartDocked;
    case 'miniEndDocked':
      return FloatingActionButtonLocation.miniEndDocked;
    default:
  }
  return null;
}

String? floatingActionButtonLocationToString(
    FloatingActionButtonLocation? value) {
  switch (value) {
    case FloatingActionButtonLocation.centerDocked:
      return 'centerDocked';
    case FloatingActionButtonLocation.startDocked:
      return 'startDocked';
    case FloatingActionButtonLocation.endDocked:
      return 'endDocked';
    case FloatingActionButtonLocation.miniCenterDocked:
      return 'miniCenterDocked';
    case FloatingActionButtonLocation.miniStartDocked:
      return 'miniStartDocked';
    case FloatingActionButtonLocation.miniEndDocked:
      return 'miniEndDocked';
    default:
  }
  return null;
}

enum FloatingType {
  diamond,
  rectangle,
}

FloatingType stringToFloatingType(String? value) {
  switch (value) {
    case 'diamond':
      return FloatingType.diamond;
    default:
      return FloatingType.rectangle;
  }
}

String floatingTypeToString(FloatingType value) =>
    value.toString().split('.').last;

class TabBarFloatingConfig {
  int? position;
  FloatingActionButtonLocation? location;
  late FloatingType floatingType;
  HexColor? color;
  double? radius;
  double? elevation; //shadow
  double? width;
  double? height;

  TabBarFloatingConfig({
    this.position,
    this.radius,
    this.floatingType = FloatingType.rectangle,
    this.color,
    this.width,
    this.height,
    this.elevation,
    this.location,
  });

  TabBarFloatingConfig.fromJson(dynamic json) {
    if (json['color'] != null) {
      color = HexColor(json['color']);
    }
    location = stringToFloatingActionButtonLocation(json['location']);
    position = Helper.formatInt(json['position'], 0);
    floatingType = stringToFloatingType(json['floatingType']);
    radius = Helper.formatDouble(json['radius'], 50.0);
    width = Helper.formatDouble(json['width'], 50.0);
    height = Helper.formatDouble(json['height'], 50.0);
    elevation = Helper.formatDouble(json['elevation'], 2.0);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['position'] = position;
    map['radius'] = radius;
    map['color'] = color?.value.toRadixString(16);
    map['location'] = floatingActionButtonLocationToString(location);
    map['width'] = width;
    map['height'] = height;
    map['elevation'] = elevation;
    map['floatingType'] = floatingTypeToString(floatingType);
    return map;
  }
}
