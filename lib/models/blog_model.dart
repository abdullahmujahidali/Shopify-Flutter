import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../services/services.dart';
import 'entities/blog.dart';
import 'entities/category.dart';
import 'entities/tag.dart';

class BlogModel with ChangeNotifier {
  List<Blog>? blogList = [];

  final _service = Services();

  bool isFetching = false;
  bool? isEnd;
  dynamic categoryId;
  String? categoryName;
  String? errMsg;

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  List<Tag> _tags = [];

  List<Tag> get tags => _tags;

  void setBlogNewsList(List<Blog>? blogs) {
    blogList = blogs ?? [];
    isFetching = false;
    isEnd = false;
    // notifyListeners();
  }

  void fetchBlogsByCategory({categoryId, categoryName}) {
    this.categoryId = categoryId;
    this.categoryName = categoryName;
    // notifyListeners();
  }

  Future<void> getBlogsList({
    categoryId,
    categoryName,
    orderBy,
    order,
    lang,
    page,
  }) async {
    try {
      printLog('[♻️ getBlogsList] by Category: $categoryId');

      printLog('getBlogsList');
      if (_categories.isNotEmpty) {
        printLog(_categories.first);
      }

      if (categoryId != null) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
      }

      isFetching = true;
      isEnd = false;

      final blogs = await _service.api.fetchBlogsByCategory(
          categoryId: categoryId, lang: lang, page: page, order: order);
      if (blogs.isEmpty) {
        isEnd = true;
      }

      if (page == 0 || page == 1) {
        blogList = blogs;
      } else {
        blogList = [...blogList!, ...blogs];
      }
      isFetching = false;
      notifyListeners();
    } catch (err) {
      errMsg = err.toString();
      isFetching = false;
      notifyListeners();
    }
  }

  void setBlogsList(List<Blog> blogs) {
    blogList = blogs;
    isFetching = false;
    isEnd = false;
    // notifyListeners();
  }

  Future<List<Category>> getCategoryList() async {
    _categories = await _service.api.getBlogCategories();
    notifyListeners();
    return _categories;
  }

  Future<List<Tag>> getTagList() async {
    _tags = await _service.api.getBlogTags();
    notifyListeners();
    return _tags;
  }
}
