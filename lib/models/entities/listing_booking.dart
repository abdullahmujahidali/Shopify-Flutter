import 'dart:convert';

import '../../common/constants.dart';

class ListingBooking {
  String? title;
  String? featuredImage;
  String? status;
  String? price;
  String? createdDate;
  String? orderId;
  String? orderStatus;
  Map<String, String?> adults = {};
  List<String?> services = [];
  ListingBooking(
      this.title,
      this.featuredImage,
      this.status,
      this.price,
      this.createdDate,
      this.adults,
      this.services,
      this.orderId,
      this.orderStatus);

  ListingBooking.fromJson(Map json) {
    title = json['title'];
    if (json['featured_image'] is String) {
      featuredImage = json['featured_image'];
    } else {
      featuredImage = kDefaultImage;
    }

    status = json['status'];
    price = json['price'];
    createdDate = json['created'];
    orderId = json['order_id'];
    orderStatus = json['order_status'] ?? '';
    var commentJson = jsonDecode(json['comment']);
    if (commentJson['adults'] != null) {
      adults['adults'] = commentJson['adults'];
    }
    if (commentJson['tickets'] != null) {
      adults['tickets'] = commentJson['tickets'];
    }
    if (commentJson['service'] is bool) {
      return;
    }
    for (var item in commentJson['service']) {
      services.add(item['service']['name']);
    }
  }
}
