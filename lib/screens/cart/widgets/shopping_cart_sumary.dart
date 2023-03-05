import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, CartModel, Coupons, Discount;
import '../../../services/index.dart';
import 'coupon_list.dart';
import 'point_reward.dart';

class ShoppingCartSummary extends StatefulWidget {
  final bool showPrice;

  const ShoppingCartSummary({this.showPrice = true});

  @override
  State<ShoppingCartSummary> createState() => _ShoppingCartSummaryState();
}

class _ShoppingCartSummaryState extends State<ShoppingCartSummary> {
  final services = Services();
  Coupons? coupons;

  String _productsInCartJson = '';
  final _debounceApplyCouponTag = 'debounceApplyCouponTag';
  final defaultCurrency = kAdvanceConfig.defaultCurrency;

  CartModel get cartModel => Provider.of<CartModel>(context, listen: false);

  final couponController = TextEditingController();

  final bool _showCouponList = kAdvanceConfig.showCouponList &&
      ServerConfig().type != ConfigType.magento;

  @override
  void initState() {
    super.initState();
    getCoupon();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        // if (cartModel.couponObj != null && cartModel.couponObj!.amount! > 0) {
        //   final savedCoupon = cartModel.savedCoupon;
        //   couponController.text = savedCoupon ?? '';
        // }
        final savedCoupon = cartModel.savedCoupon;
        couponController.text = savedCoupon ?? '';
        _productsInCartJson = jsonEncode(cartModel.productsInCart);
      }
    });
  }

  void _onProductInCartChange(CartModel cartModel) {
    // If app success a coupon before
    // Need to apply again when any change in cart
    EasyDebounce.debounce(
        _debounceApplyCouponTag, const Duration(milliseconds: 300), () {
      if (cartModel.productsInCart.isEmpty) {
        removeCoupon(cartModel);
        return;
      }
      final newData = jsonEncode(cartModel.productsInCart);
      if (_productsInCartJson != newData) {
        _productsInCartJson = newData;
        checkCoupon(couponController.text, cartModel);
      }
    });
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  Future<void> getCoupon() async {
    try {
      coupons = await services.api.getCoupons();
    } catch (e) {
//      print(e.toString());
    }
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(S.of(context).warning(message)),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Check coupon code
  void checkCoupon(String couponCode, CartModel cartModel) {
    if (couponCode.isEmpty) {
      showError(S.of(context).pleaseFillCode);
      return;
    }

    cartModel.setLoadingDiscount();

    Services().widget.applyCoupon(
      context,
      coupons: coupons,
      code: couponCode,
      success: (Discount discount) async {
        await cartModel.updateDiscount(discount: discount);
        cartModel.setLoadedDiscount();
      },
      error: (String errMess) {
        if (cartModel.couponObj != null) {
          removeCoupon(cartModel);
        }
        cartModel.setLoadedDiscount();
        showError(errMess);
      },
    );
  }

  Future<void> removeCoupon(CartModel cartModel) async {
    await Services().widget.removeCoupon(context);
    cartModel.resetCoupon();
    cartModel.discountAmount = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final smallAmountStyle =
        TextStyle(color: Theme.of(context).colorScheme.secondary);
    final largeAmountStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 20,
    );
    final formatter = NumberFormat.currency(
      locale: 'en',
      symbol: defaultCurrency?.symbol,
      decimalDigits: defaultCurrency?.decimalDigits,
    );
    final screenSize = MediaQuery.of(context).size;

    return Consumer<CartModel>(builder: (context, cartModel, child) {
      var couponMsg = '';
      var isApplyCouponSuccess = false;
      if (cartModel.couponObj != null &&
          (cartModel.couponObj!.amount ?? 0) > 0) {
        isApplyCouponSuccess = true;
        _onProductInCartChange(cartModel);
        couponController.text = cartModel.couponObj!.code ?? '';
        couponMsg = S.of(context).couponMsgSuccess;
        if (cartModel.couponObj!.discountType == 'percent') {
          couponMsg += ' ${cartModel.couponObj!.amount}%';
        } else {
          couponMsg += ' - ${formatter.format(cartModel.couponObj!.amount)}';
        }
      } else {
        couponController.clear();
      }
      if (cartModel.productsInCart.isEmpty) {
        return const SizedBox();
      }
      final enableCoupon =
          kAdvanceConfig.enableCouponCode && !cartModel.isWalletCart();
      final enablePointReward = !cartModel.isWalletCart();

      return SizedBox(
        width: screenSize.width,
        child: SizedBox(
          width:
              screenSize.width / (2 / (screenSize.height / screenSize.width)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (enableCoupon)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          decoration: !isApplyCouponSuccess
                              ? BoxDecoration(
                                  color: Theme.of(context).colorScheme.background)
                              : BoxDecoration(
                                  color: Theme.of(context).primaryColorLight),
                          child: GestureDetector(
                            onTap: _showCouponList
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => CouponList(
                                          isFromCart: true,
                                          coupons: coupons,
                                          onSelect: (String couponCode) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 250), () {
                                              couponController.text =
                                                  couponCode;
                                              checkCoupon(couponController.text,
                                                  cartModel);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: AbsorbPointer(
                              absorbing: _showCouponList,
                              child: TextField(
                                controller: couponController,
                                autocorrect: false,
                                enabled: !isApplyCouponSuccess &&
                                    !cartModel.calculatingDiscount,
                                decoration: InputDecoration(
                                  prefixIcon: _showCouponList
                                      ? Icon(
                                          CupertinoIcons.search,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : null,
                                  labelText: S.of(context).couponCode,
                                  //hintStyle: TextStyle(color: _enable ? Colors.grey : Colors.black),
                                  contentPadding: const EdgeInsets.all(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Theme.of(context).primaryColorLight,
                          elevation: 0.0,
                        ),
                        label: Text(
                          cartModel.calculatingDiscount
                              ? S.of(context).loading
                              : !isApplyCouponSuccess
                                  ? S.of(context).apply
                                  : S.of(context).remove,
                        ),
                        icon: const Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          size: 18,
                        ),
                        onPressed: !cartModel.calculatingDiscount
                            ? () {
                                if (!isApplyCouponSuccess) {
                                  checkCoupon(couponController.text, cartModel);
                                } else {
                                  removeCoupon(cartModel);
                                }
                              }
                            : null,
                      )
                    ],
                  ),
                ),
              if (isApplyCouponSuccess)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 15,
                  ),
                  child: Text(
                    couponMsg,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (enablePointReward) const PointReward(),
              if (widget.showPrice)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 15.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S.of(context).products,
                                  style: smallAmountStyle,
                                ),
                              ),
                              Text(
                                'x${cartModel.totalCartQuantity}',
                                style: smallAmountStyle,
                              ),
                            ],
                          ),
                          if (cartModel.rewardTotal > 0) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(S.of(context).cartDiscount,
                                      style: smallAmountStyle),
                                ),
                                Text(
                                  PriceTools.getCurrencyFormatted(
                                      cartModel.rewardTotal, currencyRate,
                                      currency: currency)!,
                                  style: smallAmountStyle,
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${S.of(context).total}:',
                                  style: largeAmountStyle,
                                ),
                              ),
                              cartModel.calculatingDiscount
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : Text(
                                      PriceTools.getCurrencyFormatted(
                                          cartModel.getTotal()! -
                                              cartModel.getShippingCost()!,
                                          currencyRate,
                                          currency: cartModel.isWalletCart()
                                              ? defaultCurrency?.currencyCode
                                              : currency)!,
                                      style: largeAmountStyle,
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Services().widget.renderRecurringTotals(context)
            ],
          ),
        ),
      );
    });
  }
}
