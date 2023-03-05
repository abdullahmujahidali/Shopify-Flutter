import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show CartModel, Order;
import '../../models/tera_wallet/wallet_model.dart';
import '../../services/index.dart';
import '../../widgets/product/product_bottom_sheet.dart';
import '../base_screen.dart';
import 'review_screen.dart';
import 'widgets/payment_methods.dart';
import 'widgets/shipping_address.dart';
import 'widgets/success.dart';

class CheckoutArgument {
  final bool? isModal;

  const CheckoutArgument({this.isModal});
}

class Checkout extends StatefulWidget {
  final bool? isModal;

  const Checkout({this.isModal});

  @override
  BaseScreen<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends BaseScreen<Checkout> {
  int tabIndex = 0;
  Order? newOrder;
  bool isPayment = false;
  bool isLoading = false;
  bool enabledShipping = kPaymentConfig.enableShipping;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final cartModel = Provider.of<CartModel>(context, listen: false);

      var productList = cartModel.getProductsInCart();

      Services().firebase.firebaseAnalytics?.logBeginCheckout(
            coupon: cartModel.couponObj?.code,
            currency: cartModel.currencyCode,
            data: productList,
            price: cartModel.getSubTotal(),
          );
      setState(() {
        enabledShipping = cartModel.isEnabledShipping();
      });
    });
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (!kPaymentConfig.enableAddress) {
      setState(() {
        tabIndex = 1;
      });
      if (!enabledShipping) {
        setState(() {
          tabIndex = 2;
        });
        if (!kPaymentConfig.enableReview) {
          setState(() {
            tabIndex = 3;
            isPayment = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget progressBar = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        kPaymentConfig.enableAddress
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 0;
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          S.of(context).address.toUpperCase(),
                          style: TextStyle(
                              color: tabIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      tabIndex >= 0
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(2.0),
                                  bottomLeft: Radius.circular(2.0)),
                              child: Container(
                                  height: 3.0,
                                  color: Theme.of(context).primaryColor),
                            )
                          : Divider(
                              height: 2,
                              color: Theme.of(context).colorScheme.secondary)
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        enabledShipping
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    // if (cartModel.address != null &&
                    //     cartModel.address!.isValid()) {
                    //   setState(() {
                    //     tabIndex = 1;
                    //   });
                    // }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          S.of(context).shipping.toUpperCase(),
                          style: TextStyle(
                              color: tabIndex == 1
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      tabIndex >= 1
                          ? Container(
                              height: 3.0,
                              color: Theme.of(context).primaryColor)
                          : Divider(
                              height: 2,
                              color: Theme.of(context).colorScheme.secondary)
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        kPaymentConfig.enableReview
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    // if (cartModel.shippingMethod != null) {
                    //   setState(() {
                    //     tabIndex = 2;
                    //   });
                    // }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          S.of(context).review.toUpperCase(),
                          style: TextStyle(
                            color: tabIndex == 2
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      tabIndex >= 2
                          ? Container(
                              height: 3.0,
                              color: Theme.of(context).primaryColor)
                          : Divider(
                              height: 2,
                              color: Theme.of(context).colorScheme.secondary)
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // if (cartModel.shippingMethod != null) {
              //   setState(() {
              //     tabIndex = 3;
              //   });
              // }
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    S.of(context).payment.toUpperCase(),
                    style: TextStyle(
                      color: tabIndex == 3
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                tabIndex >= 3
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(2.0),
                            bottomRight: Radius.circular(2.0)),
                        child: Container(
                            height: 3.0, color: Theme.of(context).primaryColor),
                      )
                    : Divider(
                        height: 2,
                        color: Theme.of(context).colorScheme.secondary)
              ],
            ),
          ),
        )
      ],
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              S.of(context).checkout,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              if (widget.isModal != null && widget.isModal == true)
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                    } else {
                      ExpandingBottomSheet.of(context, isNullOk: true)?.close();
                    }
                  },
                ),
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: newOrder != null
                ? OrderedSuccess(order: newOrder)
                : Column(
                    children: <Widget>[
                      !isPayment ? progressBar : const SizedBox(),
                      Expanded(
                        /// Will render with animation, fix later
                        // child: AnimatedSwitcher(
                        //   duration: const Duration(milliseconds: 250),
                        //   reverseDuration: const Duration(milliseconds: 250),
                        //   transitionBuilder:
                        //       (Widget child, Animation<double> animation) {
                        //     final inAnimation = Tween<Offset>(
                        //         begin: Offset(1.0, 0.0),
                        //         end: Offset(0.0, 0.0))
                        //         .animate(animation);
                        //     final outAnimation = Tween<Offset>(
                        //         begin: Offset(-1.0, 0.0),
                        //         end: Offset(0.0, 0.0))
                        //         .animate(animation);
                        //     if (true) {
                        //       return SlideTransition(
                        //         position: inAnimation,
                        //         child: child,
                        //       );
                        //     } else {
                        //       return SlideTransition(
                        //         position: outAnimation,
                        //         child: child,
                        //       );
                        //     }
                        //   },
                        //   child: renderContent(),
                        // ),
                        child: renderContent(),
                      )
                    ],
                  ),
          ),
        ),
        isLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.36),
                child: kLoadingWidget(context),
              )
            : const SizedBox()
      ],
    );
  }

  Widget renderContent() {
    switch (tabIndex) {
      case 0:
        return SizedBox(
          key: const ValueKey(0),
          child: ShippingAddress(onNext: () {
            Future.delayed(Duration.zero, goToShippingTab);
          }),
        );
      case 1:
        return SizedBox(
          key: const ValueKey(1),
          child: Services().widget.renderShippingMethods(context, onBack: () {
            goToAddressTab(true);
          }, onNext: () {
            goToReviewTab();
          }),
        );
      case 2:
        return SizedBox(
          key: const ValueKey(2),
          child: ReviewScreen(onBack: () {
            goToShippingTab(true);
          }, onNext: () {
            goToPaymentTab();
          }),
        );
      case 3:
      default:
        return SizedBox(
          key: const ValueKey(3),
          child: PaymentMethods(
              onBack: () {
                goToReviewTab(true);
              },
              onFinish: (order) async {
                final cartModel =
                    Provider.of<CartModel>(context, listen: false);

                setState(() {
                  newOrder = order;
                });

                var productList = cartModel.getProductsInCart();
                unawaited(Services().firebase.firebaseAnalytics?.logPurchase(
                      orderId: newOrder?.id,
                      price: cartModel.getSubTotal(),
                      shipping: cartModel.getShippingCost(),
                      tax: cartModel.taxesTotal,
                      coupon: cartModel.couponObj?.code,
                      currency: cartModel.currencyCode,
                      data: productList,
                    ));

                cartModel.clearCart();
                unawaited(context.read<WalletModel>().refreshWallet());
                await Services()
                    .widget
                    .updateOrderAfterCheckout(context, order);
              },
              onLoading: setLoading),
        );
    }
  }

  /// tabIndex: 0
  void goToAddressTab([bool isGoingBack = false]) {
    if (kPaymentConfig.enableAddress) {
      setState(() {
        tabIndex = 0;
      });
    } else {
      if (!isGoingBack) {
        goToShippingTab(isGoingBack);
      }
    }
  }

  /// tabIndex: 1
  void goToShippingTab([bool isGoingBack = false]) {
    if (enabledShipping) {
      setState(() {
        tabIndex = 1;
      });
    } else {
      if (isGoingBack) {
        goToAddressTab(isGoingBack);
      } else {
        goToReviewTab(isGoingBack);
      }
    }
  }

  /// tabIndex: 2
  void goToReviewTab([bool isGoingBack = false]) {
    if (kPaymentConfig.enableReview) {
      setState(() {
        tabIndex = 2;
      });
    } else {
      if (isGoingBack) {
        goToShippingTab(isGoingBack);
      } else {
        goToPaymentTab(isGoingBack);
      }
    }
  }

  /// tabIndex: 3
  void goToPaymentTab([bool isGoingBack = false]) {
    if (!isGoingBack) {
      setState(() {
        tabIndex = 3;
      });
    }
  }
}
