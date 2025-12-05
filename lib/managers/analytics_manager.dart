import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsManager {
  final FirebaseAnalytics _analytics;
  bool _analyticsEnabled = false;

  AnalyticsManager({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  /// Check if analytics collection is enabled
  bool get isEnabled => _analyticsEnabled;

  /// Enable or disable analytics collection
  Future<void> setAnalyticsEnabled(bool enabled) async {
    _analyticsEnabled = enabled;
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Log an event only if analytics is enabled
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_analyticsEnabled) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
