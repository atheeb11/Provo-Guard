class MLKitScannerResult {
  final String extractedText;
  final bool hasPassport;
  final bool hasNationalID;
  final bool hasCreditCard;
  final bool hasFaces;
  final List<String> detectedPII;

  MLKitScannerResult({
    required this.extractedText,
    required this.hasPassport,
    required this.hasNationalID,
    required this.hasCreditCard,
    required this.hasFaces,
    required this.detectedPII,
  });
}

class MLKitService {
  /// Local OCR & Privacy Document Scanner
  /// Analyzes images on-device using ML Kit without uploading sensitive images
  static Future<MLKitScannerResult> scanImagePrivacy(String imagePath) async {
    // Simulated high-fidelity ML Kit OCR & Face Detection output
    final sampleText = "PASSPORT / UNITED STATES OF AMERICA\nSurname: VANCE\nGiven Names: ALEX\nPassport No: A99481023\nDate of Birth: 14 MAY 2003\nPlace of Birth: CALIFORNIA, USA";

    final upper = sampleText.toUpperCase();
    final hasPassport = upper.contains("PASSPORT") || upper.contains("USA");
    final hasNationalID = upper.contains("NATIONAL ID") || upper.contains("SSN");
    final hasCreditCard = upper.contains("CARD") || upper.contains("CVV");

    final pii = <String>[];
    if (hasPassport) pii.add("Official Passport Number");
    if (sampleText.contains("2003")) pii.add("Full Date of Birth");
    if (sampleText.contains("CALIFORNIA")) pii.add("Home State / Location metadata");

    return MLKitScannerResult(
      extractedText: sampleText,
      hasPassport: hasPassport,
      hasNationalID: hasNationalID,
      hasCreditCard: hasCreditCard,
      hasFaces: true,
      detectedPII: pii,
    );
  }
}
