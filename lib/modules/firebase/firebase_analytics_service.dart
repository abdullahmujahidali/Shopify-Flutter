import 'package:flutter/material.dart';

class FirebaseAnalyticsService {
  void init() {}

  List<NavigatorObserver> getMNavigatorObservers() {
    return const <NavigatorObserver>[];
  }

  // Log some an event with a custom name
  Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameter,
  }) async {}

  // Select a product list
  Future<void> logViewItemList({
    String? itemListId,
    String? itemListName,
    dynamic data,
  }) async {}

  // Select a product from a list
  Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    dynamic data,
  }) async {}

  // View product details
  Future<void> logViewItem({
    String? currency,
    double? price,
    dynamic data,
  }) async {}

  // Add a product to Wish list
  Future<void> logAddToWishlist({
    String? currency,
    double? price,
    dynamic data,
  }) async {}

  // Add a product to shopping cart
  Future<void> logAddToCart({
    String? currency,
    double? price,
    dynamic data,
    int? quantity,
  }) async {}

  // View shopping cart
  Future<void> logViewCart({
    String? currency,
    double? price,
    dynamic data,
  }) async {}

  // Remove a product from a shopping cart
  Future<void> logRemoveFromCart({
    String? currency,
    double? price,
    dynamic data,
  }) async {}

  // Initiate the checkout process
  Future<void> logBeginCheckout({
    String? currency,
    double? price,
    dynamic data,
    String? coupon,
  }) async {}

  // Add shipping information
  Future<void> logAddShippingInfo({
    String? currency,
    double? price,
    dynamic data,
    String? coupon,
    String? shippingTier,
  }) async {}

  // Add payment information
  Future<void> logAddPaymentInfo({
    String? currency,
    double? price,
    dynamic data,
    String? coupon,
    String? paymentType,
  }) async {}

  // Make a purchase
  Future<void> logPurchase({
    String? orderId,
    String? currency,
    double? price,
    double? shipping,
    double? tax,
    dynamic data,
    String? coupon,
  }) async {}

  // Make a refund
  Future<void> logRefund({
    String? orderId,
    String? currency,
    double? price,
    dynamic data,
  }) async {}

  // Apply promotions
  Future<void> logViewPromotion({
    String? promotionId,
    String? promotionName,
    String? creativeName,
    String? creativeSlot,
    String? locationId,
    dynamic data,
  }) async {}

  Future<void> logSelectPromotion({
    String? promotionId,
    String? promotionName,
    String? creativeName,
    String? creativeSlot,
    String? locationId,
    dynamic data,
  }) async {}
}
