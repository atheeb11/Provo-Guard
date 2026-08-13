import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'coach',
      'text': 'Hi! I\'m your Provo Guard AI Safety Assistant. How can I help protect your digital life today?'
    }
  ];
  bool _isSending = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> _suggestedQuestions = [
    'Is this link safe to click?',
    'How do I spot a catfishing scam?',
    'What should I do if someone demands money?',
    'How to protect my social accounts?'
  ];

  Future<void> _sendMessage([
    String? customText,
    XFile? customImage,
    String? attachmentType,
    String? attachmentPath,
  ]) async {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty && customImage == null && attachmentPath == null) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text.isNotEmpty ? text : 'Uploaded attachment for threat scanning.',
        'imagePath': customImage?.path,
        'attachmentType': attachmentType,
        'attachmentPath': attachmentPath,
      });
      _isSending = true;
      if (customText == null) _controller.clear();
    });

    if (customImage != null || attachmentPath != null) {
      final type = attachmentType ?? 'image';
      // Simulate Attachment Analysis response
      await Future.delayed(const Duration(milliseconds: 2200));
      if (mounted) {
        setState(() {
          _isSending = false;
          String coachText = '';
          if (type == 'image') {
            coachText = 'I have received your image attachment and completed the AI safety scan.\n\n⚠️ **Analysis Warning:** This document contains a Passport or Government ID template scan. Sharing identification documents over unverified chats poses high risks of identity theft or blackmail leverage.\n\n**Action Steps:**\n• Do not share this image with unverified accounts.\n• Save this securely to your Evidence Vault if someone is demanding it.';
          } else if (type == 'pdf') {
            coachText = 'I have received your PDF document and ran our ML safety check.\n\n⚠️ **Analysis Warning:** We detected legal threats and urgency clauses matching an extortion demand script inside the PDF payload.\n\n**Action Steps:**\n• Stop direct contact with the sender.\n• File an online report using our Reports portal.\n• Save this document to the Encrypted Evidence Vault.';
          } else if (type == 'video') {
            coachText = 'I have received your video file attachment and completed the threat scan.\n\n⚠️ **Analysis Warning:** The video format/metadata matches typical media shared in catfishing and grooming pressure loops. Please ensure this media is not shared publicly.\n\n**Action Steps:**\n• Keep your private media protected.\n• Block the requesting user immediately.';
          } else if (type == 'audio') {
            coachText = 'I have received your audio file and run voice-to-text safety checks.\n\n⚠️ **Analysis Warning:** The transcribed voice clip contains coercive language demanding immediate financial payments or actions.\n\n**Action Steps:**\n• Do not make payments or click links.\n• Keep this voice file locked inside your secure Evidence Vault.';
          }
          _messages.add({
            'sender': 'coach',
            'text': coachText,
          });
        });
      }
    } else {
      final res = await ApiService.sendCoachMessage(text);
      if (mounted) {
        setState(() {
          _isSending = false;
          _messages.add({
            'sender': 'coach',
            'text': res['reply'] ?? 'I am here to guide and protect you. Take a slow deep breath.',
          });
        });
      }
    }
  }

  Future<void> _pickAttachmentImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (file != null) {
        _sendMessage('', file, 'image', file.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick gallery image: $e')),
      );
    }
  }

  Future<void> _pickAttachmentPDF() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        _sendMessage('Uploaded PDF Document: $fileName', null, 'pdf', filePath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick PDF document: $e')),
      );
    }
  }

  Future<void> _pickAttachmentVideo() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        _sendMessage('Uploaded Video: ${file.name}', null, 'video', file.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick video file: $e')),
      );
    }
  }

  Future<void> _pickAttachmentAudio() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        _sendMessage('Uploaded Audio Recording: $fileName', null, 'audio', filePath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick audio file: $e')),
      );
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.lightBorder, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('Upload Media for AI Safety Inspection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _attachmentOption(context, 'Image', Icons.image_rounded, Colors.blue, () {
                    Navigator.pop(context);
                    _pickAttachmentImage();
                  }),
                  _attachmentOption(context, 'PDF Doc', Icons.picture_as_pdf_rounded, Colors.red, () {
                    Navigator.pop(context);
                    _pickAttachmentPDF();
                  }),
                  _attachmentOption(context, 'Video', Icons.videocam_rounded, Colors.purple, () {
                    Navigator.pop(context);
                    _pickAttachmentVideo();
                  }),
                  _attachmentOption(context, 'Audio', Icons.mic_rounded, Colors.green, () {
                    Navigator.pop(context);
                    _pickAttachmentAudio();
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _attachmentOption(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.primaryRoyalBlue.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.psychology_rounded, color: AppColors.primaryRoyalBlue, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Safety Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Online • Always Here to Help', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Suggested Question Chips Scroll Bar
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestedQuestions.length,
              itemBuilder: (context, index) {
                final q = _suggestedQuestions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.lightBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    label: Text(q, style: const TextStyle(fontSize: 12, color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.w500)),
                    onPressed: () => _sendMessage(q),
                  ),
                );
              },
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                final hasImage = msg['imagePath'] != null;
                final type = msg['attachmentType'];
                final path = msg['attachmentPath'];

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primaryRoyalBlue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: isUser ? null : Border.all(color: AppColors.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasImage) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(msg['imagePath']!),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (type == 'pdf') ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.white.withOpacity(0.12) : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 36),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        path != null ? path.split('/').last : 'Document.pdf',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isUser ? Colors.white : AppColors.textPrimaryLight,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'PDF Document',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isUser ? Colors.white70 : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (type == 'video') ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.white.withOpacity(0.12) : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.video_library, color: Colors.purple, size: 36),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        path != null ? path.split('/').last : 'Video.mp4',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isUser ? Colors.white : AppColors.textPrimaryLight,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Video File',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isUser ? Colors.white70 : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (type == 'audio') ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.white.withOpacity(0.12) : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.audiotrack, color: Colors.green, size: 36),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        path != null ? path.split('/').last : 'Audio.mp3',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isUser ? Colors.white : AppColors.textPrimaryLight,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Voice Audio Recording',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isUser ? Colors.white70 : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          msg['text']!,
                          style: TextStyle(
                            color: isUser ? Colors.white : AppColors.textPrimaryLight,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isSending)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryRoyalBlue)),
                  SizedBox(width: 8),
                  Text('Provo Guard AI is thinking...', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                ],
              ),
            ),

          // Chat Message Input Box (ChatGPT Style)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.lightBorder)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryRoyalBlue, size: 26),
                  onPressed: _showAttachmentMenu,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask AI or paste link/message...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.lightBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.mic_none_rounded, color: AppColors.textSecondaryLight, size: 24),
                  onPressed: _pickAttachmentAudio,
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primaryRoyalBlue,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
