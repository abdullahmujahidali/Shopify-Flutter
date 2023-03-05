// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerShipping _$SerializerShippingFromJson(Map<String, dynamic> json) {
  return SerializerShipping(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    cost: json['cost'] as int?,
  );
}

Map<String, dynamic> _$SerializerShippingToJson(SerializerShipping instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'cost': instance.cost,
    };
