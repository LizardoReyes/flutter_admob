import 'package:example_admob_ios_android/services/ads_services/collapsible_banner_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleBannerAdScreen extends StatelessWidget {
  final bool showTopBanner;
  final bool showBottomBanner;
  final Map<String, dynamic>? topBannerParams;
  final Map<String, dynamic>? bottomBannerParams;
  const CollapsibleBannerAdScreen({
    super.key,
    this.showTopBanner = true,
    this.showBottomBanner = true,
    this.topBannerParams,
    this.bottomBannerParams,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Collapsible Banner Ads",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          if (showTopBanner)
            CollapsibleBannerWidget(
              position: BannerPosition.top,
              loadingHeight: topBannerParams?['loadingHeight'] ?? 50,
              loadingBackgroundColor:
                  topBannerParams?['loadingBackgroundColor'],
              loadingWidget: topBannerParams?['loadingWidget'],
            ),
          Expanded(child: Center(child: Text("Collapsible Banner Ads"))),
          if (showBottomBanner)
            CollapsibleBannerWidget(
              position: BannerPosition.bottom,
              loadingHeight: topBannerParams?['loadingHeight'] ?? 50,
              loadingBackgroundColor:
                  topBannerParams?['loadingBackgroundColor'],
              loadingWidget: topBannerParams?['loadingWidget'],
            ),
        ],
      ),
    );
  }
}
