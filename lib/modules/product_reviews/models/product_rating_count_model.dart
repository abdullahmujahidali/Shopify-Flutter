import 'package:flutter/cupertino.dart';

import '../../../models/entities/rating_count.dart';
import '../../../services/services.dart';

class ProductRatingCountModel extends ChangeNotifier {
  ProductRatingCountModel(this._productId) {
    init();
  }

  final api = Services().api;
  var _value = const RatingCount();
  final String _productId;

  var _isLoading = false;

  bool get isLoading => _isLoading;

  RatingCount get value => _value;

  void update(RatingCount? newValue) {
    _value = newValue?.copyWith() ?? const RatingCount();
    notifyListeners();
  }

  void init() async {
    _isLoading = true;
    final data = await api.getProductRatingCount(_productId);
    _isLoading = false;
    update(data);
  }
}
