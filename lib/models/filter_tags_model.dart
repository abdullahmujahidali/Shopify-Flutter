import 'package:flutter/material.dart';

import '../services/index.dart';
import 'entities/filter_tags.dart';
import 'mixins/language_mixin.dart';

class FilterTagModel with ChangeNotifier, LanguageMixin {
  List<FilterTag>? lstProductTag;
  final Services _service = Services();
  bool isLoading = false;

  Future<void> getFilterTags() async {
    try {
      isLoading = true;
      notifyListeners();
      lstProductTag = await _service.api.getFilterTags(lang: langCode);
      if (lstProductTag == null || lstProductTag!.isEmpty) {
        isLoading = false;
        notifyListeners();
        return;
      }
      // Remove duplicates item
      for (var index = 0; index < lstProductTag!.length; index++) {
        final currentProduct = lstProductTag![index];
        final listDuplicate = lstProductTag!
            .where((element) => currentProduct.id == element.id)
            .toList();
        if (listDuplicate.length > 1) {
          for (var indexDup = 1; indexDup < listDuplicate.length; indexDup++) {
            lstProductTag!.remove(listDuplicate[indexDup]);
          }
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (_) {}
  }
}
