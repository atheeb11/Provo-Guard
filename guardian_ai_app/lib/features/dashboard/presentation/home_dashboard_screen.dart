import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../domain/models/threat_model.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  List<ThreatModel> _threats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThreatData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchProfileFromApi();
    });
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
    final profile = ref.watch(profileProvider);
    final firstName = profile.fullName.trim().split(' ').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF0075FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset('assets/images/shield_badge.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'PROVO GUARD',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A2540), letterSpacing: 0.5),
                ),
                Text(
                  'Think Before You Act',
                  style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.people_alt_outlined, color: Color(0xFF0A2540), size: 20),
              onPressed: () => context.push('/parent-dashboard'),
              tooltip: 'Parent Dashboard',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.shield_outlined, color: Color(0xFF0A2540), size: 20),
              onPressed: () => context.push('/privacy-center'),
              tooltip: 'Privacy Center',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadThreatData();
          await ref.read(profileProvider.notifier).fetchProfileFromApi();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Greeting & Protection Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0075FF), Color(0xFF0052CC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0075FF).withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 86.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${firstName.isNotEmpty ? firstName : "Mubarak"} 👋',
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text('You are protected', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Safety Status: ${maxScore > 70 ? "Action Required" : "Optimal Protection"}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: maxScore > 70 ? const Color(0xFF0075FF) : const Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => context.go('/dashboard/alerts'),
                            child: const Row(
                              children: [
                                Text(
                                  'View Details',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Premium Floating 3D Shield Badge Graphic
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0038A8).withOpacity(0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/shield_badge_transparent.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF10B981),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Ask AI Anything Banner Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0075FF).withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => context.go('/dashboard/ai-chat'),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ask AI Anything', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0A2540))),
                              SizedBox(height: 2),
                              Text(
                                'Check links, suspicious messages\nor security questions',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Section 1: QUICK PROTECTION TOOLS Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'QUICK PROTECTION TOOLS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B), letterSpacing: 0.8),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Text('Customize ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0075FF))),
                        Icon(Icons.grid_view_rounded, size: 14, color: Color(0xFF0075FF)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 2x2 Quick Protection Grid
              Row(
                children: [
                  Expanded(
                    child: _buildQuickToolTile(
                      title: 'Analyze Text',
                      subtitle: 'Conversation Check',
                      icon: Icons.chat_bubble_outline_rounded,
                      iconBg: const Color(0xFFEBF4FF),
                      iconColor: const Color(0xFF0075FF),
                      onTap: () => context.go('/dashboard/analyze'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickToolTile(
                      title: 'Media Scanner',
                      subtitle: 'OCR & Document PII',
                      icon: Icons.image_search_outlined,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF8B5CF6),
                      onTap: () => context.go('/dashboard/analyze'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildQuickToolTile(
                      title: 'Security Alerts',
                      subtitle: 'Phishing & OTP',
                      icon: Icons.notifications_none_outlined,
                      iconBg: const Color(0xFFDCFCE7),
                      iconColor: const Color(0xFF10B981),
                      onTap: () => context.go('/dashboard/alerts'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickToolTile(
                      title: 'Evidence Vault',
                      subtitle: 'AES-256 Storage',
                      icon: Icons.lock_outline_rounded,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFF59E0B),
                      onTap: () => context.push('/vault'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Section 2: RECENT ACTIVITY Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RECENT ACTIVITY',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B), letterSpacing: 0.8),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/dashboard/alerts'),
                    child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0075FF))),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Activity Cards Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0075FF).withOpacity(0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Activity 1: Sextortion WhatsApp (High Risk)
                    _buildActivityItem(
                      iconWidget: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('94', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                      title: 'Sextortion',
                      sourceTag: 'WhatsApp',
                      subtitle: 'Pay \$500 in crypto or I send your...',
                      timeStr: 'Today, 10:24 AM',
                      riskBadge: _buildRiskPill('High Risk', const Color(0xFFFEF2F2), const Color(0xFFEF4444)),
                      onTap: () => context.go('/dashboard/alerts'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFF1F5F9)),

                    // Activity 2: Suspicious Link Detected (Medium Risk)
                    _buildActivityItem(
                      iconWidget: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.link_rounded, color: Color(0xFF0284C7), size: 20),
                      ),
                      title: 'Suspicious Link Detected',
                      subtitle: 'bit.ly/secure-win-now',
                      timeStr: 'Today, 09:15 AM',
                      riskBadge: _buildRiskPill('Medium Risk', const Color(0xFFFFFBEB), const Color(0xFFF59E0B)),
                      onTap: () => context.go('/dashboard/alerts'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFF1F5F9)),

                    // Activity 3: Safe Browsing Enabled (Secure)
                    _buildActivityItem(
                      iconWidget: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.verified_user_outlined, color: Color(0xFF10B981), size: 20),
                      ),
                      title: 'Safe Browsing Enabled',
                      subtitle: 'Protection is active',
                      timeStr: 'Today, 08:30 AM',
                      riskBadge: _buildRiskPill('Secure', const Color(0xFFECFDF5), const Color(0xFF10B981)),
                      onTap: () => context.go('/dashboard/alerts'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // EMERGENCY Red Action Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF3B30), Color(0xFFDC2626)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => context.push('/emergency'),
                  borderRadius: BorderRadius.circular(18),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EMERGENCY',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Need immediate help? Tap here.',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickToolTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0075FF).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0A2540))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required Widget iconWidget,
    required String title,
    String? sourceTag,
    required String subtitle,
    required String timeStr,
    required Widget riskBadge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0A2540))),
                      if (sourceTag != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            sourceTag,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(timeStr, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            riskBadge,
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskPill(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: textCol, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: textCol, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
