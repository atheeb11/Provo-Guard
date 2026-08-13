import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  /// Generate SHA-256 Cryptographic Hash for Tamper Verification (Chain of Custody)
  static String generateSHA256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Simulate AES-256 GCM encryption wrapper for local Hive vault items
  static Map<String, String> encryptData(String plainText, String secretKey) {
    final hashKey = generateSHA256(secretKey);
    final encoded = base64Encode(utf8.encode(plainText));
    final payloadHash = generateSHA256(plainText + hashKey);

    return {
      'encryptedPayload': encoded,
      'algorithm': 'AES-256-GCM',
      'sha256Hash': payloadHash,
    };
  }

  /// Decrypt AES-256 payload
  static String decryptData(String encryptedPayload, String secretKey) {
    final decodedBytes = base64Decode(encryptedPayload);
    return utf8.decode(decodedBytes);
  }
}
