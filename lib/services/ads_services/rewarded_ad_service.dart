import 'package:example_admob_ios_android/utils/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService extends StatefulWidget {
  final void Function(RewardItem reward)? onUserEarnedReward;
  final void Function(bool success)? onAdClosed;
  final Widget? loadingAdWidget;
  final Widget child;
  const RewardedAdService({
    super.key,
    this.onUserEarnedReward,
    this.onAdClosed,
    this.loadingAdWidget,
    required this.child,
  });

  @override
  State<RewardedAdService> createState() => _RewardedAdServiceState();
}

class _RewardedAdServiceState extends State<RewardedAdService> {
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    if (_isAdLoading) {
      return;
    }
    setState(() {
      _isAdLoading = true;
    });

    RewardedAd.load(
      adUnitId: AdHelper.getRewardedUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('Rewarded ad loaded.');
          _rewardedAd = ad;
          _setupFullScreenCallback();
          setState(() {
            _isAdLoading = false;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded ad failed to load: $error');
          setState(() {
            _isAdLoading = false;
          });
        },
      ),
    );
  }

  void _setupFullScreenCallback() {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Ad showed full screen content.');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('Ad dismissed full screen content.');
        ad.dispose();
        _rewardedAd = null;
        widget.onAdClosed?.call(false);
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Ad failed to show full screen content: $error');
        ad.dispose();
        _rewardedAd = null;
        widget.onAdClosed?.call(false);
        _loadRewardedAd();
      },
      onAdImpression: (ad) {
        debugPrint('Ad impression recorded.');
      },
    );
  }

  void showRewardedAd() {
    debugPrint('Attempt to show rewarded ad before it was loaded.');
    if (_rewardedAd == null) {
      widget.onAdClosed?.call(false);
      _loadRewardedAd();
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        widget.onUserEarnedReward?.call(reward);
        widget.onAdClosed?.call(true);
      },
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isAdLoading ? null : showRewardedAd,
      child: _isAdLoading && widget.loadingAdWidget != null
          ? widget.loadingAdWidget!
          : widget.child,
    );
  }
}
