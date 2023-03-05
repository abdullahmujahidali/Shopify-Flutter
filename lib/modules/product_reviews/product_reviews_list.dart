import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../common/config.dart';
import '../../generated/l10n.dart';
import '../../widgets/common/expansion_info.dart';
import 'models/product_rating_count_model.dart';
import 'models/product_reviews_model.dart';
import 'views/widgets/rating_count_widget.dart';
import 'views/widgets/review_item.dart';

class ProductReviewsList extends StatelessWidget {
  const ProductReviewsList({
    Key? key,
    this.onTapSeeAllReviews,
  }) : super(key: key);

  final VoidCallback? onTapSeeAllReviews;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductReviewsModel>(
      builder: (context, model, child) {
        if (model.isFirstLoad) kLoadingWidget(context);

        final reviews = model.data.take(5);

        if (reviews.isEmpty) return const SizedBox();

        return ExpansionInfo(
          title: S.of(context).reviews,
          children: [
            const SizedBox(height: 16),
            Consumer<ProductRatingCountModel>(
              builder: (context, reviewCountModel, child) {
                if (reviewCountModel.isLoading) {
                  return const RatingCountSkeleton();
                }

                final rating = reviewCountModel.value;
                return RatingCountWidget(
                  averageRating: model.averageRating,
                  ratingCount: model.ratingCount,
                  rating1: rating.oneStar,
                  rating2: rating.twoStar,
                  rating3: rating.threeStar,
                  rating4: rating.fourStar,
                  rating5: rating.fiveStar,
                );
              },
            ),
            const SizedBox(height: 8),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final review = model.data[index];
                return ReviewItem(
                  name: review.displayName,
                  date: timeago.format(review.createdAt),
                  rating: review.rating ?? 0,
                  content: review.displayContent,
                  images: review.images,
                  showRatingStar: kAdvanceConfig.enableRating,
                  verified: review.verified,
                );
              },
            ),
            OutlinedButton(
              onPressed: onTapSeeAllReviews,
              child: Text(S.of(context).seeAll),
            )
          ],
        );
      },
    );
  }
}
