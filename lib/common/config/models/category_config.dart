class CategoryAdvanceConfig {
  final bool enableLargeCategories;
  final int deepLevel;

  const CategoryAdvanceConfig({
    required this.enableLargeCategories,
    this.deepLevel = 2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryAdvanceConfig &&
          runtimeType == other.runtimeType &&
          enableLargeCategories == other.enableLargeCategories &&
          deepLevel == other.deepLevel);

  @override
  int get hashCode => enableLargeCategories.hashCode ^ deepLevel.hashCode;

  @override
  String toString() {
    return 'CategoryConfig{ enableLargeCategories: $enableLargeCategories, deepLevel: $deepLevel,}';
  }

  CategoryAdvanceConfig copyWith({
    bool? enableLargeCategories,
    int? deepLevel,
  }) {
    return CategoryAdvanceConfig(
      enableLargeCategories:
          enableLargeCategories ?? this.enableLargeCategories,
      deepLevel: deepLevel ?? this.deepLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableLargeCategories': enableLargeCategories,
      'deepLevel': deepLevel,
    };
  }

  factory CategoryAdvanceConfig.fromJson(Map map) {
    return CategoryAdvanceConfig(
      enableLargeCategories: (map['enableLargeCategories'] as bool?) ?? false,
      deepLevel: (map['deepLevel'] as int?) ?? 2,
    );
  }
}
