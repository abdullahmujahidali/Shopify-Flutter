import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import '../data/boxes.dart';
import 'entities/product.dart';

class RecentModel with ChangeNotifier {
  List<Product> products = [];

  void addRecentProduct(Product? product) {
    if (product == null) {
      return;
    }
    var data = <Map>[];
    products.removeWhere((index) => index.id == product.id);
    if (products.length == 20) products.removeLast();
    products.insert(0, product);
    for (var item in products) {
      data.add(item.toJson());
    }
    UserBox().recentProducts = data;
    notifyListeners();
  }

  Future<List<Product>> getRecentProduct() {
    var data = UserBox().recentProducts ?? <Map>[];
    if (data.isNotEmpty) {
      for (var item in data) {
        final product = Product.fromLocalJson(item);
        if (products.firstWhereOrNull((o) => o.id == product.id) == null) {
          products.add(product);
        }
      }
      notifyListeners();
    }
    return Future.delayed(const Duration(milliseconds: 1), () => products);
  }

  void removeRecentProduct(Product? product) {
    if (product == null) {
      return;
    }
    var data = <Map>[];
    products.removeWhere((index) => index.id == product.id);
    for (var item in products) {
      data.add(item.toJson());
    }
    UserBox().recentProducts = data;
    notifyListeners();
  }
}
