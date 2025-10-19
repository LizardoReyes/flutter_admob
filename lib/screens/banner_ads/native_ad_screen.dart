import 'package:example_admob_ios_android/services/ads_services/native_ad_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdScreen extends StatefulWidget {
  const NativeAdScreen({super.key});

  @override
  State<NativeAdScreen> createState() => _NativeAdScreenState();
}

class _NativeAdScreenState extends State<NativeAdScreen> {
  static const double _insets = 16;
  final List<String> _demoItems = List.generate(
    25,
    (index) => 'Content Items ${index + 1}',
  );
  static const int _adInterval = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Native Ads Screen",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(_insets),
        child: ListView.builder(
          itemCount: _getAdjustedItemCount(),
          itemBuilder: (context, index) {
            if (_shouldShowAdAt(index)) {
              return _buildAdItem();
            }
            final contentIndex = _getContentIndex(index);
            return _buildContentItem(contentIndex);
          },
        ),
      ),
    );
  }

  int _getAdjustedItemCount() {
    final int adCount = (_demoItems.length / _adInterval).floor();
    return _demoItems.length + adCount;
  }

  bool _shouldShowAdAt(int index) {
    return (index + 1) % (_adInterval + 1) == 0;
  }

  int _getContentIndex(int index) {
    final int numberOfAdsBefore = (index / (_adInterval + 1)).floor();
    return index - numberOfAdsBefore;
  }

  Widget _buildAdItem() {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 500)), // simula carga
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(height: 300); // espacio reservado
        }
        return NativeAdService(
          height: MediaQuery.of(context).size.width * 0.75,
          templateType: TemplateType.medium,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildContentItem(int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          _demoItems[index],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Details For Item #${index + 1}'),
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Text('${index + 1}'),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Selected: ${_demoItems[index]}"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
