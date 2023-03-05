import '../helper/helper.dart';

/// blurRadius : 10.0
/// colorOpacity : 0.1
/// spreadRadius : 10.0
/// x : 0.0
/// y : 0.0

class BoxShadowConfig {
  double blurRadius = 10.0;
  double colorOpacity = 0.5;
  double spreadRadius = 10.0;
  double x = 0.0;
  double y = 0.0;

  BoxShadowConfig(
      {this.blurRadius = 10.0,
      this.colorOpacity = 1.0,
      this.spreadRadius = 10.0,
      this.x = 0.0,
      this.y = 0.0});

  BoxShadowConfig.fromJson(dynamic json) {
    blurRadius = Helper.formatDouble(json['blurRadius']) ?? 10.0;
    colorOpacity = Helper.formatDouble(json['colorOpacity']) ?? 0.5;
    spreadRadius = Helper.formatDouble(json['spreadRadius']) ?? 10.0;
    x = Helper.formatDouble(json['x']) ?? 0.0;
    y = Helper.formatDouble(json['y']) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['blurRadius'] = blurRadius;
    map['colorOpacity'] = colorOpacity;
    map['spreadRadius'] = spreadRadius;
    map['x'] = x;
    map['y'] = y;
    return map;
  }
}
