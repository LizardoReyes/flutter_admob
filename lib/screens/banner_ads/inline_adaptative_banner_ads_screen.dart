import 'package:example_admob_ios_android/services/ads_services/inline_adaptative_banner_ad_widget.dart';
import 'package:flutter/material.dart';

class InlineAdaptiveBannerAdScreen extends StatelessWidget {
  static const double _insets = 16;

  final List<String> _demoItems = List.generate(
    30,
    (index) => ' Content Item ${index + 1}',
  );

  InlineAdaptiveBannerAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inline Adaptive Banner Ad",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _insets),
        child: ListView.builder(
          itemCount: _demoItems.length + 3,
          itemBuilder: (context, index) {
            if (index == 10) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: InlineAdaptiveBannerAdWidget(
                  key: const ValueKey('inline_ad_1'),
                  horizontalPadding: _insets,
                  onAdLoaded: () {
                    debugPrint("First Inline Adaptive Banner Ad Loaded");
                  },
                ),
              );
            } else if (index == 20) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: InlineAdaptiveBannerAdWidget(
                  key: const ValueKey('inline_ad_2'),
                  horizontalPadding: _insets,
                  maxHeight: 250,
                  loadingAdWidget: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
            } else if (index == 30) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: InlineAdaptiveBannerAdWidget(
                  key: const ValueKey('inline_ad_3'),
                  horizontalPadding: _insets,
                ),
              );
            } else {
              int contentIndex = index;
              if (index > 10) contentIndex--;
              if (index > 20) contentIndex--;
              if (index > 30) contentIndex--;
              if (contentIndex < _demoItems.length) {
                return ListTile(
                  title: Text(_demoItems[contentIndex]),
                  subtitle: Text('Tap For More Details'),
                  leading: const Icon(Icons.article_outlined),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected :${_demoItems[contentIndex]}'),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        ),
      ),
    );
  }
}
