import '../entities/category.dart';
import 'detail_category_model.dart';
import 'list_category_model.dart';

abstract class CategoryModel extends ListCategoryModel {
  List<Category>? get categories;

  Map<String?, Category> get categoryList;

  void sortCategoryList({
    List<Category>? categoryList,
    dynamic sortingList,
    String? categoryLayout,
  });

  void refreshCategoryList();

  void mapCategories(List<Category> categories, List<Map> remapCategories);

  Future<void> getCategories({
    lang,
    sortingList,
    categoryLayout,
    List<Map>? remapCategories,
  });

  List<Category>? getCategory({required String parentId});

  /// Optimize

  void initSubcategory(Category category, {bool fetchData = false}) {}

  DetailCategoryModel? getDetailCategoryModel(String id) {
    return null;
  }

  List<Category>? get rootCategories =>
      categories?.where((element) => element.isRoot).toList();
}
