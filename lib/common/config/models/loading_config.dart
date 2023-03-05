enum LoadingLayout { rive, spinkit, image, lottie }

class LoadingConfig {
  LoadingLayout layout = LoadingLayout.spinkit;
  String? type;
  num? size;
  String? path;

  LoadingConfig({
    this.layout = LoadingLayout.spinkit,
    this.type,
    this.size,
    this.path,
  });

  LoadingConfig.fromJson(dynamic json) {
    layout = LoadingLayout.values.firstWhere(
      (element) => element.toString().split('.').last == json['layout'],
      orElse: () => LoadingLayout.spinkit,
    );
    type = json['type'];
    size = json['size'];
    path = json['path'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout.toString().split('.').last;
    map['type'] = type;
    map['size'] = size;
    map['path'] = path;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
