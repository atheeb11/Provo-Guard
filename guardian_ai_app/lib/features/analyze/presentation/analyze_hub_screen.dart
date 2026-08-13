import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/models/threat_model.dart';

class AnalyzeHubScreen extends StatefulWidget {
  const AnalyzeHubScreen({super.key});

  @override
  State<AnalyzeHubScreen> createState() => _AnalyzeHubScreenState();
}

class _AnalyzeHubScreenState extends State<AnalyzeHubScreen> {
  int _activeTab = 0; // 0: Conversation, 1: Media & OCR, 2: Voice Analysis
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  bool _isRecording = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _analyzeText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAnalyzing = true);
    final result = await ApiService.analyzeText(text: text, appSource: 'Manual Scan');

    if (mounted) {
      setState(() => _isAnalyzing = false);
      context.push('/threat-detail', extra: result);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (file != null) {
        setState(() {
          _selectedImage = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to access camera or gallery: $e')),
      );
    }
  }

  void _showMediaSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simulate Photo Scan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.badge_outlined, color: AppColors.primarySky),
              title: const Text('Official Passport Scan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Simulates scanning a passport page containing PII.', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _runMediaAnalysis('passport');
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: AppColors.riskCritical),
              title: const Text('Blackmail Chat Screenshot', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Simulates chat logs containing extortion demand text.', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _runMediaAnalysis('blackmail');
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_outlined, color: Colors.green),
              title: const Text('Safe Family Portrait', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Simulates a safe, clean photograph.', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _runMediaAnalysis('safe');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runMediaAnalysis(String type) async {
    setState(() => _isAnalyzing = true);

    // Simulate scanning delay
    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    ThreatModel threat;
    if (type == 'passport') {
      threat = ThreatModel(
        id: 'ocr_passport_mock',
        riskScore: 65,
        riskLevel: 'Medium',
        category: 'PII Exposure',
        appSource: 'ML Kit OCR Scan',
        scannedTextSnippet: 'PASSPORT SPECIMEN - JOHN DOE - ID NO: 9283748291A - DOB: 12-08-1996',
        explanation: 'MEDIUM RISK: Identity exposure detected. Uploaded document contains Passport number, Full Name, and Date of Birth details which could be used for identity theft.',
        redFlags: ['Official passport ID exposed', 'Sensitive personal info visible'],
        actionableSteps: ['Do not send this image to unverified contacts.', 'Purge this document from insecure local downloads folder.'],
        psychologicalSupport: 'Keep your identity documents private. Protecting your personal data is smart self-defense.',
        timestamp: DateTime.now(),
      );
    } else if (type == 'blackmail') {
      threat = ThreatModel(
        id: 'ocr_blackmail_mock',
        riskScore: 94,
        riskLevel: 'Critical',
        category: 'Sextortion',
        appSource: 'Screenshot Upload',
        scannedTextSnippet: 'Pay \$500 in crypto or I send your private photos to your Instagram followers...',
        explanation: 'CRITICAL WARNING: Blackmail pattern detected. Message contains direct financial extortion threats linked to exposure of private media.',
        redFlags: ['Financial demand', 'Exposure threat', 'Urgency pressure'],
        actionableSteps: ['DO NOT SEND PAYMENT.', 'Keep this screenshot saved in the Evidence Vault.', 'Block the sender account immediately.'],
        psychologicalSupport: 'Take a deep breath. Extortionists rely on panic — remaining calm and locking evidence is your best shield.',
        timestamp: DateTime.now(),
      );
    } else {
      threat = ThreatModel(
        id: 'ocr_safe_mock',
        riskScore: 5,
        riskLevel: 'Safe',
        category: 'Safe Interaction',
        appSource: 'Media Scan',
        scannedTextSnippet: 'Landscape photo containing family members posing in front of park trees.',
        explanation: 'SAFE: No sensitive ID numbers, credit card strings, or extortion text detected inside the image.',
        redFlags: [],
        actionableSteps: ['Continue observing normal digital safety guidelines.'],
        psychologicalSupport: 'You are safe. Keep maintaining healthy digital boundaries!',
        timestamp: DateTime.now(),
      );
    }

    // Clear picker state on success
    setState(() {
      _selectedImage = null;
    });

    context.push('/threat-detail', extra: threat);
  }

  void _startVoiceAnalysis() {
    setState(() => _isRecording = true);

    // Simulate active recording waveform animation
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() => _isRecording = false);
      _showVoiceOptionDialog();
    });
  }

  void _showVoiceOptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Voice Transcription', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.warning, color: AppColors.riskCritical),
              title: const Text('Coercive Coercion Audio', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Simulates recorded audio demanding money.', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _analyzeVoiceText('You must pay me \$300 by tonight or I will upload your private video clip to your school group.');
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Safe Friendly Conversation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Simulates a typical voicemail to mom.', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(context);
                _analyzeVoiceText('Hi Mom, I am heading home from the library now. See you soon!');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeVoiceText(String transcription) async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    final result = await ApiService.analyzeText(text: transcription, appSource: 'Voice Transcription');
    context.push('/threat-detail', extra: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('MULTIMODAL RISK ANALYZER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tab Choice Chips
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Conversation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    selected: _activeTab == 0,
                    selectedColor: AppColors.primaryRoyalBlue,
                    labelStyle: TextStyle(color: _activeTab == 0 ? Colors.white : AppColors.textPrimaryLight),
                    onSelected: (_) => setState(() => _activeTab = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Media & OCR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    selected: _activeTab == 1,
                    selectedColor: AppColors.primaryRoyalBlue,
                    labelStyle: TextStyle(color: _activeTab == 1 ? Colors.white : AppColors.textPrimaryLight),
                    onSelected: (_) => setState(() => _activeTab = 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Voice Analysis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    selected: _activeTab == 2,
                    selectedColor: AppColors.primaryRoyalBlue,
                    labelStyle: TextStyle(color: _activeTab == 2 ? Colors.white : AppColors.textPrimaryLight),
                    onSelected: (_) => setState(() => _activeTab = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: _isAnalyzing
                    ? _buildAnalyzingState()
                    : _activeTab == 0
                        ? _buildConversationCheck()
                        : _activeTab == 1
                            ? _buildMediaScanner()
                            : _buildVoiceAnalyzer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text(
                'Running Multimodal Threat Analysis...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 8),
              Text(
                'Analyzing for blackmail patterns and identity exposure using Gemini AI...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConversationCheck() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.chat_outlined, color: AppColors.primaryRoyalBlue, size: 22),
                    SizedBox(width: 10),
                    Text('Conversation Risk Check', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Paste suspicious messages, DMs, or emails to run Gemini Explainable AI risk analysis.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Paste message text here (e.g. "Pay \$500 or I leak photos...")',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.lightBorder)),
                    filled: true,
                    fillColor: AppColors.lightBackground,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRoyalBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isAnalyzing ? null : _analyzeText,
                    icon: const Icon(Icons.bolt_rounded, color: Colors.white),
                    label: const Text(
                      'Run Risk Analysis',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaScanner() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (_selectedImage == null) ...[
                  const Icon(Icons.document_scanner_rounded, size: 48, color: AppColors.primaryRoyalBlue),
                  const SizedBox(height: 12),
                  const Text('ML Kit Document & PII Scanner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text(
                    'Scans Passports, Credit Cards, National IDs & sensitive photos on-device before sharing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Upload Photo'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRoyalBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                          label: const Text('Take Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_selectedImage!.path),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Photo Loaded Successfully', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  const Text(
                    'Ready to run on-device ML Kit text extraction and risk analysis.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.riskCritical),
                          ),
                          onPressed: () => setState(() => _selectedImage = null),
                          icon: const Icon(Icons.delete_outline, color: AppColors.riskCritical),
                          label: const Text('Clear Photo', style: TextStyle(color: AppColors.riskCritical)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRoyalBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _showMediaSourceDialog,
                          icon: const Icon(Icons.bolt, color: Colors.white),
                          label: const Text('Scan & Analyze', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceAnalyzer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              _isRecording ? Icons.settings_voice : Icons.graphic_eq_rounded,
              size: 48,
              color: _isRecording ? AppColors.riskCritical : AppColors.secondaryIndigo,
            ),
            const SizedBox(height: 12),
            Text(
              _isRecording ? 'Listening and Transcribing...' : 'Speech-to-Text Voice Analysis',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              _isRecording
                  ? 'Please speak clearly into your microphone...'
                  : 'Record or upload audio clips to transcribe speech and analyze coercive threat keywords.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? AppColors.riskCritical : AppColors.secondaryIndigo,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isRecording ? null : _startVoiceAnalysis,
              icon: Icon(_isRecording ? Icons.graphic_eq : Icons.mic, color: Colors.white),
              label: Text(
                _isRecording ? 'Recording Active...' : 'Start Recording Audio',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
