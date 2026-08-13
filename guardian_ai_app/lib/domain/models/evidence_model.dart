class EvidenceModel {
  final String id;
  final String title;
  final String itemType; // screenshot | chat_export | audio | document
  final String appSource;
  final String sha256Hash;
  final String encryptionAlgorithm;
  final String fileUrl;
  final DateTime timestamp;

  EvidenceModel({
    required this.id,
    required this.title,
    required this.itemType,
    required this.appSource,
    required this.sha256Hash,
    required this.encryptionAlgorithm,
    required this.fileUrl,
    required this.timestamp,
  });

  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      id: json['id'] ?? 'ev_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title'] ?? 'Encrypted Evidence Item',
      itemType: json['itemType'] ?? 'screenshot',
      appSource: json['appSource'] ?? 'WhatsApp',
      sha256Hash: json['sha256Hash'] ?? 'a8f5f167f44f4964e6c998dee827110c',
      encryptionAlgorithm: json['encryptionAlgorithm'] ?? 'AES-256-GCM',
      fileUrl: json['fileUrl'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
