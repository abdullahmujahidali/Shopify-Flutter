import '../helper/helper.dart';

class InstagramStoryConfig {
  String? path;
  List<Map> items = [];
  bool usePath = false;
  num marginRight = 15.0;
  num marginBottom = 10.0;
  num marginLeft = 15.0;
  num marginTop = 10.0;
  int limit = 10;
  int time = 10;

  /// item config
  num itemBorderRadius = 10;
  num itemWidth = 100;
  num itemHeight = 200;
  String viewLayout = 'iframe';
  num itemSpacing = 10;
  bool hideAvatar = false;
  bool hideCaption = false;

  InstagramStoryConfig({
    this.path,
    this.items = const [],
    this.usePath = false,
    this.marginLeft = 15.0,
    this.marginRight = 15.0,
    this.marginBottom = 10.0,
    this.marginTop = 10.0,
    this.limit = 10,
    this.time = 10,
    this.itemBorderRadius = 10,
    this.itemWidth = 100,
    this.itemHeight = 200,
    this.viewLayout = 'iframe',
    this.itemSpacing = 10,
  });

  InstagramStoryConfig.fromJson(dynamic json) {
    path = json['path'];
    items = List<Map>.from(json['items'] ?? []);
    usePath = json['usePath'] ?? false;
    marginLeft = json['marginLeft'] ?? 15.0;
    marginRight = json['marginRight'] ?? 15.0;
    marginTop = json['marginTop'] ?? 10.0;
    marginBottom = json['marginBottom'] ?? 10.0;
    limit = Helper.formatInt(json['limit']) ?? 10;
    time = Helper.formatInt(json['time']) ?? 10;
    itemBorderRadius = json['itemBorderRadius'] ?? 10;
    itemWidth = json['itemWidth'] ?? 100;
    itemHeight = json['itemHeight'] ?? 200;
    viewLayout = json['viewLayout'] ?? 'iframe';
    itemSpacing = json['itemSpacing'] ?? 10;
    hideAvatar = json['hideAvatar'] ?? false;
    hideCaption = json['hideCaption'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['path'] = path;
    map['items'] = items;
    map['usePath'] = usePath;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['limit'] = limit;
    map['time'] = time;
    map['itemBorderRadius'] = itemBorderRadius;
    map['itemWidth'] = itemWidth;
    map['itemHeight'] = itemHeight;
    map['viewLayout'] = viewLayout;
    map['itemSpacing'] = itemSpacing;
    map['hideAvatar'] = hideAvatar;
    map['hideCaption'] = hideCaption;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
