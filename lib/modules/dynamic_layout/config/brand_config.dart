/// Example Brand config
///
/// layout: 'brand',
/// name: 'Our Brand Choice',
/// isBrandNameShown: true,
/// isLogoCornerRounded: true

class BrandConfig {
  String? layout;
  String? name;
  bool? isBrandNameShown = true;
  bool? isLogoCornerRounded = true;

  BrandConfig(this.layout, this.isBrandNameShown, this.isLogoCornerRounded);

  BrandConfig.fromJson(dynamic json) {
    layout = json['layout'];
    name = json['name'];
    isBrandNameShown = json['isBrandNameShown'];
    isLogoCornerRounded = json['isLogoCornerRounded'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['name'] = name;
    map['isBrandNameShown'] = isBrandNameShown;
    map['isLogoCornerRounded'] = isLogoCornerRounded;
    return map;
  }
}
