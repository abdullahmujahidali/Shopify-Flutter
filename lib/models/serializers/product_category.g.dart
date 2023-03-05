// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerProductCategory _$SerializerProductCategoryFromJson(
    Map<String, dynamic> json) {
  return SerializerProductCategory(
    json['id'] as int?,
    json['name'] as String?,
    json['description'] as String?,
    json['feature_image'] == null
        ? null
        : FeatureImage.fromJson(json['feature_image'] as Map<String, dynamic>),
    (json['products'] as List<dynamic>?)
        ?.map((e) => SerializerProduct.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SerializerProductCategoryToJson(
        SerializerProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'feature_image': instance.featureImage,
      'products': instance.products,
    };
