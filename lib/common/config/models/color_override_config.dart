import 'color_override/index.dart';

export 'color_override/index.dart';

class ColorOverrideConfig {
  ProductFilterColor? productFilterColor;
  StockColor stockColor = StockColor();
  RatingColor ratingColor = RatingColor();

  ColorOverrideConfig({
    this.productFilterColor,
    required this.stockColor,
    required this.ratingColor,
  });

  ColorOverrideConfig.fromJson(dynamic json) {
    if (json['productFilterColor'] != null) {
      productFilterColor =
          ProductFilterColor.fromJson(json['productFilterColor']);
    }
    if (json['stockColor'] != null) {
      stockColor = StockColor.fromJson(json['stockColor']);
    }
    if (json['ratingColor'] != null) {
      ratingColor = RatingColor.fromJson(json['ratingColor']);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['productFilterColor'] = productFilterColor?.toJson();
    map['stockColor'] = stockColor.toJson();
    map['ratingColor'] = ratingColor.toJson();
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
