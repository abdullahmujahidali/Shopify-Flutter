import 'package:flutter/foundation.dart';

enum AdvertisementType { banner, reward, native, interstitial }

extension AdvertisementTypeExtension on AdvertisementType {
  String get content => describeEnum(this);
}

enum AdvertisementProvider { facebook, google }

extension AdvertisementProviderExtension on AdvertisementProvider {
  String get content => describeEnum(this);
}
