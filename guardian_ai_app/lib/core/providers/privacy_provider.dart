import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyPreferences {
  final bool visibleMonitoring;
  final bool localOCR;
  final bool cloudAnalysisConsent;
  final bool biometricLock;

  PrivacyPreferences({
    required this.visibleMonitoring,
    required this.localOCR,
    required this.cloudAnalysisConsent,
    required this.biometricLock,
  });

  PrivacyPreferences copyWith({
    bool? visibleMonitoring,
    bool? localOCR,
    bool? cloudAnalysisConsent,
    bool? biometricLock,
  }) {
    return PrivacyPreferences(
      visibleMonitoring: visibleMonitoring ?? this.visibleMonitoring,
      localOCR: localOCR ?? this.localOCR,
      cloudAnalysisConsent: cloudAnalysisConsent ?? this.cloudAnalysisConsent,
      biometricLock: biometricLock ?? this.biometricLock,
    );
  }
}

class PrivacyNotifier extends StateNotifier<PrivacyPreferences> {
  PrivacyNotifier() : super(PrivacyPreferences(
    visibleMonitoring: true,
    localOCR: true,
    cloudAnalysisConsent: true,
    biometricLock: true,
  ));

  void toggleVisibleMonitoring(bool val) => state = state.copyWith(visibleMonitoring: val);
  void toggleLocalOCR(bool val) => state = state.copyWith(localOCR: val);
  void toggleCloudAnalysis(bool val) => state = state.copyWith(cloudAnalysisConsent: val);
  void toggleBiometricLock(bool val) => state = state.copyWith(biometricLock: val);
}

final privacyProvider = StateNotifierProvider<PrivacyNotifier, PrivacyPreferences>((ref) {
  return PrivacyNotifier();
});
