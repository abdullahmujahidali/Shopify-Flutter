class UserShippingLocation {
  String? address;
  double? lat;
  double? lng;

  UserShippingLocation({this.address, this.lat, this.lng});

  UserShippingLocation.fromJson(Map json) {
    address = json['address'];
    lat = double.parse(json['lat'].toString());
    lng = double.parse(json['lng'].toString());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
