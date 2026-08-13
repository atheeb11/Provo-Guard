import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool _pushThreats = true;
  bool _emailAlerts = true;
  bool _smsEmergency = true;
  bool _parentAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('NOTIFICATION PREFERENCES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CHANNELS & TRIGGERS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 12),

            Card(
              child: SwitchListTile(
                value: _pushThreats,
                onChanged: (val) => setState(() => _pushThreats = val),
                secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryRoyalBlue),
                title: const Text('Push Threat Warnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Send alerts immediately when visible chat scans detect coercive blackmail or extortion patterns.', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: SwitchListTile(
                value: _emailAlerts,
                onChanged: (val) => setState(() => _emailAlerts = val),
                secondary: const Icon(Icons.mail_outline, color: AppColors.primaryRoyalBlue),
                title: const Text('Email Safety Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Dispatch critical security incident reports directly to your verified email address.', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: SwitchListTile(
                value: _smsEmergency,
                onChanged: (val) => setState(() => _smsEmergency = val),
                secondary: const Icon(Icons.sms_outlined, color: AppColors.primaryRoyalBlue),
                title: const Text('Emergency Contact SMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Automatically ping your selected trusted emergency contacts when Emergency Mode is triggered.', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              child: SwitchListTile(
                value: _parentAlerts,
                onChanged: (val) => setState(() => _parentAlerts = val),
                secondary: const Icon(Icons.supervisor_account_outlined, color: AppColors.primaryRoyalBlue),
                title: const Text('Parental Dashboard Sync', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Instantly share critical threat alerts with connected parent/guardian dashboard profiles.', style: TextStyle(fontSize: 12)),
              ),
            ),
            
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySky,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification preferences saved successfully!', style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop();
                },
                child: const Text('Save Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
