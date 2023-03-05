import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../modules/dynamic_layout/config/index.dart';
import '../../../modules/dynamic_layout/product/product_list_default.dart';
import '../../../modules/dynamic_layout/product/product_recent_placeholder.dart';
import '../../../services/index.dart';

class RecentProducts extends StatelessWidget {
  final Product? excludeProduct;

  const RecentProducts({
    super.key,
    this.excludeProduct,
  });

  @override
  Widget build(BuildContext context) {
    final products = List.from(context.select((RecentModel _) => _.products));
    if (excludeProduct != null) {
      products.removeWhere((item) => item.id == excludeProduct?.id);
    }
    if (products.length < 3) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 18.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Text(
            S.of(context).recentlyViewed,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ServerConfig().isBuilder
            ? ProductRecentPlaceholder()
            : ProductListDefault(
                products: products,
                config: ProductConfig.empty(),
                maxWidth: MediaQuery.of(context).size.width,
              ),
      ],
    );
  }
}
