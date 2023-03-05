class Prediction {
  String? description;
  String? placeId;
  String? lat;
  String? long;
  Prediction.fromJson(json) {
    description = json['description'];
    placeId = json['place_id'];
  }
  Prediction();
}
