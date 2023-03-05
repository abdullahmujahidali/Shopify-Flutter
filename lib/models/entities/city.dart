class City {
  String? id;
  String? name;
  City({this.id, this.name});

  City.fromConfig(dynamic parsedJson) {
    if (parsedJson is Map) {
      id = parsedJson['id'];
      name = parsedJson['name'];
    }
    if (parsedJson is String) {
      id = parsedJson;
      name = parsedJson;
    }
  }
}
