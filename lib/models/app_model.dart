import 'dart:async';
import 'dart:convert' as convert;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/constants.dart';
import '../data/boxes.dart';
import '../modules/dynamic_layout/config/app_config.dart';
import '../services/index.dart';
import 'advertisement/index.dart' show AdvertisementConfig;
import 'cart/cart_model.dart';
import 'category/category_model.dart';
import 'entities/currency.dart';
import 'filter_attribute_model.dart';

class AppModel with ChangeNotifier {
  AppConfig? appConfig;
  AdvertisementConfig advertisement = const AdvertisementConfig();
  Map? deeplink;
  late bool isMultivendor;

  /// Loading State setting
  bool isLoading = true;
  bool isInit = false;

  /// Current and Payment settings
  String? currency;
  String? currencyCode;
  Map<String, dynamic> currencyRate = <String, dynamic>{};
  int? smallestUnitRate;

  /// Language Code
  String _langCode = kAdvanceConfig.defaultLanguage;

  String get langCode => _langCode;

  /// Theming values for light or dark theme mode
  ThemeMode? themeMode;

  bool get darkTheme => themeMode == ThemeMode.dark;

  set darkTheme(bool value) =>
      themeMode = value ? ThemeMode.dark : ThemeMode.light;

  ThemeConfig get themeConfig => darkTheme ? kDarkConfig : kLightConfig;

  /// The app will use mainColor from env.dart,
  /// or override it with mainColor from config JSON if found.
  String get mainColor {
    final configJsonMainColor = appConfig?.settings.mainColor;
    if (configJsonMainColor != null && configJsonMainColor.isNotEmpty) {
      return configJsonMainColor;
    }
    return themeConfig.mainColor;
  }

  /// Product and Category Layout setting
  List<String>? categories;
  List<Map>? remapCategories;
  Map? categoriesIcons;
  String categoryLayout = '';

  String get productListLayout => appConfig!.settings.productListLayout;

  double get ratioProductImage =>
      appConfig!.settings.ratioProductImage ??
      (kAdvanceConfig.ratioProductImage * 1.0);

  String get productDetailLayout =>
      appConfig!.settings.productDetail ?? kProductDetail.layout;

  kBlogLayout get blogDetailLayout => appConfig!.settings.blogDetail != null
      ? kBlogLayout.values.byName(appConfig!.settings.blogDetail!)
      : kAdvanceConfig.detailedBlogLayout;

  /// App Model Constructor
  AppModel([String? lang]) {
    _langCode = lang ?? kAdvanceConfig.defaultLanguage;

    advertisement = AdvertisementConfig.fromJson(adConfig: kAdConfig);
    isMultivendor = ServerConfig().typeName.isMultiVendor;
  }

  void _updateAndSaveDefaultLanguage(String? lang) {
    final prefLang = SettingsBox().languageCode;
    _langCode = prefLang != null && prefLang.isNotEmpty
        ? prefLang
        : lang ?? kAdvanceConfig.defaultLanguage;
    SettingsBox().languageCode = _langCode.split('-').first.toLowerCase();
  }

  /// Get persist config from Share Preference
  Future<bool> getPrefConfig({String? lang}) async {
    try {
      _updateAndSaveDefaultLanguage(lang);

      var defaultCurrency = kAdvanceConfig.defaultCurrency;

      darkTheme = SettingsBox().isDarkTheme ?? kDefaultDarkTheme;
      currency = SettingsBox().currency ?? defaultCurrency?.currencyDisplay;
      currencyCode =
          SettingsBox().currencyCode ?? defaultCurrency?.currencyCode;
      smallestUnitRate = _getCurrencyByCode(currencyCode)?.smallestUnitRate;
      isInit = true;
      await updateTheme(darkTheme);

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> changeLanguage(String languageCode, BuildContext context) async {
    try {
      _langCode = languageCode;
      SettingsBox().languageCode = _langCode;

      await loadAppConfig(isSwitched: true);
      await loadCurrency();
      eventBus.fire(const EventChangeLanguage());

      final categoryModel = Provider.of<CategoryModel>(context, listen: false);
      categoryModel.refreshCategoryList();
      unawaited(categoryModel.getCategories(
        lang: _langCode,
        sortingList: categories,
        categoryLayout: categoryLayout,
        remapCategories: remapCategories,
      ));
      unawaited(Provider.of<FilterAttributeModel>(context, listen: false)
          .getFilterAttributes());

      return true;
    } catch (err) {
      return false;
    }
  }

  Currency? _getCurrencyByCode(String? code) {
    final currencies = kAdvanceConfig.currencies;
    return currencies.firstWhereOrNull(
        (e) => e.currencyCode.toLowerCase() == code?.toLowerCase());
  }

  Future<void> changeCurrency(String? item, BuildContext context,
      {String? code}) async {
    try {
      Provider.of<CartModel>(context, listen: false)
          .changeCurrency(code ?? item);
      currency = item;
      currencyCode = code;
      SettingsBox().currencyCode = currencyCode;
      SettingsBox().currency = currency;
      smallestUnitRate = _getCurrencyByCode(currencyCode)?.smallestUnitRate;
      notifyListeners();
    } catch (error) {
      printLog('[changeCurrency] error: ${error.toString()}');
    }
  }

  Future<void> updateTheme(bool theme) async {
    try {
      darkTheme = theme;
      SettingsBox().isDarkTheme = theme;
      notifyListeners();
    } catch (error) {
      printLog('[updateTheme] error: ${error.toString()}');
    }
  }

  void loadStreamConfig(config) {
    appConfig = AppConfig.fromJson(config);
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCloudAppConfig(String url) async {
    /// Do not enable cache here because we need to get the latest config JSON.
    final appJson = await http.get(
      Uri.encodeFull(url).toUri()!,
      headers: {
        'Accept': 'application/json',
      },
    );
    appConfig = AppConfig.fromJson(
      convert.jsonDecode(
        convert.utf8.decode(appJson.bodyBytes),
      ),
    );
  }

  Future<AppConfig?> loadAppConfig(
      {isSwitched = false, Map<String, dynamic>? config}) async {
    isLoading = true;
    notifyListeners();

    var startTime = DateTime.now();

    if (_langCode == '') {
      _langCode = kAdvanceConfig.defaultLanguage;
    }

    try {
      if (!isInit || _langCode.isEmpty) {
        await getPrefConfig();
      }

      if (config != null) {
        appConfig = AppConfig.fromJson(config);
      } else {
        var loadAppConfigDone = false;

        /// load config from Notion
        if (ServerConfig().type == ConfigType.notion) {
          final appCfg = await Services().widget.onGetAppConfig(langCode);

          if (appCfg != null) {
            appConfig = appCfg;
            loadAppConfigDone = true;
          }
        }

        if (loadAppConfigDone == false) {
          /// we only apply the http config if isUpdated = false, not using switching language
          // ignore: prefer_contains
          if (kAppConfig.indexOf('http') != -1) {
            // load on cloud config and update on air
            var path = kAppConfig;
            if (path.contains('.json')) {
              path = path.substring(0, path.lastIndexOf('/'));
              path += '/config_$langCode.json';
            }
            try {
              await fetchCloudAppConfig(path);
            } catch (_) {
              /// In case config_$langCode.json is not found,
              /// load user's original config URL.
              printLog(
                  '🚑 Config at $path not found. Loading from $kAppConfig instead.');
              await fetchCloudAppConfig(kAppConfig);
            }
          } else {
            // load local config
            var path = 'lib/config/config_$langCode.json';
            try {
              final appJson = await rootBundle.loadString(path);
              appConfig = AppConfig.fromJson(convert.jsonDecode(appJson));
            } catch (e) {
              final appJson = await rootBundle.loadString(kAppConfig);
              appConfig = AppConfig.fromJson(convert.jsonDecode(appJson));
            }
          }
        }
      }

      /// apply App Caching if isCaching is enable
      /// not use for Fluxbuilder
      if (!ServerConfig().isBuilder) {
        await Services().widget.onLoadedAppConfig(langCode, (configCache) {
          appConfig = AppConfig.fromJson(configCache);
        });
      }

      /// Load categories config for the Tabbar menu
      /// User to sort the category Setting
      final categoryTab = appConfig!.tabBar.toList().firstWhereOrNull(
          (e) => e.layout == 'category' || e.layout == 'vendors');
      if (categoryTab != null) {
        if (categoryTab.categories != null) {
          categories = List<String>.from(categoryTab.categories ?? []);
          if (ServerConfig().isShopify) {
            /// Support old type category (base64) work with new API
            /// Old type is base64, new type is url like gid://shopify/Collection/123456789
            categories = categories?.map(_parseShopifyCategories).toList();
          }
        }
        if (categoryTab.images != null) {
          categoriesIcons =
              categoryTab.images is Map ? Map.from(categoryTab.images) : null;
        }
        if (categoryTab.remapCategories != null) {
          remapCategories = categoryTab.remapCategories;

          /// Support old type category (base64) work with new API
          /// Old type is base64, new type is url like gid://shopify/Collection/123456789
          if (ServerConfig().isShopify) {
            remapCategories = remapCategories?.map((e) {
              for (var key in ['parent', 'category']) {
                if (e[key] != null) {
                  e[key] = _parseShopifyCategories(e[key]);
                }
              }
              return e;
            }).toList();
          }
        }
        categoryLayout = categoryTab.categoryLayout;
      }

      if (appConfig?.settings.tabBarConfig.alwaysShowTabBar != null) {
        Configurations().setAlwaysShowTabBar(
            appConfig?.settings.tabBarConfig.alwaysShowTabBar ?? false);
      }
      isLoading = false;

      notifyListeners();
      printLog('[Debug] Finish Load AppConfig', startTime);
      eventBus.fire(const EventLoadedAppConfig());
      return appConfig;
    } catch (err, trace) {
      printLog('🔴 AppConfig JSON loading error');
      printError(err, trace);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> loadCurrency({Function(Map<String, dynamic>)? callback}) async {
    /// Load the Rate for Product Currency
    final rates = await Services().api.getCurrencyRate();
    if (rates != null) {
      currencyRate = rates;
      callback?.call(rates);
    }
  }

  void updateProductListLayout(layout) {
    appConfig!.settings =
        appConfig!.settings.copyWith(productListLayout: layout);
    notifyListeners();
  }

  void raiseNotify() {
    notifyListeners();
  }

  String _parseShopifyCategories(String categoryId) {
    try {
      return EncodeUtils.decode(categoryId);
    } on FormatException catch (_) {
      return categoryId;
    }
  }
}
