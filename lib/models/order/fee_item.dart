class FeeItem {
  String? id;
  String? name;
  String? total;

  FeeItem.fromJson(Map parsedJson) {
    id = parsedJson['id'].toString();
    name = parsedJson['name'];
    total = parsedJson['total'];
  }
}
