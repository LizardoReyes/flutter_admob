import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InlineAdaptiveBannerAdWidget extends StatefulWidget {
  final Widget? loadingAdWidget;

  final Function()? onAdLoaded;
  final Function(LoadAdError)? onAdFailedToLoad;
  final int? maxHeight;
  final double horizontalPadding;
  const InlineAdaptiveBannerAdWidget({
    super.key,
    this.loadingAdWidget,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.maxHeight,
    this.horizontalPadding = 0,
  });

  @override
  State<InlineAdaptiveBannerAdWidget> createState() =>
      _InlineAdaptiveBannerAdWidgetState();
}

class _InlineAdaptiveBannerAdWidgetState
    extends State<InlineAdaptiveBannerAdWidget>
    with WidgetsBindingObserver {
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  @override
  void didChangeMetrics() {
    if (mounted) {
      final orientation = MediaQuery.of(context).orientation;
      if (_currentOrientation != orientation) {
        _currentOrientation = orientation;
        _loadAd();
      }
    }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inlineAdaptiveAd?.dispose();
    super.dispose();
  }

  double get _adWidth {
    return MediaQuery.of(context).size.width - (2 * widget.horizontalPadding);
  }

  Future<void> _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    if (mounted) {
      setState(() {
        _inlineAdaptiveAd = null;
        _isLoaded = false;
        _adSize = null;
      });
    }
    AdSize size;
    if (widget.maxHeight != null) {
      size = AdSize.getInlineAdaptiveBannerAdSize(
        _adWidth.truncate(),
        widget.maxHeight!,
      );
    } else {
      size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        _adWidth.truncate(),
      );
    }
    _inlineAdaptiveAd = BannerAd(
      size: size,
      adUnitId: AdHelper.getAdaptiveBannerUnitId(),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          debugPrint("Inline Adaptive Banner Ad Loaded");
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            debugPrint("Inline Adaptive Banner Ad Size is null");
            return;
          }
          if (mounted) {
            setState(() {
              _inlineAdaptiveAd = bannerAd;
              _isLoaded = true;
              _adSize = size;
            });
          }
          widget.onAdLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Inline Adaptive Banner Ad Failed to Load: $error");
          ad.dispose();
          widget.onAdFailedToLoad?.call(error);
        },
        onAdOpened: (ad) {
          debugPrint("Inline Adaptive Banner Ad Opened");
        },
        onAdClosed: (ad) {
          debugPrint("Inline Adaptive Banner Ad Closed");
        },
        onAdImpression: (ad) {
          debugPrint("Inline Adaptive Banner Ad Impression");
        },
      ),
    );
    try {
      await _inlineAdaptiveAd!.load();
    } catch (e) {
      debugPrint("Error loading Inline Adaptive Banner Ad: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _inlineAdaptiveAd == null || _adSize == null) {
      return widget.loadingAdWidget ??
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
            ),
          );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      width: _adWidth,
      height: _adSize!.height.toDouble(),
      child: AdWidget(ad: _inlineAdaptiveAd!),
    );
  }
}
