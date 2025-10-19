import 'package:example_admob_ios_android/services/ads_services/fixed_banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FixedBannerAdsScreen extends StatelessWidget {
  const FixedBannerAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fixed Banner Ads", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Large Banner Ad 320x100"),
            FixedBannerAdWidget(
              adSize: AdSize.largeBanner,
              loadingAdWidget: SizedBox(
                height: 100,
                child: Center(child: LinearProgressIndicator()),
              ),
            ),

            Text("Medium Rectangle Ad 300x250"),
            FixedBannerAdWidget(
              adSize: AdSize.mediumRectangle,
              loadingAdWidget: SizedBox(
                height: 200,
                child: Center(child: LinearProgressIndicator()),
              ),
            ),

            Text("Full Banner Ad 468x60"),
            FixedBannerAdWidget(
              adSize: AdSize.fullBanner,
              loadingAdWidget: SizedBox(
                height: 80,
                child: Center(child: LinearProgressIndicator()),
              ),
            ),

            Text("Leaderboard Ad 728x90"),
            FixedBannerAdWidget(
              adSize: AdSize.leaderboard,
              loadingAdWidget: SizedBox(
                height: 90,
                child: Center(child: LinearProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
      // ! 320x50
      bottomNavigationBar: SafeArea(
        child: FixedBannerAdWidget(
          adSize: AdSize.banner,
          loadingAdWidget: SizedBox(
            height: 50,
            child: Center(child: LinearProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
