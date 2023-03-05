import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:inspireui/inspireui.dart';

import '../../models/index.dart'
    show AdvertisementItem, AdvertisementProvider, AdvertisementType;
import 'advertisement_base.dart';

const _preFix = '[Advertisement]: ';

class GoogleAdvertisement extends AdvertisementBase {
  @override
  AdvertisementProvider get adsProvider => AdvertisementProvider.google;

  @override
  Widget createAdWidget({
    required AdvertisementItem adItem,
  }) {
    switch (adItem.type) {
      case AdvertisementType.banner:
        return Builder(
          key: ValueKey<String>(adItem.id),
          builder: (context) {
            final googleBannerAd = BannerAd(
              // Replace the testAdUnitId with an ad unit id from the AdMob dash.
              // https://developers.google.com/admob/android/test-ads
              // https://developers.google.com/admob/ios/test-ads
              adUnitId: adItem.id,
              size: AdSize.banner,
              listener: BannerAdListener(
                onAdLoaded: (Ad ad) {
                  printLog('$ad loaded: ${ad.responseInfo}');
                },
                onAdFailedToLoad: (Ad ad, LoadAdError error) {
                  printLog('Banner failedToLoad: $error');
                  ad.dispose();
                },
              ),
              request: _adRequest,
            )..load();
            return Container(
              alignment: Alignment.bottomCenter,
              width: googleBannerAd.size.width.toDouble(),
              height: googleBannerAd.size.height.toDouble(),
              child: AdWidget(ad: googleBannerAd),
            );
          },
        );
      default:
        return const SizedBox();
    }
  }

  @override
  void showAd({required AdvertisementItem adItem}) {
    EasyDebounce.debounce(
      adItem.id,
      Duration(seconds: adItem.waitingTimeToDisplay),
      () {
        switch (adItem.type) {
          case AdvertisementType.reward:
            _loadRewardAd(adItem);
            break;
          case AdvertisementType.interstitial:
            _loadInterstitialAd(adItem);
            break;
          default:
            break;
        }
      },
    );
  }

  void _loadRewardAd(AdvertisementItem adItem) {
    RewardedAd.load(
      adUnitId: adItem.id,
      request: _adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          printLog('$_preFix $ad loaded.');
          // Keep a reference to the ad so you can show it later.
          ad
            ..fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) =>
                  printLog('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                printLog('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (RewardedAd ad, AdError error) {
                printLog('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
              onAdImpression: (RewardedAd ad) =>
                  printLog('$_preFix $ad impression occurred.'),
            )
            ..show(onUserEarnedReward: (ad, RewardItem rewardItem) {
              // Reward the user for watching an ad.h
            });
        },
        onAdFailedToLoad: (LoadAdError error) {
          printLog('$_preFix RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void _loadInterstitialAd(AdvertisementItem adItem) async {
    late InterstitialAd interstitialAd;
    await InterstitialAd.load(
      adUnitId: adItem.id,
      request: _adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          interstitialAd = ad;
          interstitialAd
            ..fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) =>
                  printLog('$_preFix $ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                printLog('$_preFix $ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                printLog(
                    '$_preFix $ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
              onAdImpression: (InterstitialAd ad) =>
                  printLog('$_preFix $ad impression occurred.'),
            )
            ..show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          printLog('$_preFix InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}

const _adRequest = AdRequest(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  nonPersonalizedAds: false,
);
