import '../../../modules/dynamic_layout/helper/helper.dart';

class AgeRestrictionConfig {
  final bool enable;
  final String imageUrl;
  final String backgroundImageUrl;
  final String title;
  final String deniedMessage;
  final String hintMessage;
  final int minimumAge;
  final bool useLogo;
  final bool alwaysShowUponOpen;

  AgeRestrictionConfig({
    this.enable = false,
    this.imageUrl = '',
    this.backgroundImageUrl = '',
    this.title = '',
    this.deniedMessage = '',
    this.hintMessage = '',
    this.minimumAge = 21,
    this.useLogo = true,
    this.alwaysShowUponOpen = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'enable': enable,
      'imageUrl': imageUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'title': title,
      'deniedMessage': deniedMessage,
      'hintMessage': hintMessage,
      'minimumAge': minimumAge,
      'useLogo': useLogo,
      'alwaysShowUponOpen': alwaysShowUponOpen,
    };
  }

  factory AgeRestrictionConfig.fromMap(Map map) {
    return AgeRestrictionConfig(
      enable: map['enable'] == true,
      imageUrl: '${map['imageUrl'] ?? ''}',
      backgroundImageUrl: '${map['backgroundImageUrl'] ?? ''}',
      title: '${map['title'] ?? ''}',
      deniedMessage: '${map['deniedMessage'] ?? ''}',
      hintMessage: '${map['hintMessage'] ?? ''}',
      minimumAge: Helper.formatInt(map['minimumAge'] ?? 21) ?? 21,
      useLogo: map['useLogo'] != false,
      alwaysShowUponOpen: map['alwaysShowUponOpen'] != false,
    );
  }

  AgeRestrictionConfig copyWith({
    bool? enable,
    String? imageUrl,
    String? backgroundImageUrl,
    String? title,
    String? deniedMessage,
    String? hintMessage,
    int? minimumAge,
    bool? useLogo,
    bool? alwaysShowUponOpen,
  }) {
    return AgeRestrictionConfig(
      enable: enable ?? this.enable,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      title: title ?? this.title,
      deniedMessage: deniedMessage ?? this.deniedMessage,
      hintMessage: hintMessage ?? this.hintMessage,
      minimumAge: minimumAge ?? this.minimumAge,
      useLogo: useLogo ?? this.useLogo,
      alwaysShowUponOpen: alwaysShowUponOpen ?? this.alwaysShowUponOpen,
    );
  }
}
