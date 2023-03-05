import 'dart:convert';

import 'package:collection/collection.dart';
import 'index.dart';
import 'variable_attributes.dart';

class PosCartItem {
  final Product product;
  final ProductVariation? variation;
  final String title;
  final int quantity;
  final List<VariableAttribute>? selectedVariableAttributes;
  PosCartItem({
    required this.product,
    this.variation,
    required this.title,
    required this.quantity,
    this.selectedVariableAttributes,
  });

  PosCartItem copyWith({
    Product? product,
    ProductVariation? variation,
    String? title,
    int? quantity,
    List<VariableAttribute>? selectedVariableAttributes,
  }) {
    return PosCartItem(
      product: product ?? this.product,
      variation: variation ?? this.variation,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      selectedVariableAttributes:
          selectedVariableAttributes ?? this.selectedVariableAttributes,
    );
  }

  Map<String, dynamic> toMap() {
    var data = {
      'product_id': product.id,
      'quantity': quantity,
    };
    if (variation != null && selectedVariableAttributes != null) {
      data['variation_id'] = variation!.id.toString();
      var attrs = <Map<String, String>>[];
      for (var item in selectedVariableAttributes as List<VariableAttribute>) {
        attrs.add({item.name: item.attributeSlug});
      }
      data['variations'] = attrs;
    }
    return data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'PosCartItem(productId: ${product.id}, variationId: ${variation?.id}, title: $title, quantity: $quantity, selectedVariableAttributes: $selectedVariableAttributes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is PosCartItem &&
        other.product.id == product.id &&
        other.variation?.id == variation?.id &&
        other.title == title &&
        listEquals(
            other.selectedVariableAttributes, selectedVariableAttributes);
  }

  @override
  int get hashCode {
    var variationId = variation?.id.toString() ?? -1;
    return product.id.hashCode ^
        variationId.hashCode ^
        title.hashCode ^
        selectedVariableAttributes.hashCode;
  }
}
