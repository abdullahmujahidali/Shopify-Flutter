import 'dart:convert';

class VariableAttribute {
  final String name;
  final String attributeSlug;
  final String? attributeName;
  final bool isAny;
  VariableAttribute({
    required this.name,
    required this.attributeSlug,
    required this.attributeName,
    required this.isAny,
  });

  VariableAttribute copyWith({
    String? name,
    String? attributeSlug,
    String? attributeName,
    bool? isAny,
  }) {
    return VariableAttribute(
      name: name ?? this.name,
      attributeSlug: attributeSlug ?? this.attributeSlug,
      attributeName: attributeName ?? this.attributeName,
      isAny: isAny ?? this.isAny,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': attributeSlug,
      'attribute_name': attributeName,
    };
  }

  factory VariableAttribute.fromMap(map) {
    return VariableAttribute(
        name: map['name'],
        attributeSlug: map['slug'] ?? '',
        attributeName: map['attribute_name'] ?? map['slug'],
        isAny: (map['slug'] == null || map['attribute_name'] == null) ||
            (map['slug'].isEmpty || map['attribute_name'].isEmpty));
  }

  String toJson() => json.encode(toMap());

  factory VariableAttribute.fromJson(String source) =>
      VariableAttribute.fromMap(json.decode(source));

  @override
  String toString() =>
      'VariableAttribute(name: $name, slug: $attributeSlug, attribute_name: $attributeName, isAny: $isAny)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VariableAttribute &&
        other.name == name &&
        other.attributeSlug == attributeSlug &&
        other.attributeName == attributeName;
  }

  @override
  int get hashCode =>
      name.hashCode ^ attributeSlug.hashCode ^ attributeName.hashCode;
}
