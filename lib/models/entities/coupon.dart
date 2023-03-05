import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:inspireui/widgets/coupon_card.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../services/service_config.dart';
import '../app_model.dart';
import '../cart/cart_base.dart';
import '../order/order.dart';

class Coupons {
  List<Coupon> coupons = [];

  static Future<Discount?> getDiscount({
    required CartModel cartModel,
    String? couponCode,
  }) async {
    try {
      final endpoint = '${ServerConfig().url}/wp-json/api/flutter_woo/coupon';
      var params = Order().toJson(
          cartModel, cartModel.user != null ? cartModel.user!.id : null, false);
      params['coupon_code'] = couponCode;
      final response = await httpPost(
        endpoint.toUri()!,
        body: json.encode(params),
      );
      if(response.statusCode == 502){
        return null;
      }
      final body = json.decode(response.body) ?? {};
      if (response.statusCode == HttpStatus.ok) {
        return Discount.fromJson(body);
      } else if (body['message'] != null) {
        throw Exception(body['message']);
      }
    } catch (err) {
      rethrow;
    }
    return null;
  }

  Coupons.getListCoupons(List a) {
    for (var i in a) {
      coupons.add(Coupon.fromJson(i));
    }
  }

  Coupons.getListCouponsOpencart(List a) {
    for (var i in a) {
      coupons.add(Coupon.fromOpencartJson(i));
    }
  }

  Coupons.getListCouponsPresta(List a) {
    for (var i in a) {
      coupons.add(Coupon.fromPresta(i));
    }
  }
}

class Discount {
  Coupon? coupon;
  double? discountValue;

  Discount({this.coupon, this.discountValue});

  Discount.fromJson(Map json) {
    coupon = json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null;
    discountValue = double.parse('${(json['discount'] ?? 0.0)}');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    data['discount'] = discountValue;
    return data;
  }
}

class CouponTrans extends CouponTranslate {
  CouponTrans(context) : super(context);

  @override
  String get discount => S.of(context).discount;

  @override
  String get expired => S.of(context).expired;

  @override
  String expiringInTime(time) => S.of(context).expiringInTime(time);

  @override
  String get fixedCartDiscount => S.of(context).fixedCartDiscount;

  @override
  String get fixedProductDiscount => S.of(context).fixedProductDiscount;

  @override
  String get langCode => Provider.of<AppModel>(context).langCode;

  @override
  String get saveForLater => S.of(context).saveForLater;

  @override
  String get useNow => S.of(context).useNow;

  @override
  String validUntilDate(data) => S.of(context).validUntilDate(data);
}
