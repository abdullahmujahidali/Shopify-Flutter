class TikTokVideo {
  int? bitrate;
  String? codecType;
  String? cover;
  String? definition;
  String? downloadAddr;
  int? duration;
  String? dynamicCover;
  String? encodeUserTag;
  String? encodedType;
  String? format;
  int? height;
  String? id;
  String? originCover;
  String? playAddr;
  String? ratio;
  String? reflowCover;
  List<String>? shareCover;
  String? videoQuality;
  int? width;

  TikTokVideo({
    this.bitrate,
    this.codecType,
    this.cover,
    this.definition,
    this.downloadAddr,
    this.duration,
    this.dynamicCover,
    this.encodeUserTag,
    this.encodedType,
    this.format,
    this.height,
    this.id,
    this.originCover,
    this.playAddr,
    this.ratio,
    this.reflowCover,
    this.shareCover,
    this.videoQuality,
    this.width,
  });

  TikTokVideo.fromJson(Map json) {
    bitrate = json['bitrate'];
    codecType = json['codecType'];
    cover = json['cover'];
    definition = json['definition'];
    downloadAddr = json['downloadAddr'];
    duration = json['duration'];
    dynamicCover = json['dynamicCover'];
    encodeUserTag = json['encodeUserTag'];
    encodedType = json['encodedType'];
    format = json['format'];
    height = json['height'];
    id = json['id'];
    originCover = json['originCover'];
    playAddr = json['playAddr'];
    ratio = json['ratio'];
    reflowCover = json['reflowCover'];
    shareCover = json['shareCover'].cast<String>();
    videoQuality = json['videoQuality'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bitrate'] = bitrate;
    data['codecType'] = codecType;
    data['cover'] = cover;
    data['definition'] = definition;
    data['downloadAddr'] = downloadAddr;
    data['duration'] = duration;
    data['dynamicCover'] = dynamicCover;
    data['encodeUserTag'] = encodeUserTag;
    data['encodedType'] = encodedType;
    data['format'] = format;
    data['height'] = height;
    data['id'] = id;
    data['originCover'] = originCover;
    data['playAddr'] = playAddr;
    data['ratio'] = ratio;
    data['reflowCover'] = reflowCover;
    data['shareCover'] = shareCover;
    data['videoQuality'] = videoQuality;
    data['width'] = width;
    return data;
  }
}
