import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../common/constants.dart';
import '../models/entities/address.dart';
import '../models/entities/blog.dart';
import '../models/entities/fstore_notification.dart';
import '../models/entities/product.dart';
import '../models/entities/user.dart';
import '../services/service_config.dart';
import 'secure_storage.dart';

part 'boxes/common/box_keys.dart';

part 'boxes/common/flux_box.dart';

part 'boxes/common/web_box.dart';

part 'boxes/common/mixin/encryption.dart';

part 'boxes/common/mixin/periodically_clean.dart';

/// Define all Hive boxes below.

/// [SettingsBox] store general settings.
part 'boxes/settings.dart';

/// Store general settings (dark mode, finished onboarding,...).
part 'boxes/settings/general_extension.dart';

/// Store locale-related settings (language, currency,...).
part 'boxes/settings/locale_extension.dart';

/// Store media-related settings (image, audio, video,...).
part 'boxes/settings/media_extension.dart';

/// [UserBox] stores all user-related settings (logged-in user, wishlist,...),
/// which should be cleared upon logout using `UserBox().cleanUpForLogout()`.
/// This box is encrypted ([isEncrypted] is `true`).
part 'boxes/user.dart';

/// Store general user settings (logged-in user, user's info,...).
part 'boxes/user/general_extension.dart';

/// Store user's commerce data (order, wishlist,...).
part 'boxes/user/commerce_extension.dart';

/// Store user's data for POS features.
part 'boxes/user/pos_extension.dart';

/// [CacheBox] stores cache for faster loading.
/// This box should be cleared periodically.
part 'boxes/cache.dart';

part 'boxes/cache/general_extension.dart';

/// Store cache for commerce data (products, categories,...).
part 'boxes/cache/commerce_extension.dart';

/// Store cache for blog posts.
part 'boxes/cache/blog_extension.dart';

/// End of Hive boxes.

/// Set [kDisableWebCookies] to true to use [WebBox].
/// [WebBox] is only used for Shopify Builder.
const bool kDisableWebCookies = false;

Future<void> initBoxes() async {
  await SecureStorage().init();

  final subDir = ServerConfig().isBuilder ? 'FluxBuilder' : null;
  await Hive.initFlutter(subDir);

  await SettingsBox().init();
  await UserBox().init();
  await CacheBox().init();
}
