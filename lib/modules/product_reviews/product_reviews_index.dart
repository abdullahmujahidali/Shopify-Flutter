import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/entities/product.dart';
import 'models/product_rating_count_model.dart';
import 'models/product_reviews_model.dart';
import 'product_reviews_list.dart';

class ProductReviewsIndex extends StatelessWidget {
  final Product product;

  const ProductReviewsIndex({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kProductDetail.enableReview) {
      return const SizedBox();
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductReviewsModel>(
          create: (context) => ProductReviewsModel(product),
        ),
        ChangeNotifierProvider<ProductRatingCountModel>(
          create: (context) => ProductRatingCountModel(product.id),
        ),
      ],
      child: ProductReviewsList(
        onTapSeeAllReviews: () {
          Navigator.of(context).pushNamed(
            RouteList.productReviews,
            arguments: product,
          );
        },
      ),
    );
  }
}
