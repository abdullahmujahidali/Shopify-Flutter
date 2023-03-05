part of 'products_filter_mixin.dart';

extension ProductsFilterMixinGetterExtension on ProductsFilterMixin {
  String? get orderBy => filterSortBy.orderByType?.name;

  String? get order => filterSortBy.orderType?.name;

  bool? get featured => filterSortBy.featured;

  bool? get onSale => filterSortBy.onSale;
}
