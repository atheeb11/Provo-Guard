import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LearningCenterScreen extends StatefulWidget {
  const LearningCenterScreen({super.key});

  @override
  State<LearningCenterScreen> createState() => _LearningCenterScreenState();
}

class _LearningCenterScreenState extends State<LearningCenterScreen> {
  int _activeTab = 0; // 0: Modules, 1: Simulator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEARNING & THREAT SIMULATOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Segmented Tab Selector
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Cyber Courses', style: TextStyle(fontWeight: FontWeight.bold))),
                    selected: _activeTab == 0,
                    selectedColor: AppColors.primarySky,
                    onSelected: (selected) => setState(() => _activeTab = 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Fake Chat Simulator', style: TextStyle(fontWeight: FontWeight.bold))),
                    selected: _activeTab == 1,
                    selectedColor: AppColors.primarySky,
                    onSelected: (selected) => setState(() => _activeTab = 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _activeTab == 0 ? _buildModulesList() : _buildSimulatorView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    final modules = [
      {
        'title': 'Recognizing Digital Extortion & Sextortion',
        'category': 'Extortion Shield',
        'duration': '6 min',
        'badge': 'Shield Master',
        'completed': true,
      },
      {
        'title': 'Spotting Catfishing & AI Deepfakes',
        'category': 'Media Literacy',
        'duration': '8 min',
        'badge': 'Deepfake Detective',
        'completed': false,
      },
      {
        'title': 'Grooming & Secrecy Red Flags',
        'category': 'Personal Safety',
        'duration': '5 min',
        'badge': 'Boundary Defender',
        'completed': false,
      },
    ];

    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final mod = modules[index];
        final isCompleted = mod['completed'] as bool;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: isCompleted ? Colors.green.withOpacity(0.2) : AppColors.primarySky.withOpacity(0.2),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.school_outlined,
                color: isCompleted ? Colors.green : AppColors.primaryLightSky,
              ),
            ),
            title: Text(mod['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  Text('${mod['category']} • ${mod['duration']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primarySky.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(mod['badge'] as String, style: const TextStyle(fontSize: 10, color: AppColors.primaryLightSky, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            onTap: () {
              _showQuizModal(context, mod['title'] as String);
            },
          ),
        );
      },
    );
  }

  Widget _buildSimulatorView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.sports_esports_outlined, color: AppColors.primaryLightSky, size: 24),
                SizedBox(width: 10),
                Text('Extortion Chat Practice Scenario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: const Text(
                'Unknown Sender: "I have your Snapchat pictures. Pay \$300 in Bitcoin right now or I send them to all your Instagram followers in 10 minutes."',
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Choose Your Response Strategy:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 10),
            _simulatorOption('Option A: Pay \$300 immediately', false, 'INCORRECT: Extortionists will ask for more money. Never pay.'),
            const SizedBox(height: 8),
            _simulatorOption('Option B: Tap One-Tap Emergency & Lock Vault', true, 'CORRECT! Preserves evidence cryptographically and breaks panic leverage.'),
            const SizedBox(height: 8),
            _simulatorOption('Option C: Beg them not to post', false, 'RISKY: Begging gives the scammer emotional leverage.'),
          ],
        ),
      ),
    );
  }

  Widget _simulatorOption(String text, bool isCorrect, String feedback) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isCorrect ? 'Correct Decision!' : 'Risky Choice', style: TextStyle(color: isCorrect ? Colors.green : AppColors.riskCritical)),
            content: Text(feedback),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          children: [
            Icon(isCorrect ? Icons.check_circle_outline : Icons.error_outline, color: isCorrect ? Colors.green : AppColors.textSecondaryDark, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }

  void _showQuizModal(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              const Text('Interactive Quiz Question:', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
              const SizedBox(height: 10),
              const Text('What is the most critical first step if someone threatens to publish a private photo unless you pay?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primarySky, minimumSize: const Size(double.infinity, 44)),
                onPressed: () => Navigator.pop(context),
                child: const Text('DO NOT Pay, Save Evidence & Block Offender', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}
