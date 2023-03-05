import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../models/entities/product.dart';
import '../../../services/index.dart';
import 'index.dart';

class ProductCommonInfo extends StatelessWidget {
  final bool isLoading;
  final Product? product;
  final bool wrapSliver;

  const ProductCommonInfo({
    super.key,
    required this.isLoading,
    this.product,
    this.wrapSliver = true,
  });

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product == null) {
      return const SizedBox();
    }
    if (isLoading) {
      return kLoadingWidget(context);
    }
    switch (product.type) {
      case 'appointment':
        return Services().getBookingLayout(
          product: product,
          wrapSliver: wrapSliver,
        );
      case 'booking':
        return ListingBooking(product);
      case 'grouped':
        return GroupedProduct(product);
      case 'simple':
      case 'variable':
      default:
        return ProductVariant(product);
    }
  }
}
