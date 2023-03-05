import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../data/boxes.dart';
import '../services/index.dart';
import 'entities/product.dart';

class ProductWishListModel extends ChangeNotifier {
  ProductWishListModel() {
    getLocalWishlist();
  }

  List<Product> products = [];

  List<Product> getWishList() => products;

  int get wishlistCount => products.length;

  void addToWishlist(Product product) {
    final isExist = products.indexWhere((item) => item.id == product.id) != -1;
    if (!isExist) {
      Services().firebase.firebaseAnalytics?.logAddToWishlist(data: product);

      products.add(product);
      saveWishlist(products);
      notifyListeners();
    }
  }

  void removeToWishlist(Product product) {
    final isExist = products.indexWhere((item) => item.id == product.id) != -1;
    if (isExist) {
      products = products.where((item) => item.id != product.id).toList();
      saveWishlist(products);
      notifyListeners();
    }
  }

  Future<void> saveWishlist(List<Product> products) async {
    try {
      UserBox().wishList = products;
    } catch (err, trace) {
      printError(err, trace, '[ProductWishListModel] saveWishlist error');
    }
  }

  void getLocalWishlist() {
    try {
      final wishList = UserBox().wishList;
      if (wishList.isNotEmpty) {
        products = wishList;
      }
    } catch (err, trace) {
      printError(err, trace, '[ProductWishListModel] getLocalWishlist error');
    }
  }

  Future<void> clearWishList() async {
    products = [];
    await saveWishlist(products);
    notifyListeners();
  }
}
