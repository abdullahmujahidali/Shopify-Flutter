// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerProduct _$SerializerProductFromJson(Map<String, dynamic> json) {
  return SerializerProduct(
    id: json['id'] as int?,
    title: json['title'] as String?,
    isOutOfStock: json['is_out_of_stock'] as bool?,
    inventory: json['inventory'] as int?,
    price: (json['price'] as num?)?.toDouble() ?? 0,
    salePrice: (json['sale_price'] as num?)?.toDouble() ?? 0,
    images: (json['images'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
    thumbnail: json['thumbnail'] == null
        ? null
        : Thumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
    productCategories: (json['product_categories'] as List<dynamic>?)
        ?.map((e) =>
            SerializerProductCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
    review: json['review'] as int?,
    isSale: json['is_sale'] as bool? ?? false,
  );
}

Map<String, dynamic> _$SerializerProductToJson(SerializerProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'is_out_of_stock': instance.isOutOfStock,
      'inventory': instance.inventory,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'images': instance.images,
      'thumbnail': instance.thumbnail,
      'review': instance.review,
      'is_sale': instance.isSale,
      'product_categories': instance.productCategories,
    };
