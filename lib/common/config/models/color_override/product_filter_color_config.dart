class ProductFilterColor {
  bool useBackgroundColor = false;
  bool usePrimaryColorLight = false;
  String? backgroundColor;
  num backgroundColorOpacity = 1.0;
  String? labelColor;
  num labelColorOpacity = 1.0;
  bool useAccentColor = false;

  ProductFilterColor({
    this.useBackgroundColor = false,
    this.usePrimaryColorLight = false,
    this.backgroundColor,
    this.backgroundColorOpacity = 1.0,
    this.labelColor,
    this.labelColorOpacity = 1.0,
    this.useAccentColor = false,
  });

  ProductFilterColor.fromJson(dynamic json) {
    useBackgroundColor = json['useBackgroundColor'] ?? false;
    usePrimaryColorLight = json['usePrimaryColorLight'] ?? false;
    backgroundColor = json['backgroundColor'];
    backgroundColorOpacity = json['backgroundColorOpacity'] ?? 1.0;
    labelColor = json['labelColor'];
    labelColorOpacity = json['labelColorOpacity'] ?? 1.0;
    useAccentColor = json['useAccentColor'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['useBackgroundColor'] = useBackgroundColor;
    map['usePrimaryColorLight'] = usePrimaryColorLight;
    map['backgroundColor'] = backgroundColor;
    map['backgroundColorOpacity'] = backgroundColorOpacity;
    map['labelColor'] = labelColor;
    map['labelColorOpacity'] = labelColorOpacity;
    map['useAccentColor'] = useAccentColor;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
