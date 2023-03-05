import 'package:flutter/cupertino.dart';
import 'package:inspireui/inspireui.dart';

import '../frameworks/frameworks.dart';
import '../models/booking/booking_model.dart';
import '../models/index.dart';
import 'audio/audio_manager.dart';
import 'base_services.dart';

enum ConfigType {
  opencart,
  magento,
  shopify,
  presta,
  strapi,
  dokan,
  wcfm,
  listeo,
  listpro,
  mylisting,
  vendorAdmin,
  wordpress,
  delivery,
  woo,
  notion,
  bigCommerce
}

class ServerConfig {
  late ConfigType type;
  late String url;
  String? blog;
  late String consumerKey;
  late String consumerSecret;
  String? addListingUrl;
  String? forgetPassword;
  String? accessToken;
  bool? isCacheImage;
  bool isBuilder = false;

  /// Platform and Type are different
  /// Platform can be woo, wcfm, dokan
  late String platform;

  static final ServerConfig _instance = ServerConfig._internal();

  factory ServerConfig() => _instance;

  ServerConfig._internal();

  String get typeName => type.name;

  bool get isListingType {
    return [
      ConfigType.listeo,
      ConfigType.listpro,
      ConfigType.mylisting,
    ].contains(type);
  }

  bool get isWooType {
    return [
      ConfigType.listeo,
      ConfigType.listpro,
      ConfigType.mylisting,
      ConfigType.dokan,
      ConfigType.wcfm,
      ConfigType.woo,
    ].contains(type);
  }

  bool get isStrapi {
    return typeName == 'strapi';
  }

  bool get isNotion {
    return typeName == 'notion';
  }

  bool get isBigCommerce {
    return typeName == 'bigCommerce';
  }

  bool get isShopify => typeName == 'shopify';

  bool get isWordPress {
    return typeName == 'wordpress';
  }

  bool get isListProType => typeName == 'listpro';

  bool get isListeoType => typeName == 'listeo';

  bool get isMyListingType => typeName == 'mylisting';

  /// Another framework use the UI of Wordpress blog
  bool get isUseWordPressBlog {
    return typeName != 'wordpress' && blog != null;
  }

  bool get isPayPluginSupported {
    return [
      ConfigType.woo,
      ConfigType.wcfm,
      ConfigType.dokan,
      ConfigType.presta,
      ConfigType.opencart,
      ConfigType.notion,
      ConfigType.magento,
      ConfigType.strapi,
    ].contains(type);
  }

  bool isVendorManagerType() {
    return ConfigType.vendorAdmin == type;
  }

  bool isVendorType() {
    return typeName == 'wcfm' || typeName == 'dokan';
  }

  bool get isSupportDeleteAccount {
    return true;
  }

  void setConfig(config) {
    type = ConfigType.values.firstWhere(
      (element) => element.name == config['type']?.toString().trim(),
      orElse: () => ConfigType.woo,
    );
    url = config['url']?.toString().trim() ?? '';
    blog = config['blog'];
    consumerKey = config['consumerKey'] ?? '';
    consumerSecret = config['consumerSecret'] ?? '';
    forgetPassword = config['forgetPassword'];
    accessToken = config['accessToken'];
    isCacheImage = config['isCacheImage'];
    isBuilder = config['isBuilder'] ?? false;
    platform = config['platform'] ?? 'wcfm';
    addListingUrl = config['addListingUrl'];
  }
}

mixin ConfigMixin {
  late BaseServices api;
  late BaseFrameworks widget;
  bool init = false;

  /// mock services for FluxBuilder
  void configBase({
    required BaseServices apiServices,
    required appConfig,
    required widgetServices,
  }) {
    setAppConfig(appConfig);
    api = apiServices;
    widget = widgetServices;
    init = true;
  }

  void configOpencart(appConfig) {}

  void configMagento(appConfig) {}

  void configShopify(appConfig) {}

  void configPrestashop(appConfig) {}

  void configTrapi(appConfig) {}

  void configDokan(appConfig) {}

  void configWCFM(appConfig) {}

  void configWoo(appConfig) {}

  void configListing(appConfig) {}

  void configVendorAdmin(appConfig) {}

  void configWordPress(appConfig) {}

  void configDelivery(appConfig) {}

  void configNotion(appConfig) {}

  void configBigCommerce(appConfig) {}

  void configPOS(appConfig) {}

  void setAppConfig(appConfig) {
    ServerConfig().setConfig(appConfig);
    CartInject().init(appConfig);

    printLog('[🌍appConfig] ${appConfig['type']} $appConfig');

    switch (appConfig['type']) {
      case 'opencart':
        configOpencart(appConfig);
        break;
      case 'magento':
        configMagento(appConfig);
        break;
      case 'shopify':
        configShopify(appConfig);
        break;
      case 'presta':
        configPrestashop(appConfig);
        break;
      case 'strapi':
        configTrapi(appConfig);
        break;
      case 'dokan':
        configDokan(appConfig);
        break;
      case 'wcfm':
        configWCFM(appConfig);
        break;
      case 'listeo':
        configListing(appConfig);
        break;
      case 'listpro':
        configListing(appConfig);
        break;
      case 'mylisting':
        configListing(appConfig);
        break;
      case 'vendorAdmin':
        configVendorAdmin(appConfig);
        break;
      case 'delivery':
        configDelivery(appConfig);
        break;
      case 'wordpress':
        configWordPress(appConfig);
        break;
      case 'notion':
        configNotion(appConfig);
        break;
      case 'bigCommerce':
        configBigCommerce(appConfig);
        break;
      case 'pos':
        configPOS(appConfig);
        break;
      case 'woo':
      default:
        configWoo(appConfig);
        break;
    }
  }

  /// Empty Widget feature
  Widget getBookingLayout({
    required Product product,
    Function(BookingModel)? onCallBack,
    bool wrapSliver = true,
  }) =>
      const SliverToBoxAdapter(
        child: SizedBox(),
      );

  /// get Empty Vendor app
  Widget getVendorAdminApp({languageCode, user, isFromMV}) => const SizedBox();

  /// get Empty Delivery app
  Widget getDeliveryApp({languageCode, user, isFromMV}) => const SizedBox();

  dynamic getVendorRoute(settings) => {};

  /// Empty Module Audio
  Widget getAudioWidget() => const SizedBox();

  AudioManager getAudioService() => AudioServiceEmpty();

  void playMediaItem(BuildContext context, FluxMediaItem mediaItem) {}

  void addMediaItemToPlaylist(BuildContext context, FluxMediaItem mediaItem) {}

  void addBlogAudioToPlaylist(BuildContext context, Blog blog) {}

  Widget renderAudioPlaylistScreen() => const SizedBox();

  Widget getAudioBlogCard(
    Blog blog, {
    ValueChanged<Blog>? addAll,
    ValueChanged<FluxMediaItem>? addItem,
    ValueChanged<FluxMediaItem>? playItem,
  }) =>
      const SizedBox();

  Widget renderWalletPayPartialPayment() => const SizedBox();

  Widget renderCheckoutWalletInfo() => const SizedBox();

  Widget renderWalletPaymentMethodItem(PaymentMethod paymentMethod,
          Function(String? p1) onSelected, String? selectedId) =>
      const SizedBox();

  dynamic getWalletRoutesWithSettings(RouteSettings settings) => {};

  dynamic getWalletTransaction(String cookie) => null;

  dynamic getMembershipUltimateRoutesWithSettings(RouteSettings settings) => {};

  dynamic getPaidMembershipProRoutesWithSettings(RouteSettings settings) => {};

  dynamic getDigitsMobileLoginRoutesWithSettings(RouteSettings settings) => {};

  dynamic getPOSRoutesWithSettings(RouteSettings settings) => {};

  void doIAPPayment(
          BuildContext context,
          Product product,
          ProductVariation? productVariation,
          int quantity,
          Map<String?, String?> mapAttribute,
          Function(bool) onLoading,
          VoidCallback onAddToCart) =>
      onAddToCart();

  void iapDispose() => {};
}

extension ConfigMixinExt on String {
  bool get isWoo => this == 'woo';

  bool get isWcfm => this == 'wcfm';

  bool get isDokan => this == 'dokan';

  bool get isMultiVendor => ['wcfm', 'dokan'].contains(this);

  bool get isPos => this == 'pos';
}
