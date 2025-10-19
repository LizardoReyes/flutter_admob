import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FixedBannerAdWidget extends StatefulWidget {
  final AdSize adSize;
  final Widget? loadingAdWidget;
  const FixedBannerAdWidget({
    super.key,
    required this.adSize,
    this.loadingAdWidget,
  });

  @override
  State<FixedBannerAdWidget> createState() => _FixedBannerAdWidgetState();
}

class _FixedBannerAdWidgetState extends State<FixedBannerAdWidget>
    with WidgetsBindingObserver {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createAndLoadAd();
  }

  void _createAndLoadAd() {
    _bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: AdHelper.getBannerUnitId(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
          debugPrint('BannerAd loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
        onAdOpened: (ad) {
          debugPrint('BannerAd opened: ${ad.adUnitId}');
        },
        onAdClosed: (ad) {
          debugPrint('BannerAd closed: ${ad.adUnitId}');
        },
      ),
      request: const AdRequest(),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null) {
      return widget.loadingAdWidget ??
          SizedBox(
            height: widget.adSize.height.toDouble(),
            child: const Center(
              child: Center(child: LinearProgressIndicator()),
            ),
          );
    }
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
