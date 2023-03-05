class SocialConnectUrl {
  final String name;
  final String icon;
  final String url;

  SocialConnectUrl({required this.name, required this.icon, required this.url});

  factory SocialConnectUrl.fromJson(Map json) {
    return SocialConnectUrl(
      name: '${json['name']}',
      icon: '${json['icon']}',
      url: '${json['url']}',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['url'] = url;
    return data;
  }
}
