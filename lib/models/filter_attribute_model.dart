import 'package:flutter/material.dart';

import '../services/index.dart';
import 'entities/filter_attribute.dart';
import 'mixins/language_mixin.dart';

class FilterAttributeModel with ChangeNotifier, LanguageMixin {
  List<FilterAttribute>? lstProductAttribute;
  final Services _service = Services();
  List<SubAttribute> lstCurrentAttr = [];
  List<bool> lstCurrentSelectedTerms = [];
  bool _isLoading = false;
  bool _isEnd = false;
  int? selectedAttr;

  bool get isLoadingMore => _isLoading && lstCurrentAttr.isNotEmpty;

  bool get isLoading => _isLoading;

  bool get isEnd => _isEnd;

  bool get isFirstLoad => _isLoading && lstCurrentAttr.isEmpty;

  int get indexSelectedAttr => selectedAttr != null
      ? (lstProductAttribute
              ?.indexWhere((element) => element.id == selectedAttr) ??
          -1)
      : -1;
  int _currentPage = 1;

  Future<void> getFilterAttributes() async {
    try {
      _isLoading = true;
      notifyListeners();
      lstProductAttribute = await _service.api.getFilterAttributes(
        lang: langCode,
      );
      if (lstProductAttribute != null &&
          lstProductAttribute!.isNotEmpty &&
          lstProductAttribute?.first.id != null) {
        await getAttr(id: lstProductAttribute!.first.id);
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> getAttr({int? id}) async {
    try {
      /// If the same id, load the next page
      /// else load the first page
      final theSameId = selectedAttr == id;
      if (!_isLoading) {
        _isLoading = true;
        notifyListeners();
      }
      final page = theSameId ? ++_currentPage : _currentPage = 1;
      final data = await _service.api.getSubAttributes(
        id: id,
        lang: langCode,
        page: page,
      )!;
      selectedAttr = id;
      if (theSameId) {
        lstCurrentAttr.addAll(data);
      } else {
        lstCurrentAttr = data;
      }

      if (data.isEmpty) {
        _isEnd = true;
      }

      // Remove duplicates item
      for (var index = 0; index < lstCurrentAttr.length; index++) {
        final currentProduct = lstCurrentAttr[index];
        final listDuplicate = lstCurrentAttr
            .where((element) => currentProduct.id == element.id)
            .toList();
        if (listDuplicate.length > 1) {
          for (var indexDup = 1; indexDup < listDuplicate.length; indexDup++) {
            lstCurrentAttr.remove(listDuplicate[indexDup]);
          }
        }
      }
      lstCurrentSelectedTerms.clear();

      List.generate(
        lstCurrentAttr.length,
        (index) => lstCurrentSelectedTerms.add(false),
      );

      _isLoading = false;
      notifyListeners();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  void updateAttributeSelectedItem(int index, bool value) {
    lstCurrentSelectedTerms[index] = value;
    notifyListeners();
  }

  void resetFilter() {
    selectedAttr = null;
    lstCurrentSelectedTerms = [];
  }
}
