// // Enable webview payment plugin
// /// This Webview plugin is disable by default by missing V2 Android embedding
// /// to enable make sure to install from pubspec
// /// https://pub.dev/packages/flutter_webview_plugin
// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
// import '../../common/config.dart';
// import '../base_screen.dart';
//
// class PaymentWebviewPlugin extends StatefulWidget {
//   final String url;
//   final Map<String, String> headers;
//   final Function? onFinish;
//   final Function? onClose;
//
//   const PaymentWebviewPlugin({
//     this.onFinish,
//     this.onClose,
//     required this.headers,
//     required this.url,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return PaymentWebviewState();
//   }
// }
//
// class PaymentWebviewState extends BaseScreen<PaymentWebviewPlugin> {
//   int selectedIndex = 1;
//   @override
//   Future<void> afterFirstLayout(BuildContext context) async {
//     initWebView();
//   }
//
//   void initWebView() {
//     final flutterWebviewPlugin = FlutterWebviewPlugin();
//
//     flutterWebviewPlugin.onUrlChanged.listen((String url) {
//       if (url.contains('/order-received/')) {
//         final items = url.split('/order-received/');
//         if (items.length > 1) {
//           final number = items[1].split('/')[0];
//           widget.onFinish!(number);
//           Navigator.of(context).pop();
//         }
//       }
//       if (url.contains('checkout/success')) {
//         widget.onFinish!('0');
//         Navigator.of(context).pop();
//       }
//
//       // shopify url final checkout
//       if (url.contains('thank_you')) {
//         widget.onFinish!('0');
//         Navigator.of(context).pop();
//       }
//     });
//
//     // this code to hide some classes in website, change site-header class based on the website
//     flutterWebviewPlugin.onStateChanged.listen((viewState) {
//       if (viewState.type == WebViewState.finishLoad) {
//         flutterWebviewPlugin.evalJavascript(
//             'document.getElementsByClassName(\'site-header\')[0].style.display=\'none\';');
//         flutterWebviewPlugin.evalJavascript(
//             'document.getElementsByClassName(\'site-footer\')[0].style.display=\'none\';');
//       }
//     });
//
// //    var givenJS = rootBundle.loadString('assets/extra_webview.js');
// //    // ignore: missing_return
// //    givenJS.then((String js) {
// //      flutterWebviewPlugin.onStateChanged.listen((viewState) async {
// //        if (viewState.type == WebViewState.finishLoad) {
// //          await flutterWebviewPlugin.evalJavascript(js);
// //        }
// //      });
// //    });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//       withJavascript: true,
//       appCacheEnabled: true,
//       geolocationEnabled: true,
//       url: widget.url,
//       headers: widget.headers,
//       // it's possible to add the Agent to fix the payment in some cases
//       // userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36',
//       appBar: AppBar(
//         leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               widget.onFinish!(null);
//               Navigator.of(context).pop();
//
//               if (widget.onClose != null) {
//                 widget.onClose!();
//               }
//             }),
//         backgroundColor: Theme.of(context).backgroundColor,
//         elevation: 0.0,
//       ),
//       withZoom: true,
//       withLocalStorage: true,
//       initialChild: Container(
//         color: Theme.of(context).backgroundColor,
//         child: kLoadingWidget(context),
//       ),
//     );
//   }
// }
