import 'package:flutter/material.dart';
import '../../../models/entities/index.dart';
import '../../../models/entities/paging_response.dart';
import '../../../models/paging_data_model.dart';

class ProductReviewsModel extends PagingDataModel<Review> {
  final Product _product;

  double get averageRating => _product.averageRating ?? 0.0;

  int get ratingCount => _product.ratingCount ?? 0;

  ProductReviewsModel(this._product) {
    getData();
  }

  @protected
  @override
  Future<PagingResponse<Review>>? Function(dynamic page) get requestApi =>
      (page) => api.getReviews(_product.id, page: page);
}
