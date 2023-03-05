import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../common/config.dart';
import '../../generated/l10n.dart';
import '../../models/entities/product.dart';
import '../../models/entities/review.dart';
import '../../widgets/common/paging_list.dart';
import '../../widgets/product/product_simple_view.dart';
import 'models/product_reviews_model.dart';
import 'views/widgets/product_rating_count.dart';
import 'views/widgets/review_item.dart';

class ProductReviewScreen extends StatelessWidget {
  const ProductReviewScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          S.of(context).productReview,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PagingList<ProductReviewsModel, Review>(
        allowPullToRefresh: false,
        header: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              ProductSimpleView(
                item: product,
                isFromSearchScreen: true,
              ),
              ProductRatingCount(product: product),
              const Divider(),
            ],
          ),
        ),
        itemBuilder: (_, review, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                ReviewItem(
                  name: review.displayName,
                  date: timeago.format(review.createdAt),
                  rating: review.rating ?? 0,
                  content: review.displayContent,
                  images: review.images,
                  showRatingStar: kAdvanceConfig.enableRating,
                  verified: review.verified,
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
