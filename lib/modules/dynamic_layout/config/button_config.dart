class ButtonConfig {
  String alignment = 'topCenter';
  num marginTop = 0.0;
  num marginBottom = 0.0;
  List<ButtonItemConfig> items = [];

  ButtonConfig({
    this.alignment = 'topCenter',
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
    this.items = const [],
  });

  ButtonConfig.fromJson(dynamic json) {
    alignment = json['alignment'] ?? 'topCenter';
    marginTop = json['marginTop'] ?? 0.0;
    marginBottom = json['marginBottom'] ?? 0.0;
    if (json['items']?.isNotEmpty ?? false) {
      for (var item in json['items']) {
        items.add(ButtonItemConfig.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['alignment'] = alignment;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    var itemsJson = [];
    for (var item in items) {
      itemsJson.add(item.toJson());
    }
    map['items'] = itemsJson;
    return map;
  }
}

class ButtonItemConfig {
  String? text;
  String? image;
  String? backgroundColor;
  String? textColor;
  num width = 100.0;
  num height = 20.0;
  num borderRadius = 2.0;
  num marginLeft = 0.0;
  num marginRight = 0.0;
  num textFontSize = 14.0;
  bool useMaxWidth = false;
  Map<String, dynamic> navigator = {}; //use for onTapNavigateOptions

  ButtonItemConfig({
    this.text,
    this.image,
    this.backgroundColor,
    this.textColor,
    this.width = 100.0,
    this.height = 20.0,
    this.borderRadius = 2.0,
    this.marginLeft = 0.0,
    this.marginRight = 0.0,
    this.textFontSize = 14.0,
    this.useMaxWidth = false,
    this.navigator = const {},
  });

  ButtonItemConfig.fromJson(dynamic json) {
    text = json['text'];
    image = json['image'];
    backgroundColor = json['backgroundColor'];
    textColor = json['textColor'];
    width = json['width'] ?? 100.0;
    height = json['height'] ?? 20.0;
    borderRadius = json['borderRadius'] ?? 2.0;
    marginLeft = json['marginLeft'] ?? 0.0;
    marginRight = json['marginRight'] ?? 0.0;
    textFontSize = json['textFontSize'] ?? 14.0;
    useMaxWidth = json['useMaxWidth'] ?? false;
    navigator = Map.from(json['navigator'] ?? <String, dynamic>{});
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['text'] = text;
    map['image'] = image;
    map['backgroundColor'] = backgroundColor;
    map['textColor'] = textColor;
    map['width'] = width;
    map['height'] = height;
    map['borderRadius'] = borderRadius;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['textFontSize'] = textFontSize;
    map['useMaxWidth'] = useMaxWidth;
    navigator.removeWhere((key, value) => value == null);
    map['navigator'] = Map.from(navigator);
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
