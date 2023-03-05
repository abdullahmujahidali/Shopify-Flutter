import 'package:flutter/material.dart';
import 'package:inspireui/widgets/coupon_card.dart';

import '../../../common/tools.dart';
import '../../../data/boxes.dart';
import '../../entities/coupon.dart';
import '../cart_base.dart';
import 'cart_mixin.dart';

mixin CouponMixin on CartMixin implements ChangeNotifier {
  Coupon? couponObj;
  Discount? _discount;
  String? savedCoupon;

  bool _calculatingDiscount = false;

  bool get calculatingDiscount => _calculatingDiscount;

  void setLoadingDiscount() {
    _calculatingDiscount = true;
    notifyListeners();
  }

  void setLoadedDiscount() {
    _calculatingDiscount = false;
    notifyListeners();
  }

  void resetCoupon() {
    couponObj = null;
    _discount = null;
    clearSavedCoupon();
    notifyListeners();
  }

  Future updateDiscount({Discount? discount, Function? onFinish}) async {
    if (discount != null) {
      _discount = discount;
      couponObj = discount.coupon;
      savedCoupon = couponObj?.code ?? '';
      return;
    }

    if (couponObj == null) {
      _discount = null;
      return;
    }

    _calculatingDiscount = true;
    try {
      _discount = await Coupons.getDiscount(
        cartModel: this as CartModel,
        couponCode: couponObj!.code,
      );
      couponObj = _discount?.coupon;
    } catch (_) {
      resetCoupon();
    } finally {
      _calculatingDiscount = false;
    }

    if (onFinish != null) {
      onFinish();
    }
  }

  String getCoupon() {
    if (couponObj != null) {
      return '-${PriceTools.getCurrencyFormatted(getCouponCost(), currencyRates, currency: currencyCode)}';
    }
    return '';
  }

  double getCouponCost() {
    return _discount?.discountValue ?? 0.0;
  }

  void clearSavedCoupon() {
    savedCoupon = null;
    UserBox().savedCoupon = '';
  }
}
