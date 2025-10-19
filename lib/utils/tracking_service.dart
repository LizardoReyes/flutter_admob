import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/widgets.dart';

class TrackingService {
  static final TrackingService _instance = TrackingService._internal();
  factory TrackingService() => _instance;
  TrackingService._internal();

  bool _initialized = false;

  TrackingStatus _status = TrackingStatus.notDetermined;

  TrackingStatus get status => _status;

  bool get isTrackingAuthorized => _status == TrackingStatus.authorized;

  Future<void> initialize() async {
    if (!Platform.isIOS) {
      _initialized = true;
      return;
    }
    try {
      _status = await AppTrackingTransparency.trackingAuthorizationStatus;
      _initialized = true;
    } catch (e) {
      debugPrint('Failed to get tracking status: $e');
    }
  }

  Future<TrackingStatus> requestTrackingAuthorization() async {
    if (!Platform.isIOS) {
      return TrackingStatus.authorized;
    }
    if (!_initialized) {
      await initialize();
    }
    if (_status != TrackingStatus.notDetermined) {
      return _status;
    }
    try {
      _status = await AppTrackingTransparency.requestTrackingAuthorization();
      return _status;
    } catch (e) {
      debugPrint("'Failed to request tracking authorization: $e'");
      return TrackingStatus.notDetermined;
    }
  }

  Future<String> getAdvertisingId() async {
    if (!Platform.isIOS) {
      return "";
    }
    try {
      return await AppTrackingTransparency.getAdvertisingIdentifier();
    } catch (e) {
      debugPrint('Failed to get advertising ID: $e');
      return '';
    }
  }
}
