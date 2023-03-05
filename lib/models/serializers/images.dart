import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class Image {
  String? url;
  Image(this.url);
  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

@JsonSerializable()
class Thumbnail {
  String? url;
  Thumbnail(this.url);
  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}
