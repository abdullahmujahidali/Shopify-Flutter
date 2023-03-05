import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'common/config.dart';
import 'common/constants.dart';
import 'common/tools.dart';
import 'data/boxes.dart';
import 'models/index.dart'
    show
        AppModel,
        CartModel,
        CategoryModel,
        FilterAttributeModel,
        FilterTagModel,
        ListingLocationModel,
        TagModel;
import 'modules/dynamic_layout/config/app_config.dart';
import 'screens/app_error.dart';
import 'screens/base_screen.dart';
import 'screens/blog/models/list_blog_model.dart';
import 'services/index.dart';
import 'widgets/common/splash_screen.dart';

class AppInit extends StatefulWidget {
  const AppInit();

  @override
  State<AppInit> createState() => _AppInitState();
}

class _AppInitState extends BaseScreen<AppInit> {
  /// It is true if the app is initialized
  bool isLoggedIn = false;
  bool hasLoadedData = false;
  bool hasLoadedSplash = false;

  late AppConfig? appConfig;

  AppModel get appModel => Provider.of<AppModel>(context, listen: false);

  Future<void> loadInitData() async {
    try {
      printLog('[AppState] Init Data 💫');
      isLoggedIn = UserBox().isLoggedIn;

      /// set the server config at first loading
      /// Load App model config
      if (ServerConfig().isBuilder) {
        Services().setAppConfig(serverConfig);
      }

      /// Load layout config
      appConfig = await appModel.loadAppConfig(config: kLayoutConfig);

      Future.delayed(Duration.zero, () {
        /// Load more Category/Blog/Attribute Model beforehand
        final lang = appModel.langCode;

        /// Request Categories
        Provider.of<CategoryModel>(context, listen: false).getCategories(
          lang: lang,
          sortingList: appModel.categories,
          categoryLayout: appModel.categoryLayout,
          remapCategories: appModel.remapCategories,
        );
        hasLoadedData = true;
        if (hasLoadedSplash) {
          goToNextScreen();
        }
      });

      /// Request more Async data which is not use on home screen
      Future.delayed(
        Duration.zero,
        () {
          Provider.of<TagModel>(context, listen: false).getTags();

          Provider.of<ListBlogModel>(context, listen: false).getBlogs();

          Provider.of<FilterTagModel>(context, listen: false).getFilterTags();

          Provider.of<FilterAttributeModel>(context, listen: false)
              .getFilterAttributes();

          final cartModel = Provider.of<CartModel>(context, listen: false);
          Provider.of<AppModel>(context, listen: false).loadCurrency(
              callback: (currencyRate) {
            cartModel.changeCurrencyRates(currencyRate);
          });

          if (ServerConfig().isListingType) {
            Provider.of<ListingLocationModel>(context, listen: false)
                .getLocations();
          }

          /// init Facebook & Google Ads
          Services()
              .advertisement
              .initAdvertise(context.read<AppModel>().advertisement);
        },
      );

      printLog('[AppState] InitData Finish');
    } catch (err, trace) {
      printError(err, trace);
    }
  }

  void goToNextScreen() async {
    /// Update status bar color on Android
    if (isMobile) {
      SystemChrome.setSystemUIOverlayStyle((appModel.darkTheme)
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.black,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.black,
            ));
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }

    if (appConfig == null) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AppError(),
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

    if (!kIsWeb && appConfig != null) {
      if (kEnableOnBoarding &&
          (!SettingsBox().hasFinishedOnboarding ||
              !kAdvanceConfig.onBoardOnlyShowFirstTime)) {
        await Navigator.of(context).pushReplacementNamed(RouteList.onBoarding);
        return;
      }

      if (!SettingsBox().hasFinishedOnboarding) {
        if (kAdvanceConfig.showRequestNotification) {
          await Navigator.of(context)
              .pushReplacementNamed(RouteList.notificationRequest);
          return;
        }
        await injector<NotificationService>().requestPermission();
        SettingsBox().hasFinishedOnboarding = true;
      }
    }

    if (Services().widget.isRequiredLogin && !isLoggedIn) {
      NavigateTools.navigateToLogin(
        context,
        replacement: true,
      );
      return;
    }

    if (kAdvanceConfig.gdprConfig.showPrivacyPolicyFirstTime &&
        !UserBox().hasAgreedPrivacy) {
      await Navigator.of(context).pushReplacementNamed(RouteList.privacyTerms);
      return;
    }

    await Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
  }

  void checkToShowNextScreen() {
    /// If the config was load complete then navigate to Dashboard
    hasLoadedSplash = true;
    if (hasLoadedData) {
      goToNextScreen();
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadInitData();
  }

  @override
  Widget build(BuildContext context) {
    var splashScreenType = kSplashScreen['type'];
    dynamic splashScreenImage = kSplashScreen['image'];
    var duration = kSplashScreen['duration'] ?? 2000;
    return SplashScreenIndex(
      imageUrl: splashScreenImage,
      splashScreenType: splashScreenType,
      actionDone: checkToShowNextScreen,
      duration: duration,
    );
  }
}
