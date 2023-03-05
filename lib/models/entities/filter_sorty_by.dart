import 'package:collection/collection.dart';

import '../../generated/l10n.dart';

enum OrderType { asc, desc }

extension Display on OrderType {
  String get displayPrice =>
      this == OrderType.asc ? 'Low to High' : 'High to Low';

  String get displayDate => this == OrderType.asc ? 'Newest' : 'Oldest';

  String get displayTitle => this == OrderType.asc ? 'A -> Z' : 'Z -> A';

  bool get isAsc => this == OrderType.asc;
  bool get isDesc => this == OrderType.desc;
}

enum OrderByType {
  onSale,
  featured,
  price,
  date,
  title,
  popularity,
  rating,
  id,
  include,
  slug,
  modified,
  // ignore: constant_identifier_names
  menu_order,
}

class FilterSortBy {
  /// Include name, date, price, popularity, rating
  final OrderByType? orderByType;

  /// Include asc, desc
  final OrderType? orderType;
  final bool? featured;
  final bool? onSale;

  const FilterSortBy({
    this.orderByType,
    this.orderType,
    this.featured,
    this.onSale,
  });

  FilterSortBy applyOrderBy(
    String? orderByType,
  ) {
    return FilterSortBy(
      orderByType: OrderByType.values
          .firstWhereOrNull((element) => element.name == orderByType),
      orderType: orderType,
      featured: featured,
      onSale: onSale,
    );
  }

  FilterSortBy applyOrder(
    String? orderType,
  ) {
    return FilterSortBy(
      orderType: OrderType.values
          .firstWhereOrNull((element) => element.name == orderType),
      orderByType: orderByType,
      featured: featured,
      onSale: onSale,
    );
  }

  FilterSortBy applyFeatured(
    bool? featured,
  ) {
    return FilterSortBy(
      orderByType: orderByType,
      orderType: orderType,
      featured: featured,
      onSale: onSale,
    );
  }

  FilterSortBy applyOnSale(
    bool? onSale,
  ) {
    return FilterSortBy(
      orderByType: orderByType,
      orderType: orderType,
      featured: featured,
      onSale: onSale,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterSortBy &&
          runtimeType == other.runtimeType &&
          orderByType == other.orderByType &&
          orderType == other.orderType &&
          featured == other.featured &&
          onSale == other.onSale);

  @override
  int get hashCode =>
      orderByType.hashCode ^
      orderType.hashCode ^
      featured.hashCode ^
      onSale.hashCode;

  @override
  String toString() {
    return 'OrderBy{'
        ' type: $orderByType,'
        ' sortBy: $orderType,'
        ' featured: $featured,'
        ' onSale: $onSale,'
        '}';
  }

  FilterSortBy copyWith({
    OrderByType? type,
    OrderType? sortBy,
    bool? featured,
    bool? onSale,
  }) {
    return FilterSortBy(
      orderByType: type ?? orderByType,
      orderType: sortBy ?? orderType,
      featured: featured ?? this.featured,
      onSale: onSale ?? this.onSale,
    );
  }

  FilterSortBy copyWithString({
    String? orderBy,
    String? order,
    String? featured,
    String? onSale,
  }) {
    return FilterSortBy(
      orderByType: orderBy == null
          ? orderByType
          : OrderByType.values.firstWhere(
              (element) => element.name == orderBy,
              orElse: () => OrderByType.date,
            ),
      orderType: order == null
          ? orderType
          : OrderType.values.firstWhere(
              (element) => element.name == order,
              orElse: () => OrderType.desc,
            ),
      featured: featured == null
          ? this.featured
          : featured == 'featured'
              ? true
              : false,
      onSale: onSale == null
          ? this.onSale
          : onSale == 'onSale'
              ? true
              : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': orderByType,
      'sortBy': orderType,
      'featured': featured,
      'onSale': onSale,
    };
  }

  factory FilterSortBy.fromMap(Map map) {
    return FilterSortBy(
      orderByType: map['type'] as OrderByType,
      orderType: map['sortBy'] as OrderType,
      featured: map['featured'] as bool,
      onSale: map['onSale'] as bool,
    );
  }

  String? get groupOrderBy => '${orderByType?.name}-${orderType?.name}';

  String? get groupSpecial => featured ?? false
      ? 'featured'
      : onSale ?? false
          ? 'onSale'
          : null;

  String? get displaySpecial {
    if (featured ?? false) {
      return S.current.featured;
    }
    if (onSale ?? false) {
      return S.current.onSale;
    }
    return null;
  }

  String? get displayOrderBy {
    switch (orderByType) {
      case OrderByType.price:
        return S.current.byPrice;
      case OrderByType.date:
        return S.current.date;
      case OrderByType.title:
        return S.current.title;
      case OrderByType.popularity:
        return S.current.popularity;
      case OrderByType.rating:
        return S.current.averageRating;
      case OrderByType.menu_order:
        return S.current.menuOrder;
      default:
        return null;
    }
  }
}
