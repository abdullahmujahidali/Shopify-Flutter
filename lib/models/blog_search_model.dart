import 'package:flutter/material.dart';

import '../data/boxes.dart';
import '../services/index.dart';
import 'entities/blog.dart';

class BlogSearchModel extends ChangeNotifier {
  BlogSearchModel() {
    getKeywords();
  }

  List<String> keywords = [];
  List<Blog> blogs = [];
  bool loading = false;
  String errMsg = '';

  void searchBlogs({required String name}) async {
    try {
      loading = true;
      notifyListeners();
      blogs = await Services().api.searchBlog(name: name);
      if (blogs.isNotEmpty && name.isNotEmpty) {
        var index = keywords.indexOf(name);
        if (index > -1) {
          keywords.removeAt(index);
        }
        keywords.insert(0, name);
        saveKeywords(keywords);
      }
      loading = false;

      notifyListeners();
      // return blogs;
    } catch (err) {
      loading = false;
      errMsg = err.toString();
      notifyListeners();
    }
  }

  void clearKeywords() {
    keywords = [];
    saveKeywords(keywords);
    notifyListeners();
  }

  void saveKeywords(List<String> keywords) {
    UserBox().recentBlogsSearch = keywords;
  }

  void getKeywords() {
    final list = UserBox().recentBlogsSearch;
    if (list.isNotEmpty) {
      keywords = list;
    }
  }
}
