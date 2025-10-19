import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdService extends StatefulWidget {
  final double height;
  final TemplateType templateType;
  final BoxDecoration? decoration;
  final Widget? loadingWidget;
  const NativeAdService({
    super.key,
    this.height = 100,
    this.templateType = TemplateType.small,
    this.decoration,
    this.loadingWidget,
  });

  @override
  State<NativeAdService> createState() => _NativeAdServiceState();
}

class _NativeAdServiceState extends State<NativeAdService>
    with WidgetsBindingObserver {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _createAndLoadAd();
    WidgetsBinding.instance.addObserver(this);
  }

  void _createAndLoadAd() {
    _nativeAd = NativeAd(
      adUnitId: AdHelper.getNativeAdUnitId(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
          debugPrint("Native ad loaded successfully");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Native ad failed to load: ${error.message}');
        },
        onAdOpened: (ad) => debugPrint('Native ad opened'),
        onAdClosed: (ad) => debugPrint('Native ad closed'),
        onAdImpression: (ad) => debugPrint('Native ad impression recorded'),
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
      ),
    );
    _nativeAd!.load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_nativeAd == null) {
        _createAndLoadAd();
      }
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return widget.loadingWidget ??
          SizedBox(
            height: widget.height,
            child: const Center(child: LinearProgressIndicator()),
          );
    }
    return Container(
      decoration: widget.decoration,
      constraints: BoxConstraints(
        maxHeight: widget.height,
        minHeight: widget.height,
      ),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
