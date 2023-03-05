import 'package:flutter/material.dart';

class MetadataItem {
  String id = UniqueKey().toString();
  String? code;
  String? image;
  String? video;
  String? profileImage;
  String? caption;
  String? mediaCaption;
  MetadataItem({
    required this.id,
    this.code,
    this.image,
    this.video,
    this.profileImage,
    this.caption,
    this.mediaCaption,
  });

  MetadataItem.fromJson(dynamic json, {String? profile}) {
    id = json['id'] ?? UniqueKey().toString();
    code = json['shortcode'];
    image = json['thumbnail_src'];
    video = json['video_url'];
    caption = json['accessibility_caption'];
    var mediaCaps = json['edge_media_to_caption']?['edges'] as List?;
    if (mediaCaps?.isNotEmpty ?? false) {
      mediaCaption = (mediaCaps!.first)['node']?['text'];
    }
    profileImage = profile;
  }

  MetadataItem.fromConfig(dynamic json) {
    id = UniqueKey().toString();
    code = json['code'];
    image = json['image'];
    video = json['video'];
    profileImage = json['profileImage'];
    mediaCaption = json['mediaCaption'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['image'] = image;
    map['video'] = video;
    map['profileImage'] = profileImage;
    map['mediaCaption'] = mediaCaption;
    map['caption'] = caption;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
