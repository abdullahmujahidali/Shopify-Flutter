part of '../config.dart';

/// Ads layout type for Admob and Facebook Ads
// ignore: camel_case_types
enum kAdType {
  googleBanner,
  googleInterstitial,
  googleReward,
  facebookBanner,
  facebookInterstitial,
  facebookNative,
  facebookNativeBanner,
}

Map get kAdConfig => Configurations.adConfig;
