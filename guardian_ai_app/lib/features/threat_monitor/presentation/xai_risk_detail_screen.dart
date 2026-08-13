import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/threat_model.dart';

class XAIRiskDetailScreen extends StatelessWidget {
  final ThreatModel threat;
  const XAIRiskDetailScreen({super.key, required this.threat});

  @override
  Widget build(BuildContext context) {
    final severityColor = AppColors.getSeverityColor(threat.riskScore);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPLAINABLE AI (XAI) BREAKDOWN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Risk Badge & Score Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: severityColor, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: severityColor, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        '${threat.riskLevel.toUpperCase()} RISK LEVEL',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: severityColor, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${threat.riskScore} / 100',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: severityColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Threat Classification: ${threat.category}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scanned Snippet Preview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SCANNED MESSAGE TEXT', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '"${threat.scannedTextSnippet}"',
                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Explainable AI Rationale Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.psychology, color: AppColors.primaryLightSky, size: 22),
                        SizedBox(width: 8),
                        Text('Why Gemini AI Flags This Risk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      threat.explanation,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Red Flags List
            if (threat.redFlags.isNotEmpty) ...[
              const Text('DETECTED COERCIVE RED FLAGS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
              const SizedBox(height: 10),
              ...threat.redFlags.map((flag) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.remove_circle, color: AppColors.riskCritical, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(flag, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              )),
              const SizedBox(height: 20),
            ],

            // Actionable Steps
            const Text('RECOMMENDED SAFETY ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
            const SizedBox(height: 10),
            ...threat.actionableSteps.map((step) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(step, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            )),

            const SizedBox(height: 24),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () => context.go('/dashboard/vault'),
                    icon: const Icon(Icons.lock, size: 18),
                    label: const Text('Save to Evidence Vault'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.riskCritical,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => context.push('/emergency'),
                    icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
                    label: const Text('Emergency Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
