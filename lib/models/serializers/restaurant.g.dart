// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerRestaurant _$SerializerRestaurantFromJson(Map<String, dynamic> json) {
  return SerializerRestaurant(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    address: json['address'] as String?,
    website: json['website'] as String?,
    phone: json['phone'] as String?,
    images: (json['images'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SerializerRestaurantToJson(
        SerializerRestaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'website': instance.website,
      'phone': instance.phone,
      'images': instance.images,
    };
