import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'fonts.dart';

ThemeData buildDarkTheme(String? language, [fontFamily, fontHeader]) {
  final base = ThemeData.dark();
  return base.copyWith(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    textTheme:
        buildTextTheme(base.textTheme, language, fontFamily, fontHeader).apply(
      displayColor: kLightBG,
      bodyColor: kLightBG,
    ),
    primaryTextTheme:
        buildTextTheme(base.primaryTextTheme, language, fontFamily, fontHeader)
            .apply(
      displayColor: kLightBG,
      bodyColor: kLightBG,
    ),
    canvasColor: kDarkBG,
    cardColor: kDarkBgLight,
    brightness: Brightness.dark,
    primaryColor: kDarkBG,
    primaryColorLight: kDarkBgLight,
    scaffoldBackgroundColor: kDarkBG,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
        color: kDarkBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(
        color: kDarkAccent,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    buttonTheme: ButtonThemeData(
        colorScheme: kColorScheme.copyWith(onPrimary: kLightBG)),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: 13),
      unselectedLabelStyle: TextStyle(fontSize: 13),
    ),
    dialogBackgroundColor: kDarkBG, colorScheme: kDarkColorScheme.copyWith(
      secondary: kDarkAccent,
    ).copyWith(background: kDarkBG),
  );
}
