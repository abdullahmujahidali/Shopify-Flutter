import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inspireui/widgets/platform_error/platform_error.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/extensions/extensions.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class WebViewInApp extends StatefulWidget {
  final String url;
  final String? title;
  final String? script;
  final Function(String?)? onUrlChanged;
  final Map<String, String>? headers;
  final Function? onClosed;
  final bool enableForward;
  final bool enableBackward;
  final bool enableClose;
  final Function? overrideNavigation;

  const WebViewInApp({
    Key? key,
    required this.url,
    this.title,
    this.script,
    this.onUrlChanged,
    this.onClosed,
    this.headers,
    this.enableBackward = true,
    this.enableForward = true,
    this.enableClose = true,
    this.overrideNavigation,
  }) : super(key: key);

  @override
  State<WebViewInApp> createState() => _WebViewInAppState();
}

class _WebViewInAppState extends State<WebViewInApp> {
  final GlobalKey webViewKey = GlobalKey();
  bool isLoaded = false;
  bool isDone = false;
  String addListingUrl = '';
  late var authUrl;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;

  @override
  void dispose() {
    if (kAdvanceConfig.alwaysClearWebViewCache) {
      webViewController?.clearCache();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.black45),
      onRefresh: () async {
        // var url = webViewController?.getUrl().toString();
        printLog('[WebView InApp] Pull to Refresh');
        if (isAndroid) {
          await webViewController?.reload();
        } else if (isIos) {
          await webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || isDesktop) {
      return const PlatformError(
        enablePop: false,
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.title ?? '',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        leadingWidth: 150,
        actions: [
          if (widget.enableClose)
            IconButton(
              onPressed: () async {
                widget.onClosed?.call();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, size: 20),
            ),
          const SizedBox(width: 10),
        ],
        leading: Builder(builder: (buildContext) {
          return Row(
            children: [
              const SizedBox(width: 20),
              if (widget.enableBackward)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () async {
                    final value = await webViewController?.canGoBack();
                    if (value == true) {
                      await webViewController?.goBack();
                    } else if (!widget.enableClose &&
                        Navigator.canPop(context)) {
                      widget.onClosed?.call();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              if (webViewController?.canGoForward() != null &&
                  widget.enableForward)
                IconButton(
                  onPressed: () => webViewController?.goForward(),
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
            ],
          );
        }),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
          url: Uri.parse(
            '${widget.url}${kAdvanceConfig.alwaysClearWebViewCache ? '${widget.url.paramSymbol}dummy=${DateTime.now().millisecondsSinceEpoch}' : ''}',
          ),
          headers: widget.headers,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url.toString();
          printLog('[WebViewInApp] shouldOverrideUrlLoading: $url');
          final result = await widget.overrideNavigation?.call(url);
          if (result == true) {
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
        initialUserScripts: UnmodifiableListView<UserScript>([
          /// Demo the Javascript Style override
          UserScript(
            source: widget.script ?? '',
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          ),
        ]),
        gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{}..add(
            const Factory<VerticalDragGestureRecognizer>(
                VerticalDragGestureRecognizer.new),
          ),
        initialOptions: options,
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        androidOnGeolocationPermissionsShowPrompt:
            (InAppWebViewController controller, String origin) async {
          if (await Permission.locationWhenInUse.isDenied) {
            await Permission.location.request();
          } else if (await Permission.locationWhenInUse.isPermanentlyDenied) {
            await openAppSettings();
          }
          return GeolocationPermissionShowPromptResponse(
              origin: origin, allow: true, retain: true);
        },
        onLoadError: (controller, url, code, message) {
          pullToRefreshController.endRefreshing();
        },
        onLoadStop: (_, __) {
          setState(() {});
        },
        onProgressChanged: (_, progress) {
          if (progress == 100) {
            pullToRefreshController.endRefreshing();
          }
        },
        onUpdateVisitedHistory: (_, uri, androidIsReload) {
          if (widget.onUrlChanged != null) {
            widget.onUrlChanged!(uri?.toString());
          }
        },
      ),
    );
  }
}
