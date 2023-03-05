import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../services/services.dart';
import '../entities/category.dart';
import 'list_category_model.dart';
import 'list_product_model.dart';

class DetailCategoryModel with ChangeNotifier {
  final Category _category;

  final ListCategoryModel _subcategoryModel;
  final ListProductModel _listProductModel;
  int? _totalProduct;
  final api = Services().api;

  String get categoryId => _category.id!;

  int get totalProduct => _totalProduct ?? 0;

  ListProductModel get listProductModel => _listProductModel;

  ListCategoryModel get subcategoryModel => _subcategoryModel;

  bool _intialized = false;

  bool get isLoading => _totalProduct == null;

  bool? get hasChildren =>
      _category.hasChildren ?? (_subcategoryModel.data.isNotEmpty);

  DetailCategoryModel({required Category category})
      : _category = category,
        _listProductModel = ListProductModel(categoryId: category.id!),
        _subcategoryModel = ListCategoryModel(parentId: category.id!);

  Future<void> initData() async {
    if (_intialized) {
      return;
    }
    _intialized = true;
    _totalProduct = _category.totalProduct ??
        await api.getProductCountOfCategory(categoryId);

    notifyListeners();

    /// If null then need check it's has children or not
    if (_category.hasChildren ?? true) {
      await _subcategoryModel.getData();
      if (_subcategoryModel.data.isNotEmpty) {
        notifyListeners();
        return;
      }
    }

    notifyListeners();

    /// If it does not have children then need get product list
    if (!(hasChildren ?? false)) {
      await _listProductModel.getData();
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    _intialized = false;
    await _listProductModel.refresh(autoGetData: false);
    await _subcategoryModel.refresh(autoGetData: false);
    await initData();
  }
}
