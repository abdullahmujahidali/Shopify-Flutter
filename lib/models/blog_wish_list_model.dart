import 'dart:async';

import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../data/boxes.dart';
import 'entities/blog.dart';

class BlogWishListModel extends ChangeNotifier {
  BlogWishListModel() {
    getLocalWishlist();
  }

  List<Blog> blogs = [];

  List<Blog> getWishList() => blogs;

  final keyData = BoxKeys.blogWishList;

  void addToWishlist(Blog blog) {
    blogs.add(blog);
    saveWishlist(blogs);
    notifyListeners();
  }

  void removeToWishlist(Blog blog) {
    blogs.removeWhere((item) => item.id == blog.id);
    saveWishlist(blogs);
    notifyListeners();
  }

  Future<void> saveWishlist(List<Blog> blogs) async {
    try {
      UserBox().blogWishList = blogs;
    } catch (err, trace) {
      printError(err, trace, '[BlogWishListModel] saveWishlist error');
    }
  }

  void getLocalWishlist() async {
    try {
      final blogWishList = UserBox().blogWishList;

      if (blogWishList.isNotEmpty) {
        blogs = blogWishList;
      }
    } catch (err, trace) {
      printError(err, trace, '[BlogWishListModel] getLocalWishlist error');
    }
  }
}
