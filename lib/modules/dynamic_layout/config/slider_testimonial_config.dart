import '../helper/helper.dart';
import '../index.dart';

class SliderTestimonialConfig {
  String type = 'default';
  num marginLeft = 0;
  num marginRight = 0;
  num marginTop = 0;
  num marginBottom = 0;
  bool autoPlay = false;
  int intervalTime = 3;
  num height = 250;
  List<TestimonialConfig> items = [];

  SliderTestimonialConfig({
    this.type = 'default',
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.autoPlay = false,
    this.intervalTime = 3,
    this.height = 250,
    this.items = const [],
  });

  SliderTestimonialConfig.fromJson(dynamic json) {
    type = json['type'] ?? 'default';
    marginLeft = json['marginLeft'] ?? 0;
    marginRight = json['marginRight'] ?? 0;
    marginTop = json['marginTop'] ?? 0;
    marginBottom = json['marginBottom'] ?? 0;
    autoPlay = json['autoPlay'] ?? false;
    height = json['height'] ?? 250;
    intervalTime = Helper.formatInt(json['intervalTime']) ?? 3;
    if (json['items'] != null && json['items'] is List) {
      for (var item in json['items']) {
        items.add(TestimonialConfig.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['type'] = type;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['autoPlay'] = autoPlay;
    map['intervalTime'] = intervalTime;
    map['height'] = height;
    var mapItem = <Map<String, dynamic>>[];
    for (var item in items) {
      mapItem.add(item.toJson());
    }
    map['items'] = mapItem;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
