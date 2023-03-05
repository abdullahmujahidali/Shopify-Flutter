import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/index.dart'
    show AppModel, CartModel, Product, UserModel;
import '../../../services/service_config.dart';
import 'services.dart';

class MercadoPagoPayment extends StatefulWidget {
  final Function(dynamic, bool)? onFinish;

  const MercadoPagoPayment({this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return MercadoPagoPaymentState();
  }
}

class MercadoPagoPaymentState extends State<MercadoPagoPayment> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final MercadoPagoServices _services = MercadoPagoServices();
  String? url;
  String? id = '';
  final kReturnSuccessUrl = '${ServerConfig().url}/success';

  Map<String, dynamic> getOrderParams() {
    var cartModel = Provider.of<CartModel>(context, listen: false);
    final currency = Provider.of<AppModel>(context, listen: false).currency;
    List items = cartModel.productsInCart.keys.map(
      (key) {
        var productId = Product.cleanProductID(key);

        final product = cartModel.getProductById(productId);
        final variation = cartModel.getProductVariationById(key);
        final price = variation != null ? variation.price! : product!.price!;

        return {
          'title': product!.name,
          'description': '',
          'quantity': cartModel.productsInCart[key],
          'unit_price': double.parse(price),
          'currency_id': currency
        };
      },
    ).toList();

    var temp = <String, dynamic>{
      'items': items,
      'back_urls': {'success': kReturnSuccessUrl},
      'shipments': {'cost': cartModel.getShippingCost()}
    };

    final userEmail = context.read<UserModel>().user?.email;
    if (userEmail != null) {
      temp['payer'] = {'email': userEmail};
    }

    return temp;
  }

  Future<void> customWebViewListener(WebViewController controller) async {
    var currentUrl = await (controller.currentUrl() as Future<String>);
    if (!_handleUrlCallback(context, currentUrl)) {
      await Future.delayed(const Duration(seconds: 2)).then(
        (value) => customWebViewListener(controller),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        var map = await _services.getPaymentUrl(getOrderParams());
        url = map['paymentUrl'];
        id = map['orderId'];
        if (url == null) {
          return;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: GestureDetector(
            onTap: () {
              widget.onFinish?.call(null, false);
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: WebView(
          initialUrl: url,
          onWebViewCreated: customWebViewListener,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            _handleUrlCallback(context, request.url);
            return NavigationDecision.navigate;
          },
        ),
      );
    }
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.onFinish?.call(null, false);
                Navigator.of(context).pop();
              }),
          backgroundColor: kGrey200,
          elevation: 0.0,
        ),
        body: Container(child: kLoadingWidget(context)),
      ),
    );
  }

  bool _handleUrlCallback(BuildContext context, String url) {
    /// Efecty, customers needs to make the payment at the physical branch and
    /// they need a voucher with the data to be able to pay this in the physical establishment.
    /// Order will be created as not paid.
    final isEfectyPaymentMethod = url.contains('congrats/instructions');
    final paid = !isEfectyPaymentMethod;
    if (url.contains(kReturnSuccessUrl) || url.contains('congrats/approved')) {
      widget.onFinish?.call(id, paid);
      Navigator.of(context).pop();
      return true;
    }
    return false;
  }
}
