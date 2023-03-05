import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../screens/chat/smartchat.dart';
import '../../../services/index.dart' show ServerConfig;

mixin SmartChatMixin<T extends StatefulWidget> on State<T> {
  List<String> _showOnScreens = <String>[];
  final _hideOnScreens = <String>[];

  late bool _showChat;

  bool get _useVendorChat => ServerConfig().isVendorType();

  bool get _enableChat =>
      (kConfigChat['EnableSmartChat'] ?? false) &&
      kConfigChat['showOnScreens'] != null;

  @override
  void initState() {
    super.initState();
    if (_enableChat) {
      _showOnScreens = List<String>.from(kConfigChat['showOnScreens']);
      if (_useVendorChat) {
        _hideOnScreens.addAll([
          RouteList.productDetail,
          RouteList.storeDetail,
        ]);
      }
    }
    _showChat = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildSmartChatWidget() {
    return Visibility(
      visible: _showChat,
      child: const SmartChat(
        margin: EdgeInsets.only(right: 25.0),
      ),
    );
  }

  void handleSmartChat(String? screenName) {
    /// routeName is a route emitted by RouteObservable
    /// Which can be modify by [FluxNavigate] to support Web
    ///
    /// screenName is define in env.txt file
    /// Which can not modify and the same in [RouteList]

    if (screenName == null) return;
    if (!_enableChat) return;

    if (_hideOnScreens.contains(screenName)) {
      _showChat = false;
      return;
    }

    if (!_showOnScreens.contains(screenName)) {
      _showChat = false;
      return;
    }

    _showChat = true;
  }
}
