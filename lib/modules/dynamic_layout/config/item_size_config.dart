import '../helper/helper.dart';

/// width : 10.0
/// height : 10.0

class ItemSizeConfig {
  double? width;
  double? height;

  ItemSizeConfig({this.width, this.height});

  ItemSizeConfig.fromJson(dynamic json) {
    width = Helper.formatDouble(json['width']) ?? 0.0;
    height = Helper.formatDouble(json['height']) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}
