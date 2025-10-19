import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  // Enable test ads in debug mode, disable in release mode
  static bool useTestAds = kDebugMode;

  // ! Test IDs
  static const String androidBannerTestId =
      "ca-app-pub-3940256099942544/6300978111";
  static const String iosBannerTestId =
      "ca-app-pub-3940256099942544/2934735716";

  static const String androidAdaptiveBannerTestId =
      "ca-app-pub-3940256099942544/9214589741";
  static const String iosAdaptiveBannerTestId =
      "ca-app-pub-3940256099942544/2435281174";

  static const String androidCollapsibleBannerTestId =
      "ca-app-pub-3940256099942544/2014213617";
  static const String iosCollapsibleBannerTestId =
      "ca-app-pub-3940256099942544/8388050270";

  static const String androidInterstitialTestId =
      "ca-app-pub-3940256099942544/1033173712";
  static const String iosInterstitialTestId =
      "ca-app-pub-3940256099942544/4411468910";

  static const String androidRewardedTestId =
      "ca-app-pub-3940256099942544/5224354917";
  static const String iosRewardedTestId =
      "ca-app-pub-3940256099942544/1712485313";

  static const String androidAppOpenAdTestId =
      "ca-app-pub-3940256099942544/9257395921";
  static const String iosAppOpenAdTestId =
      "ca-app-pub-3940256099942544/5575463023";

  static const String androidNativeAdTestId =
      "ca-app-pub-3940256099942544/2247696110";
  static const String iosNativeAdTestId =
      "ca-app-pub-3940256099942544/3986624511";

  // ! Production IDs
  static const String androidBannerProdId =
      "ca-app-pub-2489147968860162/7870646924";
  static const String iosBannerProdId =
      "ca-app-pub-2489147968860162/1632541633";

  static const String androidInterstitialProdId =
      "ca-app-pub-2489147968860162/8746692437";
  static const String iosInterstitialProdId =
      "ca-app-pub-2489147968860162/3973712053";

  static const String androidRewardedProdId =
      "ca-app-pub-2489147968860162/6002546385";
  static const String iosRewardedProdId =
      "ca-app-pub-2489147968860162/5703039776";

  static const String androidAppOpenAdProdId =
      "ca-app-pub-2489147968860162/9112001430";
  static const String iosAppOpenAdProdId =
      "ca-app-pub-2489147968860162/8412925609";

  static const String androidNativeAdProdId =
      "ca-app-pub-2489147968860162/4776314376";
  static const String iosNativeAdProdId =
      "ca-app-pub-2489147968860162/3415965394";

  static String getBannerUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidBannerTestId : androidBannerProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosBannerTestId : iosBannerProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getAdaptiveBannerUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidAdaptiveBannerTestId : androidBannerProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosAdaptiveBannerTestId : iosBannerProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getCollapsibleBannerUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidCollapsibleBannerTestId : androidBannerProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosCollapsibleBannerTestId : iosBannerProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getInterstitialUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidInterstitialTestId : androidInterstitialProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosInterstitialTestId : iosInterstitialProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getRewardedUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidRewardedTestId : androidRewardedProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosRewardedTestId : iosRewardedProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getAppOpenAdUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidAppOpenAdTestId : androidAppOpenAdProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosAppOpenAdTestId : iosAppOpenAdProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getNativeAdUnitId() {
    if (Platform.isAndroid) {
      return useTestAds ? androidNativeAdTestId : androidNativeAdProdId;
    } else if (Platform.isIOS) {
      return useTestAds ? iosNativeAdTestId : iosNativeAdProdId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
