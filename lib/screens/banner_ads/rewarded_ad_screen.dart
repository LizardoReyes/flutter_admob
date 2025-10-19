import 'package:example_admob_ios_android/services/ads_services/rewarded_ad_service.dart';
import 'package:flutter/material.dart';

class RewardedAdScreen extends StatefulWidget {
  const RewardedAdScreen({super.key});

  @override
  State<RewardedAdScreen> createState() => _RewardedAdScreenState();
}

class _RewardedAdScreenState extends State<RewardedAdScreen> {
  int _rewardedAdPoints = 0;
  bool _isAdLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rewarded Ad Screen",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Current Points: $_rewardedAdPoints",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            RewardedAdService(
              onUserEarnedReward: (reward) {
                setState(() {
                  _rewardedAdPoints = reward.amount.toInt() + _rewardedAdPoints;
                });
              },
              onAdClosed: (success) {
                if (!success) {
                  setState(() {
                    _isAdLoading = false;
                  });
                }
              },
              loadingAdWidget: _isAdLoading
                  ? const SizedBox(
                      height: 50,
                      width: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : null,
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Watch Ad For Reward",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
