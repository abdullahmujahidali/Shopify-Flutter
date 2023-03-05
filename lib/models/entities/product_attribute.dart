import '../../common/constants.dart';
import '../../common/tools.dart';

class ProductAttribute {
  String? id;
  String? name;
  String? label;
  String? slug;
  List? options = [];
  List optionSlugs = [];
  bool? isVisible;
  bool? isVariation;

  String? get cleanSlug => slug?.replaceAll('pa_', '');
  bool? isDefault;
  bool? isActive = false;

  /// For BigCommerce.
  String? type;

  ProductAttribute({
    this.id,
    this.name,
    this.label,
    this.slug,
    this.options,
    this.optionSlugs = const [],
    this.isVisible,
    this.isVariation,
    this.isDefault,
    this.isActive,
    this.type,
  });

  ProductAttribute.fromJson(Map parsedJson) {
    id = parsedJson['id'].toString();
    label = parsedJson['label'] ?? parsedJson['name']?.replaceAll('pa_', '');
    name = parsedJson['name']?.replaceAll('pa_', '');

    slug = parsedJson['slug']?.toString().toLowerCase();
    isVariation = parsedJson['variation'] ?? false;
    isVisible = parsedJson['visible'] ?? false;
    isDefault = parsedJson['default'] ?? false;
    if (parsedJson['options'] != null) {
      for (var item in parsedJson['options']) {
        options!.add(item);
      }
    }
    if (parsedJson['slugs'] != null) {
      for (var item in parsedJson['slugs']) {
        optionSlugs.add(item);
      }
    }
  }

  ProductAttribute.fromMagentoJson(Map parsedJson) {
    id = "${parsedJson["attribute_id"]}";
    name = parsedJson['attribute_code'];
    label = name;
    options = parsedJson['options'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'options': options,
      'slugs': optionSlugs,
      'visible': isVisible,
      'variation': isVariation,
      'isActive': isActive,
      'default': isDefault,
      'slug': slug,
    };
  }

  ProductAttribute.fromLocalJson(Map json) {
    try {
      id = json['id']?.toString();
      name = json['name'];
      options = json['options'];
      label = name;
    } catch (e) {
      printLog(e.toString());
    }
  }

  ProductAttribute.fromShopify(att) {
    try {
      id = att['id'];
      name = att['name'];
      label = name;
      List? values = att['values'];
      if (values != null) {
        options = values;
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  ProductAttribute.fromPresta(att) {
    try {
      id = att['id'].toString();
      name = att['name'];
      options = att['options'];
      label = name;
    } catch (e) {
      printLog(e.toString());
    }
  }

  ProductAttribute.fromNotion(
      Map<String, dynamic> parsedJson, String nameAttribute) {
    id = parsedJson['id'].toString();
    name = nameAttribute; // name for FluxStore Manager
    label = name;
    slug = nameAttribute;
    isVariation = false;
    isVisible = true;
    options = NotionDataTools.fromMultiSelect(parsedJson);
  }

  ProductAttribute.fromBigCommerceJson(Map json) {
    id = '${json['id']}';
    name = id;
    label = json['display_name'];
    type = json['type'];
    // sortOrder = json['sort_order'];
    final optionValues = json['option_values'];
    if (optionValues is List && optionValues.isNotEmpty) {
      options = [];
      for (var item in optionValues) {
        options?.add(Map.from(item));
        optionSlugs.add(item['id']);
      }
    }
  }

  ProductAttribute copyWith({
    String? id,
    String? name,
    String? label,
    String? slug,
    List? options,
    List? optionSlugs,
    bool? isVisible,
    bool? isVariation,
    bool? isDefault,
    bool? isActive,
  }) {
    return ProductAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      slug: slug ?? this.slug,
      options: options ?? this.options,
      optionSlugs: optionSlugs ?? this.optionSlugs,
      isVisible: isVisible ?? this.isVisible,
      isVariation: isVariation ?? this.isVariation,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }
}

class Attribute {
  int? id;
  String? name;
  String? option;

  /// For BigCommerce.
  String? optionLabel;

  Attribute({
    this.id,
    this.name,
    this.option,
    this.optionLabel,
  });

  Attribute.fromJson(Map parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    option = parsedJson['option'];
  }

  Attribute.fromMagentoJson(Map parsedJson) {
    id = int.parse(parsedJson['value']);
    name = parsedJson['attribute_code'];
    option = parsedJson['value'];
  }

  Attribute.fromLocalJson(Map parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    option = parsedJson['option'];
  }

  Attribute.fromShopifyJson(Map parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    option = parsedJson['value'];
  }

  Attribute.fromPrestaJson(Map parsedJson) {
    id = int.tryParse('${parsedJson['id']}');
    name = parsedJson['name'];
    option = parsedJson['option'];
  }

  Attribute.fromBigCommerceJson(Map json) {
    id = json['id'];
    name = '${json['option_id']}';
    option = json['label'];
    optionLabel = json['option_display_name'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'option': option};
  }

  @override
  String toString() {
    return '${name ?? ""}${option ?? ""}';
  }
}
