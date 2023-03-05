// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerPayment _$SerializerPaymentFromJson(Map<String, dynamic> json) {
  return SerializerPayment(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$SerializerPaymentToJson(SerializerPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };
