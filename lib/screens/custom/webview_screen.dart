import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../widgets/common/index.dart';

class WebViewScreen extends StatefulWidget {
  final String? title;
  final String? url;
  final String script;
  final bool enableForward;
  final bool enableBackward;
  final bool enableClose;

  /// is determine if include cookie/session into WebView URL
  final bool auth;

  const WebViewScreen({
    this.title,
    this.auth = false,
    this.script = '',
    this.enableForward = true,
    this.enableBackward = true,
    this.enableClose = true,
    required this.url,
  });

  @override
  State<WebViewScreen> createState() => _StateWebViewScreen();
}

class _StateWebViewScreen extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      url: widget.url,
      title: widget.title,
      enableForward: widget.enableForward,
      enableBackward: widget.enableBackward,
      enableClose: Navigator.canPop(context) && widget.enableClose,
      auth: widget.auth,
      script: widget.script.isEmptyOrNull
          ? kAdvanceConfig.webViewScript
          : widget.script,
      routeName: RouteList.page,
    );
  }
}
