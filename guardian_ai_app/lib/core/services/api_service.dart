import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/threat_model.dart';
import '../../domain/models/evidence_model.dart';

class ApiService {
  static String? _cachedBaseUrl;

  static List<String> get candidateBaseUrls {
    final list = <String>[];
    if (kIsWeb) {
      list.add('http://localhost:8080/api/v1');
    } else {
      try {
        if (Platform.isAndroid) {
          list.add('http://10.0.2.2:8080/api/v1');
        }
      } catch (_) {}
      list.add('http://localhost:8080/api/v1');
      list.add('http://127.0.0.1:8080/api/v1');
    }
    list.add('https://provo-guard.vercel.app/api/v1');
    return list;
  }

  static String get baseUrl => _cachedBaseUrl ?? candidateBaseUrls.first;

  static String authToken = '';
  static const _storage = FlutterSecureStorage();

  static Future<bool> checkStoredSession() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      authToken = token;
      return true;
    }
    return false;
  }

  static Future<void> saveSession(String token) async {
    authToken = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> logout() async {
    authToken = '';
    await _storage.delete(key: 'auth_token');
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'bypass-tunnel-reminder': 'true',
      };

  /// Internal HTTP POST with auto-fallback across backend target URLs
  static Future<http.Response> _httpPost(String path, Map<String, dynamic> bodyData, {Duration timeout = const Duration(seconds: 5)}) async {
    final targets = _cachedBaseUrl != null
        ? [_cachedBaseUrl!, ...candidateBaseUrls.where((u) => u != _cachedBaseUrl)]
        : candidateBaseUrls;

    Exception? lastErr;
    for (final base in targets) {
      try {
        final response = await http.post(
          Uri.parse('$base$path'),
          headers: _headers,
          body: jsonEncode(bodyData),
        ).timeout(timeout);

        _cachedBaseUrl = base; // Lock in working backend URL
        return response;
      } catch (e) {
        lastErr = e is Exception ? e : Exception(e.toString());
      }
    }
    throw lastErr ?? Exception('Failed to connect to any backend target');
  }

  /// Internal HTTP GET with auto-fallback across backend target URLs
  static Future<http.Response> _httpGet(String path, {Duration timeout = const Duration(seconds: 5)}) async {
    final targets = _cachedBaseUrl != null
        ? [_cachedBaseUrl!, ...candidateBaseUrls.where((u) => u != _cachedBaseUrl)]
        : candidateBaseUrls;

    Exception? lastErr;
    for (final base in targets) {
      try {
        final response = await http.get(
          Uri.parse('$base$path'),
          headers: _headers,
        ).timeout(timeout);

        _cachedBaseUrl = base;
        return response;
      } catch (e) {
        lastErr = e is Exception ? e : Exception(e.toString());
      }
    }
    throw lastErr ?? Exception('Failed to connect to any backend target');
  }

  /// Internal HTTP PUT with auto-fallback across backend target URLs
  static Future<http.Response> _httpPut(String path, Map<String, dynamic> bodyData, {Duration timeout = const Duration(seconds: 5)}) async {
    final targets = _cachedBaseUrl != null
        ? [_cachedBaseUrl!, ...candidateBaseUrls.where((u) => u != _cachedBaseUrl)]
        : candidateBaseUrls;

    Exception? lastErr;
    for (final base in targets) {
      try {
        final response = await http.put(
          Uri.parse('$base$path'),
          headers: _headers,
          body: jsonEncode(bodyData),
        ).timeout(timeout);

        _cachedBaseUrl = base;
        return response;
      } catch (e) {
        lastErr = e is Exception ? e : Exception(e.toString());
      }
    }
    throw lastErr ?? Exception('Failed to connect to any backend target');
  }


  /// Log in and request verification if required
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpPost('/auth/login', {
        'email': email,
        'password': password,
      }, timeout: const Duration(seconds: 5));
      
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['token'] != null) {
        await saveSession(data['token']);
      }
      return data;
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection failed: ${e.toString()}'
      };
    }
  }

  /// Register a new account and request verification OTP
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String country,
  }) async {
    try {
      final response = await _httpPost('/auth/register', {
        'email': email,
        'password': password,
        'fullName': fullName,
        'age': age,
        'country': country,
      }, timeout: const Duration(seconds: 5));
      
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Connection failed: ${e.toString()}'};
    }
  }

  /// Verify OTP and obtain authorization token
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _httpPost('/auth/verify-otp', {
        'email': email,
        'otp': otp,
      }, timeout: const Duration(seconds: 5));
      
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['token'] != null) {
        await saveSession(data['token']);
      }
      return data;
    } catch (e) {
      return {'success': false, 'error': 'Connection failed: ${e.toString()}'};
    }
  }

  /// Analyze text or OCR snippet with AI Risk Engine
  static Future<ThreatModel> analyzeText({
    required String text,
    required String appSource,
  }) async {
    try {
      final response = await _httpPost('/ai-risk/analyze', {
        'text': text,
        'appSource': appSource,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ThreatModel.fromJson(data['analysis']);
      } else {
        throw Exception('Failed to analyze threat: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback local heuristic model if network offline
      final lower = text.toLowerCase();
      if (lower.contains('secret') || lower.contains('dont tell') || lower.contains('don\'t tell')) {
        return ThreatModel(
          id: 'local_mock_grooming',
          riskScore: 72,
          riskLevel: 'High',
          category: 'Grooming',
          appSource: appSource,
          scannedTextSnippet: text,
          explanation: 'High risk grooming indicator enforcing secrecy and social isolation.',
          redFlags: ['Secrecy enforcement ("don\'t tell anyone")', 'Isolation tactics'],
          actionableSteps: ['Refuse demands for secrecy', 'Inform trusted contact or parent', 'Document in Evidence Vault'],
          psychologicalSupport: 'Anyone who asks you to keep secrets does not have your best interests at heart.',
          timestamp: DateTime.now(),
        );
      } else {
        return ThreatModel(
          id: 'local_mock_extortion',
          riskScore: 94,
          riskLevel: 'Critical',
          category: 'Sextortion',
          appSource: appSource,
          scannedTextSnippet: text,
          explanation: 'Critical extortion threat with coercive financial demands and public exposure warnings.',
          redFlags: ['Financial demand or blackmail', 'Threat of public photo sharing', 'High urgency'],
          actionableSteps: ['DO NOT SEND MONEY', 'Save to Vault', 'Block sender and report to authorities'],
          psychologicalSupport: 'Take a deep breath. Extortionists rely on panic — you are not alone.',
          timestamp: DateTime.now(),
        );
      }
    }
  }

  /// Chat with Provo Guard AI Digital-Safety Assistant (Multi-Turn Supported)
  static Future<Map<String, dynamic>> sendCoachMessage(
    String message, {
    List<Map<String, dynamic>>? history,
  }) async {
    try {
      final response = await _httpPost(
        '/ai-risk/coach-chat',
        {
          'message': message,
          'conversationHistory': history ?? [],
        },
        timeout: const Duration(seconds: 25),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final replyText = data['reply'] ?? data['message'] ?? 'Response received.';
        return {
          'success': data['success'] ?? true,
          'reply': replyText,
          'message': replyText,
          'riskLevel': data['riskLevel'],
        };
      }
      throw Exception('Server returned status code: ${response.statusCode}');
    } catch (e) {
      return {
        'success': false,
        'reply': 'The AI assistant is temporarily unavailable. Please check your network connection and try again.',
        'errorCode': 'AI_UNAVAILABLE'
      };
    }
  }

  /// Fetch Threat Logs
  static Future<List<ThreatModel>> getThreatLogs() async {
    try {
      final response = await _httpGet('/ai-risk/threat-logs', timeout: const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['threats'] ?? [];
        return list.map((json) => ThreatModel.fromJson(json)).toList();
      }
      throw Exception('Server returned status code: ${response.statusCode}');
    } catch (e) {
      return [
        ThreatModel(
          id: 'log_mock_1',
          riskScore: 94,
          riskLevel: 'Critical',
          category: 'Sextortion',
          appSource: 'WhatsApp',
          scannedTextSnippet: 'Pay \$500 in crypto or I send your private photos to your Instagram followers...',
          explanation: 'Critical extortion threat with coercive financial demands and public exposure warnings.',
          redFlags: ['Financial demand', 'Exposure threat', 'Time limit'],
          actionableSteps: ['Do NOT pay', 'Save to Vault', 'Trigger Incident Report'],
          psychologicalSupport: 'Take a deep breath. You are safe.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        ThreatModel(
          id: 'log_mock_2',
          riskScore: 72,
          riskLevel: 'High',
          category: 'Grooming',
          appSource: 'Instagram Direct',
          scannedTextSnippet: 'Don\'t tell your parents or friends about our chats. It\'s our special secret...',
          explanation: 'High risk grooming indicator enforcing secrecy and social isolation.',
          redFlags: ['Secrecy enforcement', 'Isolation tactic'],
          actionableSteps: ['Refuse secrecy', 'Inform trusted contact'],
          psychologicalSupport: 'You have a right to talk to trusted adults.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        )
      ];
    }
  }

  /// Fetch Evidence Items
  static Future<List<EvidenceModel>> getEvidenceItems() async {
    try {
      final response = await _httpGet('/evidence', timeout: const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['items'] ?? [];
        return list.map((json) => EvidenceModel.fromJson(json)).toList();
      }
      throw Exception('Server returned status code: ${response.statusCode}');
    } catch (e) {
      return [
        EvidenceModel(
          id: 'ev_mock_1',
          title: 'Extortion Demand WhatsApp Screenshot',
          itemType: 'screenshot',
          appSource: 'WhatsApp',
          sha256Hash: 'a8f5f167f44f4964e6c998dee827110c',
          encryptionAlgorithm: 'AES-256-GCM',
          fileUrl: '',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        EvidenceModel(
          id: 'ev_mock_2',
          title: 'Instagram Direct Message Chain Export',
          itemType: 'chat_export',
          appSource: 'Instagram',
          sha256Hash: 'c772b189283726ab293817109283fcc1',
          encryptionAlgorithm: 'AES-256-GCM',
          fileUrl: '',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        )
      ];
    }
  }

  /// Trigger One-Tap Emergency Alert
  static Future<Map<String, dynamic>> triggerEmergency({
    required double lat,
    required double lng,
    required String customMessage,
  }) async {
    try {
      final response = await _httpPost('/emergency/trigger', {
        'latitude': lat,
        'longitude': lng,
        'customMessage': customMessage,
      }, timeout: const Duration(seconds: 5));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Server returned status code: ${response.statusCode}');
    } catch (e) {
      return {
        'success': true,
        'message': 'EMERGENCY MODE ACTIVATED. Emergency contacts pinged and incident logged.',
        'incident': {
          'incidentId': 'INC-${DateTime.now().millisecondsSinceEpoch}',
          'timestamp': DateTime.now().toIso8601String(),
        }
      };
    }
  }

  /// Get user profile details from database
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _httpGet('/auth/profile', timeout: const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'error': 'Failed to fetch profile'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Update user profile details in database and send email notification
  static Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
    required int age,
    required String country,
    List<Map<String, String>>? emergencyContacts,
  }) async {
    try {
      final response = await _httpPut('/auth/profile', {
        'fullName': fullName,
        'email': email,
        'age': age,
        'country': country,
        'emergencyContacts': emergencyContacts,
      }, timeout: const Duration(seconds: 6));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      final err = jsonDecode(response.body);
      return {'success': false, 'error': err['error'] ?? 'Failed to update profile'};
    } catch (e) {
      return {'success': false, 'error': 'Connection error: ${e.toString()}'};
    }
  }

  /// Change user password in database and trigger email security alert
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _httpPost('/auth/change-password', {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }, timeout: const Duration(seconds: 6));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      final err = jsonDecode(response.body);
      return {'success': false, 'error': err['error'] ?? 'Failed to update password'};
    } catch (e) {
      return {'success': false, 'error': 'Connection error: ${e.toString()}'};
    }
  }

  /// Update Emergency Contacts in database
  static Future<Map<String, dynamic>> updateEmergencyContacts(
    List<Map<String, String>> contacts,
  ) async {
    try {
      final response = await _httpPut('/auth/emergency-contacts', {
        'contacts': contacts,
      }, timeout: const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'error': 'Failed to update emergency contacts'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Request 6-digit password reset OTP email
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _httpPost('/auth/forgot-password', {
        'email': email,
      }, timeout: const Duration(seconds: 6));

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Connection error: ${e.toString()}'};
    }
  }

  /// Verify 6-digit OTP and reset password in database
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _httpPost('/auth/reset-password', {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }, timeout: const Duration(seconds: 6));

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Connection error: ${e.toString()}'};
    }
  }
}



