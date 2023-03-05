import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../models/entities/filter_sorty_by.dart';
import '../../../../models/index.dart';
import '../../../app.dart';
import '../../../generated/l10n.dart';
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../../../widgets/backdrop/backdrop_menu.dart';
import '../../../widgets/common/drag_handler.dart';
import '../widgets/filter_label.dart';

part 'getter_extension.dart';

part 'methods_extension.dart';

part 'widget_extension.dart';

mixin ProductsFilterMixin {
  String get lang;

  String get tagName;

  FilterAttributeModel get filterAttrModel;

  CategoryModel get categoryModel;

  Future<void> getProductList();

  void clearProductList();

  /// Call setState(() {}) or notifyListener().
  void rebuild();

  void onCloseFilter();

  void onCategorySelected(String name);

  /// Filter params.
  String? categoryId;
  double? minPrice;
  double? maxPrice;
  int page = 1;
  String? tagId;
  String? attribute;
  String? listingLocationId;
  List? include;
  String? search;
  FilterSortBy filterSortBy = const FilterSortBy();

  bool get enableSearchHistory => false;

  bool get shouldShowLayout => enableSearchHistory ? false : true;
}
