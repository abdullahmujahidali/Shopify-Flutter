class SaleoffProductConfig {
  bool showCountDown = true;
  bool hideEmptySaleOffLayout = false;
  String? color;

  SaleoffProductConfig({
    this.showCountDown = true,
    this.hideEmptySaleOffLayout = false,
    this.color ,
  });

  SaleoffProductConfig.fromJson(dynamic json) {
    showCountDown = json['ShowCountDown'] ?? true;
    hideEmptySaleOffLayout = json['HideEmptySaleOffLayout'] ?? false;
    color = json['Color'];
  }
  
  Map toJson() {
    var map = <String, dynamic>{};
    map['ShowCountDown'] = showCountDown;
    map['HideEmptySaleOffLayout'] = hideEmptySaleOffLayout;
    map['Color'] = color;
    map.removeWhere((key, value) => value == null);
    return map;
  }

  SaleoffProductConfig copyWith({bool? showCountDown, bool? hideEmptySaleOffLayout, String? color}) {
    return SaleoffProductConfig(
      showCountDown: showCountDown ?? this.showCountDown,
      hideEmptySaleOffLayout: hideEmptySaleOffLayout ?? this.hideEmptySaleOffLayout,
      color: color ?? this.color,
    );
  }
}
