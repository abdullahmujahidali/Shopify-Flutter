import 'package:json_annotation/json_annotation.dart';

part 'shipping.g.dart';

@JsonSerializable()
class SerializerShipping {
  int? id;
  String? title;
  String? description;
  int? cost;
  SerializerShipping({this.id, this.title, this.description, this.cost});

  factory SerializerShipping.fromJson(Map<String, dynamic> json) =>
      _$SerializerShippingFromJson(json);

  Map<String, dynamic> toJson() => _$SerializerShippingToJson(this);

  @override
  String toString() => 'SerializerShipping { id: $id title $title}';
}
