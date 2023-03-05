import 'dart:ui';

import '../../../constants.dart';

class StockColor {
  Color inStock = const Color(0xff3fc1be);
  Color outOfStock = const Color(0xffe74c3c);
  Color backorder = const Color(0xffeaa601);

  StockColor({
    this.inStock = const Color(0xff3fc1be),
    this.outOfStock = const Color(0xffe74c3c),
    this.backorder = const Color(0xffeaa601),
  });

  StockColor.fromJson(Map config) {
    inStock = HexColor(config['inStock'] ?? '#3fc1be');
    outOfStock = HexColor(config['outOfStock'] ?? '#e74c3c');
    backorder = HexColor(config['backorder'] ?? '#eaa601');
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['inStock'] = inStock.value.toRadixString(16);
    map['outOfStock'] = outOfStock.value.toRadixString(16);
    map['backorder'] = backorder.value.toRadixString(16);
    return map;
  }
}
