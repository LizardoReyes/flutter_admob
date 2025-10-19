import 'dart:async';

import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {
  AppOpenAd? _appOpenAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  bool _isShowingAd = false;

  DateTime? _lasTadShownTime;
  int _appOpenCounter = 0;

  DateTime? _appOpenLoadTime;
  final Duration maxCacheDuration = Duration(hours: 4);
  int _minSecondsBetweenAds = 30;
  int _minaAppOpenBetweenAds = 2;
  final int _maxRetryAttemts = 3;
  int _retryAttempts = 0;

  static final AppOpenAdService _instance = AppOpenAdService._internal();
  factory AppOpenAdService() => _instance;
  AppOpenAdService._internal();

  String get adUnitId => AdHelper.getAppOpenAdUnitId();

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  bool get isShowingAd => _isShowingAd;

  DateTime? get lastAdShownTime => _lasTadShownTime;
  int get cooldownSeconds => _minSecondsBetweenAds;
  int get requiredAppOpensCount => _minaAppOpenBetweenAds;
  int get currentAppOpenCount => _appOpenCounter;

  bool get isAdAvailable => _appOpenAd != null;

  Future<void> loadAd() async {
    if (_isLoaded || isLoading) {
      return;
    }
    _isLoading = true;
    try {
      await AppOpenAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (AppOpenAd ad) {
            debugPrint("App OpenAd Load Successfully");
            _appOpenAd = ad;
            _appOpenLoadTime = DateTime.now();
            _isLoaded = true;
            _isLoading = false;
            _retryAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint("App OpenAd Failed to Load: $error");
            _isLoading = false;
            _isLoaded = false;
            if (_retryAttempts < _maxRetryAttemts) {
              _retryAttempts++;
              final retryDelay = Duration(
                microseconds: (1 << _retryAttempts) * 1000,
              );
              debugPrint(
                "Retrying to load App OpenAd in ${retryDelay.inSeconds} seconds",
              );
              Timer(retryDelay, () {
                loadAd();
              });
            }
          },
        ),
      );
    } catch (e) {
      debugPrint("Error loading App OpenAd: $e");
      _isLoading = false;
    }
  }

  void incrementAppOpenCounter() {
    _appOpenCounter++;
  }

  bool _canShowAd() {
    if (!isAdAvailable || _isShowingAd) {
      return false;
    }
    if (_appOpenLoadTime != null) {
      if (DateTime.now()
          .subtract(maxCacheDuration)
          .isAfter(_appOpenLoadTime!)) {
        debugPrint("App Open Ad is expired");
        _dispose();
        loadAd();
        return false;
      }
    }
    if (_lasTadShownTime != null) {
      final timeSinceLastAd = DateTime.now()
          .difference(_lasTadShownTime!)
          .inSeconds;
      if (timeSinceLastAd < _minSecondsBetweenAds) {
        debugPrint(
          "ad cooldown active : ${_minSecondsBetweenAds - timeSinceLastAd}",
        );
        return false;
      }
    }

    if (_appOpenCounter < _minaAppOpenBetweenAds) {
      debugPrint(
        "Not enough app opens: $_appOpenCounter/$_minaAppOpenBetweenAds",
      );
      return false;
    }
    return true;
  }

  Future<bool> showAdIfAvailable() async {
    if (!_canShowAd()) {
      if (!_isLoaded && !_isLoading) {
        loadAd();
      }
      return false;
    }
    if (_appOpenAd == null) {
      debugPrint("Tried to show ad before one was loaded");
      return false;
    }
    try {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingAd = true;
          debugPrint("App Open Ad shown");
          _lasTadShownTime = DateTime.now();
          _appOpenCounter = 0;
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _isShowingAd = false;
          _dispose();
          loadAd();
          debugPrint("App Open Ad failed to show: $error");
        },
        onAdDismissedFullScreenContent: (ad) {
          _isShowingAd = false;
          _dispose();
          loadAd();
          debugPrint("App Open Ad dismissed");
        },
        onAdImpression: (ad) {
          debugPrint("App Open Ad impression recorded");
        },
      );
      await _appOpenAd!.show();
      return true;
    } catch (e) {
      debugPrint("Error showing App Open Ad: $e");
      _dispose();
      loadAd();
      return false;
    }
  }

  void _dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isLoaded = false;
  }

  void dispose() {
    _dispose();
  }

  void setCooldownParametrs({int? secondsBetweenAds, int? appOpenBetweenAds}) {
    if (secondsBetweenAds != null && secondsBetweenAds > 0) {
      _minSecondsBetweenAds = secondsBetweenAds;
    }
    if (appOpenBetweenAds != null && appOpenBetweenAds > 0) {
      _minaAppOpenBetweenAds = appOpenBetweenAds;
    }
  }
}
