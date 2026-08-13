import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/models/threat_model.dart';

class ThreatMonitorScreen extends StatefulWidget {
  const ThreatMonitorScreen({super.key});

  @override
  State<ThreatMonitorScreen> createState() => _ThreatMonitorScreenState();
}

class _ThreatMonitorScreenState extends State<ThreatMonitorScreen> {
  final TextEditingController _inputController = TextEditingController();
  bool _isAnalyzing = false;
  List<ThreatModel> _threats = [];

  @override
  void initState() {
    super.initState();
    _fetchThreats();
  }

  Future<void> _fetchThreats() async {
    final list = await ApiService.getThreatLogs();
    if (mounted) setState(() => _threats = list);
  }

  Future<void> _analyzeInputText() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAnalyzing = true);
    final result = await ApiService.analyzeText(text: text, appSource: 'Manual Scan');

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _threats.insert(0, result);
        _inputController.clear();
      });

      // Navigate to detailed Explainable AI breakdown view
      context.push('/threat-detail', extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THREAT MONITOR & XAI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instant Message Analyzer Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.analytics_outlined, color: AppColors.primaryLightSky, size: 20),
                        SizedBox(width: 8),
                        Text('Instant Threat Analyzer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Paste any suspicious chat message, DM, or email to analyze extortion or grooming risk using Gemini AI.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _inputController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g. "Pay $500 or I post your photos to all followers..."',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: AppColors.darkBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySky,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isAnalyzing ? null : _analyzeInputText,
                        icon: _isAnalyzing
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.bolt, color: Colors.white),
                        label: Text(
                          _isAnalyzing ? 'Analyzing with Gemini AI...' : 'Analyze Threat & Explain Risk',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text('SCANNED INTERACTION HISTORY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.1)),
            const SizedBox(height: 10),

            Expanded(
              child: _threats.isEmpty
                  ? const Center(child: Text('No threats logged yet.'))
                  : ListView.builder(
                      itemCount: _threats.length,
                      itemBuilder: (context, index) {
                        final item = _threats[index];
                        final badgeColor = AppColors.getSeverityColor(item.riskScore);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: badgeColor.withOpacity(0.2),
                              child: Text(
                                '${item.riskScore}',
                                style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.riskLevel.toUpperCase(),
                                    style: TextStyle(fontSize: 10, color: badgeColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                item.explanation,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () => context.push('/threat-detail', extra: item),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
