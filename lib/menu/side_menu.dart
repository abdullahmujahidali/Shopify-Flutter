import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../common/constants.dart';
import '../modules/dynamic_layout/helper/helper.dart';
import '../modules/dynamic_layout/index.dart';
import '../screens/index.dart';
import '../widgets/common/index.dart';

class SideMenu extends StatefulWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final String? sideMenuBackground;
  final String? sideMenuBackgroundImage;
  final String? colorFilter;
  final num? filter;
  final ZoomConfig? zoomConfig;
  final Widget? drawer;
  final bool tabBarOnTop;

  const SideMenu({
    required this.child,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.sideMenuBackground,
    this.sideMenuBackgroundImage,
    this.colorFilter,
    this.filter,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.zoomConfig,
    this.tabBarOnTop = false,
    this.drawer,
  });

  @override
  BaseScreen<SideMenu> createState() => _StateSideMenu();
}

class _StateSideMenu extends BaseScreen<SideMenu> {
  /// Navigation variable
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(debugLabel: 'Dashboard');

  StreamSubscription? _subOpenNativeDrawer;
  StreamSubscription? _subCloseNativeDrawer;
  StreamSubscription? _subDrawerSettings;
  final _drawerController = ZoomDrawerController();

  bool get enableBackground =>
      widget.sideMenuBackground != null ||
      widget.colorFilter != null ||
      widget.zoomConfig?.backgroundImage != null ||
      widget.sideMenuBackgroundImage != null;

  @override
  void initState() {
    super.initState();
    _subOpenNativeDrawer = eventBus.on<EventOpenNativeDrawer>().listen((event) {
      if (!_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openDrawer();
      }
      if (widget.zoomConfig != null) {
        _drawerController.open!();
      }
    });
    _subDrawerSettings = eventBus.on<EventDrawerSettings>().listen((event) {
      if (!_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openDrawer();
      }
      if (widget.zoomConfig != null) {
        _drawerController.open!();
      }
    });
    _subCloseNativeDrawer =
        eventBus.on<EventCloseNativeDrawer>().listen((event) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      }
      if (widget.zoomConfig != null) {
        _drawerController.close!();
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);

    /// call for update drawer notifier
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    _subOpenNativeDrawer?.cancel();
    _subCloseNativeDrawer?.cancel();
    _subDrawerSettings?.cancel();
  }

  bool isOpen() {
    if (_drawerController.isOpen != null) {
      return _drawerController.isOpen!();
    }
    return false;
  }

  bool moveMenuScreen(String value) {
    switch (value) {
      case 'scaleRight':
        return false;
      default:
    }
    return true;
  }

  double angle(String style, double value) {
    switch (style) {
      case 'rotate':
      case '3Din':
      case '3Dout':
        return value;
      default:
    }
    return 0.0;
  }

  DrawerStyle getStyle(String value) {
    switch (value) {
      case 'scaleRight':
      case 'overlay':
      case 'rotate':
        return DrawerStyle.defaultStyle;
      case 'scaleBottom':
        return DrawerStyle.style2;
      case '3Din':
        return DrawerStyle.style3;
      case '3Dout':
        return DrawerStyle.style4;
      default:
        return DrawerStyle.defaultStyle;
    }
  }

  Widget renderLayout({bool enableDrawer = false}) {
    return Scaffold(
      key: _scaffoldKey,
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: widget.backgroundColor,
      bottomNavigationBar:
          widget.tabBarOnTop ? null : widget.bottomNavigationBar,
      appBar: widget.tabBarOnTop && widget.bottomNavigationBar != null
          ? PreferredSize(
              preferredSize: const Size(double.infinity, 40),
              child: widget.bottomNavigationBar ?? const SizedBox(),
            )
          : null,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton,
      body: widget.child,
      drawer: widget.drawer == null ||
              !enableDrawer ||
              Layout.isDisplayDesktop(context) ||
              Layout.isDisplayTablet(context)
          ? null
          : Drawer(
              child: enableBackground
                  ? Stack(
                      children: [
                        if (widget.sideMenuBackground?.isNotEmpty ?? false)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: HexColor(widget.sideMenuBackground),
                          ),
                        if (widget.sideMenuBackgroundImage?.isNotEmpty ?? false)
                          FluxImage(
                            imageUrl: widget.sideMenuBackgroundImage!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.fill,
                          ),
                        if (widget.colorFilter?.isNotEmpty ?? false)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: HexColor(widget.colorFilter).withOpacity(
                              widget.filter?.toDouble() ?? 0.0,
                            ),
                          ),
                        if (widget.drawer != null) widget.drawer!,
                      ],
                    )
                  : widget.drawer,
            ),
    );
  }

  double mainScreenScale(String style, double value) {
    if (style == 'overlay') return 0.0;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.zoomConfig != null) {
      var zoomConfig = widget.zoomConfig ?? ZoomConfig();
      var backgroundImage =
          widget.sideMenuBackgroundImage ?? zoomConfig.backgroundImage;
      var color = (widget.sideMenuBackground?.isNotEmpty ?? false)
          ? HexColor(widget.sideMenuBackground)
          : null;
      var colorFilter = (widget.colorFilter?.isNotEmpty ?? false)
          ? HexColor(widget.colorFilter).withOpacity(
              widget.filter?.toDouble() ?? 0.0,
            )
          : null;
      return Stack(
        children: [
          if (color != null)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: color,
            ),
          if (backgroundImage?.isNotEmpty ?? false)
            FluxImage(
              imageUrl: backgroundImage!,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          if (colorFilter != null)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: colorFilter,
            ),
          Material(
            color: Theme.of(context)
                .colorScheme.background
                .withOpacity(enableBackground ? 0.0 : 1.0),
            child: ZoomDrawer(
              controller: _drawerController,
              style: getStyle(zoomConfig.style),
              showShadow: zoomConfig.enableShadow,
              mainScreenAbsorbPointer: false,
              angle: angle(zoomConfig.style, zoomConfig.angle.toDouble()),
              borderRadius: zoomConfig.borderRadius.toDouble(),
              mainScreenScale: mainScreenScale(
                  zoomConfig.style, zoomConfig.mainScreenScale.toDouble()),
              drawerShadowsBackgroundColor: Theme.of(context).primaryColor,
              isRtl: context.isRtl,
              slideWidth:
                  MediaQuery.of(context).size.width * zoomConfig.slideWidth,
              menuScreenWidth:
                  MediaQuery.of(context).size.width * zoomConfig.slideWidth -
                      zoomConfig.slideMargin,
              menuScreen: widget.drawer ?? const SizedBox(),
              mainScreen: ValueListenableBuilder<DrawerState>(
                valueListenable: _drawerController.stateNotifier ??
                    ValueNotifier(DrawerState.open),
                builder: (context, value, child) {
                  var isOpen = value != DrawerState.closed;
                  return GestureDetector(
                    onTap: isOpen
                        ? () {
                            _drawerController.close!();
                          }
                        : null,
                    child: AbsorbPointer(
                      absorbing: isOpen,
                      child: child,
                    ),
                  );
                },
                child: renderLayout(),
              ),
            ),
          ),
        ],
      );
    }
    return renderLayout(enableDrawer: true);
  }
}
