import '../helper/helper.dart';

class TikTokVideosConfig {
  String username = '';
  String uid = '';
  String secUid = '';
  String avatarUrl = '';

  int limit = 10;
  num marginRight = 16.0;
  num marginBottom = 8.0;
  num marginLeft = 16.0;
  num marginTop = 8.0;

  /// item config
  num itemBorderRadius = 10;
  num itemWidth = 100;
  num itemHeight = 200;
  num itemSpacing = 10;
  bool hideAvatar = false;
  bool hideCaption = false;

  TikTokVideosConfig({
    required this.username,
    this.uid = '',
    this.secUid = '',
    this.avatarUrl = '',
    this.marginLeft = 16.0,
    this.marginRight = 16.0,
    this.marginBottom = 8.0,
    this.marginTop = 8.0,
    this.limit = 10,
    this.itemBorderRadius = 10,
    this.itemWidth = 100,
    this.itemHeight = 200,
    this.itemSpacing = 10,
  });

  TikTokVideosConfig.fromJson(dynamic json) {
    username = json['username'];
    uid = json['uid'] ?? '';
    secUid = json['secUid'] ?? '';
    avatarUrl = json['avatarUrl'] ?? '';
    marginLeft = json['marginLeft'] ?? 16.0;
    marginRight = json['marginRight'] ?? 16.0;
    marginTop = json['marginTop'] ?? 8.0;
    marginBottom = json['marginBottom'] ?? 8.0;
    limit = Helper.formatInt(json['limit']) ?? 10;
    itemBorderRadius = json['itemBorderRadius'] ?? 10;
    itemWidth = json['itemWidth'] ?? 100;
    itemHeight = json['itemHeight'] ?? 200;
    itemSpacing = json['itemSpacing'] ?? 10;
    hideAvatar = json['hideAvatar'] ?? false;
    hideCaption = json['hideCaption'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['username'] = username;
    map['uid'] = uid;
    map['secUid'] = secUid;
    map['avatarUrl'] = avatarUrl;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['limit'] = limit;
    map['itemBorderRadius'] = itemBorderRadius;
    map['itemWidth'] = itemWidth;
    map['itemHeight'] = itemHeight;
    map['itemSpacing'] = itemSpacing;
    map['hideAvatar'] = hideAvatar;
    map['hideCaption'] = hideCaption;
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TikTokVideosConfig &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          uid == other.uid &&
          secUid == other.secUid &&
          avatarUrl == other.avatarUrl &&
          limit == other.limit &&
          marginRight == other.marginRight &&
          marginBottom == other.marginBottom &&
          marginLeft == other.marginLeft &&
          marginTop == other.marginTop &&
          itemBorderRadius == other.itemBorderRadius &&
          itemWidth == other.itemWidth &&
          itemHeight == other.itemHeight &&
          itemSpacing == other.itemSpacing &&
          hideAvatar == other.hideAvatar &&
          hideCaption == other.hideCaption;

  @override
  int get hashCode =>
      username.hashCode ^
      uid.hashCode ^
      secUid.hashCode ^
      avatarUrl.hashCode ^
      limit.hashCode ^
      marginRight.hashCode ^
      marginBottom.hashCode ^
      marginLeft.hashCode ^
      marginTop.hashCode ^
      itemBorderRadius.hashCode ^
      itemWidth.hashCode ^
      itemHeight.hashCode ^
      itemSpacing.hashCode ^
      hideAvatar.hashCode ^
      hideCaption.hashCode;
}
