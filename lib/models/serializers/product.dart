import 'package:json_annotation/json_annotation.dart';

import 'images.dart';
import 'product_category.dart';

part 'product.g.dart';

//Automatically generated toJson and fromJson methods for product model

//Attributes in SerializerProduct must be matched with return json key,
//otherwise JsonKey(name: "") must be provided

@JsonSerializable()
class SerializerProduct {
  int? id;
  String? title;
  @JsonKey(name: 'is_out_of_stock')
  bool? isOutOfStock;
  int? inventory;
  @JsonKey(defaultValue: 0)
  double? price;
  @JsonKey(name: 'sale_price', defaultValue: 0)
  double? salePrice;
  List<Image>? images;
  Thumbnail? thumbnail;
  int? review;
  @JsonKey(name: 'is_sale', defaultValue: false)
  bool? isSale;
  @JsonKey(name: 'product_categories')
  List<SerializerProductCategory>? productCategories;
  SerializerProduct(
      {this.id,
      this.title,
      this.isOutOfStock,
      this.inventory,
      this.price,
      this.salePrice,
      this.images,
      this.thumbnail,
      this.productCategories,
      this.review,
      this.isSale});

  factory SerializerProduct.fromJson(Map<String, dynamic> json) =>
      _$SerializerProductFromJson(json);

  Map<String, dynamic> toJson() => _$SerializerProductToJson(this);

  @override
  String toString() => 'ProductSerializer { id: $id name: $title}';
}
