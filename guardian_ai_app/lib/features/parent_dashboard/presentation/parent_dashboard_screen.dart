import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/models/threat_model.dart';
import 'package:intl/intl.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  late Future<List<ThreatModel>> _threatLogsFuture;

  @override
  void initState() {
    super.initState();
    _threatLogsFuture = ApiService.getThreatLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('PARENT / GUARDIAN DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: FutureBuilder<List<ThreatModel>>(
        future: _threatLogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Error loading dashboard: ${snapshot.error}'),
              ),
            );
          }

          final logs = snapshot.data ?? [];
          final criticalCount = logs.where((l) => l.riskLevel.toLowerCase() == 'critical').length;
          final highCount = logs.where((l) => l.riskLevel.toLowerCase() == 'high').length;

          // Alerts count
          final totalAlerts = logs.length;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _threatLogsFuture = ApiService.getThreatLogs();
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connected Child Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.primaryRoyalBlue,
                            child: Icon(Icons.person, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Connected Child', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                                Text('Alex Johnson (Teen)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 14),
                                    SizedBox(width: 4),
                                    Text('Protection Active', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Manage', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weekly Summary Cards (2 Grid)
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Alerts Triggers', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                                const SizedBox(height: 8),
                                Text('$totalAlerts', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.riskMedium)),
                                Text('$criticalCount Critical • $highCount High', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('AI Scans Run', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                                const SizedBox(height: 8),
                                Text('${totalAlerts * 2 + 3}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryRoyalBlue)),
                                const Text('Digital literacy active', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('RECENT CHILD PROTECTION ALERTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondaryLight, letterSpacing: 1.1)),
                  const SizedBox(height: 10),

                  if (logs.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text('No active threats or alerts detected.', style: TextStyle(color: AppColors.textSecondaryLight)),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        IconData icon;
                        Color iconColor;
                        if (log.riskLevel.toLowerCase() == 'critical') {
                          icon = Icons.error_rounded;
                          iconColor = AppColors.riskHigh;
                        } else if (log.riskLevel.toLowerCase() == 'high') {
                          icon = Icons.warning_rounded;
                          iconColor = AppColors.riskMedium;
                        } else {
                          icon = Icons.info_rounded;
                          iconColor = AppColors.primaryRoyalBlue;
                        }

                        final formattedTime = DateFormat('MMM d, h:mm a').format(log.timestamp);
                        final snippet = log.scannedTextSnippet.length > 50
                            ? '${log.scannedTextSnippet.substring(0, 47)}...'
                            : log.scannedTextSnippet;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(icon, color: iconColor),
                            title: Text(log.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('Snippet: "$snippet"\nDetected: $formattedTime • Source: ${log.appSource}'),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRoyalBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.phone_rounded, color: Colors.white),
                      label: const Text('Contact Connected Guardian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
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
