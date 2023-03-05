// Enable Facebook Ads
// import 'package:facebook_audience_network/ad/ad_banner.dart';
// import 'package:facebook_audience_network/ad/ad_interstitial.dart';
// import 'package:facebook_audience_network/ad/ad_native.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../common/constants.dart';
// import '../../models/index.dart'
//     show AdvertisementItem, AdvertisementProvider, AdvertisementType;
// import 'advertisement_base.dart';
//
// class FacebookAdvertisement extends AdvertisementBase {
//   @override
//   AdvertisementProvider get adsProvider => AdvertisementProvider.facebook;
//
//   @override
//   void showAd({
//     required AdvertisementItem adItem,
//   }) {
//     switch (adItem.type) {
//       case AdvertisementType.interstitial:
//         FacebookInterstitialAd.loadInterstitialAd(
//           placementId: adItem.id,
//           listener: (result, value) {
//             if (result == InterstitialAdResult.LOADED) {
//               FacebookInterstitialAd.showInterstitialAd(delay: 5000);
//             }
//           },
//         );
//         break;
//       default:
//         break;
//     }
//   }
//
//   Widget createFacebookBannerAd(AdvertisementItem adItem) {
//     return Builder(
//       key: ValueKey(adItem.id),
//       builder: (context) => FacebookBannerAd(
//         placementId: adItem.id,
//         bannerSize: BannerSize.STANDARD,
//         listener: (result, value) {
//           switch (result) {
//             case BannerAdResult.ERROR:
//               printLog('Error: $value');
//               break;
//             case BannerAdResult.LOADED:
//               printLog('Loaded: $value');
//               break;
//             case BannerAdResult.CLICKED:
//               printLog('Clicked: $value');
//               break;
//             case BannerAdResult.LOGGING_IMPRESSION:
//               printLog('Logging Impression: $value');
//               break;
//           }
//         },
//       ),
//     );
//   }
//
//   Widget createFacebookNativeAd(AdvertisementItem adItem) {
//     return FacebookNativeAd(
//         placementId: adItem.id,
//         adType: NativeAdType.NATIVE_AD,
//         width: double.infinity,
//         height: 300,
//         backgroundColor: Colors.blue,
//         titleColor: Colors.white,
//         descriptionColor: Colors.white,
//         buttonColor: Colors.deepPurple,
//         buttonTitleColor: Colors.white,
//         buttonBorderColor: Colors.white,
//         listener: (result, value) {
//           printLog('Native Ad: $result --> $value');
//         });
//   }
//
//   Widget facebookBannerNative(AdvertisementItem adItem) {
//     return FacebookNativeAd(
//       placementId: adItem.id,
//       adType: NativeAdType.NATIVE_BANNER_AD,
//       bannerAdSize: NativeBannerAdSize.HEIGHT_100,
//       width: double.infinity,
//       backgroundColor: Colors.blue,
//       titleColor: Colors.white,
//       descriptionColor: Colors.white,
//       buttonColor: Colors.deepPurple,
//       buttonTitleColor: Colors.white,
//       buttonBorderColor: Colors.white,
//       listener: (result, value) {
//         printLog('Native Ad: $result --> $value');
//       },
//     );
//   }
//
//   @override
//   Widget createAdWidget({required AdvertisementItem adItem}) {
//     switch (adItem.type) {
//       case AdvertisementType.banner:
//         return createFacebookBannerAd(adItem);
//       default:
//         return const SizedBox();
//     }
//   }
// }
