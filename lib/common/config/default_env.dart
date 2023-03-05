part of '../config.dart';

class DefaultConfig {
  static String environment = '';
  static String appName = 'Fluxstore';
  static bool enableRemoteConfigFirebase = false;
  static bool enableFirebaseAnalytics = false;
  static bool enableCrashAnalytics = false;
  static String defaultLanguage = '';
  static String baseUrl = '';
  static Map serverConfig = {};
  static String appConfig = '';
  static bool defaultDarkTheme = false;
  static String countryCodeDefault = 'VN';
  static String dialCodeDefault = '+84';
  static String nameDefault = 'Vietnam';
  static Map<String, dynamic> phoneNumberConfig = {
    'enablePhoneNumberValidation': false,
    'countryCodeDefault': 'VN',
    'dialCodeDefault': '+84',
    'useInternationalFormat': true,
    'selectorFlagAsPrefixIcon': true,
    'showCountryFlag': true,
    'customCountryList': [], // List alpha_2_code. E.g: ["VN", "AU"]
    'selectorType': 'BOTTOM_SHEET', // [DROPDOWN, BOTTOM_SHEET, DIALOG]
  };
  static Map advanceConfig = {
    'DefaultLanguage': 'en',
    'DetailedBlogLayout': 'halfSizeImageType',
    'EnablePointReward': false,
    'hideOutOfStock': false,
    'HideEmptyTags': true,
    'HideEmptyCategories': true,
    'EnableRating': false,
    'hideEmptyProductListRating': false,

    'OnBoardOnlyShowFirstTime': true,

    'EnableCart': true,
    'ShowBottomCornerCart': true,

    /// Enable search by SKU in search screen
    'EnableSkuSearch': false,

    /// Show stock Status on product List & Product Detail
    'showStockStatus': false,

    /// Gird count setting on Category screen
    'GridCount': 3,

    /// set isCaching to true if you have upload the config file to mstore-api
    /// set kIsResizeImage to true if you have finished running Re-generate image plugin
    /// ref: https://support.inspireui.com/help-center/articles/3/8/19/app-performance
    'isCaching': false,
    'kIsResizeImage': false,
    'httpCache': true,

    /// Stripe payment only: set currencyCode and smallestUnitRate.
    /// All API requests expect amounts to be provided in a currency’s smallest unit.
    /// For example, to charge 10 USD, provide an amount value of 1000 (i.e., 1000 cents).
    /// Reference: https://stripe.com/docs/currencies#zero-decimal
    'DefaultCurrency': {
      'symbol': '\$',
      'decimalDigits': 2,
      'symbolBeforeTheNumber': true,
      'currency': 'USD',
      'currencyCode': 'usd',
      'smallestUnitRate': 100,

      /// 100 cents = 1 usd
    },
    'Currencies': [
      {
        'symbol': '\$',
        'decimalDigits': 2,
        'symbolBeforeTheNumber': true,
        'currency': 'USD',
        'currencyCode': 'USD',
        'smallestUnitRate': 100,

        /// 100 cents = 1 usd
      },
      {
        'symbol': '₹',
        'decimalDigits': 0,
        'symbolBeforeTheNumber': true,
        'currency': 'INR',
        'currencyCode': 'INR',
      },
      {
        'symbol': 'đ',
        'decimalDigits': 2,
        'symbolBeforeTheNumber': false,
        'currency': 'VND',
        'currencyCode': 'VND',
      },
      {
        'symbol': '€',
        'decimalDigits': 2,
        'symbolBeforeTheNumber': true,
        'currency': 'EUR',
        'currencyCode': 'EUR',
      },
      {
        'symbol': '£',
        'decimalDigits': 2,
        'symbolBeforeTheNumber': true,
        'currency': 'Pound sterling',
        'currencyCode': 'GBP',
        'smallestUnitRate': 100,

        /// 100 pennies = 1 pound
      },
      {
        'symbol': 'AR\$',
        'decimalDigits': 2,
        'symbolBeforeTheNumber': true,
        'currency': 'ARS',
        'currencyCode': 'ARS',
      }
    ],

    /// Below config is used for Magento store
    'DefaultStoreViewCode': '',
    'EnableAttributesConfigurableProduct': ['color', 'size'],
    'EnableAttributesLabelConfigurableProduct': ['color', 'size'],

    /// if the woo commerce website supports multi languages
    /// set false if the website only have one language
    'isMultiLanguages': false,

    ///Review gets approved automatically on woocommerce admin without requiring administrator to approve.
    'EnableApprovedReview': false,

    /// Sync Cart from website and mobile
    'EnableSyncCartFromWebsite': true,
    'EnableSyncCartToWebsite': true,

    /// Enable firebase to support FCM, realtime chat for Fluxstore MV
    'EnableFirebase': false,

    /// ratio Product Image, default value is 1.2 = height / width
    'RatioProductImage': 1.2,

    /// Enable Coupon Code When checkout
    'EnableCouponCode': true,

    /// Enable to Show Coupon list.
    'ShowCouponList': false,

    /// Enable this will show all coupons in Coupon list.
    /// Disable will show only coupons which is restricted to the current user"s email.
    'ShowAllCoupons': true,

    /// Show expired coupons in Coupon list.
    'ShowExpiredCoupons': false,
    'AlwaysShowTabBar': false,

    /// Privacy Policies page ID. Accessible in the app via Settings > Privacy menu.
    'PrivacyPoliciesPageId': null,

    /// If page id null
    /// Privacy Policies page Url. Accessible in the app via Settings > Privacy menu.
    'PrivacyPoliciesPageUrl': 'https://mstore.io/',

    'SupportPageUrl': 'https://support.inspireui.com/',

    'DownloadPageUrl': 'https://mstore.io/#download',

    'SocialConnectUrl': [
      {
        'name': 'Facebook',
        'icon': 'assets/icons/logins/facebook.png',
        'url': 'https://www.facebook.com/inspireui'
      },
      {
        'name': 'Instagram',
        'icon': 'assets/icons/logins/instagram.png',
        'url': 'https://www.instagram.com/inspireui9/'
      },
    ],

    'AutoDetectLanguage': false,
    'QueryRadiusDistance': 10,
    'MinQueryRadiusDistance': 1,

    /// Distance by km
    'MaxQueryRadiusDistance': 10,

    /// Enable Membership Pro Ultimate WP
    'EnableMembershipUltimate': false,

    /// Enable Paid Membership Pro
    'EnablePaidMembershipPro': false,

    /// Support Digits : WordPress Mobile Number Signup and Login.
    /// Plugin (https://codecanyon.net/item/digits-wordpress-mobile-number-signup-and-login/19801105)
    'EnableDigitsMobileLogin': false,
    'EnableDigitsMobileFirebase': false,

    /// Enable Delivery Date when doing checkout
    'EnableDeliveryDateOnCheckout': true,

    /// Enable new SMS Login
    'EnableNewSMSLogin': false,

    /// Enable bottom add to cart from product card view
    'EnableBottomAddToCart': false,

    /// Disable inAppWebView to use webview_flutter
    /// so webview can navigate to external app.
    /// Useful for webview checkout which need to handle payment in another app.
    'inAppWebView': false,
    'AlwaysClearWebViewCache': false,
    'WebViewScript': '',

    'AlwaysRefreshBlog': false,

    ///support multi currency via WOOCS – Currency Switcher for WooCommerce plugin (https://wordpress.org/plugins/woocommerce-currency-switcher/)
    'EnableWOOCSCurrencySwitcher': false,

    /// Enable product backdrop layout - https://tppr.me/L5Pnf
    'enableProductBackdrop': false,

    /// false: show category menu as Text https://tppr.me/v3bLI
    /// true: show as Category Image
    'categoryImageMenu': true,

    'EnableVersionCheck': false,

    'AjaxSearchURL': '',

    /// show order notes in order detail with private notes
    'OrderNotesWithPrivateNote': true,

    'OrderNotesLinkSupport': false,

    // Enable the request Notify permission from onboarding
    'showRequestNotification': true,
  };
  static Map storeIdentifier = {};
  static Map defaultDrawer = {};
  static List defaultSettings = [];
  static Map loginSetting = {};
  static Map oneSignalKey = {};
  static List onBoardingData = [
    {
      'title': 'Welcome to FluxStore',
      'image': 'assets/images/fogg-delivery-1.png',
      'desc': 'Fluxstore is on the way to serve you. '
    },
    {
      'title': 'Connect Surrounding World',
      'image': 'assets/images/fogg-uploading-1.png',
      'desc':
          'See all things happening around you just by a click in your phone. Fast, convenient and clean.'
    },
    {
      'title': "Let's Get Started",
      'image': 'assets/images/fogg-order-completed.png',
      'desc': "Waiting no more, let's see what we get!"
    }
  ];
  static List vendorOnBoardingData = [
    {
      'title': 'Welcome aboard',
      'image': 'assets/images/searching.png',
      'desc': 'Just a few more steps to become our vendor'
    },
    {
      'title': 'Let\'s Get Started',
      'image': 'assets/images/manage.png',
      'desc': 'Good Luck for great beginnings.'
    }
  ];

  static Map productDetail = {};
  static Map blogDetail = {
    'showComment': true,
    'showHeart': true,
    'showSharing': true,
    'enableAudioSupport': false,
  };
  static Map productVariantLayout = {};
  static Map adConfig = {
    'enable': false,
    'facebookTestingId': '',
    'googleTestingId': [],
    'ads': [
      {
        'type': 'banner',
        'provider': 'google',
        'iosId': 'ca-app-pub-3940256099942544/2934735716',
        'androidId': 'ca-app-pub-3940256099942544/6300978111',
        'showOnScreens': [],
        'hideOnScreens': [
          'category',
        ],
        // 'waitingTimeToDisplay': 8,
      },
      {
        'type': 'banner',
        'provider': 'google',
        'iosId': 'ca-app-pub-2101182411274198/5418791562',
        'androidId': 'ca-app-pub-2101182411274198/4052745095',
        'showOnScreens': ['home', 'search', 'product-detail'],
        'hideOnScreens': [],
      },
      {
        'type': 'interstitial',
        'provider': 'google',
        'iosId': 'ca-app-pub-3940256099942544/4411468910',
        'androidId': 'ca-app-pub-3940256099942544/4411468910',
        // 'showOnScreens': ['profile'],
        'hideOnScreens': [],
        // 'waitingTimeToDisplay': 8,
      },
      {
        'type': 'reward',
        'provider': 'google',
        'iosId': 'ca-app-pub-3940256099942544/1712485313',
        'androidId': 'ca-app-pub-3940256099942544/4411468910',
        // 'showOnScreens': ['cart'],
        'hideOnScreens': [],
        // 'waitingTimeToDisplay': 8,
      },
      {
        'type': 'banner',
        'provider': 'facebook',
        'iosId': 'IMG_16_9_APP_INSTALL#430258564493822_876131259906548',
        'androidId': 'IMG_16_9_APP_INSTALL#430258564493822_489007588618919',
        'showOnScreens': ['home'],
        'hideOnScreens': [],
        // 'waitingTimeToDisplay': 8,
      },
      {
        'type': 'interstitial',
        'provider': 'facebook',
        'iosId': '430258564493822_489092398610438',
        'androidId': 'IMG_16_9_APP_INSTALL#430258564493822_489092398610438',
        // 'showOnScreens': ['profile'],
        'hideOnScreens': [],
        // 'waitingTimeToDisplay': 8,
      },
    ]
  };
  static Map firebaseDynamicLinkConfig = {
    'isEnabled': true,
    // Domain is the domain name for your product.
    // Let’s assume here that your product domain is “example.com”.
    // Then you have to mention the domain name as : https://example.page.link.
    'uriPrefix': 'https://fluxstoreinspireui.page.link',
    //The link your app will open
    'link': 'https://mstore.io/',
    //----------* Android Setting *----------//
    'androidPackageName': 'com.inspireui.fluxstore',
    'androidAppMinimumVersion': 1,
    //----------* iOS Setting *----------//
    'iOSBundleId': 'com.cbii.quickers.flutter',
    'iOSAppMinimumVersion': '1.0.1',
    'iOSAppStoreId': '1469772800'
  };
  static List<Map> languagesInfo = <Map>[];
  static Map paymentConfig = {};
  static List<AddressFieldConfig> addressFields = [
    {
      'type': 'firstName',
      'visible': true,
      'position': 1,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
    {
      'type': 'lastName',
      'visible': true,
      'position': 2,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
    {
      'type': 'phoneNumber',
      'visible': true,
      'position': 3,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
    {
      'type': 'email',
      'visible': true,
      'position': 4,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
    {
      'type': 'searchAddress',
      'visible': true,
      'position': 5,
    },
    {
      'type': 'selectAddress',
      'visible': true,
      'position': 6,
    },
    {
      'type': 'country',
      'visible': true,
      'position': 7,
    },
    {
      'type': 'state',
      'visible': true,
      'position': 8,
    },
    {
      'type': 'city',
      'visible': true,
      'position': 9,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
    {
      'type': 'apartment',
      'visible': true,
      'position': 10,
      'editable': true,
      'required': false,
    },
    {
      'type': 'block',
      'visible': true,
      'position': 11,
      'editable': true,
      'required': false,
      'defaultValue': '',
    },
    {
      'type': 'street',
      'visible': true,
      'position': 12,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
    {
      'type': 'zipCode',
      'visible': true,
      'position': 13,
      'editable': true,
      'required': true,
      'defaultValue': '',
    },
  ].map<AddressFieldConfig>(AddressFieldConfig.fromMap).toList();
  static Map payments = {};
  static Map stripeConfig = {};
  static Map paypalConfig = {};
  static Map razorpayConfig = {
    'keyId': 'rzp_test_SDo2WKBNQXDk5Y',
    'keySecret': 'RrgfT3oxbJdaeHSzvuzaJRZf',
    'paymentMethodId': 'razorpay',
    'enabled': true
  };
  static Map tapConfig = {};
  static Map payTmConfig = {
    'paymentMethodId': 'paytm',
    'merchantId': 'your-merchant-id',
    'production': false,
    'enabled': false
  };
  static Map payStackConfig = {
    'paymentMethodId': 'paystack',
    'publicKey': 'pk_test_a1a37615c9ca90dead5dd84dedbb5e476b640a6f',
    'production': false,
    'enabled': false
  };
  static Map flutterwaveConfig = {
    'paymentMethodId': 'rave',
    'publicKey': 'FLWPUBK_TEST-72b90e0734da8c9e43916adf63cd711e-X',
    'production': false,
    'enabled': true
  };
  static Map myFatoorahConfig = {
    'paymentMethodId': 'myfatoorah_v2',
    'apiToken':
        'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
    'accountCountry': 'KW',
    'production': false,
    'enabled': false
  };
  static Map mercadoPagoConfig = {};
  static Map inAppPurchaseConfig = {'productIDs': [], 'enabled': false};
  static Map afterShip = {};
  static Map productAddons = {};
  static Map cartDetail = {};
  static Map productVariantLanguage = {};
  static int excludedCategory = 311;
  static Map saleOffProduct = {};
  static bool notStrictVisibleVariant = true;
  static Map configChat = {};
  static List<Map> smartChat = [];
  static String adminEmail = '';
  static String adminName = '';
  static Map vendorConfig = {};
  static Map? loadingIcon;
  static Map productCard = {};
  static String? cardFit;
  static List defaultCountryShipping = [
    {
      'name': 'Vietnam',
      'iosCode': 'VN',
      'icon': 'https://cdn.britannica.com/41/4041-004-A06CBD63/Flag-Vietnam.jpg'
    },
    {
      'name': 'India',
      'iosCode': 'IN',
      'icon':
          'https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png'
    },
    {'name': 'Austria', 'iosCode': 'AT', 'icon': ''}
  ];
  static Map loginSMSConstants = {};
  static Map darkConfig = {};
  static Map lightConfig = {};
  static String version = '2.2.0';

  static Map orderDelivery = {
    'enable': false,
  };
  static Map subGeneralSetting = {};
  static Map splashScreen = {
    'enable': true,
    'type': 'flare',
    'image': 'assets/images/splashscreen.flr',
    'boxFit': 'contain',
    'backgroundColor': '#ffffff',
    'paddingTop': 0,
    'paddingBottom': 0,
    'paddingLeft': 0,
    'paddingRight': 0,
    'animationName': 'fluxstore',
    'duration': 2000,
  };
  static Map colorOverrideConfig = {};
  static GoogleApiKeyConfig googleApiKey = GoogleApiKeyConfig.fromMap(
    {
      'android': 'AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ',
      'ios': 'AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ',
      'web': 'AIzaSyDW3uXzZepWBPi-69BIYKyS-xo9NjFSFhQ'
    },
  );
  static bool enableOnBoarding = true;
}
