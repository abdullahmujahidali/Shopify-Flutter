import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../common/constants.dart';
import '../../../common/tools/tools.dart';
import '../../../services/service_config.dart';

class Layout {
  /// Product or Blog Layout styles
  static const String columns = 'columns';
  static const String twoColumn = 'twoColumn';
  static const String threeColumn = 'threeColumn';
  static const String fourColumn = 'fourColumn';
  static const String recentView = 'recentView';
  static const String saleOff = 'saleOff';
  static const String card = 'card';
  static const String listTile = 'listTile';
  static const String list = 'list';
  static const String pinterest = 'pinterest';
  static const String columnsWithFilter = 'columnsWithFilter';
  static const String menu = 'menu';
  static const String staggered = 'staggered';
  static const String simpleList = 'simpleList';
  static const String simpleVerticalListItems = 'simpleVerticalListItems';
  static const String largeCard = 'largeCard';
  static const String largeCardHorizontalListItems =
      'largeCardHorizontalListItems';
  static const String sliderList = 'sliderList';
  static const String sliderItem = 'sliderItem';

  /// Other Type Layout styles
  static const String logo = 'logo';
  static const String brand = 'brand';
  static const String story = 'story';
  static const String video = 'video';
  static const String blog = 'blog';
  static const String category = 'category';
  static const String featuredVendors = 'featuredVendors';
  static const String geoSearch = 'geoSearch';

  /// Header Style
  static const String headerSearch = 'header_search';
  static const String headerText = 'header_text';

  /// Banner Layout style
  static const String bannerImage = 'bannerImage';
  static const String bannerAnimated = 'bannerAnimated';

  /// Common Layout style
  static const String divider = 'divider';
  static const String spacer = 'spacer';
  static const String button = 'button';
  static const String testimonial = 'testimonial';
  static const String sliderTestimonial = 'sliderTestimonial';
  static const String instagramStory = 'instagramStory';
  static const String tiktokVideos = 'tiktokVideos';

  /// Advance Tabbar Menu (combine multi dynamic layout + tabMenu: true)
  static const String tabMenu = 'tabMenu';

  /// Advance scrollable layout (combine 2 dynamic layout + scrollLayout: true)
  static const String scrollable = 'scrollable';

  static bool isDisplayDesktop(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    return !isMobile &&
        (deviceType == DeviceScreenType.desktop ||
            (deviceType == DeviceScreenType.tablet &&
                MediaQuery.of(context).orientation == Orientation.landscape));
  }

  static bool isDisplayTablet(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    return isMobile &&
        ((deviceType == DeviceScreenType.desktop ||
                deviceType == DeviceScreenType.tablet) &&
            MediaQuery.of(context).orientation == Orientation.landscape);
  }

  static double buildProductWidth({layout, required screenWidth}) {
    switch (layout) {
      case twoColumn:
        return screenWidth * 0.5;
      case threeColumn:
        return screenWidth / 3;
      case fourColumn:
        return screenWidth / 4;
      case recentView:
        return screenWidth * 0.35;
      case saleOff:
        return screenWidth * 0.35;
      case card:
      case listTile:
      default:
        return screenWidth - 10;
    }
  }

  // it does not adapt with large screen
  static double buildProductMaxWidth({context, layout}) {
    final isTablet =
        context != null ? Tools.isTablet(MediaQuery.of(context)) : false;
    double width;
    switch (layout) {
      case twoColumn:
        width = 300;
        break;
      case threeColumn:
        width = 200;
        break;
      case fourColumn:
        width = 150;
        break;
      case recentView:
        width = 200;
        break;
      case saleOff:
        width = 200;
        break;
      case card:
      case listTile:
      default:
        return kMaxProductWidth;
    }
    return isTablet ? width * 2 : width;
  }

  // it does not adapt with large screen
  static double buildProductHeight({layout, defaultHeight}) {
    switch (layout) {
      case Layout.twoColumn:
      case Layout.threeColumn:
      case Layout.fourColumn:
      case Layout.recentView:
      case Layout.saleOff:
        return 220;
      case Layout.card:
      case Layout.listTile:
      default:
        return defaultHeight;
    }
  }

  static double getColumnCount({layout}) {
    switch (layout) {
      case Layout.twoColumn:
        return 2;
      case Layout.fourColumn:
        return 4;
      case Layout.threeColumn:
      default:
        return 3;
    }
  }
}

class Helper {
  /// Convert String to double
  /// use for mapping JSON purpose and special logic, please consider twice when refactoring 🔥
  static double? formatDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null || value == '') {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    return double.tryParse(value) ?? defaultValue;
  }

  /// Convert String to int
  /// use for mapping JSON purpose and special logic, please consider twice when refactoring 🔥
  static int? formatInt([dynamic value = '0', int? defaultValue]) {
    if (value == null || value == '') {
      return defaultValue;
    }

    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  static BoxFit boxFit(
    String? fit, {
    BoxFit? defaultValue,
  }) {
    switch (fit) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'scaleDown':
        return BoxFit.scaleDown;
      case 'cover':
        return BoxFit.cover;
      default:
        return defaultValue ?? BoxFit.fitWidth;
    }
  }

  /// check tablet screen
  static bool isTablet(MediaQueryData query) {
    if (ServerConfig().isBuilder) {
      return false;
    }

    if (kIsWeb) {
      return true;
    }

    if (UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      return false;
    }

    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static String? compactNumberFormat(
    dynamic value, {
    double defaultValue = 0.0,
  }) {
    var number = value.toString();

    var doubleNumber = double.tryParse(number) ?? defaultValue;

    if (doubleNumber < 100000) {
      return doubleNumber.toStringAsFixed(1);
    }

    var numberFormat = NumberFormat.compact();

    return numberFormat.format(doubleNumber);
  }
}
