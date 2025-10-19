import 'dart:async';

import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _interstitialAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  DateTime? _lastAdShownTime;
  int _actionCounter = 0;
  int _minSecondsBetweenAds = 30;
  int _minActionBetweenAds = 3;
  final int _maxRetryAttempys = 3;
  int _retryAttempts = 0;

  static final InterstitialAdService _instance =
      InterstitialAdService._internal();
  factory InterstitialAdService() => _instance;
  InterstitialAdService._internal();

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  DateTime? get lastAdShownTime => _lastAdShownTime;
  int get coolDownSeconds => _minSecondsBetweenAds;
  int get requireActionCount => _minActionBetweenAds;
  int get currentActionCount => _actionCounter;

  Future<void> loadAd() async {
    if (_isLoaded || _isLoading) {
      return;
    }
    _isLoading = true;

    await InterstitialAd.load(
      adUnitId: AdHelper.getInterstitialUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint("Interstitial ad loaded");
          _interstitialAd = ad;
          _isLoaded = true;
          _isLoading = false;
          _retryAttempts = 0;

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  debugPrint("Ad is Dismissed");
                  _dispose();
                  loadAd();
                },
                onAdFailedToShowFullScreenContent:
                    (InterstitialAd ad, AdError error) {
                      debugPrint("Failed to show ad: $error");
                      _dispose();
                      loadAd();
                    },
                onAdShowedFullScreenContent: (InterstitialAd ad) {
                  debugPrint("Ad is Shown");
                  _lastAdShownTime = DateTime.now();
                  _actionCounter = 0;
                },
                onAdImpression: (InterstitialAd ad) {
                  debugPrint("Ad impression recorded");
                },
              );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Interstitial ad failed to load: $error");
          _isLoading = false;
          _isLoaded = false;

          if (_retryAttempts < _maxRetryAttempys) {
            _retryAttempts++;
            final retryDelay = Duration(
              microseconds: (1 << _retryAttempts) * 1000,
            );
            debugPrint(
              "Retrying to load interstitial ad in ${retryDelay.inSeconds}s",
            );
            Timer(retryDelay, () {
              loadAd();
            });
          }
        },
      ),
    );
  }

  void increcrementActionCounter() {
    _actionCounter++;
  }

  bool _canShowAd() {
    if (!_isLoaded || _interstitialAd == null) {
      return false;
    }
    if (_lastAdShownTime != null) {
      final timeSinceLastAd = DateTime.now()
          .difference(_lastAdShownTime!)
          .inSeconds;
      if (timeSinceLastAd < _minSecondsBetweenAds) {
        debugPrint(
          "Ad cooldown active : ${_minSecondsBetweenAds - timeSinceLastAd}s left",
        );
        return false;
      }
    }
    if (_actionCounter < _minActionBetweenAds) {
      debugPrint("Not enough actions:$_actionCounter/$_minActionBetweenAds");
      return false;
    }
    return true;
  }

  Future<bool> showAdIfReady() async {
    if (!_canShowAd()) {
      if (!_isLoaded && !_isLoading) {
        loadAd();
      }
      return false;
    }
    try {
      await _interstitialAd!.show();
      return true;
    } catch (e) {
      debugPrint("Error showing interstitial ad: $e");
      _dispose();
      loadAd();
      return false;
    }
  }

  void _dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoaded = false;
  }

  void dispose() {
    _dispose();
  }

  void setCooldownParameters({int? secondsBetweenAds, int? actionBetweenAds}) {
    if (secondsBetweenAds != null && secondsBetweenAds > 0) {
      _minSecondsBetweenAds = secondsBetweenAds;
    }
    if (actionBetweenAds != null && actionBetweenAds > 0) {
      _minActionBetweenAds = actionBetweenAds;
    }
  }
}
