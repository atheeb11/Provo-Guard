import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/models/threat_model.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  List<ThreatModel> _threats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThreatData();
  }

  Future<void> _loadThreatData() async {
    final threats = await ApiService.getThreatLogs();
    if (mounted) {
      setState(() {
        _threats = threats;
        _isLoading = false;
      });
    }
  }

  int get _highestRiskScore {
    if (_threats.isEmpty) return 12;
    return _threats.map((e) => e.riskScore).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final maxScore = _highestRiskScore;
    final riskColor = AppColors.getSeverityColor(maxScore);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryRoyalBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.primaryRoyalBlue, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Provo Guard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Think Before You Act', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.supervisor_account_outlined),
            onPressed: () => context.push('/parent-dashboard'),
            tooltip: 'Parent Dashboard',
          ),
          IconButton(
            icon: const Icon(Icons.privacy_tip_outlined),
            onPressed: () => context.push('/privacy-center'),
            tooltip: 'Privacy Center',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadThreatData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Greeting & Protection Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryRoyalBlue, AppColors.secondaryIndigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRoyalBlue.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi, Alex 👋', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('You are protected', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 26),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.accentMint, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Safety Status: ${maxScore > 70 ? "Action Required" : "You are Safe"}',
                            style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Ask AI Quick Prompt Bar
              Card(
                child: InkWell(
                  onTap: () => context.go('/dashboard/ai-chat'),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRoyalBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.psychology_rounded, color: AppColors.primaryRoyalBlue, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ask AI Anything', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 2),
                              Text('Check links, suspicious messages or security questions', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondaryLight),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions Grid (2x2)
              const Text('QUICK PROTECTION TOOLS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondaryLight, letterSpacing: 1.1)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickTile(
                      context,
                      title: 'Analyze Text',
                      subtitle: 'Conversation Check',
                      icon: Icons.chat_bubble_outline_rounded,
                      color: AppColors.primaryRoyalBlue,
                      onTap: () => context.go('/dashboard/analyze'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickTile(
                      context,
                      title: 'Media Scanner',
                      subtitle: 'OCR & Document PII',
                      icon: Icons.image_search_rounded,
                      color: AppColors.secondaryIndigo,
                      onTap: () => context.go('/dashboard/analyze'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickTile(
                      context,
                      title: 'Security Alerts',
                      subtitle: 'Phishing & OTP',
                      icon: Icons.notifications_active_outlined,
                      color: AppColors.supportSky,
                      onTap: () => context.go('/dashboard/alerts'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickTile(
                      context,
                      title: 'Evidence Vault',
                      subtitle: 'AES-256 Storage',
                      icon: Icons.lock_clock_outlined,
                      color: Colors.amber,
                      onTap: () => context.push('/vault'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Activity Stream
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('RECENT ACTIVITY LOGS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondaryLight, letterSpacing: 1.1)),
                  TextButton(
                    onPressed: () => context.go('/dashboard/alerts'),
                    child: const Text('View All', style: TextStyle(color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _threats.length,
                      itemBuilder: (context, index) {
                        final threat = _threats[index];
                        final badgeColor = AppColors.getSeverityColor(threat.riskScore);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: badgeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${threat.riskScore}',
                                  style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(threat.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBackground,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.lightBorder),
                                  ),
                                  child: Text(threat.appSource, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                threat.scannedTextSnippet,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryLight),
                            onTap: () => context.push('/threat-detail', extra: threat),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
            ],
          ),
        ),
      ),
    );
  }
}
