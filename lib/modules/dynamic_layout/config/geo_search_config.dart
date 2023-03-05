class GeoSearchConfig {
  String? layout;
  bool? showSeeAll;
  String? headerText;
  GeoSearchConfig(this.layout);

  GeoSearchConfig.fromJson(dynamic json) {
    layout = json['layout'];
    showSeeAll = json['showSeeAll'];
    headerText = json['headerText'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['showSeeAll'] = showSeeAll;
    map['headerText'] = headerText;
    return map;
  }
}
