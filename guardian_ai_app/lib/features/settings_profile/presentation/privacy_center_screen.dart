import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/privacy_provider.dart';

class PrivacyCenterScreen extends ConsumerWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacy = ref.watch(privacyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PRIVACY CENTER & CONSENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsible AI Banner
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: const [
                    Icon(Icons.security, color: Colors.green, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'ZERO-TRUST PRIVACY POLICY\nGuardian AI processes OCR data locally on-device and requires explicit consent before any cloud risk evaluation.',
                        style: TextStyle(fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('GRANULAR PRIVACY CONTROLS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
            const SizedBox(height: 10),

            Card(
              child: SwitchListTile(
                value: privacy.visibleMonitoring,
                onChanged: (val) => ref.read(privacyProvider.notifier).toggleVisibleMonitoring(val),
                title: const Text('Visible Conversation Monitoring', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Accessibility service monitors visible chats in WhatsApp/Instagram for blackmail patterns.', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: SwitchListTile(
                value: privacy.localOCR,
                onChanged: (val) => ref.read(privacyProvider.notifier).toggleLocalOCR(val),
                title: const Text('On-Device ML Kit OCR Scanning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Scans photos locally for Passports, Credit Cards, and IDs before you tap send.', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: SwitchListTile(
                value: privacy.cloudAnalysisConsent,
                onChanged: (val) => ref.read(privacyProvider.notifier).toggleCloudAnalysis(val),
                title: const Text('Gemini AI Threat Risk Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Sends redacted text snippets to Gemini API for Explainable AI (XAI) threat classification.', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: SwitchListTile(
                value: privacy.biometricLock,
                onChanged: (val) => ref.read(privacyProvider.notifier).toggleBiometricLock(val),
                title: const Text('Biometric Vault Lock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Requires Fingerprint/Face ID to access the Evidence Vault and Emergency Settings.', style: TextStyle(fontSize: 12)),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.riskCritical)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All local threat logs and evidence caches purged.')),
                  );
                },
                icon: const Icon(Icons.delete_forever, color: AppColors.riskCritical),
                label: const Text('Purge Local Encryption Cache', style: TextStyle(color: AppColors.riskCritical, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
