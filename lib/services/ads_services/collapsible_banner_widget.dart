import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum BannerPosition { top, bottom }

class CollapsibleBannerWidget extends StatefulWidget {
  final BannerPosition position;
  final double loadingHeight;
  final Color? loadingBackgroundColor;
  final Widget? loadingWidget;
  const CollapsibleBannerWidget({
    super.key,
    this.position = BannerPosition.top,
    this.loadingHeight = 50,
    this.loadingBackgroundColor,
    this.loadingWidget,
  });

  @override
  State<CollapsibleBannerWidget> createState() =>
      _CollapsibleBannerWidgetState();
}

class _CollapsibleBannerWidgetState extends State<CollapsibleBannerWidget> {
  BannerAd? _bannerAd;
  // ignore: unused_field
  bool _isAdLoaded = false;
  AdSize? _adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCollapsibleBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadCollapsibleBanner() async {
    if (_bannerAd != null) {
      return;
    }

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );
    if (size == null) {
      return;
    }

    if (mounted) {
      setState(() {
        _adSize = size;
      });
    }

    final collapsiblePosition = widget.position == BannerPosition.top
        ? "top"
        : "bottom";

    final adRequest = AdRequest(extras: {"collapsible": collapsiblePosition});
    _bannerAd = BannerAd(
      adUnitId: AdHelper.getCollapsibleBannerUnitId(),
      request: adRequest,
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("Collapsible Banner Ad loaded");
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Collapsible Banner Ad faiiled to load : $error");
          ad.dispose();
        },
      ),
    );
    await _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _adSize != null) {
      return SizedBox(
        width: _adSize!.width.toDouble(),
        height: _adSize!.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return Container(
        height: widget.loadingHeight,
        color: widget.loadingBackgroundColor ?? Colors.grey[200],
        child:
            widget.loadingWidget ??
            const Center(child: LinearProgressIndicator()),
      );
    }
  }
}
