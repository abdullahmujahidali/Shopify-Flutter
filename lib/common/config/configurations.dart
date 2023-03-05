part of '../config.dart';

class Configurations {
  static String _environment = DefaultConfig.environment;
  static String _baseUrl = DefaultConfig.baseUrl;
  static String _appName = DefaultConfig.appName;
  static bool _enableCrashAnalytics = DefaultConfig.enableCrashAnalytics;
  static bool _enableRemoteConfigFirebase =
      DefaultConfig.enableRemoteConfigFirebase;
  static bool _enableFirebaseAnalytics = DefaultConfig.enableFirebaseAnalytics;
  static String _defaultLanguage = DefaultConfig.defaultLanguage;
  static Map _serverConfig = DefaultConfig.serverConfig;
  static String _appConfig = DefaultConfig.appConfig;
  static bool _defaultDarkTheme = DefaultConfig.defaultDarkTheme;
  static String _countryCodeDefault = DefaultConfig.countryCodeDefault;
  static String _dialCodeDefault = DefaultConfig.dialCodeDefault;
  static String _nameDefault = DefaultConfig.nameDefault;
  static Map _advanceConfig = DefaultConfig.advanceConfig;
  static Map _storeIdentifier = DefaultConfig.storeIdentifier;
  static List _defaultSettings = DefaultConfig.defaultSettings;
  static Map _loginSetting = DefaultConfig.loginSetting;
  static Map _defaultDrawer = DefaultConfig.defaultDrawer;
  static Map _oneSignalKey = DefaultConfig.oneSignalKey;
  static List _onBoardingData = DefaultConfig.onBoardingData;
  static List _vendorOnBoardingData = DefaultConfig.vendorOnBoardingData;
  static Map _productDetail = DefaultConfig.productDetail;
  static Map _blogDetail = DefaultConfig.blogDetail;
  static Map _productVariantLayout = DefaultConfig.productVariantLayout;
  static Map _adConfig = DefaultConfig.adConfig;
  static Map _firebaseDynamicLinkConfig =
      DefaultConfig.firebaseDynamicLinkConfig;
  static List<Map> _languagesInfo = DefaultConfig.languagesInfo;
  static Map _paymentConfig = DefaultConfig.paymentConfig;
  static Map _payments = DefaultConfig.payments;
  static Map _stripeConfig = DefaultConfig.stripeConfig;
  static Map _paypalConfig = DefaultConfig.paypalConfig;
  static Map _razorpayConfig = DefaultConfig.razorpayConfig;
  static Map _tapConfig = DefaultConfig.tapConfig;
  static Map _payTmConfig = DefaultConfig.payTmConfig;
  static Map _payStackConfig = DefaultConfig.payStackConfig;
  static Map _flutterwaveConfig = DefaultConfig.flutterwaveConfig;
  static Map _myFatoorahConfig = DefaultConfig.myFatoorahConfig;
  static Map _mercadoPagoConfig = DefaultConfig.mercadoPagoConfig;
  static Map _inAppPurchaseConfig = DefaultConfig.inAppPurchaseConfig;
  static Map _afterShip = DefaultConfig.afterShip;
  static Map _productAddons = DefaultConfig.productAddons;
  static Map _cartDetail = DefaultConfig.cartDetail;
  static Map _productVariantLanguage = DefaultConfig.productVariantLanguage;
  static Map _saleOffProduct = DefaultConfig.saleOffProduct;
  static int _excludedCategory = DefaultConfig.excludedCategory;
  static bool _notStrictVisibleVariant = DefaultConfig.notStrictVisibleVariant;
  static Map _configChat = DefaultConfig.configChat;
  static List<Map> _smartChat = DefaultConfig.smartChat;
  static String _adminEmail = DefaultConfig.adminEmail;
  static String _adminName = DefaultConfig.adminName;
  static VendorConfig _vendorConfig =
      VendorConfig.fromJson(DefaultConfig.vendorConfig);
  static List<AddressFieldConfig> _addressFields = DefaultConfig.addressFields;
  static List _defaultCountryShipping = DefaultConfig.defaultCountryShipping;
  static Map? _loadingIcon = DefaultConfig.loadingIcon;
  static Map _productCard = DefaultConfig.productCard;
  static Map _loginSMSConstants = DefaultConfig.loginSMSConstants;
  static PhoneNumberConfig _phoneNumberConfig =
      PhoneNumberConfig.fromJson(DefaultConfig.phoneNumberConfig);
  static Map _darkConfig = DefaultConfig.darkConfig;
  static Map _lightConfig = DefaultConfig.lightConfig;
  static String _version = DefaultConfig.version;
  static Map _subGeneralSetting = DefaultConfig.subGeneralSetting;
  static Map _splashScreen = DefaultConfig.splashScreen;
  static Map _colorOverrideConfig = DefaultConfig.colorOverrideConfig;
  static GoogleApiKeyConfig _googleApiKey = DefaultConfig.googleApiKey;
  static bool _enableOnBoarding = DefaultConfig.enableOnBoarding;
  static Map? _managerConfig;
  static Map? _deliveryConfig;
  static Map? _salesiqConfig;

  /// only support firebase remote config
  static Map<String, dynamic>? _layoutDesign;

  static String get environments => _environment;

  static String get version => _version;

  static String get baseUrl => _baseUrl;

  static String get appName => _appName;

  static bool get enableCrashAnalytics => _enableCrashAnalytics;

  static bool get enableRemoteConfigFirebase => _enableRemoteConfigFirebase;

  static bool get enableFirebaseAnalytics => _enableFirebaseAnalytics;

  static String get defaultLanguage => _defaultLanguage;

  static Map get serverConfig => _serverConfig;

  static String get appConfig => _appConfig;

  static bool get defaultDarkTheme => _defaultDarkTheme;

  static String get countryCodeDefault => _countryCodeDefault;

  static String get dialCodeDefault => _dialCodeDefault;

  static String get nameDefault => _nameDefault;

  static Map get advanceConfig => _advanceConfig;

  static Map get storeIdentifier => _storeIdentifier;

  static List get defaultSettings => _defaultSettings;

  static Map get loginSetting => _loginSetting;

  static Map get defaultDrawer => _defaultDrawer;

  static Map get oneSignalKey => _oneSignalKey;

  static List get onBoardingData => _onBoardingData;

  static List get vendorOnBoardingData => _vendorOnBoardingData;

  static Map get productDetail => _productDetail;

  static Map get blogDetail => _blogDetail;

  static Map get productVariantLayout => _productVariantLayout;

  static Map get adConfig => _adConfig;

  static Map get firebaseDynamicLinkConfig => _firebaseDynamicLinkConfig;

  static List<Map> get languagesInfo => _languagesInfo;

  static Map get paymentConfig => _paymentConfig;

  static Map get payments => _payments;

  static Map get stripeConfig => _stripeConfig;

  static Map get paypalConfig => _paypalConfig;

  static Map get razorpayConfig => _razorpayConfig;

  static Map get tapConfig => _tapConfig;

  static Map get payTmConfig => _payTmConfig;

  static Map get payStackConfig => _payStackConfig;

  static Map get flutterwaveConfig => _flutterwaveConfig;

  static Map get myFatoorahConfig => _myFatoorahConfig;

  static Map get mercadoPagoConfig => _mercadoPagoConfig;

  static Map get inAppPurchaseConfig => _inAppPurchaseConfig;

  static Map get afterShip => _afterShip;

  static Map get productAddons => _productAddons;

  static Map get cartDetail => _cartDetail;

  static Map get productVariantLanguage => _productVariantLanguage;

  static Map get saleOffProduct => _saleOffProduct;

  static int get excludedCategory => _excludedCategory;

  static bool get notStrictVisibleVariant => _notStrictVisibleVariant;

  static Map get configChat => _configChat;

  static List<Map> get smartChat => _smartChat;

  static String get adminEmail => _adminEmail;

  static String get adminName => _adminName;

  static VendorConfig get vendorConfig => _vendorConfig;

  static List<AddressFieldConfig> get addressFields => _addressFields;

  static List get defaultCountryShipping => _defaultCountryShipping;

  static Map? get loadingIcon => _loadingIcon;

  static Map get productCard => _productCard;

  static Map get loginSMSConstants => _loginSMSConstants;

  static PhoneNumberConfig get phoneNumberConfig => _phoneNumberConfig;

  static Map get darkConfig => _darkConfig;

  static Map get lightConfig => _lightConfig;

  static Map get subGeneralSetting => _subGeneralSetting;

  static Map get splashScreen => _splashScreen;

  static Map get colorOverrideConfig => _colorOverrideConfig;

  static GoogleApiKeyConfig get googleApiKey => _googleApiKey;

  static Map<String, dynamic>? get layoutDesign => _layoutDesign;

  static bool get enableOnBoarding => _enableOnBoarding;

  static Map? get managerConfig => _managerConfig;

  static Map? get deliveryConfig => _deliveryConfig;

  static Map? get salesiqConfig => _salesiqConfig;

  void setConfigurationValues(Map<String, dynamic> value) {
    _environment = value['environment'] ?? DefaultConfig.environment;
    _baseUrl = value['baseUrl'] ?? DefaultConfig.baseUrl;
    _appName = value['app_name'] ?? DefaultConfig.appName;
    _enableCrashAnalytics =
        value['enableCrashAnalytics'] ?? DefaultConfig.enableCrashAnalytics;
    _enableRemoteConfigFirebase = value['enableRemoteConfigFirebase'] ??
        DefaultConfig.enableRemoteConfigFirebase;
    _enableFirebaseAnalytics = value['enableFirebaseAnalytics'] ??
        DefaultConfig.enableFirebaseAnalytics;
    _defaultLanguage =
        value['defaultLanguage'] ?? DefaultConfig.defaultLanguage;
    _appConfig = value['appConfig'] ?? DefaultConfig.appConfig;
    _serverConfig = value['serverConfig'] ?? DefaultConfig.serverConfig;
    _defaultDarkTheme =
        value['defaultDarkTheme'] ?? DefaultConfig.defaultDarkTheme;
    _storeIdentifier =
        value['storeIdentifier'] ?? DefaultConfig.storeIdentifier;
    _advanceConfig = value['advanceConfig'] != null
        ? Map.from(value['advanceConfig'])
        : DefaultConfig.advanceConfig;
    _countryCodeDefault = DefaultConfig.countryCodeDefault;
    _dialCodeDefault = DefaultConfig.dialCodeDefault;
    _nameDefault = DefaultConfig.nameDefault;
    _defaultSettings =
        value['defaultSettings'] ?? DefaultConfig.defaultSettings;
    _loginSetting = value['loginSetting'] ?? DefaultConfig.loginSetting;
    _defaultDrawer = value['defaultDrawer'] ?? DefaultConfig.defaultDrawer;
    _oneSignalKey = value['oneSignalKey'] ?? DefaultConfig.oneSignalKey;
    _onBoardingData = value['onBoardingData'] ?? DefaultConfig.onBoardingData;
    _vendorOnBoardingData =
        value['vendorOnBoardingData'] ?? DefaultConfig.vendorOnBoardingData;
    _productDetail = value['productDetail'] ?? DefaultConfig.productDetail;
    _blogDetail = value['blogDetail'] ?? DefaultConfig.blogDetail;
    _productVariantLayout =
        value['productVariantLayout'] ?? DefaultConfig.productVariantLayout;
    _adConfig = value['adConfig'] ?? DefaultConfig.adConfig;
    _firebaseDynamicLinkConfig = value['firebaseDynamicLinkConfig'] ??
        DefaultConfig.firebaseDynamicLinkConfig;
    _languagesInfo =
        List<Map>.from(value['languagesInfo'] ?? DefaultConfig.languagesInfo);
    _paymentConfig = value['paymentConfig'] ?? DefaultConfig.paymentConfig;
    _payments = value['payments'] ?? DefaultConfig.payments;
    if (value['stripeConfig'] != null) {
      _stripeConfig = value['stripeConfig'];

      _stripeConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_stripeConfig['paymentMethodId'] != null) {
        _stripeConfig['paymentMethodIds'] = [
          ..._stripeConfig['paymentMethodIds'],
          _stripeConfig['paymentMethodId']
        ];
      }
    } else {
      _stripeConfig = DefaultConfig.stripeConfig;
      _stripeConfig['paymentMethodIds'] ??= [];
    }
    _paypalConfig = value['paypalConfig'] ?? DefaultConfig.paypalConfig;
    _razorpayConfig = value['razorpayConfig'] ?? DefaultConfig.razorpayConfig;
    _tapConfig = value['tapConfig'] ?? DefaultConfig.tapConfig;
    _payTmConfig = value['payTmConfig'] ?? DefaultConfig.payTmConfig;
    _payStackConfig = value['payStackConfig'] ?? DefaultConfig.payStackConfig;
    _flutterwaveConfig =
        value['flutterwaveConfig'] ?? DefaultConfig.flutterwaveConfig;
    _myFatoorahConfig =
        value['myFatoorahConfig'] ?? DefaultConfig.myFatoorahConfig;
    _mercadoPagoConfig =
        value['mercadoPagoConfig'] ?? DefaultConfig.mercadoPagoConfig;
    _inAppPurchaseConfig =
        value['inAppPurchaseConfig'] ?? DefaultConfig.inAppPurchaseConfig;
    _afterShip = value['afterShip'] ?? DefaultConfig.afterShip;
    _productAddons = value['productAddons'] ?? DefaultConfig.productAddons;
    _cartDetail = value['cartDetail'] ?? DefaultConfig.cartDetail;
    _productVariantLanguage =
        value['productVariantLanguage'] ?? DefaultConfig.productVariantLanguage;
    _saleOffProduct = value['saleOffProduct'] ?? DefaultConfig.saleOffProduct;
    _excludedCategory =
        value['excludedCategory'] ?? DefaultConfig.excludedCategory;
    _notStrictVisibleVariant = value['notStrictVisibleVariant'] ??
        DefaultConfig.notStrictVisibleVariant;
    _configChat = value['configChat'] ?? DefaultConfig.configChat;
    _smartChat = ConfigurationUtils.loadSmartChat(
        List<Map>.from(value['smartChat'] ?? DefaultConfig.smartChat));
    _adminEmail = value['adminEmail'] ?? DefaultConfig.adminEmail;
    _adminName = value['adminName'] ?? DefaultConfig.adminName;
    _vendorConfig = VendorConfig.fromJson(
        value['vendorConfig'] ?? DefaultConfig.vendorConfig);
    final addressFieldsData = value['addressFields'];
    if (addressFieldsData is List && addressFieldsData.isNotEmpty) {
      _addressFields = [];
      for (var item in addressFieldsData) {
        final addressFieldConfig = AddressFieldConfig.fromMap(item);
        if (addressFieldConfig.type == AddressFieldType.unknown) {
          continue;
        }
        _addressFields.add(addressFieldConfig);
      }
      _addressFields.sort((a, b) => a.position.compareTo(b.position));
    } else {
      _addressFields = List.from(
        DefaultConfig.addressFields,
      );
    }
    _defaultCountryShipping =
        value['defaultCountryShipping'] ?? DefaultConfig.defaultCountryShipping;

    _loadingIcon = value['loadingIcon'] ?? DefaultConfig.loadingIcon;
    _productCard = value['productCard'] ?? DefaultConfig.productCard;
    _loginSMSConstants =
        value['loginSMSConstants'] ?? DefaultConfig.loginSMSConstants;
    _phoneNumberConfig = PhoneNumberConfig.fromJson(
        value['phoneNumberConfig'] ?? DefaultConfig.phoneNumberConfig);
    _darkConfig = value['darkConfig'] ?? DefaultConfig.darkConfig;
    _lightConfig = value['lightConfig'] ?? DefaultConfig.lightConfig;
    _version = value['version'] ?? DefaultConfig.version;
    _subGeneralSetting = ConfigurationUtils.loadSubGeneralSetting(
        value['subGeneralSetting'] ?? DefaultConfig.subGeneralSetting);
    _splashScreen = value['splashScreen'] ?? DefaultConfig.splashScreen;
    _colorOverrideConfig =
        value['colorOverrideConfig'] ?? DefaultConfig.colorOverrideConfig;

    _googleApiKey = value['googleApiKey'] == null
        ? DefaultConfig.googleApiKey
        : GoogleApiKeyConfig.fromMap(value['googleApiKey']);

    _enableOnBoarding =
        value['enableOnBoarding'] ?? DefaultConfig.enableOnBoarding;
    _managerConfig = value['managerConfig'];
    _deliveryConfig = value['deliveryConfig'];
    _salesiqConfig = value['salesiqConfig'];
  }

  void setAlwaysShowTabBar(bool value) {
    _advanceConfig['AlwaysShowTabBar'] = value;
  }

  void mergeWithMap(Map<String, dynamic> value) {
    try {
      _environment = value['environment'] ?? _environment;
      _baseUrl = value['baseUrl'] ?? _baseUrl;
      _appName = value['app_name'] ?? _appName;
      _enableCrashAnalytics =
          value['enableCrashAnalytics'] ?? _enableCrashAnalytics;
      _enableRemoteConfigFirebase =
          value['enableRemoteConfigFirebase'] ?? _enableRemoteConfigFirebase;
      _enableFirebaseAnalytics =
          value['enableFirebaseAnalytics'] ?? _enableFirebaseAnalytics;
      _defaultLanguage = value['defaultLanguage'] ?? _defaultLanguage;
      _appConfig = value['appConfig'] ?? _appConfig;
      _serverConfig = value['serverConfig'] ?? _serverConfig;
      _defaultDarkTheme = value['defaultDarkTheme'] ?? _defaultDarkTheme;
      _storeIdentifier = value['storeIdentifier'] ?? _storeIdentifier;
      _advanceConfig = value['advanceConfig'] != null
          ? Map.from(value['advanceConfig'])
          : _advanceConfig;
      _defaultSettings = value['defaultSettings'] ?? _defaultSettings;
      _loginSetting = value['loginSetting'] ?? _loginSetting;
      _defaultDrawer = value['defaultDrawer'] ?? _defaultDrawer;
      _oneSignalKey = value['oneSignalKey'] ?? _oneSignalKey;
      _onBoardingData = value['onBoardingData'] ?? _onBoardingData;
      _vendorOnBoardingData =
          value['vendorOnBoardingData'] ?? _vendorOnBoardingData;
      _productDetail = value['productDetail'] ?? _productDetail;
      _blogDetail = value['blogDetail'] ?? _blogDetail;
      _productVariantLayout =
          value['productVariantLayout'] ?? _productVariantLayout;
      _adConfig = value['adConfig'] ?? _adConfig;
      _firebaseDynamicLinkConfig =
          value['firebaseDynamicLinkConfig'] ?? _firebaseDynamicLinkConfig;
      _languagesInfo = List<Map>.from(value['languagesInfo'] ?? _languagesInfo);
      _paymentConfig = value['paymentConfig'] ?? _paymentConfig;
      _payments = value['payments'] ?? _payments;
      if (value['stripeConfig'] != null) {
        _stripeConfig = value['stripeConfig'];

        /// To support old paymentMethodId param
        if (_stripeConfig['paymentMethodId'] != null) {
          _stripeConfig['paymentMethodIds'] = [
            ...(_stripeConfig['paymentMethodIds'] ?? []),
            _stripeConfig['paymentMethodId']
          ];
        }
      }
      _paypalConfig = value['paypalConfig'] ?? _paypalConfig;
      _razorpayConfig = value['razorpayConfig'] ?? _razorpayConfig;
      _tapConfig = value['tapConfig'] ?? _tapConfig;
      _payTmConfig = value['payTmConfig'] ?? _payTmConfig;
      _payStackConfig = value['payStackConfig'] ?? _payStackConfig;
      _flutterwaveConfig = value['flutterwaveConfig'] ?? _flutterwaveConfig;
      _myFatoorahConfig = value['myFatoorahConfig'] ?? _myFatoorahConfig;
      _mercadoPagoConfig = value['mercadoPagoConfig'] ?? _mercadoPagoConfig;
      _afterShip = value['afterShip'] ?? _afterShip;
      _productAddons = value['productAddons'] ?? _productAddons;
      _cartDetail = value['cartDetail'] ?? _cartDetail;
      _productVariantLanguage =
          value['productVariantLanguage'] ?? _productVariantLanguage;
      _saleOffProduct = value['saleOffProduct'] ?? _saleOffProduct;
      _excludedCategory = value['excludedCategory'] ?? _excludedCategory;
      _notStrictVisibleVariant =
          value['notStrictVisibleVariant'] ?? _notStrictVisibleVariant;
      _configChat = value['configChat'] ?? _configChat;
      _smartChat = value['smartChat'] is List
          ? ConfigurationUtils.loadSmartChat(List<Map>.from(value['smartChat']))
          : _smartChat;
      _adminEmail = value['adminEmail'] ?? _adminEmail;
      _adminName = value['adminName'] ?? _adminName;
      _vendorConfig = value['vendorConfig'] is Map
          ? VendorConfig.fromJson(value['vendorConfig'])
          : _vendorConfig;
      final addressFieldsData = value['addressFields'];
      if (addressFieldsData is List && addressFieldsData.isNotEmpty) {
        _addressFields = [];
        for (var item in addressFieldsData) {
          final addressFieldConfig = AddressFieldConfig.fromMap(item);
          if (addressFieldConfig.type == AddressFieldType.unknown) {
            continue;
          }
          _addressFields.add(addressFieldConfig);
        }
        _addressFields.sort((a, b) => a.position.compareTo(b.position));
      }
      _defaultCountryShipping =
          value['defaultCountryShipping'] ?? _defaultCountryShipping;

      _loadingIcon = value['loadingIcon'] ?? _loadingIcon;
      _productCard = value['productCard'] ?? _productCard;
      _loginSMSConstants = value['loginSMSConstants'] ?? _loginSMSConstants;
      _phoneNumberConfig = value['phoneNumberConfig'] is Map
          ? PhoneNumberConfig.fromJson(value['phoneNumberConfig'])
          : _phoneNumberConfig;
      _darkConfig = value['darkConfig'] ?? _darkConfig;
      _lightConfig = value['lightConfig'] ?? _lightConfig;
      _version = value['version'] ?? _version;
      _subGeneralSetting = value['subGeneralSetting'] is Map
          ? ConfigurationUtils.loadSubGeneralSetting(value['subGeneralSetting'])
          : _subGeneralSetting;
      _splashScreen = value['splashScreen'] ?? _splashScreen;
      _colorOverrideConfig =
          value['colorOverrideConfig'] ?? _colorOverrideConfig;

      _googleApiKey = value['googleApiKey'] is Map
          ? GoogleApiKeyConfig.fromMap(value['googleApiKey'])
          : _googleApiKey;
      _enableOnBoarding = value['enableOnBoarding'] ?? _enableOnBoarding;
      _managerConfig = value['managerConfig'] ?? _managerConfig;
      _deliveryConfig = value['deliveryConfig'] ?? _deliveryConfig;
      _salesiqConfig = value['salesiqConfig'] ?? _salesiqConfig;
    } catch (e) {
      rethrow;
    }
  }

  void _loadDesignConfig() {
    final data = Services().firebase.getRemoteConfigString('layout_design');
    if (data.isNotEmpty) {
      _layoutDesign = Map<String, dynamic>.from(jsonDecode(data));
    }
  }
}

extension ConfigurationsFireBaseRemoteConfig on Configurations {
  Future<void> loadRemoteConfig() async {
    if (Configurations.enableRemoteConfigFirebase) {
      final isAvailable = await Services().firebase.loadRemoteConfig();
      if (isAvailable) {
        _loadDesignConfig();
        var configurations = <String, dynamic>{};
        var keys = await Services().firebase.getRemoteKeys();
        for (var item in keys) {
          var data = Services().firebase.getRemoteConfigString(item);
          if (data.isNotEmpty) {
            var dataJson;
            try {
              dataJson = jsonDecode(data);
            } catch (e) {
              dataJson = data;
            }
            configurations[item] = dataJson;
          }
        }
        mergeWithMap(configurations);
      }
    }
  }
}
