// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerOrder _$SerializerOrderFromJson(Map<String, dynamic> json) {
  return SerializerOrder(
    id: json['id'] as int?,
    createdAt: json['created_at'] as String?,
    total: (json['total'] as num?)?.toDouble(),
    user: json['user'] == null
        ? null
        : SerializerUser.fromJson(json['user'] as Map<String, dynamic>),
    shipping: json['shipping'] == null
        ? null
        : SerializerShipping.fromJson(json['shipping'] as Map<String, dynamic>),
    payment: json['payment'] == null
        ? null
        : SerializerPayment.fromJson(json['payment'] as Map<String, dynamic>),
    products: (json['products'] as List<dynamic>?)
        ?.map((e) => SerializerProduct.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SerializerOrderToJson(SerializerOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'total': instance.total,
      'user': instance.user,
      'shipping': instance.shipping,
      'payment': instance.payment,
      'products': instance.products,
    };
