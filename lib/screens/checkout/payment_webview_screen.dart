import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../services/index.dart';
import '../../widgets/common/webview.dart';
import '../base_screen.dart';

class PaymentWebview extends StatefulWidget {
  final String? url;
  final Function? onFinish;
  final Function? onClose;
  final String? token;

  const PaymentWebview({this.onFinish, this.onClose, this.url, this.token});

  @override
  State<StatefulWidget> createState() {
    return PaymentWebviewState();
  }
}

class PaymentWebviewState extends BaseScreen<PaymentWebview> with WebviewMixin {
  int selectedIndex = 1;
  String? orderId;

  void handleUrlChanged(String url) {
    if (url.contains('/order-received/')) {
      final items = url.split('/order-received/');
      if (items.length > 1) {
        orderId = items[1].split('/')[0];
      }
    }

    if (url.contains('checkout/success')) {
      orderId = '0';
    }

    if (url.contains('thank-you')) {
      orderId = '0';
    }

    // shopify url final checkout
    if (url.contains('thank_you')) {
      orderId = '0';
    }

    /// BigCommerce.
    if (url.contains('/checkout/order-confirmation')) {
      orderId = '0';
    }

    /// Prestashop
    if (url.contains('/order-confirmation')) {
      var uri = Uri.parse(url);
      orderId = (uri.queryParameters['id_order'] ?? 0).toString();
    }

    /// Finally
    if (orderId != null) {
      widget.onFinish?.call(orderId);
      if (kPaymentConfig.showWebviewCheckoutSuccessScreen) {
        Navigator.of(context).pop();
      }
    }

    // Not sure about this case, maybe related to file lib/modules_ext/membership_ultimate/views/signup_screen.dart
    if (url.contains('/member-login/')) {
      orderId = '0';
      widget.onFinish?.call(orderId);
      Navigator.of(context).pop();
    }

    // opencart: exit webview when user press `continue` button after showing 'checkout/success' page. For example https://opencart-demo.mstore.io/index.php?route=checkout/success
    if (url.contains('common/home')) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var checkoutMap = <dynamic, dynamic>{
      'url': '',
      'headers': <String, String>{}
    };

    if (widget.url != null) {
      checkoutMap['url'] = widget.url;
    } else {
      final paymentInfo = Services().widget.getPaymentUrl(context)!;
      checkoutMap['url'] = paymentInfo['url'];
      if (paymentInfo['headers'] != null) {
        checkoutMap['headers'] =
            Map<String, String>.from(paymentInfo['headers']);
      }
    }
    if (widget.token != null) {
      checkoutMap['headers']['X-Shopify-Customer-Access-Token'] = widget.token;
    }

    // // Enable webview payment plugin
    /// make sure to import 'payment_webview_plugin.dart';
    // return PaymentWebviewPlugin(
    //   url: checkoutMap['url'],
    //   headers: checkoutMap['headers'],
    //   onClose: widget.onClose,
    //   onFinish: widget.onFinish,
    // );

    return WebView(
      url: checkoutMap['url'] ?? '',
      headers: checkoutMap['headers'],
      onPageFinished: handleUrlChanged,
      onClosed: () {
        widget.onFinish?.call(orderId);
        widget.onClose?.call();
      },
    );
  }
}
