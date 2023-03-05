import '../helper/helper.dart';
import 'box_shadow_config.dart';

/// backgroundInput : false
/// fontSize : 13
/// padding : 19
/// text : 'Header'
/// radius : 30
/// textOpacity : 1
/// marginRight : 9
/// marginBottom : 0
/// boxShadow : {'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0}
/// layout : 'header_search'
/// marginLeft : 5
/// showShadow : true
/// borderInput : false
/// marginTop : 6
/// shadow : 10
/// height : 85

class HeaderConfig {
  /// type bool
  bool isSafeArea = false;
  bool showSearch = true;
  bool borderInput = false;
  bool usePrimaryColor = true;

  /// type String
  String? title;
  String? type; // static, rotate, fade, ...
  String? backgroundColor;
  String? textColor;
  String alignment = 'centerLeft';

  /// type num
  num fontWeight = 400;
  num? radius;
  num fontSize = 20.0;
  num textOpacity = 1.0;
  num marginRight = 0.0;
  num marginBottom = 15.0;
  num marginLeft = 0.0;
  num marginTop = 15.0;
  num paddingLeft = 10.0;
  num paddingRight = 15.0;
  num paddingTop = 0.0;
  num paddingBottom = 0.0;
  num height = 44.0;
  num minWidth = 0.0;

  /// other type
  BoxShadowConfig? boxShadow;
  List<String> rotate = [];

  HeaderConfig({
    this.isSafeArea = false,
    this.showSearch = true,
    this.borderInput = false,
    this.usePrimaryColor = true,
    this.title,
    this.type,
    this.backgroundColor,
    this.textColor,
    this.alignment = 'centerLeft',
    this.fontWeight = 400,
    this.radius,
    this.fontSize = 20,
    this.textOpacity = 1.0,
    this.marginRight = 0.0,
    this.marginBottom = 15.0,
    this.marginLeft = 0.0,
    this.marginTop = 15.0,
    this.paddingLeft = 5.0,
    this.paddingRight = 15.0,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.height = 44.0,
    this.boxShadow,
    this.rotate = const [],
    this.minWidth = 0.0,
  });

  HeaderConfig.fromJson(dynamic json) {
    isSafeArea = json['isSafeArea'] ?? false;
    showSearch = json['showSearch'] ?? true;
    borderInput = json['borderInput'] ?? false;
    usePrimaryColor = json['usePrimaryColor'] ?? true;
    title = json['title'] ?? json['text'];
    type = json['type'];
    backgroundColor = json['backgroundColor'];
    textColor = json['textColor'];
    alignment = json['alignment'] ?? 'centerLeft';
    fontWeight = Helper.formatInt(json['fontWeight']) ?? 400;
    radius = json['radius'];
    fontSize = json['fontSize'] ?? 20.0;
    textOpacity = json['textOpacity'] ?? 1.0;
    marginRight = json['marginRight'] ?? 0.0;
    marginLeft = json['marginLeft'] ?? 0.0;
    marginTop = json['marginTop'] ?? 15.0;
    marginBottom = json['marginBottom'] ?? 15.0;
    paddingLeft = json['paddingLeft'] ?? 5.0;
    paddingRight = json['paddingRight'] ?? 15.0;
    paddingTop = json['paddingTop'] ?? 0.0;
    paddingBottom = json['paddingBottom'] ?? 0.0;
    height = json['height'] ?? 44.0;
    boxShadow = json['boxShadow'] != null && json['boxShadow'] is Map
        ? BoxShadowConfig.fromJson(json['boxShadow'])
        : null;

    rotate = List<String>.from(json['rotate'] ?? []);
    minWidth = json['minWidth'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['isSafeArea'] = isSafeArea;
    map['showSearch'] = showSearch;
    map['usePrimaryColor'] = usePrimaryColor;
    map['borderInput'] = borderInput;
    map['title'] = title;
    map['type'] = type;
    map['backgroundColor'] = backgroundColor;
    map['textColor'] = textColor;
    map['alignment'] = alignment;
    map['fontWeight'] = fontWeight;
    map['radius'] = radius;
    map['fontSize'] = fontSize;
    map['textOpacity'] = textOpacity;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['marginBottom'] = marginBottom;
    map['marginTop'] = marginTop;
    map['paddingLeft'] = paddingLeft;
    map['paddingRight'] = paddingRight;
    map['paddingTop'] = paddingTop;
    map['paddingBottom'] = paddingBottom;
    map['height'] = height;
    map['boxShadow'] = boxShadow?.toJson();
    map['rotate'] = rotate;
    map['minWidth'] = minWidth;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
