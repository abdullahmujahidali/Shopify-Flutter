part of '../config.dart';

/// the welcome screen data
List get onBoardingData => Configurations.onBoardingData;
List get vendorOnBoarding => Configurations.vendorOnBoardingData;

bool get kEnableOnBoarding => Configurations.enableOnBoarding && onBoardingData.isNotEmpty;