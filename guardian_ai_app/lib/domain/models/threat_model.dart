class ThreatModel {
  final String id;
  final int riskScore; // 0-100
  final String riskLevel; // Safe | Low | Medium | High | Critical
  final String category; // Sextortion | Grooming | Financial Scam | Catfishing | Safe
  final String appSource; // WhatsApp | Instagram | Telegram | SMS
  final String scannedTextSnippet;
  final String explanation; // Explainable AI (XAI)
  final List<String> redFlags;
  final List<String> actionableSteps;
  final String psychologicalSupport;
  final DateTime timestamp;

  ThreatModel({
    required this.id,
    required this.riskScore,
    required this.riskLevel,
    required this.category,
    required this.appSource,
    required this.scannedTextSnippet,
    required this.explanation,
    required this.redFlags,
    required this.actionableSteps,
    required this.psychologicalSupport,
    required this.timestamp,
  });

  factory ThreatModel.fromJson(Map<String, dynamic> json) {
    return ThreatModel(
      id: json['id'] ?? json['threatId'] ?? 'threat_${DateTime.now().millisecondsSinceEpoch}',
      riskScore: json['riskScore'] ?? 0,
      riskLevel: json['riskLevel'] ?? 'Safe',
      category: json['category'] ?? 'Safe Interaction',
      appSource: json['appSource'] ?? 'Visible Monitoring',
      scannedTextSnippet: json['scannedTextSnippet'] ?? '',
      explanation: json['explanation'] ?? '',
      redFlags: List<String>.from(json['redFlags'] ?? []),
      actionableSteps: List<String>.from(json['actionableSteps'] ?? []),
      psychologicalSupport: json['psychologicalSupport'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'category': category,
      'appSource': appSource,
      'scannedTextSnippet': scannedTextSnippet,
      'explanation': explanation,
      'redFlags': redFlags,
      'actionableSteps': actionableSteps,
      'psychologicalSupport': psychologicalSupport,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
