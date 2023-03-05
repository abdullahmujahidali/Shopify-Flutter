import 'package:flutter/material.dart';

import 'flare_loading.dart';

class SplashScreen extends StatelessWidget {
  final String? name;
  final Function? next;
  final Function(dynamic data)? onSuccess;
  final Function(dynamic error, dynamic stacktrace)? onError;
  final double? width;
  final double? height;
  final Alignment alignment;
  final Future<void> Function()? until;
  final String? loopAnimation;
  final String? endAnimation;
  final String? startAnimation;
  final RouteTransitionsBuilder? transitionsBuilder;
  final bool? isLoading;
  final Color backgroundColor;
  final BoxFit boxFit;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  factory SplashScreen.callback({
    required String name,
    required Function(dynamic data) onSuccess,
    required Function(dynamic error, dynamic stacktrace) onError,
    Key? key,
    Future Function()? until,
    bool? isLoading,
    String? loopAnimation,
    Alignment alignment = Alignment.center,
    double? width,
    double? height,
    String? endAnimation,
    RouteTransitionsBuilder? transitionsBuilder,
    String? startAnimation,
    BoxFit boxFit = BoxFit.contain,
    Color backgroundColor = Colors.white,
    double paddingTop = 0.0,
    double paddingBottom = 0.0,
    double paddingLeft = 0.0,
    double paddingRight = 0.0,
  }) {
    return SplashScreen(
      name,
      null,
      until: until,
      loopAnimation: loopAnimation,
      startAnimation: startAnimation,
      isLoading: isLoading,
      endAnimation: endAnimation,
      width: width,
      height: height,
      transitionsBuilder: transitionsBuilder,
      onSuccess: onSuccess,
      onError: onError,
      alignment: alignment,
      backgroundColor: backgroundColor,
      boxFit: boxFit,
      paddingTop: paddingTop,
      paddingBottom: paddingBottom,
      paddingLeft: paddingLeft,
      paddingRight: paddingRight,
    );
  }

  factory SplashScreen.navigate({
    required String? name,
    required Function next,
    Key? key,
    bool? isLoading,
    Future Function()? until,
    String? loopAnimation,
    Alignment alignment = Alignment.center,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
    String? endAnimation,
    RouteTransitionsBuilder? transitionsBuilder,
    String? startAnimation,
    BoxFit boxFit = BoxFit.contain,
    Color backgroundColor = Colors.white,
    double paddingTop = 0.0,
    double paddingBottom = 0.0,
    double paddingLeft = 0.0,
    double paddingRight = 0.0,
  }) {
    return SplashScreen(
      name,
      next,
      until: until,
      isLoading: isLoading,
      loopAnimation: loopAnimation,
      startAnimation: startAnimation,
      endAnimation: endAnimation,
      width: width,
      height: height,
      transitionsBuilder: transitionsBuilder,
      onSuccess: (_) {},
      onError: (_, __) {},
      alignment: alignment,
      backgroundColor: backgroundColor,
      boxFit: boxFit,
      paddingTop: paddingTop,
      paddingBottom: paddingBottom,
      paddingLeft: paddingLeft,
      paddingRight: paddingRight,
    );
  }

  const SplashScreen(
    this.name,
    this.next, {
    this.loopAnimation,
    Key? key,
    this.isLoading,
    this.until,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.transitionsBuilder,
    this.endAnimation,
    this.startAnimation,
    this.onSuccess,
    this.onError,
    this.backgroundColor = Colors.white,
    this.boxFit = BoxFit.contain,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  })  : assert(!(isLoading != null && until != null),
            'isLoading and until are exclusive, pick one ;)'),
        assert(!(isLoading == null && until == null),
            'isLoading and until are null, pick one ;)'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: FlareLoading(
        endAnimation: endAnimation,
        startAnimation: startAnimation,
        loopAnimation: loopAnimation,
        width: width,
        height: height,
        fit: boxFit,
        onSuccess: (data) {
          _goToNext(context, data);
        },
        onError: onError!,
        name: name!,
        alignment: alignment,
        until: until,
        isLoading: isLoading,
      ),
    );
  }

  void _goToNext(BuildContext context, data) {
    if (next == null) {
      onSuccess!(data);
    } else {
      next!();
    }
  }
}
