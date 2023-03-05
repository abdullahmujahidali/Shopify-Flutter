part of '../../boxes.dart';

class BoxKeys {
  /// Hive Box Names.
  static const String hiveSettingsBox = 'fstore_settings';
  static const String hiveUserBox = 'fstore_user';
  static const String hiveCacheBox = 'fstore_cache';

  static const String hiveBoxDefaultEncryptionKey = 'hiveBoxDefaultEncryptionKey';
  static const String hiveUserBoxEncryptionKey = 'hiveUserBoxEncryptionKey';
  static const String hiveBoxCleanIntervalPrefix = 'hive_box_clean_interval_';

  /// [SettingsBox] - General Settings.
  static const String isLoggedIn = 'isLoggedIn';
  static const String isDarkTheme = 'isDarkTheme';
  static const String hasFinishedOnboarding = 'hasFinishedOnboarding';
  static const String posAddress = 'posAddress';
  static const String popupBannerLastUpdatedTime = 'popupBannerLastUpdatedTime';

  /// [SettingsBox] - Locale Settings.
  static const String currencyCode = 'currencyCode';
  static const String currency = 'currency';
  static const String languageCode = 'language';
  static const String countryCode = 'countryCode';
  static const String countries = 'countries';

  /// [SettingsBox] - Media Settings.
  static const String autoPlayAudio = 'autoPlayAudio';
  static const String listAudioQueueKey = 'listAudioQueueKey';

  /// [UserBox] - General Settings.
  static const String userCookie = 'userCookie';
  static const String notification = 'notification';
  static const String hasAgreedPrivacy = 'hasAgreedPrivacy';
  static const String hasAnswerAgeRestriction = 'hasAnswerAgeRestriction';
  static const String userInfo = 'userInfo';
  static const String deliveryUser = 'deliveryUser';
  static const String vendorUser = 'vendorUser';
  static const String opencartCookie = 'opencartCookie';

  /// [UserBox] - Commerce Settings
  static const String savedCoupon = 'savedCoupon';
  static const String orders = 'orders';
  static const String recentProducts = 'recentProducts';
  static const String recentSearches = 'recentSearches';
  static const String recentBlogsSearch = 'recentBlogSearch';
  static const String productsInCart = 'productsInCart';
  static const String wishList = 'wishList';
  static const String blogWishList = 'blogWishList';
  static const String shippingAddress = 'shippingAddress';
  static const String addresses = 'addresses';

  /// [UserBox] - POS Settings
  static const String selectedPrinter = 'selectedPrinter';

  /// [CacheBox] - General Settings
  static const String instagramCacheKeyPrefix = 'instagram_';
  static const String shopCategoryCacheKeyPrefix = 'shop_category_';
  static const String vendorCategories = 'vendorCategories';
}
