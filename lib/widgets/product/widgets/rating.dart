import 'package:flutter/material.dart';

import '../../../common/theme/colors.dart';
import '../../../models/entities/product.dart';
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../../common/start_rating.dart';

class ProductRating extends StatelessWidget {
  final Product product;
  final ProductConfig config;

  const ProductRating({
    Key? key,
    required this.product,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return config.enableRating &&
            (config.hideEmptyProductListRating == false ||
                (product.ratingCount != null && product.ratingCount! > 0))
        ? SmoothStarRating(
            allowHalfRating: true,
            starCount: 5,
            rating: product.averageRating ?? 0.0,
            size: 10.0,
            color: kColorRatingStar,
            borderColor: kColorRatingStar,
            label: Text(
              product.ratingCount == 0 || product.ratingCount == null
                  ? ''
                  : '${product.ratingCount}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(fontSizeFactor: 0.7),
            ),
            spacing: 0.0)
        : const SizedBox();
  }
}
