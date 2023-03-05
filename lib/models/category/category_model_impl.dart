import 'package:collection/collection.dart'
    show IterableExtension, UnmodifiableListView;

import '../../common/constants.dart';
import '../../services/index.dart';
import '../entities/category.dart';
import 'category_model.dart';

class CategoryModelImpl extends CategoryModel {
  final Services _service = Services();

  List<Category>? _categories;

  @override
  UnmodifiableListView<Category> get data =>
      UnmodifiableListView(_categories ?? <Category>[]);

  @override
  List<Category>? get categories => _categories;

  @override
  Map<String?, Category> categoryList = {};

  @override
  bool isLoading = false;

  List<Category>? _allCategories;

  /// Format the Category List and assign the List by Category ID
  @override
  void sortCategoryList(
      {List<Category>? categoryList,
      dynamic sortingList,
      String? categoryLayout}) {
    var listCategory = <String?, Category>{};
    var result = categoryList;

    if (sortingList != null) {
      var categories = <Category>[];
      var subCategories = <Category>[];
      var isParent = true;
      for (var cate in sortingList) {
        var item = categoryList!.firstWhereOrNull(
            (Category cat) => cat.id.toString() == cate.toString());
        if (item != null) {
          if (item.parent != '0') {
            isParent = false;
          }
          categories.add(item);
        }
      }
      if (!['column', 'grid', 'subCategories'].contains(categoryLayout)) {
        for (var category in categoryList!) {
          var item =
              categories.firstWhereOrNull((cat) => cat.id == category.id);
          if (item == null && isParent && category.parent != '0') {
            subCategories.add(category);
          }
        }
      }
      result = [...categories, ...subCategories];
    }

    for (var cat in result!) {
      listCategory[cat.id] = cat;
    }
    this.categoryList = listCategory;
    _categories = result;
    notifyListeners();
  }

  @override
  void mapCategories(List<Category> categories, List<Map> remapCategories) {
    var result = <String?, Category>{};
    for (var cat in categories) {
      result[cat.id] = cat;
    }
    var items = <String?, Category>{};
    for (var remapCategory in remapCategories) {
      final categoryId = remapCategory['category'].toString();
      var category = result[categoryId];
      if (category != null) {
        items[remapCategory['category'].toString()] = category.copyWith(
          totalProduct: null,
          name: remapCategory['name'],
          image: remapCategory['image'],
          parent: remapCategory['parent']?.toString(),
        );
        result.removeWhere((key, value) => key == categoryId);
      }
    }
    items.addAll(result);
    result = items;
    categoryList = Map<String?, Category>.from(result);
    _categories = result.values.toList();

    // Override total product after remap
    for (var category in _categories!) {
      if (category.isRoot) {
        final totalProduct = _categories!
            .where((element) => element.parent == category.id.toString())
            .fold(
                0,
                (int previousValue, element) =>
                    previousValue + (element.totalProduct ?? 0));
        if (totalProduct > 0) {
          category = category.copyWith(totalProduct: totalProduct);
        }
        categoryList[category.id] = category;
      }
    }
    _categories = categoryList.values.toList();
    notifyListeners();
  }

  @override
  Future<void> getCategories({
    lang,
    sortingList,
    categoryLayout,
    List<Map>? remapCategories,
  }) async {
    try {
      printLog('[Category] getCategories');
      isLoading = true;
      notifyListeners();
      _allCategories = await _service.api.getCategories(lang: lang);

      if (remapCategories != null) {
        mapCategories(
            List<Category>.from(_allCategories ?? []), remapCategories);
      } else {
        sortCategoryList(
          categoryList: _allCategories,
          sortingList: sortingList,
          categoryLayout: categoryLayout,
        );
      }

      isLoading = false;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      //notifyListeners();
    }
  }

  @override
  List<Category>? getCategory({required String parentId}) {
    return _categories?.where((element) => element.parent == parentId).toList();
  }

  @override
  bool get isFirstLoad =>
      _categories == null || (_categories!.isEmpty && isLoading);

  @override
  void refreshCategoryList() {
    _categories?.clear();
    notifyListeners();
  }
}
