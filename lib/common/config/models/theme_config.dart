import '../../constants.dart';

class ThemeConfig {
  String mainColor = '#3FC1BE';
  String? logoImage;
  String? backgroundColor;
  String? primaryColorLight;
  String? textColor;
  String? secondaryColor;

  String get logo => logoImage ?? kLogo;

  ThemeConfig({
    this.mainColor = '#3FC1BE',
    this.logoImage,
    this.backgroundColor,
    this.primaryColorLight,
    this.textColor,
    this.secondaryColor,
  });

  ThemeConfig.fromJson(Map config) {
    mainColor = config['MainColor'] ?? '#3FC1BE';
    logoImage = config['logo'];
    backgroundColor = config['backgroundColor'];
    primaryColorLight = config['primaryColorLight'];
    textColor = config['textColor'];
    secondaryColor = config['secondaryColor'];
  }

  Map? toJson() {
    var map = <String, dynamic>{};
    map['MainColor'] = mainColor;
    map['logo'] = logoImage;
    map['backgroundColor'] = backgroundColor;
    map['primaryColorLight'] = primaryColorLight;
    map['textColor'] = textColor;
    map['secondaryColor'] = secondaryColor;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
