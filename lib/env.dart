// ignore_for_file: prefer_single_quotes, lines_longer_than_80_chars final
Map<String, dynamic> environment = {
  "appConfig": "lib/config/config_en.json",
  "serverConfig": {
    "url": "https://quickers.uk/",
    "type": "shopify",
    "accessToken": "61ccec105631e3491e1cab287f71c478"
  },
  "defaultDarkTheme": false,
  "enableRemoteConfigFirebase": false,
  "enableFirebaseAnalytics": false,
  "loginSMSConstants": {
    "countryCodeDefault": "US",
    "nameDefault": "United States",
    "dialCodeDefault": "+1"
  },
  "phoneNumberConfig": {
    "useInternationalFormat": true,
    "customCountryList": [],
    "enable": true,
    "dialCodeDefault": "+44",
    "countryCodeDefault": "GB",
    "showCountryFlag": true,
    "formatInput": false,
    "selectorType": "BOTTOM_SHEET",
    "selectorFlagAsPrefixIcon": true
  },
  "storeIdentifier": {
    "android": "com.inspireui.fluxstore",
    "disable": true,
    "ios": "1469772800"
  },
  "advanceConfig": {
    "DefaultLanguage": "en",
    "DetailedBlogLayout": "halfSizeImageType",
    "EnablePointReward": false,
    "hideOutOfStock": false,
    "HideEmptyTags": true,
    "HideEmptyCategories": true,
    "EnableRating": true,
    "hideEmptyProductListRating": true,
    "EnableCart": true,
    "ShowBottomCornerCart": true,
    "EnableSkuSearch": true,
    "showStockStatus": true,
    "GridCount": 3,
    "isCaching": false,
    "kIsResizeImage": true,
    "httpCache": true,
    "Currencies": [
      {
        "symbol": "\$",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "USD",
        "currencyCode": "USD",
        "smallestUnitRate": 100
      },
      {
        "symbol": "₹",
        "decimalDigits": 0,
        "symbolBeforeTheNumber": true,
        "currency": "INR",
        "currencyCode": "INR",
        "smallestUnitRate": 1
      },
      {
        "symbol": "đ",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": false,
        "currency": "VND",
        "currencyCode": "VND",
        "smallestUnitRate": 1
      },
      {
        "symbol": "€",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "EUR",
        "currencyCode": "EUR",
        "smallestUnitRate": 1
      },
      {
        "symbol": "£",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "Pound sterling",
        "currencyCode": "GBP",
        "smallestUnitRate": 100
      },
      {
        "symbol": "AR\$",
        "decimalDigits": 2,
        "symbolBeforeTheNumber": true,
        "currency": "ARS",
        "currencyCode": "ARS",
        "smallestUnitRate": 1
      }
    ],
    "DefaultStoreViewCode": "",
    "EnableAttributesConfigurableProduct": ["color", "size"],
    "EnableAttributesLabelConfigurableProduct": ["color", "size"],
    "isMultiLanguages": true,
    "EnableApprovedReview": false,
    "EnableSyncCartFromWebsite": false,
    "EnableSyncCartToWebsite": false,
    "EnableFirebase": true,
    "RatioProductImage": 1.2,
    "EnableCouponCode": true,
    "ShowCouponList": true,
    "ShowAllCoupons": true,
    "ShowExpiredCoupons": true,
    "AlwaysShowTabBar": false,
    "PrivacyPoliciesPageId": 25569,
    "PrivacyPoliciesPageUrl": "https://policies.google.com/",
    "SupportPageUrl": "https://support.inspireui.com/",
    "DownloadPageUrl": "https://mstore.io/#download",
    "SocialConnectUrl": [
      {
        "url": "https://www.facebook.com/inspireui",
        "icon": "assets/icons/logins/facebook.png",
        "name": "Facebook"
      },
      {
        "url": "https://www.instagram.com/inspireui9/",
        "icon": "assets/icons/logins/instagram.png",
        "name": "Instagram"
      }
    ],
    "AutoDetectLanguage": false,
    "QueryRadiusDistance": 10,
    "MinQueryRadiusDistance": 1,
    "MaxQueryRadiusDistance": 10,
    "EnableMembershipUltimate": false,
    "EnablePaidMembershipPro": false,
    "EnableDeliveryDateOnCheckout": true,
    "EnableNewSMSLogin": false,
    "EnableBottomAddToCart": false,
    "inAppWebView": false,
    "EnableWOOCSCurrencySwitcher": true,
    "enableProductBackdrop": false,
    "categoryImageMenu": true,
    "EnableDigitsMobileLogin": false,
    "OnBoardOnlyShowFirstTime": false,
    "WebViewScript": "",
    "EnableVersionCheck": false,
    "AjaxSearchURL": "",
    "AlwaysClearWebViewCache": false,
    "AlwaysRefreshBlog": true,
    "OrderNotesWithPrivateNote": true,
    "OrderNotesLinkSupport": false,
    "inAppUpdateForAndroid": {"typeUpdate": "flexible", "enable": false},
    "categoryConfig": {"enableLargeCategories": false, "deepLevel": 3},
    "pinnedProductTags": [],
    "EnableDigitsMobileFirebase": false,
    "smsLoginAsDefault": false,
    "gdpr": {
      "showPrivacyPolicyFirstTime": false,
      "showDeleteAccount": true,
      "confirmCaptcha": "PERMANENTLY DELETE"
    },
    "showRequestNotification": true,
    "DefaultCurrency": {
      "currencyCode": "gbp",
      "symbolBeforeTheNumber": true,
      "currency": "GBP",
      "smallestUnitRate": 100,
      "decimalDigits": 2,
      "symbol": "£"
    }
  },
  "defaultDrawer": {
    "items": [
      {"show": true, "type": "home"},
      {"show": true, "type": "blog"},
      {"show": true, "type": "categories"},
      {"show": true, "type": "cart"},
      {"type": "profile", "show": true},
      {"type": "login", "show": true},
      {"type": "category", "show": true}
    ],
    "logo": "assets/images/logo.png"
  },
  "defaultSettings": [
    "products",
    "chat",
    "wishlist",
    "notifications",
    "language",
    "darkTheme",
    "order",
    "point",
    "rating",
    "privacy",
    "about"
  ],
  "loginSetting": {
    "facebookAppId": "430258564493822",
    "requirePhoneNumberWhenRegister": true,
    "facebookLoginProtocolScheme": "fb430258564493822",
    "showPhoneNumberWhenRegister": true,
    "IsRequiredLogin": false,
    "facebookClientToken": "",
    "smsLoginAsDefault": false,
    "isResetPasswordSupported": true
  },
  "oneSignalKey": {
    "appID": "8b45b6db-7421-45e1-85aa-75e597f62714",
    "enable": false
  },
  "onBoardingData": [
    {
      "title": "Welcome to FluxStore",
      "image": "assets/images/fogg-delivery-1.png",
      "desc": "Fluxstore is on the way to serve you. "
    },
    {
      "desc":
          "See all things happening around you just by a click in your phone. Fast, convenient and clean.",
      "title": "Connect Surrounding World",
      "image": "assets/images/fogg-uploading-1.png"
    },
    {
      "desc": "Waiting no more, let's see what we get!",
      "image": "assets/images/fogg-order-completed.png",
      "title": "Let's Get Started"
    }
  ],
  "adConfig": {
    "googleTestingId": [],
    "adMobAppIdAndroid": "ca-app-pub-7432665165146018~2664444130",
    "enable": false,
    "adMobAppIdIos": "ca-app-pub-7432665165146018~2664444130",
    "ads": [
      {
        "androidId": "ca-app-pub-3940256099942544/6300978111",
        "showOnScreens": ["home", "search"],
        "iosId": "ca-app-pub-3940256099942544/2934735716",
        "type": "banner",
        "provider": "google",
        "waitingTimeToDisplay": 2
      },
      {
        "androidId": "ca-app-pub-2101182411274198/4052745095",
        "type": "banner",
        "provider": "google",
        "iosId": "ca-app-pub-2101182411274198/5418791562"
      },
      {
        "androidId": "ca-app-pub-3940256099942544/4411468910",
        "iosId": "ca-app-pub-3940256099942544/4411468910",
        "waitingTimeToDisplay": 5,
        "showOnScreens": ["profile"],
        "type": "interstitial",
        "provider": "google"
      },
      {
        "provider": "google",
        "type": "reward",
        "showOnScreens": ["cart"],
        "androidId": "ca-app-pub-3940256099942544/4411468910",
        "iosId": "ca-app-pub-3940256099942544/1712485313"
      },
      {
        "showOnScreens": ["home"],
        "iosId": "IMG_16_9_APP_INSTALL#430258564493822_876131259906548",
        "type": "banner",
        "provider": "facebook",
        "androidId": "IMG_16_9_APP_INSTALL#430258564493822_489007588618919"
      },
      {
        "provider": "facebook",
        "iosId": "430258564493822_489092398610438",
        "type": "interstitial",
        "androidId": "IMG_16_9_APP_INSTALL#430258564493822_489092398610438"
      }
    ],
    "facebookTestingId": ""
  },
  "firebaseDynamicLinkConfig": {
    "isEnabled": true,
    "iOSAppMinimumVersion": "1.0.1",
    "androidPackageName": "com.inspireui.fluxstore",
    "iOSAppStoreId": "1469772800",
    "uriPrefix": "https://fluxstoreinspireui.page.link",
    "link": "https://mstore.io/",
    "shortDynamicLinkEnable": true,
    "iOSBundleId": "com.cbii.quickers.flutter",
    "androidAppMinimumVersion": 1
  },
  "languagesInfo": [
    {
      "name": "English",
      "storeViewCode": "",
      "code": "en",
      "text": "English",
      "icon": "assets/images/country/gb.png"
    },
    {
      "storeViewCode": "ar",
      "name": "Arabic",
      "icon": "assets/images/country/ar.png",
      "code": "ar",
      "text": "العربية"
    },
    {
      "text": "Türkçe",
      "storeViewCode": "tr",
      "icon": "assets/images/country/tr.png",
      "name": "Turkish",
      "code": "tr"
    }
  ],
  "paymentConfig": {
    "UpdateOrderStatus": false,
    "EnableRefundCancel": true,
    "EnableCustomerNote": true,
    "EnableShipping": true,
    "EnableReview": true,
    "CheckoutPageSlug": {"en": "checkout"},
    "RefundPeriod": 7,
    "EnableAlphanumericZipCode": false,
    "DefaultStateISOCode": "",
    "EnableOnePageCheckout": false,
    "SmartCOD": {"extraFee": 10, "amountStop": 200, "enabled": true},
    "EnableAddress": true,
    "NativeOnePageCheckout": false,
    "EnableAddressLocationNote": false,
    "ShowWebviewCheckoutSuccessScreen": true,
    "EnableCreditCard": false,
    "excludedPaymentIds": [],
    "ShowOrderNotes": true,
    "GuestCheckout": true,
    "allowSearchingAddress": true,
    "DefaultCountryISOCode": "UK"
  },
  "payments": {
    "stripe": "assets/icons/payment/stripe.svg",
    "stripe_v2_google_pay": "assets/icons/payment/google-pay-mark.png",
    "tap": "assets/icons/payment/tap.png",
    "paypal": "assets/icons/payment/paypal.svg",
    "stripe_v2_apple_pay": "assets/icons/payment/apple-pay-mark.svg",
    "razorpay": "assets/icons/payment/razorpay.svg"
  },
  "stripeConfig": {
    "merchantDisplayName": "FluxStore",
    "serverEndpoint": "https://stripe-server-node.vercel.app",
    "useV1": false,
    "paymentMethodIds": ["stripe"],
    "publishableKey":
        "pk_test_51HNabPCinksNdU0OwGkZ6uMdZOrLT42NGJkBxmVJwx3oM5mafpJaQRfDHifJMg2iREDZxbPkR1TvDtmBeTyjmgv200mCojR2dG",
    "returnUrl": "fluxstore://inspireui.com",
    "merchantCountryCode": "US",
    "enableApplePay": true,
    "enabled": true,
    "enableManualCapture": false,
    "merchantIdentifier": "merchant.com.inspireui.mstore.flutter",
    "enableGooglePay": true
  },
  "paypalConfig": {
    "clientId":
        "ASlpjFreiGp3gggRKo6YzXMyGM6-NwndBAQ707k6z3-WkSSMTPDfEFmNmky6dBX00lik8wKdToWiJj5w",
    "nativeMode": false,
    "enabled": true,
    "paymentMethodId": "paypal",
    "secret":
        "ECbFREri7NFj64FI_9WzS6A0Az2DqNLrVokBo0ZBu4enHZKMKOvX45v9Y1NBPKFr6QJv2KaSp5vk5A1G",
    "production": false
  },
  "razorpayConfig": {
    "paymentMethodId": "razorpay",
    "keySecret": "RrgfT3oxbJdaeHSzvuzaJRZf",
    "enabled": true,
    "keyId": "rzp_test_SDo2WKBNQXDk5Y"
  },
  "tapConfig": {
    "enabled": true,
    "paymentMethodId": "tap",
    "SecretKey": "sk_test_XKokBfNWv6FIYuTMg5sLPjhJ"
  },
  "mercadoPagoConfig": {
    "accessToken":
        "TEST-5726912977510261-102413-65873095dc5b0a877969b7f6ffcceee4-613803978",
    "paymentMethodId": "woo-mercado-pago-basic",
    "production": false,
    "enabled": true
  },
  "payTmConfig": {
    "production": false,
    "enabled": true,
    "paymentMethodId": "paytm",
    "merchantId": "your-merchant-id"
  },
  "payStackConfig": {
    "enabled": true,
    "production": false,
    "publicKey": "pk_test_a1a37615c9ca90dead5dd84dedbb5e476b640a6f",
    "paymentMethodId": "paystack",
    "supportedCurrencies": ["ZAR"]
  },
  "flutterwaveConfig": {
    "production": false,
    "publicKey": "FLWPUBK_TEST-72b90e0734da8c9e43916adf63cd711e-X",
    "enabled": true,
    "paymentMethodId": "rave"
  },
  "myFatoorahConfig": {
    "paymentMethodId": "myfatoorah_v2",
    "enabled": true,
    "apiToken":
        "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL",
    "accountCountry": "KW",
    "production": false
  },
  "inAppPurchaseConfig": {
    "subscriptionProductIDs": ["com.inspireui.fluxstore.subscription.test"],
    "nonConsumableProductIDs": [],
    "enabled": false,
    "consumableProductIDs": ["com.inspireui.fluxstore.test"]
  },
  "defaultCountryShipping": [
    {"emoji": "🇬🇧", "iosCode": "GB", "name": "United Kingdom"}
  ],
  "afterShip": {
    "tracking_url": "https://fluxstore.aftership.com",
    "api": "e2e9bae8-ee39-46a9-a084-781d0139274f"
  },
  "googleApiKey": {
    "android": "AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg",
    "ios": "AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg",
    "web": "AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg"
  },
  "productDetail": {
    "attributeImagesSize": 50,
    "ForceWhiteBackground": false,
    "SliderIndicatorType": "number",
    "productListItemHeight": 125,
    "safeArea": false,
    "showRecentProduct": true,
    "ShowSelectedImageVariant": true,
    "productImageLayout": "page",
    "showProductTags": true,
    "showQuantityInList": false,
    "showThumbnailAtLeast": 1,
    "ShowImageGallery": true,
    "SliderShowGoBackButton": true,
    "showProductCategories": true,
    "layout": "simpleType",
    "marginTop": 0,
    "autoPlayGallery": false,
    "height": 0.6,
    "showVideo": true,
    "showStockQuantity": true,
    "showRelatedProduct": true,
    "showSku": true,
    "showRelatedProductFromSameStore": true,
    "limitDayBooking": 14,
    "showAddToCartInSearchResult": true,
    "hideInvalidAttributes": false,
    "borderRadius": 3,
    "AutoSelectFirstAttribute": true
  },
  "blogDetail": {
    "showComment": true,
    "showSharing": true,
    "showTextAdjustment": true,
    "enableAudioSupport": false,
    "showHeart": true
  },
  "productVariantLayout": {
    "height": "option",
    "size": "box",
    "color-image": "image",
    "color": "color"
  },
  "productAddons": {
    "allowImageType": true,
    "allowCustomType": true,
    "allowMultiple": false,
    "allowedCustomType": ["png", "pdf", "docx"],
    "fileUploadSizeLimit": 5,
    "allowVideoType": true
  },
  "cartDetail": {"minAllowTotalCartValue": 0, "maxAllowQuantity": 10},
  "productVariantLanguage": {
    "en": {
      "color": "Color",
      "size": "Size",
      "color-image": "Color",
      "height": "Height"
    },
    "ar": {
      "height": "ارتفاع",
      "size": "بحجم",
      "color-image": "اللون",
      "color": "اللون"
    },
    "vi": {
      "size": "Kích thước",
      "color": "Màu",
      "color-image": "Màu",
      "height": "Chiều Cao"
    }
  },
  "excludedCategory": 311,
  "saleOffProduct": {
    "Color": "#C7222B",
    "HideEmptySaleOffLayout": false,
    "ShowCountDown": true
  },
  "notStrictVisibleVariant": true,
  "configChat": {
    "UseRealtimeChat": false,
    "version": "2",
    "hideOnScreens": [],
    "EnableSmartChat": false,
    "showOnScreens": ["profile"]
  },
  "smartChat": [
    {
      "description": "Realtime Chat",
      "imageData":
          "https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a392cceb1b534aa92a83e/previews/611a392dceb1b534aa92a84d/download",
      "app": "firebase"
    },
    {
      "iconData": "whatsapp",
      "description": "WhatsApp",
      "app": "https://wa.me/849908854"
    },
    {"description": "Call Us", "iconData": "phone", "app": "tel:8499999999"},
    {"iconData": "sms", "app": "sms://8499999999", "description": "Send SMS"},
    {
      "description": "Tawk Chat",
      "app": "https://tawk.to/chat/5d830419c22bdd393bb69888/default",
      "iconData": "whatsapp"
    },
    {
      "description": "Facebook Chat",
      "iconData": "facebookMessenger",
      "app": "http://m.me/inspireui"
    },
    {
      "description": "Twitter Chat",
      "imageData":
          "https://trello.com/1/cards/611a38c89ebde41ec7cf10e2/attachments/611a38d026894f10dc1091c8/previews/611a38d126894f10dc1091d6/download",
      "app":
          "https://twitter.com/messages/compose?recipient_id=821597032011931648"
    }
  ],
  "adminEmail": "admininspireui@gmail.com",
  "adminName": "InspireUI",
  "deliveryConfig": {
    "appLogo": "assets/images/app_icon_transparent.png",
    "enableSystemNotes": false,
    "appName": "FluxStore Delivery",
    "dashboardName2": "Delivery",
    "dashboardName1": "FluxStore"
  },
  "managerConfig": {
    "enableDeliveryFeature": false,
    "appLogo": "assets/images/app_icon_transparent.png",
    "appName": "FluxStore Admin"
  },
  "loadingIcon": {
    "size": 30.325473519258715,
    "layout": "spinkit",
    "type": "doubleBounce"
  },
  "splashScreen": {
    "enable": true,
    "backgroundColor": "#ffffff",
    "type": "flare",
    "boxFit": "contain",
    "animationName": "Quickers",
    "image": "assets/images/splashscreen.flr",
    "paddingBottom": 0,
    "paddingTop": 0,
    "paddingRight": 0,
    "paddingLeft": 0,
    "duration": 2000
  },
  "darkConfig": {"MainColor": "#3FC1BE", "secondaryColor": "ff5c8018"},
  "addressFields": [
    {
      "type": "firstName",
      "editable": true,
      "defaultValue": "",
      "visible": true,
      "required": true,
      "position": 1
    },
    {
      "required": true,
      "visible": true,
      "type": "lastName",
      "editable": true,
      "defaultValue": "",
      "position": 2
    },
    {
      "editable": true,
      "required": true,
      "type": "phoneNumber",
      "visible": true,
      "position": 3,
      "defaultValue": ""
    },
    {
      "position": 4,
      "required": true,
      "defaultValue": "",
      "visible": true,
      "editable": true,
      "type": "email"
    },
    {"position": 5, "visible": true, "type": "searchAddress"},
    {"visible": true, "type": "selectAddress", "position": 6},
    {"type": "country", "visible": true, "position": 7},
    {"position": 8, "visible": true, "type": "state"},
    {
      "defaultValue": "",
      "required": true,
      "editable": true,
      "type": "city",
      "visible": true,
      "position": 9
    },
    {
      "visible": true,
      "position": 10,
      "required": false,
      "editable": true,
      "defaultValue": "",
      "type": "apartment"
    },
    {
      "editable": true,
      "defaultValue": "",
      "position": 11,
      "type": "block",
      "required": false,
      "visible": true
    },
    {
      "editable": true,
      "position": 12,
      "required": true,
      "defaultValue": "",
      "type": "street",
      "visible": true
    },
    {
      "type": "zipCode",
      "defaultValue": "",
      "visible": true,
      "position": 13,
      "required": true,
      "editable": true
    }
  ],
  "enableOnBoarding": false,
  "productCard": {
    "showCartButton": false,
    "enableRating": true,
    "boxFit": "cover",
    "showCartButtonWithQuantity": true,
    "borderRadius": 3,
    "hideStore": true,
    "hideTitle": false,
    "showCartIcon": true,
    "showCartIconColor": false,
    "hidePrice": false
  },
  "lightConfig": {"MainColor": "ff174732"}
};
