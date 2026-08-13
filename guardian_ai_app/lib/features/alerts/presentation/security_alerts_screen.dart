import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SecurityAlertsScreen extends StatefulWidget {
  const SecurityAlertsScreen({super.key});

  @override
  State<SecurityAlertsScreen> createState() => _SecurityAlertsScreenState();
}

class _SecurityAlertsScreenState extends State<SecurityAlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 'alt_1',
      'title': 'Suspicious Phishing SMS Detected',
      'category': 'Scam Detection',
      'time': '10 mins ago',
      'snippet': 'Your bank account has been locked! Tap link to verify credentials: http://bank-secure-verify.xyz',
      'whyRisky': [
        'Sender is an unknown unverified phone number',
        'Contains malicious fake link pointing to unverified domain',
        'Urgency tactic claiming account lock'
      ],
      'severity': 'HIGH',
      'color': AppColors.riskHigh,
    },
    {
      'id': 'alt_2',
      'title': 'Unrecognized OTP Request Alert',
      'category': 'OTP Alert',
      'time': '2 hours ago',
      'snippet': 'WhatsApp verification code requested for a new device.',
      'whyRisky': ['If you did not request this, someone may be attempting account takeover.'],
      'severity': 'MEDIUM',
      'color': AppColors.riskMedium,
    },
    {
      'id': 'alt_3',
      'title': 'New Device Login Detected',
      'category': 'Account Security',
      'time': 'Yesterday',
      'snippet': 'Logged in from Chrome on Windows (San Francisco, CA)',
      'whyRisky': ['Verify if this was you or revoke session immediately.'],
      'severity': 'LOW',
      'color': AppColors.riskLow,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('SECURITY ALERTS & TIMELINE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          final alt = _alerts[index];
          final color = alt['color'] as Color;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                        child: Icon(Icons.shield_outlined, color: color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(alt['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      Text(alt['time'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightBorder),
                    ),
                    child: Text(alt['snippet'] as String, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                  ),
                  const SizedBox(height: 14),

                  const Text('WHY IS THIS RISKY?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 6),
                  ...(alt['whyRisky'] as List<String>).map((reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fiber_manual_record, size: 8, color: AppColors.riskCritical),
                        const SizedBox(width: 8),
                        Expanded(child: Text(reason, style: const TextStyle(fontSize: 12))),
                      ],
                    ),
                  )),

                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked alert as safe.')));
                        },
                        child: const Text('Mark as Safe', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.riskCritical,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        ),
                        onPressed: () {},
                        child: const Text('Report & Block', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
