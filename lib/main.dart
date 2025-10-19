import 'dart:io';
import 'package:example_admob_ios_android/screens/banner_ads/collapsible_banner_ad_screen.dart';
import 'package:example_admob_ios_android/screens/banner_ads/fixed_banner_ads_screen.dart';
import 'package:example_admob_ios_android/screens/banner_ads/inline_adaptative_banner_ads_screen.dart';
import 'package:example_admob_ios_android/screens/banner_ads/native_ad_screen.dart';
import 'package:example_admob_ios_android/screens/banner_ads/rewarded_ad_screen.dart';
import 'package:example_admob_ios_android/services/ads_services/app_open_ad_service.dart';
import 'package:example_admob_ios_android/services/ads_services/interstitial_ad_screen.dart';
import 'package:example_admob_ios_android/utils/app_lifecycle_reactor.dart';
import 'package:example_admob_ios_android/utils/tracking_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // Por mobile ads y tracking
  WidgetsFlutterBinding.ensureInitialized();

  // Tracking (solo iOS)
  if (Platform.isIOS) {
    final trackingService = TrackingService();
    await trackingService.initialize();

    if (!kDebugMode) {
      await trackingService.requestTrackingAuthorization();
    }
  }

  // Ads initialization
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['4cfe03b6-ae5f-4d01-8345-d4e8888846c0'],
    ),
  );

  // App Open Ad setup
  final appOpenAdService = AppOpenAdService();
  appOpenAdService.loadAd();
  final appLifecycleReactor = AppLifecycleReactor(
    appOpenAdService: appOpenAdService,
  );
  appLifecycleReactor.listenToAppChanges();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AdMob iOS & Android",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.ad_units),
            trailing: const Icon(Icons.arrow_forward),
            title: const Text("Fixed Banner Ads"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FixedBannerAdsScreen(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.ad_units),
            trailing: const Icon(Icons.arrow_forward),
            title: const Text("Inline Adaptive Banner Ad"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InlineAdaptiveBannerAdScreen(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.ad_units),
            trailing: const Icon(Icons.arrow_forward),
            title: const Text("Collapsible Banner Ads"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CollapsibleBannerAdScreen(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.ad_units),
            trailing: const Icon(Icons.arrow_forward),
            title: const Text("Interstitial Ads"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InterstitialAdScreen(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.ad_units),
            trailing: const Icon(Icons.arrow_forward),
            title: const Text("Rewarded Ads"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RewardedAdScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.ad_units),
            trailing: const Icon(Icons.arrow_forward),
            title: const Text("Native Ads"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NativeAdScreen()),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
