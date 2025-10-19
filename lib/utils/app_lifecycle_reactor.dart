import 'package:example_admob_ios_android/services/ads_services/app_open_ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppLifecycleReactor {
  final AppOpenAdService appOpenAdService;

  AppLifecycleReactor({required this.appOpenAdService});

  void listenToAppChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(
      (state) => _onAppStateChanged(state),
    );
  }

  void _onAppStateChanged(AppState appState) {
    if (appState == AppState.foreground) {
      appOpenAdService.incrementAppOpenCounter();
      appOpenAdService.showAdIfAvailable();
    }
  }
}
