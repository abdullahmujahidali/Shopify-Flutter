class SpacerConfig {
  late final num height;
  late final String? backgroundColor;
  late final bool useLightColor;

  SpacerConfig({
    this.height = 10.0,
    this.backgroundColor,
    this.useLightColor = false,
  });

  SpacerConfig.fromJson(dynamic json) {
    height = json['height'] ?? 10.0;
    backgroundColor = json['backgroundColor'];
    useLightColor = json['useLightColor'] ?? false;
  }

  SpacerConfig copyWith({
    num? height,
    String? backgroundColor,
    bool? useLightColor,
  }) {
    return SpacerConfig(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      useLightColor: useLightColor ?? this.useLightColor,
    );
  }

  SpacerConfig applyWith({required String backgroundColor}) {
    return SpacerConfig(
      height: height,
      backgroundColor: backgroundColor,
      useLightColor: useLightColor,
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['height'] = height;
    map['backgroundColor'] = backgroundColor;
    map['useLightColor'] = useLightColor;
    return map;
  }
}
