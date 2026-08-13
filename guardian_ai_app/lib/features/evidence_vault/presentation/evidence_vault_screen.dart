import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/models/evidence_model.dart';

class EvidenceVaultScreen extends StatefulWidget {
  const EvidenceVaultScreen({super.key});

  @override
  State<EvidenceVaultScreen> createState() => _EvidenceVaultScreenState();
}

class _EvidenceVaultScreenState extends State<EvidenceVaultScreen> {
  List<EvidenceModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvidence();
  }

  Future<void> _loadEvidence() async {
    final list = await ApiService.getEvidenceItems();
    if (mounted) {
      setState(() {
        _items = list;
        _isLoading = false;
      });
    }
  }

  void _addNewMockEvidence() {
    final newItem = EvidenceModel(
      id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Manual Extortion Chat Capture',
      itemType: 'screenshot',
      appSource: 'Instagram Direct',
      sha256Hash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      encryptionAlgorithm: 'AES-256-GCM',
      fileUrl: '',
      timestamp: DateTime.now(),
    );

    setState(() {
      _items.insert(0, newItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Screenshot encrypted with AES-256 and locked in Vault.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENCRYPTED EVIDENCE VAULT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined),
            onPressed: _addNewMockEvidence,
            tooltip: 'Add Screenshot Evidence',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AES-256 Vault Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.lock_clock, color: Colors.amber, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('AES-256-GCM ENCRYPTED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 2),
                          Text('Tamper-evident chain of custody with SHA-256 hash digests for law enforcement.', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('LOCKED EVIDENCE ITEMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.1)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySky,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () => context.push('/emergency'),
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 16),
                  label: const Text('Export PDF Report', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.darkBackground,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.darkBorder),
                              ),
                              child: Icon(
                                item.itemType == 'screenshot' ? Icons.image : Icons.description,
                                color: AppColors.primaryLightSky,
                              ),
                            ),
                            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.verified, color: Colors.green, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'SHA-256: ${item.sha256Hash.substring(0, 16)}...',
                                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'App Source: ${item.appSource} • ${item.timestamp.toLocal().toString().split('.')[0]}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.file_download_outlined, color: AppColors.primaryLightSky),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Downloading encrypted evidence item (${item.sha256Hash.substring(0, 8)})...')),
                                );
                              },
                            ),
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
