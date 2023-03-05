class FilterTag {
  int? id;
  String? slug;
  String? name;
  String? description;
  int? count;

  FilterTag({this.id, this.name, this.slug, this.description, this.count});

  FilterTag.fromJson(Map parsedJson) {
    id = parsedJson['id'];
    slug = parsedJson['slug'];
    name = parsedJson['name'];
    description = parsedJson['description'];
    count = parsedJson['count'];
  }
}
