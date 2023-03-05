import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '../../models/index.dart' show AdvertisementItem, AdvertisementProvider;

abstract class AdvertisementBase {
  AdvertisementProvider get adsProvider;

  void showAd({
    required AdvertisementItem adItem,
  });

  void hideAd(String adId) {
    EasyDebounce.cancel(adId);
  }

  Widget createAdWidget({
    required AdvertisementItem adItem,
  });
}
