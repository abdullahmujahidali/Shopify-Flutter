// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
// import '../../common/config.dart';
// import '../../common/constants.dart';
// import '../../common/tools.dart';
// import '../../generated/l10n.dart';
// import '../common/app_bar_mixin.dart';
//
// class WebViewScreen extends StatefulWidget {
//   final String? title;
//   final String? url;
//
//   const WebViewScreen({
//     this.title,
//     required this.url,
//   });
//
//   @override
//   _StateWebViewScreen createState() => _StateWebViewScreen();
// }
//
// class _StateWebViewScreen extends State<WebViewScreen> with AppBarMixin {
//   final flutterWebviewPlugin = FlutterWebviewPlugin();
//
//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//       withJavascript: true,
//       appCacheEnabled: true,
//       geolocationEnabled: true,
//       url: widget.url ?? '',
//       // it's possible to add the Agent to fix the payment in some cases
//       // userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36',
//       appBar: showAppBar(RouteList.page) ? appBarWidget : AppBar(
//         title: Text(
//           widget.title ?? '',
//           style: Theme.of(context)
//               .textTheme
//               .headline5
//               ?.copyWith(fontWeight: FontWeight.w700),
//         ),
//         backgroundColor: Theme.of(context).backgroundColor,
//         actions: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: GestureDetector(
//               onTap: isMobile
//                   ? () async {
//                 if (await flutterWebviewPlugin.canGoBack()) {
//                   await flutterWebviewPlugin.goBack();
//                 } else {
//                   Tools.showSnackBar(ScaffoldMessenger.of(context),
//                       S.of(context).noBackHistoryItem);
//                   return;
//                 }
//               }
//                   : null,
//               child: const Icon(Icons.arrow_back_ios),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: GestureDetector(
//               onTap: isMobile
//                   ? () async {
//                 if (await flutterWebviewPlugin.canGoForward()) {
//                   await flutterWebviewPlugin.goForward();
//                 } else {
//                   Tools.showSnackBar(ScaffoldMessenger.of(context),
//                       S.of(context).noForwardHistoryItem);
//                   return;
//                 }
//               }
//                   : null,
//               child: const Icon(Icons.arrow_forward_ios),
//             ),
//           )
//         ],
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
