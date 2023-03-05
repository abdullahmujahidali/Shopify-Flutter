import 'package:flutter/material.dart';
import '../helper/helper.dart';

class TextConfig {
  String text = '';
  String fontFamily = 'Roboto';
  double fontSize = 20.0;
  String color = '#3FC1BE';
  bool enableShadow = false;

  Alignment alignment = Alignment.topCenter;

  TextConfig({
    this.text = '',
    this.fontFamily = 'Roboto',
    this.fontSize = 20.0,
    this.color = '#3FC1BE',
    this.alignment = Alignment.topCenter,
    this.enableShadow = false,
  });

  TextConfig.fromJson(Map json) {
    text = json['text'] ?? '';
    fontFamily = json['fontFamily'] ?? 'Roboto';
    fontSize = Helper.formatDouble(json['fontSize']) ?? 20.0;
    color = json['color'] ?? '#3FC1BE';
    alignment = Alignment(Helper.formatDouble(json['x']) ?? 0.0,
        Helper.formatDouble(json['y']) ?? 0.0);
    enableShadow = json['enableShadow'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['text'] = text;
    map['fontFamily'] = fontFamily;
    map['fontSize'] = fontSize;
    map['color'] = color;
    map['x'] = alignment.x;
    map['y'] = alignment.y;
    map['enableShadow'] = enableShadow;
    return map;
  }
}
