import 'package:json_annotation/json_annotation.dart';

import 'images.dart';

part 'restaurant.g.dart';

//Automatically generated toJson and fromJson methods for product model

//Attributes in SerializerProduct must be matched with return json key,
//otherwise JsonKey(name: "") must be provided

@JsonSerializable()
class SerializerRestaurant {
  int? id;
  String? name;
  String? description;
  String? address;
  String? website;
  String? phone;
  List<Image>? images;

  SerializerRestaurant({
    this.id,
    this.name,
    this.description,
    this.address,
    this.website,
    this.phone,
    this.images,
  });

  factory SerializerRestaurant.fromJson(Map<String, dynamic> json) =>
      _$SerializerRestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$SerializerRestaurantToJson(this);

  @override
  String toString() => 'ProductSerializer { id: $id name: $name}';
}
