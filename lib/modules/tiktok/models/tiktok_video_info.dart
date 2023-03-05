import 'tiktok_video.dart';

class TikTokVideoInfo {
  // Custom.
  String authorAvatar = '';

  bool? adAuthorization;
  int? adLabelVersion;
  int? createTime;
  String? desc;
  bool? digged;
  int? duetDisplay;
  bool? duetEnabled;
  bool? forFriend;
  String? id;
  bool? isAd;
  int? itemCommentStatus;
  bool? itemMute;
  bool? officalItem;
  bool? originalItem;
  bool? privateItem;
  bool? secret;
  bool? shareEnabled;
  bool? showNotPass;
  int? stitchDisplay;
  bool? stitchEnabled;
  TikTokVideo? video;
  bool? vl1;

  TikTokVideoInfo({
    this.adAuthorization,
    this.adLabelVersion,
    this.createTime,
    this.desc,
    this.digged,
    this.duetDisplay,
    this.duetEnabled,
    this.forFriend,
    this.id,
    this.isAd,
    this.itemCommentStatus,
    this.itemMute,
    this.officalItem,
    this.originalItem,
    this.privateItem,
    this.secret,
    this.shareEnabled,
    this.showNotPass,
    this.stitchDisplay,
    this.stitchEnabled,
    this.video,
    this.vl1,
  });

  TikTokVideoInfo.fromJson(Map json) {
    adAuthorization = json['adAuthorization'];
    adLabelVersion = json['adLabelVersion'];
    createTime = json['createTime'];
    desc = json['desc'];
    digged = json['digged'];
    duetDisplay = json['duetDisplay'];
    duetEnabled = json['duetEnabled'];
    forFriend = json['forFriend'];
    id = json['id'];
    isAd = json['isAd'];
    itemCommentStatus = json['itemCommentStatus'];
    itemMute = json['itemMute'];
    officalItem = json['officalItem'];
    originalItem = json['originalItem'];
    privateItem = json['privateItem'];
    secret = json['secret'];
    shareEnabled = json['shareEnabled'];
    showNotPass = json['showNotPass'];
    stitchDisplay = json['stitchDisplay'];
    stitchEnabled = json['stitchEnabled'];
    video = json['video'] != null ? TikTokVideo.fromJson(json['video']) : null;
    vl1 = json['vl1'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['adAuthorization'] = adAuthorization;
    data['adLabelVersion'] = adLabelVersion;
    data['createTime'] = createTime;
    data['desc'] = desc;
    data['digged'] = digged;
    data['duetDisplay'] = duetDisplay;
    data['duetEnabled'] = duetEnabled;
    data['forFriend'] = forFriend;
    data['id'] = id;
    data['isAd'] = isAd;
    data['itemCommentStatus'] = itemCommentStatus;
    data['itemMute'] = itemMute;
    data['officalItem'] = officalItem;
    data['originalItem'] = originalItem;
    data['privateItem'] = privateItem;
    data['secret'] = secret;
    data['shareEnabled'] = shareEnabled;
    data['showNotPass'] = showNotPass;
    data['stitchDisplay'] = stitchDisplay;
    data['stitchEnabled'] = stitchEnabled;
    if (video != null) {
      data['video'] = video!.toJson();
    }
    data['vl1'] = vl1;
    return data;
  }
}
