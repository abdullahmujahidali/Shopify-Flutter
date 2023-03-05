import 'box_shadow_config.dart';

enum TestimonialType { chat, card }

class TestimonialConfig {
  String? avatar;
  String? name;
  String? major;
  num? rating;
  TestimonialType type = TestimonialType.card;
  String? textColor; // null use theme
  String? backgroundColor; // null use theme
  bool isLeft = true; // chat layout, chatbox in left
  bool authorInTop = false; // card layout, author detail in top
  String testimonial = '';
  num borderRadius = 5;
  num marginLeft = 0;
  num marginRight = 0;
  num marginTop = 0;
  num marginBottom = 0;
  num borderWidth = 0; //only card layout
  BoxShadowConfig? boxShadowConfig; //only card layout

  TestimonialConfig({
    this.avatar,
    this.name,
    this.major,
    this.rating,
    this.type = TestimonialType.card,
    this.textColor,
    this.backgroundColor,
    this.isLeft = true,
    this.authorInTop = false,
    this.testimonial = '',
    this.borderRadius = 5,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.borderWidth = 0,
    this.boxShadowConfig,
  });

  TestimonialConfig.fromJson(dynamic json) {
    avatar = json['avatar'];
    name = json['name'];
    major = json['major'];
    rating = json['rating'];
    type = TestimonialType.values.firstWhere(
      (element) => element.toString().split('.').last == json['type'],
      orElse: () => TestimonialType.card,
    );
    textColor = json['textColor'];
    backgroundColor = json['backgroundColor'];
    isLeft = json['isLeft'] ?? true;
    authorInTop = json['authorInTop'] ?? false;
    testimonial = json['testimonial'] ?? '';
    borderRadius = json['borderRadius'] ?? 5;
    marginLeft = json['marginLeft'] ?? 0;
    marginRight = json['marginRight'] ?? 0;
    marginTop = json['marginTop'] ?? 0;
    marginBottom = json['marginBottom'] ?? 0;
    borderWidth = json['borderWidth'] ?? 0;
    if (json['boxShadow'] != null) {
      boxShadowConfig = BoxShadowConfig.fromJson(json['boxShadow']);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['avatar'] = avatar;
    map['name'] = name;
    map['major'] = major;
    map['rating'] = rating;
    map['type'] = type.toString().split('.').last;
    map['textColor'] = textColor;
    map['backgroundColor'] = backgroundColor;
    map['isLeft'] = isLeft;
    map['authorInTop'] = authorInTop;
    map['testimonial'] = testimonial;
    map['borderRadius'] = borderRadius;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['borderWidth'] = borderWidth;
    map['boxShadow'] = boxShadowConfig?.toJson();
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
