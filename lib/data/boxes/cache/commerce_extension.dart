part of '../../boxes.dart';

extension CommerceCacheExtension on CacheBox {
  Map<String, dynamic>? get vendorCategories {
    return box.get(
      BoxKeys.vendorCategories,
      defaultValue: null,
    );
  }

  set vendorCategories(Map<String, dynamic>? value) {
    if (value == null) {
      box.delete(BoxKeys.vendorCategories);
      return;
    }
    box.put(BoxKeys.vendorCategories, value);
  }

  List? getShopCategoryCache(String key) {
    final boxKey = '${BoxKeys.shopCategoryCacheKeyPrefix}$key';
    return box.get(
      boxKey,
      defaultValue: null,
    );
  }

  void setShopCategoryCache(
    String key,
    List value,
  ) {
    final boxKey = '${BoxKeys.shopCategoryCacheKeyPrefix}$key';
    if (value.isEmpty) {
      box.delete(boxKey);
      return;
    }
    box.put(boxKey, value);
  }
}
