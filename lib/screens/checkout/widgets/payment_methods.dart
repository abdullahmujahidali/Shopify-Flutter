import 'dart:async';
import 'dart:convert' as convert;

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/booking/booking_model.dart';
import '../../../models/index.dart'
    show AppModel, CartModel, Order, PaymentMethodModel, TaxModel, UserModel;
import '../../../models/tera_wallet/index.dart';
import '../../../modules/native_payment/credit_card/index.dart';
import '../../../modules/native_payment/flutterwave/services.dart';
import '../../../modules/native_payment/mercado_pago/index.dart';
import '../../../modules/native_payment/paypal/index.dart';
import '../../../modules/native_payment/paystack/services.dart';
import '../../../modules/native_payment/paytm/services.dart';
import '../../../modules/native_payment/razorpay/services.dart';
import '../../../services/index.dart';
import '../../../widgets/common/common_safe_area.dart';
import '../../cart/widgets/shopping_cart_sumary.dart';

class PaymentMethods extends StatefulWidget {
  final Function? onBack;
  final Function? onFinish;
  final Function(bool)? onLoading;

  const PaymentMethods({this.onBack, this.onFinish, this.onLoading});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> with RazorDelegate {
  String? selectedId;
  bool isPaying = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cartModel = Provider.of<CartModel>(context, listen: false);
      final userModel = Provider.of<UserModel>(context, listen: false);
      final langCode = Provider.of<AppModel>(context, listen: false).langCode;
      Provider.of<PaymentMethodModel>(context, listen: false).getPaymentMethods(
          cartModel: cartModel,
          shippingMethod: cartModel.shippingMethod,
          token: userModel.user != null ? userModel.user!.cookie : null,
          langCode: langCode);

      if (kPaymentConfig.enableReview != true) {
        Provider.of<TaxModel>(context, listen: false)
            .getTaxes(Provider.of<CartModel>(context, listen: false),
                (taxesTotal, taxes) {
          Provider.of<CartModel>(context, listen: false).taxesTotal =
              taxesTotal;
          Provider.of<CartModel>(context, listen: false).taxes = taxes;
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);
    final taxModel = Provider.of<TaxModel>(context);

    return ListenableProvider.value(
      value: paymentMethodModel,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(S.of(context).paymentMethods,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      S.of(context).chooseYourPaymentMethod,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                      ),
                    ),
                    Services().widget.renderPayByWallet(context),
                    const SizedBox(height: 20),
                    Consumer2<PaymentMethodModel, WalletModel>(
                        builder: (context, model, walletModel, child) {
                      if (model.isLoading) {
                        return SizedBox(
                            height: 100, child: kLoadingWidget(context));
                      }

                      if (model.message != null) {
                        return SizedBox(
                          height: 100,
                          child: Center(
                              child: Text(model.message!,
                                  style: const TextStyle(color: kErrorRed))),
                        );
                      }

                      var ignoreWallet = false;
                      final isWalletExisted = model.paymentMethods
                              .firstWhereOrNull((e) => e.id == 'wallet') !=
                          null;
                      if (isWalletExisted) {
                        final total = (cartModel.getTotal() ?? 0) +
                            cartModel.walletAmount;
                        ignoreWallet = total > walletModel.balance;
                      }

                      if (selectedId == null &&
                          model.paymentMethods.isNotEmpty) {
                        selectedId =
                            model.paymentMethods.firstWhereOrNull((item) {
                          if (ignoreWallet) {
                            return item.id != 'wallet' && item.enabled!;
                          } else {
                            return item.enabled!;
                          }
                        })?.id;
                        cartModel.setPaymentMethod(model.paymentMethods
                            .firstWhere((item) => item.id == selectedId));
                      }

                      return Column(
                        children: <Widget>[
                          for (int i = 0; i < model.paymentMethods.length; i++)
                            model.paymentMethods[i].enabled!
                                ? Services().widget.renderPaymentMethodItem(
                                    context, model.paymentMethods[i], (i) {
                                    setState(() {
                                      selectedId = i;
                                    });
                                    final paymentMethod = paymentMethodModel
                                        .paymentMethods
                                        .firstWhere((item) => item.id == i);
                                    cartModel.setPaymentMethod(paymentMethod);
                                  }, selectedId)
                                : const SizedBox()
                        ],
                      );
                    }),
                    const ShoppingCartSummary(showPrice: false),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).subtotal,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8),
                            ),
                          ),
                          Text(
                              PriceTools.getCurrencyFormatted(
                                  cartModel.getSubTotal(), currencyRate,
                                  currency: cartModel.currencyCode)!,
                              style: const TextStyle(
                                  fontSize: 14, color: kGrey400))
                        ],
                      ),
                    ),
                    Services().widget.renderShippingMethodInfo(context),
                    if (cartModel.getCoupon() != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).discount,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.8),
                              ),
                            ),
                            Text(
                              cartModel.getCoupon(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.8),
                                  ),
                            )
                          ],
                        ),
                      ),
                    Services().widget.renderTaxes(taxModel, context),
                    Services().widget.renderRewardInfo(context),
                    Services().widget.renderCheckoutWalletInfo(context),
                    Services().widget.renderCODExtraFee(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).total,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(
                            PriceTools.getCurrencyFormatted(
                                cartModel.getTotal(), currencyRate,
                                currency: cartModel.currencyCode)!,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Consumer<PaymentMethodModel>(builder: (context, model, child) {
            return _buildBottom(model, cartModel);
          })
        ],
      ),
    );
  }

  Widget _buildBottom(PaymentMethodModel paymentMethodModel, cartModel) {
    return CommonSafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kPaymentConfig.enableShipping ||
              kPaymentConfig.enableAddress ||
              kPaymentConfig.enableReview) ...[
            SizedBox(
              width: 130,
              child: OutlinedButton(
                onPressed: () {
                  isPaying ? showSnackbar : widget.onBack!();
                },
                child: Text(
                  kPaymentConfig.enableReview
                      ? S.of(context).goBack.toUpperCase()
                      : kPaymentConfig.enableShipping
                          ? S.of(context).goBackToShipping
                          : S.of(context).goBackToAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ButtonTheme(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                onPressed: (paymentMethodModel.message?.isNotEmpty ?? false)
                    ? null
                    : () => isPaying || selectedId == null
                        ? showSnackbar
                        : placeOrder(paymentMethodModel, cartModel),
                icon: const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  size: 20,
                ),
                label: Text(S.of(context).placeMyOrder.toUpperCase()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackbar() {
    Tools.showSnackBar(
        ScaffoldMessenger.of(context), S.of(context).orderStatusProcessing);
  }

  void placeOrder(PaymentMethodModel paymentMethodModel, CartModel cartModel) {
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    final cartModel = Provider.of<CartModel>(context, listen: false);

    widget.onLoading!(true);
    isPaying = true;
    if (paymentMethodModel.paymentMethods.isNotEmpty) {
      final paymentMethod = paymentMethodModel.paymentMethods
          .firstWhere((item) => item.id == selectedId);
      var isSubscriptionProduct = cartModel.item.values.firstWhere(
              (element) =>
                  element?.type == 'variable-subscription' ||
                  element?.type == 'subscription',
              orElse: () => null) !=
          null;
      cartModel.setPaymentMethod(paymentMethod);

      var productList = cartModel.getProductsInCart();

      Services().firebase.firebaseAnalytics?.logAddPaymentInfo(
            coupon: cartModel.couponObj?.code,
            currency: cartModel.currencyCode,
            data: productList,
            paymentType: paymentMethod.title,
            price: cartModel.getSubTotal(),
          );

      /// Use Credit card. For Shopify only.
      if (!isSubscriptionProduct &&
          kPaymentConfig.enableCreditCard &&
          ServerConfig().isShopify) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreditCardPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading?.call(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true).then((value) {
                    widget.onLoading?.call(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );

        return;
      }

      /// Use Native payment

      /// Direct bank transfer (BACS)

      if (!isSubscriptionProduct && paymentMethod.id!.contains('bacs')) {
        widget.onLoading?.call(false);
        isPaying = false;

        showModalBottomSheet(
            context: context,
            builder: (sContext) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              S.of(context).cancel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        paymentMethod.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Expanded(child: SizedBox(height: 10)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onLoading!(true);
                          isPaying = true;
                          Services().widget.placeOrder(
                            context,
                            cartModel: cartModel,
                            onLoading: widget.onLoading,
                            paymentMethod: paymentMethod,
                            success: (Order? order) async {
                              if (order != null) {
                                for (var item in order.lineItems) {
                                  var product =
                                      cartModel.getProductById(item.productId!);
                                  if (product?.bookingInfo != null) {
                                    product!.bookingInfo!.idOrder = order.id;
                                    var booking = await createBooking(
                                        product.bookingInfo)!;

                                    Tools.showSnackBar(
                                        ScaffoldMessenger.of(context),
                                        booking
                                            ? 'Booking success!'
                                            : 'Booking error!');
                                  }
                                }
                                widget.onFinish!(order);
                              }
                              widget.onLoading?.call(false);
                              isPaying = false;
                            },
                            error: (message) {
                              widget.onLoading?.call(false);
                              if (message != null) {
                                Tools.showSnackBar(
                                    ScaffoldMessenger.of(context), message);
                              }
                              isPaying = false;
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          S.of(context).ok,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ));

        return;
      }

      /// PayPal Payment
      if (!isSubscriptionProduct &&
          isNotBlank(kPaypalConfig['paymentMethodId']) &&
          paymentMethod.id!.contains(kPaypalConfig['paymentMethodId']) &&
          kPaypalConfig['enabled'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalPayment(
              onFinish: (number) {
                if (number == null) {
                  widget.onLoading?.call(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: true, transactionId: number).then((value) {
                    widget.onLoading?.call(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );
        return;
      }

      /// MercadoPago payment
      if (!isSubscriptionProduct &&
          isNotBlank(kMercadoPagoConfig['paymentMethodId']) &&
          paymentMethod.id!.contains(kMercadoPagoConfig['paymentMethodId']) &&
          kMercadoPagoConfig['enabled'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MercadoPagoPayment(
              onFinish: (number, paid) {
                if (number == null) {
                  widget.onLoading?.call(false);
                  isPaying = false;
                  return;
                } else {
                  createOrder(paid: paid).then((value) {
                    widget.onLoading?.call(false);
                    isPaying = false;
                  });
                }
              },
            ),
          ),
        );
        return;
      }

      /// RazorPay payment
      /// Check below link for parameters:
      /// https://razorpay.com/docs/payment-gateway/web-integration/standard/#step-2-pass-order-id-and-other-options
      if (!isSubscriptionProduct &&
          paymentMethod.id!.contains(kRazorpayConfig['paymentMethodId']) &&
          kRazorpayConfig['enabled'] == true) {
        Services().api.createRazorpayOrder({
          'amount': (PriceTools.getPriceValueByCurrency(cartModel.getTotal()!,
                      cartModel.currencyCode!, currencyRate) *
                  100)
              .toInt()
              .toString(),
          'currency': cartModel.currencyCode,
        }).then((value) {
          final razorServices = RazorServices(
            amount: (PriceTools.getPriceValueByCurrency(cartModel.getTotal()!,
                        cartModel.currencyCode!, currencyRate) *
                    100)
                .toInt()
                .toString(),
            keyId: kRazorpayConfig['keyId'],
            delegate: this,
            orderId: value,
            userInfo: RazorUserInfo(
              email: cartModel.address?.email,
              phone: cartModel.address?.phoneNumber,
              fullName:
                  '${cartModel.address?.firstName ?? ''} ${cartModel.address?.lastName ?? ''}'
                      .trim(),
            ),
          );
          razorServices.openPayment(cartModel.currencyCode!);
        }).catchError((e) {
          widget.onLoading?.call(false);
          Tools.showSnackBar(ScaffoldMessenger.of(context), e);
          isPaying = false;
        });
        return;
      }

      /// PayTm payment.
      /// Check below link for parameters:
      /// https://developer.paytm.com/docs/all-in-one-sdk/hybrid-apps/flutter/
      final availablePayTm = kPayTmConfig['paymentMethodId'] != null &&
          (kPayTmConfig['enabled'] ?? false) &&
          paymentMethod.id!.contains(kPayTmConfig['paymentMethodId']);
      if (!isSubscriptionProduct && availablePayTm) {
        createOrderOnWebsite(
            paid: false,
            onFinish: (Order? order) async {
              if (order != null) {
                final paytmServices = PayTmServices(
                  amount: cartModel.getTotal()!.toString(),
                  orderId: order.id!,
                  email: cartModel.address?.email,
                );
                try {
                  await paytmServices.openPayment();
                  widget.onFinish!(order);
                } catch (e) {
                  Tools.showSnackBar(
                      ScaffoldMessenger.of(context), e.toString());
                  isPaying = false;
                  unawaited(_deletePendingOrder(order.id));
                }
              }
            });
        return;
      }

      /// PayStack payment.
      final availablePayStack = kPayStackConfig['paymentMethodId'] != null &&
          (kPayStackConfig['enabled'] ?? false) &&
          paymentMethod.id!.contains(kPayStackConfig['paymentMethodId']);
      if (!isSubscriptionProduct && availablePayStack) {
        final isSupported =
            List.from(kPayStackConfig['supportedCurrencies'] ?? [])
                    .firstWhereOrNull((e) =>
                        e.toString().toLowerCase() ==
                        cartModel.currencyCode?.toLowerCase()) !=
                null;
        if (isSupported) {
          createOrderOnWebsite(
              paid: false,
              onFinish: (Order? order) async {
                if (order != null) {
                  final payStackServices = PayStackServices(
                    amount: cartModel.getTotal()!.toString(),
                    orderId: order.id!,
                    email: cartModel.address?.email,
                  );
                  try {
                    await payStackServices.openPayment(
                        context, widget.onLoading!);
                    widget.onFinish!(order);
                  } catch (e) {
                    Tools.showSnackBar(
                        ScaffoldMessenger.of(context), e.toString());
                    isPaying = false;
                    unawaited(_deletePendingOrder(order.id));
                  }
                }
              });
        } else {
          isPaying = false;
          widget.onLoading?.call(false);
          Tools.showSnackBar(
              ScaffoldMessenger.of(context),
              S.of(context).currencyIsNotSupported(
                  cartModel.currencyCode?.toUpperCase() ?? ''));
        }
        return;
      }

      /// Flutterwave payment.
      final availableFlutterwave =
          kFlutterwaveConfig['paymentMethodId'] != null &&
              (kFlutterwaveConfig['enabled'] ?? false) &&
              paymentMethod.id!.contains(kFlutterwaveConfig['paymentMethodId']);
      if (!isSubscriptionProduct && availableFlutterwave) {
        createOrderOnWebsite(
            paid: false,
            onFinish: (Order? order) async {
              if (order != null) {
                final flutterwaveServices = FlutterwaveServices(
                    amount: cartModel.getTotal()!.toString(),
                    orderId: order.id!,
                    email: cartModel.address?.email,
                    name: cartModel.address?.fullName,
                    phone: cartModel.address?.phoneNumber,
                    currency: cartModel.currencyCode,
                    paymentMethod: paymentMethod.title);
                try {
                  await flutterwaveServices.openPayment(
                      context, widget.onLoading!);
                  widget.onFinish!(order);
                } catch (e) {
                  Tools.showSnackBar(
                      ScaffoldMessenger.of(context), e.toString());
                  isPaying = false;
                  unawaited(_deletePendingOrder(order.id));
                }
              }
            });
        return;
      }

      /// Use WebView Payment per frameworks
      Services().widget.placeOrder(
        context,
        cartModel: cartModel,
        onLoading: widget.onLoading,
        paymentMethod: paymentMethod,
        success: (Order? order) async {
          if (order != null) {
            for (var item in order.lineItems) {
              var product = cartModel.getProductById(item.productId!);
              if (product?.bookingInfo != null) {
                product!.bookingInfo!.idOrder = order.id;
                var booking = await createBooking(product.bookingInfo)!;

                Tools.showSnackBar(ScaffoldMessenger.of(context),
                    booking ? 'Booking success!' : 'Booking error!');
              }
            }
            widget.onFinish!(order);
          }
          widget.onLoading?.call(false);
          isPaying = false;
        },
        error: (message) {
          widget.onLoading?.call(false);
          if (message != null) {
            Tools.showSnackBar(ScaffoldMessenger.of(context), message);
          }

          isPaying = false;
        },
      );
    }
  }

  Future<bool>? createBooking(BookingModel? bookingInfo) async {
    return Services().api.createBooking(bookingInfo)!;
  }

  Future<void> createOrder(
      {paid = false, bacs = false, cod = false, transactionId = ''}) async {
    await createOrderOnWebsite(
        paid: paid,
        bacs: bacs,
        cod: cod,
        transactionId: transactionId,
        onFinish: (Order? order) async {
          if (!transactionId.toString().isEmptyOrNull && order != null) {
            await Services()
                .api
                .updateOrderIdForRazorpay(transactionId, order.number);
          }
          widget.onFinish!(order);
        });
  }

  Future<void> createOrderOnWebsite(
      {paid = false,
      bacs = false,
      cod = false,
      transactionId = '',
      required Function(Order?) onFinish}) async {
    widget.onLoading!(true);
    await Services().widget.createOrder(
      context,
      paid: paid,
      cod: cod,
      bacs: bacs,
      transactionId: transactionId,
      onLoading: widget.onLoading,
      success: onFinish,
      error: (message) {
        Tools.showSnackBar(ScaffoldMessenger.of(context), message);
      },
    );
    widget.onLoading?.call(false);
  }

  Future<void> _deletePendingOrder(String? orderId) async {
    try {
      final userModel = Provider.of<UserModel>(context, listen: false);
      await Services().api.deleteOrder(orderId, token: userModel.user?.cookie);
    } catch (_) {}
  }

  @override
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    createOrder(paid: true, transactionId: response.paymentId).then((value) {
      widget.onLoading?.call(false);
      isPaying = false;
    });
  }

  @override
  void handlePaymentFailure(PaymentFailureResponse response) {
    widget.onLoading?.call(false);
    isPaying = false;
    final body = convert.jsonDecode(response.message!);
    if (body['error'] != null &&
        body['error']['reason'] != 'payment_cancelled') {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), body['error']['description']);
    }
    printLog(response.message);
  }

  String formatPrice(String? price) {
    if (isNotBlank(price)) {
      final currencyRate =
          Provider.of<AppModel>(context, listen: false).currencyRate;
      final cartModel = Provider.of<CartModel>(context, listen: false);
      var p = PriceTools.getPriceValueByCurrency(
          price, cartModel.currencyCode!, currencyRate);
      final formatCurrency = NumberFormat('#,##0.00', 'en_US');
      return formatCurrency.format(p);
    } else {
      return '0';
    }
  }
}
