import 'dart:async';

import 'package:example_admob_ios_android/services/ads_services/interstitial_ad_service.dart';
import 'package:flutter/material.dart';

class InterstitialAdScreen extends StatefulWidget {
  const InterstitialAdScreen({super.key});

  @override
  State<InterstitialAdScreen> createState() => _InterstitialAdScreenState();
}

class _InterstitialAdScreenState extends State<InterstitialAdScreen>
    with WidgetsBindingObserver {
  final InterstitialAdService _interstitialAdService = InterstitialAdService();
  int _clickCount = 0;

  Timer? _uiRefreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _interstitialAdService.setCooldownParameters(
      secondsBetweenAds: 30,
      actionBetweenAds: 1,
    );
    _loadInterstitialAd();

    _uiRefreshTimer = Timer.periodic(const Duration(microseconds: 500), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!_interstitialAdService.isLoaded &&
          !_interstitialAdService.isLoading) {
        _loadInterstitialAd();
      }
    }
  }

  Future<void> _loadInterstitialAd() async {
    if (_interstitialAdService.isLoaded || _interstitialAdService.isLoading) {
      return;
    }
    try {
      await _interstitialAdService.loadAd();
    } catch (e) {
      debugPrint("Error loading interstitial ad: $e");
    }
  }

  void _handleButtonClic() async {
    setState(() {
      _clickCount++;
    });

    _interstitialAdService.increcrementActionCounter();

    bool adShown = await _interstitialAdService.showAdIfReady();

    if (!adShown) {
      if (mounted) {
        String message = !_interstitialAdService.isLoaded
            ? 'Ad is not ready yet please wait'
            : 'Please Wait before showing another ad';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  String _getTimeUntilNextAd() {
    DateTime? lastShownTime = _interstitialAdService.lastAdShownTime;

    if (lastShownTime == null) {
      return "Ready to show ad";
    }

    Duration timeSinceLastAd = DateTime.now().difference(lastShownTime);
    Duration timeRemaining =
        Duration(seconds: _interstitialAdService.coolDownSeconds) -
        timeSinceLastAd;
    if (timeRemaining.isNegative) {
      return "Ready to show ad";
    }

    int seconds = timeRemaining.inSeconds;
    return "${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _uiRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdLoaded = _interstitialAdService.isLoaded;
    final bool isAdLoading = _interstitialAdService.isLoading;
    return Scaffold(
      appBar: AppBar(
        title: Text("Interstitial Ads", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$_clickCount Times"),
            Text("Next Ad : ${_getTimeUntilNextAd()}"),
            if (isAdLoading)
              Text('Ad is Loading')
            else
              Text(isAdLoaded ? "Ad Is Ready" : " Preparing Ad"),
            ElevatedButton(onPressed: _handleButtonClic, child: Text("Click")),
          ],
        ),
      ),
    );
  }
}
