import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../screens/base_screen.dart';
import 'animated_splash.dart';
import 'flare_splash_screen.dart';
import 'lottie_splashscreen.dart';
import 'rive_splashscreen.dart';
import 'static_splashscreen.dart';

class SplashScreenIndex extends StatelessWidget {
  final Function actionDone;
  final String splashScreenType;
  final String imageUrl;
  final int duration;

  const SplashScreenIndex({
    Key? key,
    required this.actionDone,
    required this.imageUrl,
    this.splashScreenType = SplashScreenTypeConstants.static,
    this.duration = 2000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kSplashScreen['enable'] ?? true) {
      final boxFit = ImageTools.boxFit(
        kSplashScreen['boxFit'],
        defaultValue: BoxFit.contain,
      );
      final backgroundColor =
          HexColor(kSplashScreen['backgroundColor'] ?? '#ffffff');
      final paddingTop =
          Helper.formatDouble(kSplashScreen['paddingTop']) ?? 0.0;
      final paddingBottom =
          Helper.formatDouble(kSplashScreen['paddingBottom']) ?? 0.0;
      final paddingLeft =
          Helper.formatDouble(kSplashScreen['paddingLeft']) ?? 0.0;
      final paddingRight =
          Helper.formatDouble(kSplashScreen['paddingRight']) ?? 0.0;
      switch (splashScreenType) {
        case SplashScreenTypeConstants.rive:
          var animationName = kSplashScreen['animationName'];
          return RiveSplashScreen(
            onSuccess: actionDone,
            imageUrl: imageUrl,
            animationName: animationName,
            duration: duration,
            backgroundColor: backgroundColor,
            boxFit: boxFit,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
          );
        case SplashScreenTypeConstants.flare:
          return SplashScreen.navigate(
            name: imageUrl,
            startAnimation: kSplashScreen['animationName'],
            backgroundColor: backgroundColor,
            boxFit: boxFit,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
            next: actionDone,
            until: () => Future.delayed(Duration(milliseconds: duration)),
          );
        case SplashScreenTypeConstants.lottie:
          return LottieSplashScreen(
            imageUrl: imageUrl,
            onSuccess: actionDone,
            duration: duration,
            backgroundColor: backgroundColor,
            boxFit: boxFit,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
          );
        case SplashScreenTypeConstants.fadeIn:
        case SplashScreenTypeConstants.topDown:
        case SplashScreenTypeConstants.zoomIn:
        case SplashScreenTypeConstants.zoomOut:
          return AnimatedSplash(
            imagePath: imageUrl,
            animationEffect: splashScreenType,
            next: actionDone,
            duration: duration,
            backgroundColor: backgroundColor,
            boxFit: boxFit,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
          );
        case SplashScreenTypeConstants.static:
        default:
          return StaticSplashScreen(
            imagePath: imageUrl,
            onNextScreen: actionDone,
            duration: duration,
            backgroundColor: backgroundColor,
            boxFit: boxFit,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
          );
      }
    } else {
      return _EmptySplashScreen(
        onNextScreen: actionDone,
      );
    }
  }
}

class _EmptySplashScreen extends StatefulWidget {
  final Function? onNextScreen;

  const _EmptySplashScreen({Key? key, this.onNextScreen}) : super(key: key);

  @override
  _EmptySplashScreenState createState() => _EmptySplashScreenState();
}

class _EmptySplashScreenState extends BaseScreen<_EmptySplashScreen> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = eventBus.on<EventLoadedAppConfig>().listen(listener);
    super.initState();
  }

  void listener(_) {
    if (mounted) {
      widget.onNextScreen?.call();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: kLoadingWidget(context),
    );
  }
}
