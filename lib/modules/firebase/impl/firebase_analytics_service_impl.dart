import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../../models/index.dart';
import '../firebase_analytics_service.dart';

class FirebaseAnalyticsServiceImpl extends FirebaseAnalyticsService {
  late FirebaseAnalytics analytics;

  @override
  void init() {
    analytics = FirebaseAnalytics.instance;

    analytics.logAppOpen();
  }

  @override
  List<NavigatorObserver> getMNavigatorObservers() {
    return <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: analytics),
    ];
  }

  @override
  Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameter,
  }) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameter);
  }

  @override
  Future<void> logViewItemList({
    String? itemListId,
    String? itemListName,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List<Product>) {
      items = [];
      for (var item in data) {
        items.add(AnalyticsEventItem(
          itemId: item.id,
          itemName: item.name,
          itemCategory: item.categoryName ?? item.categoryId,
          price: double.tryParse(item.price ?? ''),
          // currency: data.
        ));
      }
    }
    await FirebaseAnalytics.instance.logViewItemList(
      itemListId: itemListId,
      itemListName: itemListName,
      items: items,
    );
  }

  @override
  Future<void> logSelectItem({
    String? itemListId,
    String? itemListName,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is Product) {
      items = [
        AnalyticsEventItem(
          itemId: data.id,
          itemName: data.name,
          itemCategory: data.categoryName ?? data.categoryId,
          price: double.tryParse(data.price ?? ''),
          // currency: data.
        )
      ];
    }
    await FirebaseAnalytics.instance.logSelectItem(
      itemListId: itemListId,
      itemListName: itemListName,
      items: items,
    );
  }

  @override
  Future<void> logViewItem({
    String? currency,
    double? price,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is Product) {
      items = [
        AnalyticsEventItem(
          itemId: data.id,
          itemName: data.name,
          itemCategory: data.categoryName ?? data.categoryId,
          price: double.tryParse(data.price ?? ''),
          currency: currency,
        )
      ];
    }
    await FirebaseAnalytics.instance.logViewItem(
      currency: currency,
      value: price,
      items: items,
    );
  }

  @override
  Future<void> logAddToWishlist({
    String? currency,
    double? price,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is Product) {
      items = [
        AnalyticsEventItem(
          itemId: data.id,
          itemName: data.name,
          itemCategory: data.categoryName ?? data.categoryId,
          price: double.tryParse(data.price ?? ''),
          currency: currency,
        )
      ];
    }
    await FirebaseAnalytics.instance.logAddToWishlist(
      currency: currency,
      value: price,
      items: items,
    );
  }

  @override
  Future<void> logAddToCart({
    String? currency,
    double? price,
    dynamic data,
    int? quantity,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is Product) {
      items = [
        AnalyticsEventItem(
            itemId: data.id,
            itemName: data.name,
            itemCategory: data.categoryName ?? data.categoryId,
            price: double.tryParse(data.price ?? ''),
            currency: currency,
            quantity: quantity)
      ];
    }
    await FirebaseAnalytics.instance.logAddToCart(
      currency: currency,
      value: price,
      items: items,
    );
  }

  @override
  Future<void> logViewCart({
    String? currency,
    double? price,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is Map) {
      items = [];
      for (var item in data.values) {
        var product = item['product'];
        items.add(AnalyticsEventItem(
          itemId: item['key'],
          itemName: product.name,
          itemCategory: product.categoryName ?? product.categoryId,
          price: double.tryParse(product.price ?? ''),
          quantity: item['quantity'],
          currency: currency,
        ));
      }
    }
    await FirebaseAnalytics.instance.logViewCart(
      currency: currency,
      value: price,
      items: items,
    );
  }

  @override
  Future<void> logRemoveFromCart({
    String? currency,
    double? price,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List) {
      items = [];
      for (var item in data) {
        var product = item['product'];
        items.add(AnalyticsEventItem(
          itemId: item['key'],
          itemName: product.name,
          itemCategory: product.categoryName ?? product.categoryId,
          price: double.tryParse(product.price ?? ''),
          quantity: item['quantity'],
          currency: currency,
        ));
      }
    }
    await FirebaseAnalytics.instance.logRemoveFromCart(
      currency: currency,
      value: price,
      items: items,
    );
  }

  @override
  Future<void> logBeginCheckout({
    String? currency,
    double? price,
    dynamic data,
    String? coupon,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List) {
      items = [];
      for (var item in data) {
        var product = item['product'];
        items.add(AnalyticsEventItem(
          itemId: item['key'],
          itemName: product.name,
          itemCategory: product.categoryName ?? product.categoryId,
          price: double.tryParse(product.price ?? ''),
          quantity: item['quantity'],
          currency: currency,
        ));
      }
    }
    await FirebaseAnalytics.instance.logBeginCheckout(
      currency: currency,
      value: price,
      coupon: coupon,
      items: items,
    );
  }

  @override
  Future<void> logAddShippingInfo({
    String? currency,
    double? price,
    dynamic data,
    String? coupon,
    String? shippingTier,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List) {
      items = [];
      for (var item in data) {
        var product = item['product'];
        items.add(AnalyticsEventItem(
          itemId: item['key'],
          itemName: product.name,
          itemCategory: product.categoryName ?? product.categoryId,
          price: double.tryParse(product.price ?? ''),
          quantity: item['quantity'],
          currency: currency,
        ));
      }
    }
    await FirebaseAnalytics.instance.logAddShippingInfo(
      currency: currency,
      value: price,
      coupon: coupon,
      items: items,
      shippingTier: shippingTier,
    );
  }

  @override
  Future<void> logAddPaymentInfo({
    String? currency,
    double? price,
    dynamic data,
    String? coupon,
    String? paymentType,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List) {
      items = [];
      for (var item in data) {
        var product = item['product'];
        items.add(AnalyticsEventItem(
          itemId: item['key'],
          itemName: product.name,
          itemCategory: product.categoryName ?? product.categoryId,
          price: double.tryParse(product.price ?? ''),
          quantity: item['quantity'],
          currency: currency,
        ));
      }
    }
    await FirebaseAnalytics.instance.logAddPaymentInfo(
      currency: currency,
      value: price,
      coupon: coupon,
      paymentType: paymentType,
      items: items,
    );
  }

  @override
  Future<void> logPurchase({
    String? orderId,
    String? currency,
    double? price,
    double? shipping,
    double? tax,
    dynamic data,
    String? coupon,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List) {
      items = [];
      for (var item in data) {
        var product = item['product'];
        items.add(AnalyticsEventItem(
          itemId: item['key'],
          itemName: product.name,
          itemCategory: product.categoryName ?? product.categoryId,
          price: double.tryParse(product.price ?? ''),
          quantity: item['quantity'],
          currency: currency,
        ));
      }
    }
    await FirebaseAnalytics.instance.logPurchase(
      transactionId: orderId,
      currency: currency,
      value: price,
      shipping: shipping,
      tax: tax,
      coupon: coupon,
      items: items,
      // affiliation: 'Google Store',
    );
  }

  @override
  Future<void> logRefund({
    String? orderId,
    String? currency,
    double? price,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    if (data is List) {
      items = [];
      for (var item in data) {
        if (item is ProductItem) {
          items.add(AnalyticsEventItem(
            itemId: item.id,
            itemName: item.name,
            itemCategory:
                item.product?.categoryName ?? item.product?.categoryId,
            price: double.tryParse(item.product?.price ?? ''),
            quantity: item.quantity,
            currency: currency,
          ));
        }
      }
    }
    await FirebaseAnalytics.instance.logRefund(
      transactionId: orderId,
      currency: currency,
      value: price,
      items: items,
      // affiliation: 'Google Store',
    );
  }

  @override
  Future<void> logViewPromotion({
    String? promotionId,
    String? promotionName,
    String? creativeName,
    String? creativeSlot,
    String? locationId,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    await FirebaseAnalytics.instance.logViewPromotion(
      promotionId: promotionId,
      promotionName: promotionName,
      creativeName: creativeName,
      creativeSlot: creativeSlot,
      locationId: locationId,
      items: items,
    );
  }

  @override
  Future<void> logSelectPromotion({
    String? promotionId,
    String? promotionName,
    String? creativeName,
    String? creativeSlot,
    String? locationId,
    dynamic data,
  }) async {
    List<AnalyticsEventItem>? items;
    await FirebaseAnalytics.instance.logSelectPromotion(
      promotionId: promotionId,
      promotionName: promotionName,
      creativeName: creativeName,
      creativeSlot: creativeSlot,
      locationId: locationId,
      items: items,
    );
  }
}
