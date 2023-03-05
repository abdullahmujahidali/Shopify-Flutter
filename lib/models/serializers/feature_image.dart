import 'package:json_annotation/json_annotation.dart';

part 'feature_image.g.dart';

@JsonSerializable()
class FeatureImage {
  String? url;
  FeatureImage({this.url});
  factory FeatureImage.fromJson(Map<String, dynamic> json) =>
      _$FeatureImageFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureImageToJson(this);
}
