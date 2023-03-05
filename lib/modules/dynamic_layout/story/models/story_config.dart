import 'story.dart';

class StoryConfig {
  String? name;
  bool? active;
  int? countColumn;
  bool? isHorizontal;
  double? radius;
  List<Story>? data;

  StoryConfig({
    this.name,
    this.active,
    this.countColumn,
    this.isHorizontal,
    this.radius,
    this.data,
  });
  StoryConfig.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] ?? 'Stories';
    active = json['active'] ?? false;
    countColumn = json['countColumn'] ?? 4;
    isHorizontal = json['isHorizontal'] ?? true;
    radius = toDouble(json['radius'] ?? 10.0);
    data = [];
    if (json['data']?.isNotEmpty ?? false) {
      for (final item in json['data']) {
        final story = Story.fromJson(item);
        data!.add(story);
      }
    }
  }

  @override
  String toString() {
    return '''\nStory{
      \name: $name
      \ncountColumn: $countColumn
      \nisHorizontal: $isHorizontal
      \nradius: $radius
      \nactive: $active
    }
    ''';
  }
}
