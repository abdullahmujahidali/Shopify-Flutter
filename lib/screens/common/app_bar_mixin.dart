import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../menu/index.dart' show FluxAppBar;
import '../../models/index.dart' show AppModel;
import '../../modules/dynamic_layout/index.dart' show AppBarConfig;

mixin AppBarMixin<T extends StatefulWidget> on State<T> {
  AppBarConfig? get appBar => context.read<AppModel>().appConfig?.appBar;

  final ValueNotifier<bool> _isAtTopNotifier = ValueNotifier(true);

  ValueNotifier<bool> get isAtTopNotifier => _isAtTopNotifier;

  bool _shouldShowAppBarBottomItems(bool isAtTop) =>
      isAtTop && (appBar?.bottomItems?.isNotEmpty ?? false);

  ScrollController? screenScrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenScrollController ??= PrimaryScrollController.of(context);
      screenScrollController?.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    screenScrollController?.removeListener(_scrollListener);
    screenScrollController = null;
    super.dispose();
  }

  void _scrollListener() {
    if (screenScrollController == null ||
        !(screenScrollController?.hasClients ?? false) ||
        screenScrollController?.positions.length != 1) {
      return;
    }
    if ((screenScrollController?.offset ?? 0.0) > 0.0) {
      _isAtTopNotifier.value = false;
    } else {
      _isAtTopNotifier.value = true;
    }
  }

  bool showAppBar(String routeName) {
    if (appBar?.enable ?? false) {
      return appBar?.shouldShowOn(routeName) ?? false;
    }
    return false;
  }

  Widget _getFluxAppBar(bool isAtTop) => Column(
        children: [
          FluxAppBar(
            isBottom: false,
            showBottom: isAtTop,
          ),
          if (_shouldShowAppBarBottomItems(isAtTop))
            FluxAppBar(
              isBottom: true,
              showBottom: isAtTop,
            ),
        ],
      );

  double _getFluxAppBarHeight(bool isAtTop) =>
      _shouldShowAppBarBottomItems(isAtTop)
          ? kToolbarHeight * 2 + 8
          : kToolbarHeight;

  Widget get appBarWidget => getAppBarWidget(appBar: appBar);

  /// [snap] is always false if [float] is false.
  Widget get sliverAppBarWidget => getSliverAppBarWidget(appBar: appBar);

  Widget getAppBarWidget({
    AppBarConfig? appBar,
    Color? backgroundColor,
  }) =>
      ValueListenableBuilder(
        valueListenable: _isAtTopNotifier,
        builder: (context, bool isAtTop, _) {
          return AppBar(
            titleSpacing: 0,
            elevation: appBar?.elevation.toDouble() ?? 0,
            automaticallyImplyLeading: false,
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.background,
            title: _getFluxAppBar(isAtTop),
            toolbarHeight: _getFluxAppBarHeight(isAtTop),
          );
        },
      );

  Widget getSliverAppBarWidget({
    AppBarConfig? appBar,
    Color? backgroundColor,
    List<Widget>? actions,
  }) =>
      ValueListenableBuilder(
          valueListenable: _isAtTopNotifier,
          builder: (context, bool isAtTop, _) {
            return SliverAppBar(
              snap: (appBar?.floating ?? true) ? appBar?.snap ?? true : false,
              pinned: appBar?.pinned ?? true,
              floating: appBar?.floating ?? true,
              titleSpacing: 0,
              elevation: appBar?.elevation.toDouble() ?? 0,
              forceElevated: true,
              automaticallyImplyLeading: false,
              backgroundColor:
                  backgroundColor ?? Theme.of(context).colorScheme.background,
              title: _getFluxAppBar(isAtTop),
              toolbarHeight: _getFluxAppBarHeight(isAtTop),
              actions: actions,
            );
          });

  Widget renderScaffold({
    required String routeName,
    required Widget child,
    bool? resizeToAvoidBottomInset,
    Color? backgroundColor,
    bool hideNewAppBar = false,
    Widget? floatingActionButton,
    AppBarConfig? appBarConfig,
    AppBar? secondAppBar,
    bool? disableSafeArea,
  }) {
    if (child is Scaffold) {
      printLog(
        '[renderScaffold] Warning: Duplicate Scaffold can cause AppBar issue on iOS.',
      );
    }
    final appBar = appBarConfig ?? this.appBar;
    final showNewAppBar =
        (appBar?.shouldShowOn(routeName) ?? false) && !hideNewAppBar;
    if (showNewAppBar) {
      return Scaffold(
        body: Column(
          children: [
            getAppBarWidget(
              appBar: appBar,
              backgroundColor: backgroundColor,
            ),
            if (secondAppBar != null)
              MediaQuery.removePadding(
                context: context,
                removeTop: showNewAppBar,
                child: secondAppBar,
              ),
            Expanded(child: child),
          ],
        ),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
      );
    }
    if (resizeToAvoidBottomInset != null ||
        backgroundColor != null ||
        floatingActionButton != null ||
        secondAppBar != null) {
      return Scaffold(
        appBar: secondAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        body: SafeArea(
          left: false,
          right: false,
          bottom: false,
          top: disableSafeArea != true,
          child: child,
        ),
        floatingActionButton: floatingActionButton,
      );
    }
    return child;
  }
}
