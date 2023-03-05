import 'package:flutter/material.dart';

import '../../../models/category/list_category_model.dart';
import '../../../models/index.dart';
import '../../../services/services.dart';

class SubcategoryModel with ChangeNotifier {
  final _serviceApi = Services().api;
  final String _parentId;

  final ListCategoryModel listSubcategoryModel;

  Category? parentCategory;

  SubcategoryModel({required String parentId})
      : _parentId = parentId,
        listSubcategoryModel = ListCategoryModel(parentId: parentId);

  Future<void> getData() {
    return Future.wait([
      _getInfoParentCategory(),
      listSubcategoryModel.getData(),
    ]);
  }

  Future<void> _getInfoParentCategory() async {
    parentCategory =
        await _serviceApi.getProductCategoryById(categoryId: _parentId);
    notifyListeners();
  }
}
