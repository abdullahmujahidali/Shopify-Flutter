import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools/price_tools.dart';
import '../../../common/tools/tools.dart';
import '../../../models/index.dart' show AppModel, CartModel, Product;
import 'services.dart';

class PaypalPayment extends StatefulWidget {
  final Function? onFinish;

  const PaypalPayment({this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res['approvalUrl'];
            executeUrl = res['executeUrl'];
          });
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
    });
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

  Map<String, dynamic> getOrderParams() {
    var cartModel = Provider.of<CartModel>(context, listen: false);
    final currency = Provider.of<AppModel>(context, listen: false).currency;
    List items = cartModel.productsInCart.keys.map(
      (key) {
        var productId = Product.cleanProductID(key);

        final product = cartModel.getProductById(productId);
        final variation = cartModel.getProductVariationById(key);
        final price = variation != null ? variation.price : product!.price;

        return {
          'name': product!.name,
          'quantity': cartModel.productsInCart[key],
          'price': formatPrice(price),
          'currency': (Tools.getCurrencyCode(currency) ?? '').toUpperCase()
        };
      },
    ).toList();

    // this should add Shipping Cost + Coupon...
    final discountAmount = (cartModel.getCouponCost() +
        cartModel.walletAmount +
        cartModel.rewardTotal);
    final tax = cartModel.getTotal()! -
        cartModel.getSubTotal()! -
        cartModel.getShippingCost()! +
        discountAmount;

    var temp = <String, dynamic>{
      'intent': 'sale',
      'payer': {'payment_method': 'paypal'},
      'transactions': [
        {
          'amount': {
            'total': formatPrice(cartModel.getTotal().toString()),
            'currency': (Tools.getCurrencyCode(currency) ?? '').toUpperCase(),
            'details': {
              'subtotal': formatPrice(cartModel.getSubTotal().toString()),
              'shipping': formatPrice(cartModel.getShippingCost().toString()),
              'shipping_discount':
                  formatPrice(((-1.0) * discountAmount).toString()),
              'tax': formatPrice(tax.toString())
            }
          },
          'description': 'The payment transaction description.',
          'payment_options': {
            'allowed_payment_method': 'INSTANT_FUNDING_SOURCE'
          },
          'item_list': {
            'items': items,
            if (kPaymentConfig.enableShipping && kPaymentConfig.enableAddress)
              'shipping_address': {
                'recipient_name':
                    '${cartModel.address?.firstName ?? ''} ${cartModel.address?.lastName ?? ''}'
                        .trim(),
                'line1': cartModel.address?.street,
                'line2': '',
                'city': cartModel.address?.city,
                'country_code': cartModel.address?.country,
                'postal_code': cartModel.address?.zipCode,
                'phone': cartModel.address?.phoneNumber,
                'state': cartModel.address?.state
              },
          }
        }
      ],
      'note_to_payer': 'Contact us for any questions on your order.',
      'redirect_urls': {
        'return_url': 'http://return.example.com',
        'cancel_url': 'http://cancel.example.com'
      }
    };

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return WillPopScope(
        onWillPop: _handleAndroidBack,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: GestureDetector(
              onTap: () {
                widget.onFinish!(null);
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: WebView(
            initialUrl: checkoutUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('http://return.example.com')) {
                final uri = Uri.parse(request.url);
                final payerID = uri.queryParameters['PayerID'];
                if (payerID != null) {
                  services
                      .executePayment(executeUrl, payerID, accessToken)
                      .then((id) {
                    widget.onFinish!(id);
                  });
                }
                Navigator.of(context).pop();
              }
              if (request.url.startsWith('http://cancel.example.com')) {
                Navigator.of(context).pop();
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: _handleAndroidBack,
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  widget.onFinish!(null);
                  Navigator.of(context).pop();
                }),
            backgroundColor: kGrey200,
            elevation: 0.0,
          ),
          body: Container(child: kLoadingWidget(context)),
        ),
      ),
    );
  }

  Future<bool> _handleAndroidBack() async {
    widget.onFinish!(null);
    return true;
  }
}
